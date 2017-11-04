
        ; sprite initialisation

game_init_sprites

        lda #$01 
        sta $d015                       ; Turn sprite 0 on 
        ;sta $d01c                      ; multi coloured sprite 

        lda #7 
        sta $d027                       ; set primary colour yellow

        lda #$00                        ; set black and white 
        sta $d025                       ; multi-colors global 
        lda #$01 
        sta $d026 
        rts


set_pacman_sprite_left

        lda pacman_x_sub                ; get pacman x sub position
        cmp #5                          ; compare to 5
        bcc spsl1                       ; branch to spsr1 if less than
        beq spsl2                       ; branch to spsr2 if equal
                                        ; otherwise (if greater than)
        lda #$7b
        adc pacman_x_sub
        sta $07f8
        rts

spsl1                                   ; less than 5
        lda #$85
        sbc pacman_x_sub
        sta $07f8
        rts

spsl2                                   ; equal to 5    
        lda #$80 
        sta $07f8
        rts

set_pacman_sprite_right

        lda pacman_x_sub                ; get pacman x sub position
        cmp #5                          ; compare to 5
        bcc spsr1                       ; branch to spsr1 if less than
        beq spsr2                       ; branch to spsr2 if equal
                                        ; otherwise (if greater than)

        lda #$85
        adc pacman_x_sub
        sta $07f8
        rts

spsr1                                   ; less than 5
        lda #$90
        sbc pacman_x_sub
        sta $07f8
        rts

spsr2                                   ; equal to 5    
        lda #$80 
        sta $07f8
        rts


set_pacman_sprite_up

        lda pacman_y_sub                ; get pacman y sub position
        cmp #5                          ; compare to 5
        bcc spsu1                       ; branch to spsu1 if less than
        beq spsu2                       ; branch to spsu2 if equal
                                        ; otherwise (if greater than)
        lda #$89
        adc pacman_y_sub
        sta $07f8
        rts

spsu1                                   ; less than 5

        lda #$95
        sbc pacman_y_sub
        sta $07f8
        rts


spsu2                                   ; equal to 5    
        lda #$80 
        sta $07f8
        rts

set_pacman_sprite_down

        lda pacman_y_sub                ; get pacman y sub position
        cmp #5                          ; compare to 5
        bcc spsd1                       ; branch to spsd1 if less than
        beq spsd2                       ; branch to spsd2 if equal
                                        ; otherwise (if greater than)
        lda #$80
        adc pacman_y_sub
        sta $07f8
        rts

spsd1                                   ; less than 5
        lda #$8b
        sbc pacman_y_sub
        sta $07f8
        rts

spsd2                                   ; equal to 5    
        lda #$80 
        sta $07f8
        rts


; ----------------------------------------------
; Routine to position / orient the pacman sprite
; ----------------------------------------------

update_pacman_sprite

        ; set x position
        
        ldx $d000                       ; note previous x position (for overflow checking)
        lda pacman_x_tile               ; get x tile position
        asl                             ; multiply by 10
        asl
        asl
        adc pacman_x_tile
        adc pacman_x_tile
        adc pacman_x_sub                ; add x sub tile position
        adc #45                         ; add 45 (the x offset of the background graphic)
        sta $d000                       ; store in $d000
        
        ; primitively handle the sprite's x carry bit

        cpx #255                        ; if previous x was 255
        bne ups1
        cmp #0                          ; and now it's zero
        bne ups1
        lda #1                          ; then set the carry bit
        sta $d010                       ; nb: this setting code will break when additional sprites added

ups1    cpx #0                          ; if previous x was zero
        bne ups2
        cmp #255                        ; and now it's 255
        bne ups2
        lda #%0                         ; then unset the carry bit
        sta $d010                       ; nb: this setting code will break when additional sprites added

        ; set y position

ups2    lda pacman_y_tile               ; get y tile position
        asl                             ; multiply by 10
        asl
        asl
        adc pacman_y_tile
        adc pacman_y_tile
        adc pacman_y_sub                ; add y sub position
        adc #37                         ; add 37 (the y offset of the level)
        sta $d001                       ; store in $d001
        
        rts