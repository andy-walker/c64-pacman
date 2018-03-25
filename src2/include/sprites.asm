set_score_sprites
        
        lda #%00000000
        sta $d015

        ldx #sprite_base+52             ; 1 UP / score sprites
        ldy #sprite_base+53

        lda game_mode
        cmp #intro1
        bcc sss1

        lda flash_counter2
        cmp #16
        bcs sss1

        ldx #sprite_base+62
        ldy #sprite_base+63

sss1
        stx $07f8
        sty $07f9

        lda #sprite_base+54             ; High score sprites
        sta $07fa
        lda #sprite_base+55
        sta $07fb
        lda #sprite_base+56
        sta $07fc
        lda #sprite_base+57
        sta $07fd

        lda #sprite_base+58             ; 2 UP sprites
        sta $07fe
        lda #sprite_base+59
        sta $07ff

        lda #60
        sta $d000
        lda #84
        sta $d002

        lda #140
        sta $d004
        lda #164
        sta $d006
        lda #188
        sta $d008
        lda #212
        sta $d00a

        lda #6
        sta $d00c
        lda #30
        sta $d00e

        lda #27
        sta $d001
        sta $d003
        sta $d005
        sta $d007
        sta $d009
        sta $d00b
        sta $d00d
        sta $d00f

        lda #white
        sta $d027 
        sta $d028
        sta $d029
        sta $d02a
        sta $d02b
        sta $d02c
        sta $d02d
        sta $d02e
        sta $d02f
        
        ; set carry bits for last two sprite (2 up)
        lda #%11000000
        sta $d010

        rts


; --------------------
; Sprite setup routine
; --------------------

set_pacman_sprite_left

        lda pacman_x_sub                ; get pacman x sub position
        cmp #5                          ; compare to 5
        bcc spsl1                       ; branch to spsr1 if less than
        beq spsl2                       ; branch to spsr2 if equal
                                        ; otherwise (if greater than)
        lda #sprite_base-5
        adc pacman_x_sub
        sta sprite0_pointer
        rts

spsl1                                   ; less than 5
        lda #sprite_base+5
        sbc pacman_x_sub
        sta sprite0_pointer
        rts

spsl2                                   ; equal to 5    
        lda #sprite_base 
        sta sprite0_pointer
        rts

set_pacman_sprite_right

        lda pacman_x_sub                ; get pacman x sub position
        cmp #5                          ; compare to 5
        bcc spsr1                       ; branch to spsr1 if less than
        beq spsr2                       ; branch to spsr2 if equal
                                        ; otherwise (if greater than)

        lda #sprite_base+5
        adc pacman_x_sub
        sta sprite0_pointer
        rts

spsr1                                   ; less than 5
        lda #sprite_base+16
        sbc pacman_x_sub
        sta sprite0_pointer
        rts

spsr2                                   ; equal to 5    
        lda #sprite_base 
        sta sprite0_pointer
        rts


set_pacman_sprite_up

        lda pacman_y_sub                ; get pacman y sub position
        cmp #5                          ; compare to 5
        bcc spsu1                       ; branch to spsu1 if less than
        beq spsu2                       ; branch to spsu2 if equal
                                        ; otherwise (if greater than)
        lda #sprite_base+9
        adc pacman_y_sub
        sta sprite0_pointer
        rts

spsu1                                   ; less than 5

        lda #sprite_base+21
        sbc pacman_y_sub
        sta sprite0_pointer
        rts


spsu2                                   ; equal to 5    
        lda #sprite_base 
        sta sprite0_pointer
        rts

set_pacman_sprite_down

        lda pacman_y_sub                ; get pacman y sub position
        cmp #5                          ; compare to 5
        bcc spsd1                       ; branch to spsd1 if less than
        beq spsd2                       ; branch to spsd2 if equal
                                        ; otherwise (if greater than)
        lda #sprite_base
        adc pacman_y_sub
        sta sprite0_pointer
        rts

spsd1                                   ; less than 5
        lda #sprite_base+11
        sbc pacman_y_sub
        sta sprite0_pointer
        rts

spsd2                                   ; equal to 5    
        lda #sprite_base 
        sta sprite0_pointer
        rts


; ----------------------------------------------
; Routine to position / orient the pacman sprite
; ----------------------------------------------

update_pacman_sprite

        ; set x position
        
        ldx sprite0_x                   ; note previous x position (for overflow checking)
        lda pacman_x_tile               ; get x tile position
        asl                             ; multiply by 10
        asl
        asl
        adc pacman_x_tile
        adc pacman_x_tile
        adc pacman_x_sub                ; add x sub tile position
        adc #45                         ; add 45 (the x offset of the background graphic)
        sta sprite0_x                   ; store
        
        ; handle sprite's x carry bit

        cpx #255                        ; if previous x was 255
        bne ups1
        cmp #0                          ; and now it's zero
        bne ups1

        lda #1                          ; set sprite carry bit
        sta sprite0_carry

ups1    cpx #0                          ; if previous x was zero
        bne ups2
        cmp #255                        ; and now it's 255
        bne ups2
        
        lda #0                          ; unset sprite carry bit
        sta sprite0_carry

        ; set y position

ups2    lda pacman_y_tile               ; get y tile position
        asl                             ; multiply by 10
        asl
        asl
        adc pacman_y_tile
        adc pacman_y_tile
        adc pacman_y_sub                ; add y sub position
        adc #37                         ; add 37 (the y offset of the level)
        sta sprite0_y                   ; store in $d001
        
        rts
