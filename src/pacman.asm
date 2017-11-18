; ----------------------
; Move character routine
; ----------------------

move_character
        
        lda #%11111111                  ; CIA#1 Port A set to output 
        sta ddra             
        lda #%00000000                  ; CIA#1 Port B set to input
        sta ddrb      

        lda pacman_direction            ; load current direction (0 = left, 1 = right, 2 = up, 3 = down)
        cmp #2                          ; if previous direction was left/right, check up/down first
        bcc check_up_down_first         ; (this helps when turning corners)

check_left_right_first

        jsr check_left_right
        cmp #1
        beq exit_move_character
        jsr check_up_down
        rts

check_up_down_first

        jsr check_up_down
        cmp #1
        beq exit_move_character
        jsr check_left_right

exit_move_character       
        rts


; -------------------------------------------
; Routine to check for left/right keypresses
; Returns if character was moved as 0/1 in .a
; -------------------------------------------

check_left_right

check_l lda #%11111101                  ; select row 2
        sta pra 
        lda prb                         ; load column information
        and #%00010000                  ; test 'z' key  
        beq go_left
        jmp check_r

go_left jsr check_can_move_left
        cmp #0
        beq check_r
        ldx #0                          ; set pacman direction to 0 (left)
        stx pacman_direction            ; (use .x to preserve the return code in .a)
        rts

check_r lda #%11111011                  ; select row 3
        sta pra 
        lda prb                         ; load column information
        and #%10000000                  ; test 'x' key  
        beq go_right
        lda #0                          ; set return code 0 (did not move) in .a
        rts

go_right
        jsr check_can_move_right
        cmp #0
        beq exit_check_lr
        ldx #1                          ; set pacman direction to 1 (right)
        stx pacman_direction            ; (use .x to preserve the return code in .a)
        rts

exit_check_lr
        rts


; -------------------------------------------
; Routine to check for up/down keypresses
; Returns if character was moved as 0/1 in .a
; -------------------------------------------

check_up_down

check_d lda #%11011111                  ; select row 6
        sta pra 
        lda prb                         ; load column information
        and #%00010000                  ; test '.' key  
        beq go_down
        jmp check_u

go_down jsr check_can_move_down
        cmp #0
        beq check_u
        ldx #3                          ; set pacman direction to 3 (down)
        stx pacman_direction            ; (use .x to preserve the return code in .a)
        rts

check_u lda #%10111111                  ; select row 7
        sta pra 
        lda prb                         ; load column information
        and #%00000100                  ; test ';' key 
        beq go_up  
        lda #0                          ; set return code 0 (did not move) in .a
        rts

go_up   jsr check_can_move_up
        cmp #0
        beq exit_check_ud
        ldx #2                          ; set pacman direction to 2 (up)
        stx pacman_direction            ; (use .x to preserve the return code in .a)

exit_check_ud
        rts


check_can_move_left

        lda pacman_y_sub                ; check y sub position
        cmp #5                          ; if it's 5 (y centre of tile), continue ..
        beq ccml1
        ldx pacman_direction            ; load current direction into .x
        cmp #4                          ; if y sub position is 4 ..
        bne chkl2
        cpx #down                       ; .. and current direction is down
        beq ccml1                       ; continue ..
chkl2   cmp #6                          ; if y sub position is 6 ..
        bne ccmlx       
        cpx #up                         ; .. and current direction is up
        beq ccml1                       ; continue ..
                                       
ccmlx                                   ; cannot move in this direction
        lda #0                          ; return 0 in .a (could not move)
        rts                             ; exit the subroutine

ccml1   lda pacman_x_sub                ; load .a with x sub position
        cmp #6                          ; if sub position is 6-9 ..
        bcs move_left_sub               ; we can go ahead and move the character
                                        ; if sub position is 0-5
        lda #27
        sta num1                        ; set multiplicand to 27 (the length of a row)
        ldy pacman_y_tile  
        sty num2                        ; set multiplier to row number
        jsr multiply                    ; call multiply routine (puts result in .a)
        adc pacman_x_tile               ; add the x tile offset
        tax                             ; move result to x register
        dex                             ; decrement (as we want to look one tile to the left)
        stx matrix_offset               ; save the offset value (returned in .x)   
        jsr get_tile_type               ; load the tile type index, using x as an offset
        cmp #2                          ; if the index is 2 or greater ..
        bcs move_left                   ; move the character left
                                        ; otherwise, cannot move in this direction
        lda #0                          ; return 0 in .a (could not move)
        rts                             ; exit the subroutine

move_left

        lda #5                          ; set y sub position to 5 
        sta pacman_y_sub                ; (should already be, but can be 4 or 6 when turning corners)
        lda pacman_x_sub                ; load x sub position
        cmp #0                          ; if greater than zero ..
        
        bne move_left_sub               ; move left by sub position, otherwise (if zero) ..

        ; tunnel wrap-around

        lda pacman_x_tile
        cmp #1
        bne ml1
        lda pacman_y_tile
        cmp #10                         ; and y tile is 10
        bne ml1
        lda #26                         ; set x tile to 26 (will decrement in next step)
        sta pacman_x_tile

        lda $d010
        eor #%00000001                  ; flip sprite carry bit
        sta $d010

