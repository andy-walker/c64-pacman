
; --------------------
; Sprite setup routine
; --------------------

game_init_sprites

        lda #%00100011 
        sta $d015                       ; Turn on sprite 0-2 

        lda #7 
        sta $d027                       ; sprite 0: colour yellow
        lda #2 
        sta $d028                       ; sprite 1: colour red
        lda #4
        sta $d029                       ; sprite 2: colour purple
        lda #3
        sta $d02a                       ; sprite 3: colour cyan
        lda #10
        sta $d02b                       ; sprite 4: colour orange
        lda #1
        sta $d02c
        sta $d02d
        sta $d02e
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
        ;lda #1                          ; then set the carry bit
        ;sta $d010                       ; nb: this setting code will break when additional sprites added

        ;lda $d010
        ;ora %00000001
        ;sta $d010

        inc $d010



ups1    cpx #0                          ; if previous x was zero
        bne ups2
        cmp #255                        ; and now it's 255
        bne ups2
        ;lda #%0                         ; then unset the carry bit
        ;sta $d010                       ; nb: this setting code will break when additional sprites added

        ;lda $d010
        ;and %11111110
        ;sta $d010

        dec $d010

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


; --------------------------------------------
; Routine to set the correct ghost sprites
; .x should be preloaded with ghost index
; .y should be preloaded with ghost direction
; --------------------------------------------

set_ghost_sprite
        cpy #2                          ; determine ghost direction
        bcc sgs_lr                      
sgs_ud  lda ghost0_y_sub,x              ; when up/down, get y sub position
        jmp sgs1
sgs_lr  lda ghost0_x_sub,x              ; when left/right, get x sub position
sgs1    sta num1                        ; store sub position temporarily
        lsr                             ; shift right (divide by 2)
        asl                             ; shift left (multiply by 2)
        cmp num1                        
        beq sgs_even                    ; if it's still the same number, number is an even number
                                        ; otherwise, it's an odd number
sgs_odd lda #$97                        ; load accumulator with index of ghost 'A' sprite
        jmp sgs2
sgs_even 
        lda #$98                        ; load accumulator with index of ghost 'B' sprite
sgs2        
        clc
        sta $07f9,x                     ; set sprite pointer, using .x (ghost index) as an offset
        lda #$99                        ; load accumulator with index of first sprite for ghost's eyes
        sty num1                        ; temporarily store .y register (ghost direction)
        adc num1                        ; and add to sprite index
        sta $07fd,x                     ; store the resulting sprite index using .x as an offset
        rts

; --------------------------------------------
; Routine to update a specific ghost sprite
; .x should be preloaded with ghost index
; .y should be preloaded with ghost direction
; --------------------------------------------

update_ghost_sprite

        ldy $d002                       ; note previous x position (for overflow checking)
        lda ghost0_x_tile,x             ; get x tile position
        asl                             ; multiply by 10
        asl
        asl
        clc
        adc ghost0_x_tile,x
        adc ghost0_x_tile,x
        adc ghost0_x_sub,x              ; add x sub tile position
        adc #45                         ; add 45 (the x offset of the background graphic)
        sta $d002                       ; store in $d002 (todo: need to offset with y * 2)  
        sta $d00a                       ; same for eyes sprite

        ; primitively handle the sprite's x carry bit

        cpy #255                        ; if previous x was 255
        bne ugs1
        cmp #0                          ; and now it's zero
        bne ugs1
        ;lda #1                          ; then set the carry bit
        ;sta $d010                       ; nb: this setting code will break when additional sprites added

        ;lda $d010
        ;ora %00010010
        ;sta $d010

        lda $d010
        clc
        adc #2
        adc #32
        sta $d010


ugs1    cpy #0                          ; if previous x was zero
        bne ugs2
        cmp #255                        ; and now it's 255
        bne ugs2
        ; lda #%0                         ; then unset the carry bit
        ; sta $d010                       ; nb: this setting code will break when additional sprites added

        ; lda $d010
        ; and %11101101
        ; sta $d010

        lda $d010
        sec
        sbc #2
        sbc #32


ugs2    lda ghost0_y_tile,x             ; get y tile position
        asl                             ; multiply by 10
        asl
        asl
        clc
        adc ghost0_y_tile,x
        adc ghost0_y_tile,x
        adc ghost0_y_sub,x              ; add y sub position
        adc #37                         ; add 37 (the y offset of the level)
        sta $d003                       ; store in $d003 (todo: need to offset with y * 2) 
        sta $d00b                       ; same for eyes sprite

        rts