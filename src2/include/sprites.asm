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

set_lower_game_sprites
        lda #%00000011
        sta $d015
        lda #yellow
        sta $d027 
        sta $d028
        lda #0
        sta $d010
        lda #253
        sta $d001
        sta $d003
        lda #65
        sta $d000
        lda #91
        sta $d002
        lda #sprite_base+61
        sta $07f8
        lda #sprite_base+60
        sta $07f9
        ldx #0
sls_loop
        nop
        nop
        nop
        inx
        cpx #200
        bne sls_loop

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
        sta sprite1_pointer,x           ; set sprite pointer, using .x (ghost index) as an offset
        lda #sprite_base+29             ; load accumulator with index of first sprite for ghost's eyes
        sta sprite5_pointer,x                     ; store the resulting sprite index using .x as an offset
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
        sta sprite1_pointer,x           ; set sprite pointer, using .x (ghost index) as an offset
        lda #sprite_base+25             ; load accumulator with index of first sprite for ghost's eyes
        sty num1                        ; temporarily store .y register (ghost direction)
        adc num1                        ; and add to sprite index
        sta sprite5_pointer,x                     ; store the resulting sprite index using .x as an offset
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
        
        lda sprite1_x,y                 ; note previous x position (for overflow checking)
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
        sta sprite1_x,x                 ; store in $d002 (todo: need to offset with y * 2)  
        sta sprite5_x,x                 ; same for eyes sprite

        ; primitively handle the sprite's x carry bit

        ldy tmp2
        cpy #255                        ; if previous x was 255
        bne ugs1
        cmp #0                          ; and now it's zero
        bne ugs1

        lda #1                          ; set carry bits
        sta sprite1_carry,x             ; for main ghost sprite
        sta sprite5_carry,x             ; and eyes sprite



ugs1    cpy #0                          ; if previous x was zero
        bne ugs2
        cmp #255                        ; and now it's 255
        bne ugs2

        lda #0                          ; unset carry bits
        sta sprite1_carry,x             ; for main ghost sprite
        sta sprite5_carry,x             ; and eyes sprite

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
        sta sprite1_y,x                 ; store in $d003 (todo: need to offset with y * 2) 
        sta sprite5_y,x                 ; same for eyes sprite

        rts