ml1     dec pacman_x_tile               ; decrement x tile position
        lda #9                          ; set x sub position to 9 (upper boundary)
        sta pacman_x_sub
           
        jsr set_pacman_sprite_left
        jsr update_pacman_sprite
        lda #1                          ; return 1 in .a (moved)
        rts
        
move_left_sub

        lda pacman_x_sub                ; load pacman x sub position
        sbc #1                          ; decrement
        sta pacman_x_sub                ; store that back to memory
        cmp #6                          ; does it equal 6?
        bne mls1                        ; if not, skip next instruction
        jsr eat_dot                     ; if so, clear power pill and increment score              
mls1    jsr set_pacman_sprite_left      ; set sprite pointer to the correct animation frame
        jsr update_pacman_sprite        ; update the sprite on screen
        lda #1                          ; return 1 in .a (moved)
        rts

check_can_move_right

        lda pacman_y_sub                ; check y sub position
        cmp #5                          ; if it's 5 (y centre of tile), continue ..
        beq ccmr1
        ldx pacman_direction            ; load current direction into .x
        cmp #4                          ; if y sub position is 4 ..
        bne chkr2
        cpx #down                       ; .. and current direction is down
        beq ccmr1                       ; continue ..
chkr2   cmp #6                          ; if y sub position is 6 ..
        bne ccmrx       
        cpx #up                         ; .. and current direction is up
        beq ccmr1                       ; continue ..
                                       
ccmrx                                   ; cannot move in this direction
        lda #0                          ; return 0 in .a (could not move)
        rts                             ; exit the subroutine

ccmr1   lda pacman_x_sub                ; load .a with x sub position
        cmp #5                          ; if sub position is 0-4 ..
        bcc move_right_sub              ; we can go ahead and move the character
                                        ; if sub position is 5-9
        lda #27
        sta num1                        ; set multiplicand to 27 (the length of a row)
        ldy pacman_y_tile  
        sty num2                        ; set multiplier to row number
        jsr multiply                    ; call multiply routine (puts result in .a)
        adc pacman_x_tile               ; add the x  tile offset
        tax                             ; move result to x register
        inx                             ; increment (as we want to look one tile to the right)
        stx matrix_offset               ; save the offset value             
        jsr get_tile_type               ; load the tile type index, using x as an offset
        cmp #2                          ; if the index is 2 or greater ..
        bcs move_right                  ; move the character right
                                        ; otherwise, cannot move in this direction
        lda #0                          ; return 0 in .a (could not move)
        rts                             ; exit the subroutine

move_right
        lda #5                          ; set y sub position to 5 
        sta pacman_y_sub                ; (should already be, but can be 4 or 6 when turning corners)
        lda pacman_x_sub                ; load x sub position
        cmp #9                          ; if less than 9 ..
        bne move_right_sub              ; move right by sub position, otherwise (if zero) ..
        
        ; tunnel wrap-around

        lda pacman_x_tile
        cmp #25                         ; if x tile is 25
        bne mr1
        lda pacman_y_tile
        cmp #10                         ; and y tile is 10
        bne mr1
        lda #0                          ; set x tile to zero (will increment to 1 in next step)
        sta pacman_x_tile        
        
        lda $d010
        eor #%00000001                  ; flip sprite carry bit
        sta $d010

mr1     inc pacman_x_tile               ; increment x tile position
        lda #0                          ; set x sub position to 0 (lower boundary)
        sta pacman_x_sub   
        
        jsr set_pacman_sprite_right
        jsr update_pacman_sprite
        lda #1                          ; return 1 in .a (moved)
        rts
        
move_right_sub

        lda pacman_x_sub                ; load pacman x sub position
        adc #1                          ; decrement
        sta pacman_x_sub                ; store that back to memory
        cmp #4                          ; does it equal 4?
        bne mrs1                        ; if not, skip next instruction
        jsr eat_dot                     ; if so, clear power pill and increment score  
mrs1    jsr set_pacman_sprite_right
        jsr update_pacman_sprite
        lda #1                          ; return 1 in .a (moved)
        rts

check_can_move_up

        lda pacman_x_sub                ; check x sub position
        cmp #5                          ; if it's 5 (x centre of tile), continue ..
        beq ccmu1
        ldx pacman_direction            ; load current direction into .x
        cmp #4                          ; if x sub position is 4 ..
        bne chku2
        cpx #right                      ; .. and current direction is right
        beq ccmu1                       ; continue ..
chku2   cmp #6                          ; if x sub position is 6 ..
        bne ccmux
        cpx #left                       ; .. and current direction is left
        beq ccmu1                       ; continue ..
                                       
