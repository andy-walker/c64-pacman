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
        sta $07f8
        rts

spsl1                                   ; less than 5
        lda #sprite_base+5
        sbc pacman_x_sub
        sta $07f8
        rts

spsl2                                   ; equal to 5    
        lda #sprite_base 
        sta $07f8
        rts

set_pacman_sprite_right

        lda pacman_x_sub                ; get pacman x sub position
        cmp #5                          ; compare to 5
        bcc spsr1                       ; branch to spsr1 if less than
        beq spsr2                       ; branch to spsr2 if equal
                                        ; otherwise (if greater than)

        lda #sprite_base+5
        adc pacman_x_sub
        sta $07f8
        rts

spsr1                                   ; less than 5
        lda #sprite_base+16
        sbc pacman_x_sub
        sta $07f8
        rts

spsr2                                   ; equal to 5    
        lda #sprite_base 
        sta $07f8
        rts


set_pacman_sprite_up

        lda pacman_y_sub                ; get pacman y sub position
        cmp #5                          ; compare to 5
        bcc spsu1                       ; branch to spsu1 if less than
        beq spsu2                       ; branch to spsu2 if equal
                                        ; otherwise (if greater than)
        lda #sprite_base+9
        adc pacman_y_sub
        sta $07f8
        rts

spsu1                                   ; less than 5

        lda #sprite_base+21
        sbc pacman_y_sub
        sta $07f8
        rts


spsu2                                   ; equal to 5    
        lda #sprite_base 
        sta $07f8
        rts

set_pacman_sprite_down

        lda pacman_y_sub                ; get pacman y sub position
        cmp #5                          ; compare to 5
        bcc spsd1                       ; branch to spsd1 if less than
        beq spsd2                       ; branch to spsd2 if equal
                                        ; otherwise (if greater than)
        lda #sprite_base
        adc pacman_y_sub
        sta $07f8
        rts

spsd1                                   ; less than 5
        lda #sprite_base+11
        sbc pacman_y_sub
        sta $07f8
        rts

spsd2                                   ; equal to 5    
        lda #sprite_base 
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
        
        ; handle sprite's x carry bit

        cpx #255                        ; if previous x was 255
        bne ups1
        cmp #0                          ; and now it's zero
        bne ups1

        lda $d010
        eor #%00000001                  ; flip sprite carry bit
        sta $d010

ups1    cpx #0                          ; if previous x was zero
        bne ups2
        cmp #255                        ; and now it's 255
        bne ups2

        lda $d010
        eor #%00000001                  ; flip sprite carry bit
        sta $d010

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

        lda frightened_mode
        cmp #0
        beq sgs_main

sgs_frightened
        
        cpy #2                          ; determine ghost direction
        bcc sgsf_lr                      
sgsf_ud lda ghost0_y_sub,x              ; when up/down, get y sub position
        jmp sgsf1
sgsf_lr lda ghost0_x_sub,x              ; when left/right, get x sub position
sgsf1   sta num1                        ; store sub position temporarily
        lsr                             ; shift right (divide by 2)
        asl                             ; shift left (multiply by 2)
        cmp num1                        
        beq sgsf_even                   ; if it's still the same number, number is an even number
                                        ; otherwise, it's an odd number
sgsf_odd 
        lda #sprite_base+21             ; load accumulator with index of frightened 'A' sprite
        jmp sgsf2
sgsf_even 
        lda #sprite_base+22             ; load accumulator with index of frightened 'B' sprite
sgsf2        
        sta $07f9,x                     ; set sprite pointer, using .x (ghost index) as an offset
        lda #sprite_base+29             ; load accumulator with index of first sprite for ghost's eyes
        sta $07fd,x                     ; store the resulting sprite index using .x as an offset
        rts        

sgs_main
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
sgs_odd lda #sprite_base+23             ; load accumulator with index of ghost 'A' sprite
        jmp sgs2
sgs_even 
        lda #sprite_base+24             ; load accumulator with index of ghost 'B' sprite
sgs2        
        clc
        sta $07f9,x                     ; set sprite pointer, using .x (ghost index) as an offset
        lda #sprite_base+25             ; load accumulator with index of first sprite for ghost's eyes
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

        txa                             ; setup .y as an offset register
        asl                             ; should be 2 * .x
        sta tmp1                        ; temporarily store
        tay                             ; and transfer to .y
        
        lda $d002,y                     ; note previous x position (for overflow checking)
        sta tmp2

        lda ghost0_x_tile,x             ; get x tile position
        asl                             ; multiply by 10
        asl
        asl
        clc
        adc ghost0_x_tile,x
        adc ghost0_x_tile,x
        adc ghost0_x_sub,x              ; add x sub tile position
        adc #45                         ; add 45 (the x offset of the background graphic)
        sta $d002,y                     ; store in $d002 (todo: need to offset with y * 2)  
        sta $d00a,y                     ; same for eyes sprite

        ; primitively handle the sprite's x carry bit

        ldy tmp2
        cpy #255                        ; if previous x was 255
        bne ugs1
        cmp #0                          ; and now it's zero
        bne ugs1

        jsr ghost_flip_carry_bits

ugs1    cpy #0                          ; if previous x was zero
        bne ugs2
        cmp #255                        ; and now it's 255
        bne ugs2

        jsr ghost_flip_carry_bits

ugs2    ldy tmp1
        lda ghost0_y_tile,x             ; get y tile position
        asl                             ; multiply by 10
        asl
        asl
        clc
        adc ghost0_y_tile,x
        adc ghost0_y_tile,x
        adc ghost0_y_sub,x              ; add y sub position
        adc #37                         ; add 37 (the y offset of the level)
        sta $d003,y                     ; store in $d003 (todo: need to offset with y * 2) 
        sta $d00b,y                     ; same for eyes sprite

        rts