ccmux                                   ; cannot move in this direction
        lda #0                          ; return 0 in .a (could not move)
        rts                             ; exit the subroutine

ccmu1   lda pacman_y_sub                ; load .a with y sub position
        cmp #6                          ; if sub position is 6-9 ..
        bcs move_up_sub                 ; we can go ahead and move the character
                                        ; if sub position is 0-5
        lda #27
        sta num1                        ; set multiplicand to 27 (the length of a row)
        ldy pacman_y_tile  
        dey
        sty num2                        ; set multiplier to row number
        jsr multiply                    ; call multiply routine (puts result in .a)
        adc pacman_x_tile               ; add the x tile offset
        tax                             ; move result to x register
        stx matrix_offset               ; save the offset value                
        jsr get_tile_type               ; load the tile type index, using x as an offset
        cmp #2                          ; if the index is 2 or greater ..
        bcs move_up                     ; move the character up ..
                                        ; otherwise, cannot move in this direction
        lda #0                          ; return 0 in .a (could not move)
        rts                             ; exit the subroutine

move_up
        lda #5                          ; set x sub position to 5 
        sta pacman_x_sub                ; (should already be, but can be 4 or 6 when turning corners)
        lda pacman_y_sub                ; load y sub position
        cmp #0                          ; if greater than zero ..
        bne move_up_sub                 ; move up by sub position, otherwise (if zero) ..
        dec pacman_y_tile               ; decrement y tile position
        lda #9                          ; set y sub position to 9 (upper boundary)
        sta pacman_y_sub   
        
        jsr set_pacman_sprite_up
        jsr update_pacman_sprite
        lda #1                          ; return 1 in .a (moved)
        rts
        
move_up_sub

        lda pacman_y_sub                ; load pacman x sub position
        sbc #1                          ; decrement
        sta pacman_y_sub                ; store that back to memory
        cmp #6                          ; does it equal 6?
        bne mus1                        ; if not, skip next instruction
        jsr eat_dot                     ; if so, clear power pill and increment score  
mus1    jsr set_pacman_sprite_up
        jsr update_pacman_sprite
        lda #1                          ; return 1 in .a (moved)
        rts   


check_can_move_down

        lda pacman_x_sub                ; check x sub position
        cmp #5                          ; if it's 5 (x centre of tile), continue ..
        beq ccmd1
        ldx pacman_direction            ; load current direction into .x
        cmp #4                          ; if x sub position is 4 ..
        bne chkd2
        cpx #right                      ; .. and current direction is right
        beq ccmd1                       ; continue ..
chkd2   cmp #6                          ; if x sub position is 6 ..
        bne ccmdx
        cpx #left                       ; .. and current direction is left
        beq ccmd1                       ; continue ..
                                      
ccmdx                                   ; cannot move in this direction
        lda #0                          ; return 0 in .a (could not move)
        rts                             ; exit the subroutine

ccmd1   lda pacman_y_sub                ; load .a with y sub position
        cmp #5                          ; if sub position is 0-4 ..
        bcc move_down_sub               ; we can go ahead and move the character
                                        ; if sub position is 5-9
        lda #27
        sta num1                        ; set multiplicand to 27 (the length of a row)
        ldy pacman_y_tile  
        iny
        sty num2                        ; set multiplier to row number
        jsr multiply                    ; call multiply routine (puts result in .a)
        adc pacman_x_tile               ; add the x tile offset
        tax                             ; move result to x register
        stx matrix_offset               ; save the offset value
        jsr get_tile_type               ; load the tile type index, using x as an offset
        cmp #2                          ; if the index is 2 or greater ..
        bcs move_down                   ; move the character down ..
                                        ; otherwise, cannot move in this direction
        lda #0                          ; return 0 in .a (could not move)
        rts                             ; exit the subroutine

move_down

        lda #5                          ; set x sub position to 5 
        sta pacman_x_sub                ; (should already be, but can be 4 or 6 when turning corners)
        lda pacman_y_sub                ; load y sub position
        cmp #9                          ; if less than 9 ..
        bne move_down_sub               ; move down by sub position, otherwise (if zero) ..
        inc pacman_y_tile               ; increment y tile position
        lda #0                          ; set y sub position to 0 (lower boundary)
        sta pacman_y_sub   
        
        jsr set_pacman_sprite_down
        jsr update_pacman_sprite
        lda #1                          ; return 1 in .a (moved)
        rts
        
move_down_sub

        lda pacman_y_sub                ; load pacman x sub position
        adc #1                          ; decrement
        sta pacman_y_sub                ; store that back to memory
        cmp #4                          ; does it equal 4?
        bne mds1                        ; if not, skip next instruction
        jsr eat_dot                     ; if so, clear power pill and increment score  
mds1    jsr set_pacman_sprite_down
        jsr update_pacman_sprite
        lda #1                          ; return 1 in .a (moved)
        rts   
