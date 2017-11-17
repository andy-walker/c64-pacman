; ----------------------------------
; Entry point for ghost moving logic
; ----------------------------------

move_ghosts
        ; rts ; disable for now
        ldx #0
mg1     lda ghost0_direction,x
        cmp #2
        bcs mg1_ud
mg1_lr  ldy ghost0_x_sub,x
        cpy #5
        bne ghost_move_lr
        jsr get_available_directions
        lda dir5
        sec
        sbc #1
        ; lda #2
        jsr choose_random
        sta dbg13 
        tay
        lda dir1,y
        jmp ghost_change_direction
mg1_ud  ldy ghost0_y_sub,x
        cpy #5
        bne ghost_move_ud
        jsr get_available_directions
        lda dir5
        sec
        sbc #1
        ; lda #2

        jsr choose_random
        sta dbg13
        tay
        lda dir1,y
        jmp ghost_change_direction

ghost_move_lr
        ; .a should still be loaded with the ghost's direction at this point
        cmp #left
        beq ghost_move_left
        jmp ghost_move_right

ghost_move_ud
        ; .a should still be loaded with the ghost's direction at this point
        cmp #up
        beq gm_up
        jmp gm_down

ghost_change_direction
        cmp #left
        beq ghost_move_left
        cmp #right
        beq ghost_move_right
        cmp #up
        beq gm_up
        cmp #down
        beq gm_down

        ; should not get to here, but for the moment (just in case)
        jmp ghost_move_end

gm_up   jmp ghost_move_up
gm_down jmp ghost_move_down

ghost_move_left

        lda ghost0_x_sub,x              ; load ghost x sub position
        cmp #0                          ; if greater than zero ..        
        bne ghost_move_left_sub         ; move left by sub position, otherwise (if zero) ..

        ; tunnel wrap-around

        lda ghost0_x_tile,x
        cmp #1                          ; if x tile is 1
        bne gml1
        lda ghost0_y_tile,x
        cmp #10                         ; and y tile is 10
        bne gml1
        lda #26                         ; set x tile to 26 (will decrement in next step)
        sta ghost0_x_tile,x
        lda $d010
        eor #%00100010                  ; also flip sprites' carry bits
        sta $d010
gml1
        dec ghost0_x_tile,x             ; decrement x tile position
        lda #9                          ; set x sub position to 9 (upper boundary)
        sta ghost0_x_sub,x  
        
        ldy #left                       ; load .y with current direction
        sty ghost0_direction,x          ; store the direction
        jsr set_ghost_sprite            ; set sprite pointers for the current ghost
        jsr update_ghost_sprite         ; update the sprite on screen
        jmp ghost_move_end              ; jump to end of routine
        
ghost_move_left_sub

        dec ghost0_x_sub,x              ; decrement ghost x sub position

        ldy #left                       ; load .y with current direction
        sty ghost0_direction,x          ; store the direction
        jsr set_ghost_sprite            ; set sprite pointers for the current ghost
        jsr update_ghost_sprite         ; update the sprite on screen
        jmp ghost_move_end              ; jump to end of routine 

ghost_move_right

        lda ghost0_x_sub,x              ; load x sub position
        cmp #9                          ; if less than 9 ..
        bne ghost_move_right_sub        ; move right by sub position, otherwise (if zero) ..
        
        ; tunnel wrap-around

        lda ghost0_x_tile,x
        cmp #25                         ; if x tile is 25
        bne gmr1
        lda ghost0_y_tile,x
        cmp #10                         ; and y tile is 10
        bne gmr1
        lda #0                          ; set x tile to zero (will increment to 1 in next step)
        sta ghost0_x_tile,x

        lda $d010
        eor #%00100010                  ; also flip sprites' carry bits at this point
        sta $d010

gmr1    
        inc ghost0_x_tile,x             ; increment x tile position
        lda #0                          ; set x sub position to 0 (lower boundary)
        sta ghost0_x_sub,x   
        
        ldy #right                      ; load .y with current direction
        sty ghost0_direction,x          ; store the direction
        jsr set_ghost_sprite            ; set sprite pointers for the current ghost
        jsr update_ghost_sprite         ; update the sprite on screen
        jmp ghost_move_end              ; jump to end of routine 
        
ghost_move_right_sub

        inc ghost0_x_sub,x              ; increment ghost x sub position

        ldy #right                      ; load .y with current direction
        sty ghost0_direction,x          ; store the direction
        jsr set_ghost_sprite            ; set sprite pointers for the current ghost
        jsr update_ghost_sprite         ; update the sprite on screen
        jmp ghost_move_end              ; jump to end of routine 

ghost_move_up

        lda ghost0_y_sub,x              ; load y sub position
        cmp #0                          ; if greater than 0 ..
        bne ghost_move_up_sub           ; move up by sub position, otherwise (if zero) ..
        dec ghost0_y_tile,x             ; decrement y tile position
        lda #9                          ; set y sub position to 9 (upper boundary)
        sta ghost0_y_sub,x   
        
        ldy #up                         ; load .y with current direction
        sty ghost0_direction,x          ; store the direction
        jsr set_ghost_sprite            ; set sprite pointers for the current ghost
        jsr update_ghost_sprite         ; update the sprite on screen
        jmp ghost_move_end              ; jump to end of routine 

ghost_move_up_sub

        dec ghost0_y_sub,x              ; increment ghost y sub position

        ldy #up                         ; load .y with current direction
        sty ghost0_direction,x          ; store the direction
        jsr set_ghost_sprite            ; set sprite pointers for the current ghost
        jsr update_ghost_sprite         ; update the sprite on screen
        jmp ghost_move_end              ; jump to end of routine 

ghost_move_down

        lda ghost0_y_sub,x              ; load y sub position
        cmp #9                          ; if less than 9 ..
        bne ghost_move_down_sub         ; move down by sub position, otherwise (if zero) ..
        inc ghost0_y_tile,x             ; increment y tile position
        lda #0                          ; set y sub position to 0 (lower boundary)
        sta ghost0_y_sub,x   
        
        ldy #down                       ; load .y with current direction
        sty ghost0_direction,x          ; store the direction
        jsr set_ghost_sprite            ; set sprite pointers for the current ghost
        jsr update_ghost_sprite         ; update the sprite on screen
        jmp ghost_move_end              ; jump to end of routine 


ghost_move_down_sub

        inc ghost0_y_sub,x              ; increment ghost y sub position

        ldy #down                       ; load .y with current direction
        sty ghost0_direction,x          ; store the direction
        jsr set_ghost_sprite            ; set sprite pointers for the current ghost
        jsr update_ghost_sprite         ; update the sprite on screen
        jmp ghost_move_end              ; jump to end of routine 


ghost_move_end
        ; cpx #3
        ; beq ghost_move_all_complete
        ; inx
        ; jmp mg1

ghost_move_all_complete
        rts


; ----------------------------------------
; Get directions in which ghost can move
; .x should be loaded with the ghost index
; returns result in .a as a bitfield
; ----------------------------------------

get_available_directions

        lda #0
        sta dir5                        ; initialise dir5 to zero (length of available directions)

        ; temp
        sta dbg5
        sta dbg6
        sta dbg7
        sta dbg8
        lda #4
        sta dbg9
        sta dbg10
        sta dbg11
        sta dbg12

        lda #27
        sta num1                        ; set multiplicand to 27 (the length of a row)
        lda ghost0_y_tile,x
        sta num2                        ; set multiplier to ghost y tile
        jsr multiply
        clc
        adc ghost0_x_tile,x             ; add the x tile offset
        sta tmp2                        ; store the offset (where the ghost is now)
        sec
        sbc #1                          ; subtract 1 to look to the left
        sta dbg16
        tay                             ; transfer to y register (used as an offset in ghost_get_tile_type)
        
        lda ghost0_x_tile,x
        sec
        sbc #1
        sta num1
        sta dbg20

        lda ghost0_y_tile,x             ; load accumulator with ghost y tile position
        sta dbg24
        jsr ghost_get_tile_type
        ; lda #0
        sta dbg1
        cmp #$00
        beq gd1
        lda ghost0_direction,x          ; check current direction
        cmp #right                      ; if it's right, skip to next
        beq gd1                         ; (cannot reverse direction)
        lda #1
        sta dbg5
        lda #left
        sta dir1
        sta dbg9
        inc dir5

gd1     lda tmp2                        ; restore the original offset (where the ghost is now)
        clc
        adc #1                          ; add 1 to look to the right
        sta dbg17
        tay                             ; transfer to y register (used as an offset in ghost_get_tile_type)

        lda ghost0_x_tile,x
        clc
        adc #1
        sta num1
        sta dbg21

        lda ghost0_y_tile,x             ; load accumulator with ghost y tile position
        sta dbg25

        jsr ghost_get_tile_type
        clc
        sta dbg2
        cmp #$00
        beq gd2
        lda ghost0_direction,x          ; check current direction
        cmp #left                       ; if it's left, skip to next
        beq gd2                         ; (cannot reverse direction)
        lda #1
        sta dbg6
        ldy dir5
        lda #right
        sta dir1,y
        sta dbg10
        inc dir5

gd2     lda tmp2                        ; restore the original offset (where the ghost is now)
        sec
        sbc #27                         ; subtract 27 to look at the tile above
        sta dbg18
        tay                             ; transfer to y register (used as an offset in ghost_get_tile_type)
        
        lda ghost0_x_tile,x
        sta num1
        sta dbg22

        lda ghost0_y_tile,x             ; load accumulator with ghost y tile position
        sec
        sbc #1
        sta dbg26

        jsr ghost_get_tile_type
        sta dbg3
        cmp #$00
        beq gd3
        lda ghost0_direction,x          ; check current direction
        cmp #down                       ; if it's down, skip to next
        beq gd3                         ; (cannot reverse direction)
        lda #1
        sta dbg7
        ldy dir5
        lda #up
        sta dir1,y
        sta dbg11
        inc dir5

gd3     lda tmp2                        ; restore the original offset (where the ghost is now)
        clc
        adc #27                         ; add 27 to look at the tile below
        sta dbg19
        tay                             ; transfer to y register (used as an offset in ghost_get_tile_type)
        
        lda ghost0_x_tile,x
        sta num1
        sta dbg23
        
        lda ghost0_y_tile,x             ; load accumulator with ghost y tile position
        clc
        adc #1
        sta dbg27

        jsr ghost_get_tile_type
        sta dbg4
        cmp #$00
        beq gd4
        lda ghost0_direction,x          ; check current direction
        cmp #up                         ; if it's up, skip to end
        beq gd4                         ; (cannot reverse direction)
        lda #1
        sta dbg8
        ldy dir5
        lda #down
        sta dir1,y
        sta dbg12
        inc dir5
gd4     rts


; --------------------------------------------
; Routine to get the type of a tile
; .x should be loaded with the ghost index
; .y should be loaded with the offset from 0,0
; .a should be loaded with the y offset
; num1 should be loaded with the x offset
; returns tile type index in .a 
; --------------------------------------------

ghost_get_tile_type            
        sta tmp1                        ; temporarily store y position
        cmp #9                          ; compare y tile position with 9
        bcc ggtt_top_section            ; if less than 9, branch to top section handler
        beq ggtt2                       ; if it's equal to 9, go to second check
        bcs ggtt3                       ; if it's greater than 9, go to third check
ggtt2   
        lda num1                        ; load target x tile position into .a  
        cmp #13                         ; compare x tile position with 13
        bcs ggtt_mid_section            ; if >= 13, branch to mid section handler
        jmp ggtt_top_section            ; otherwise, branch to top section handler
ggtt3   lda tmp1                        ; restore y position to .a
        cmp #18
        beq ggtt4
        bcs ggtt_bottom_section
        jmp ggtt_mid_section
ggtt4   lda num1
        cmp #25
        beq ggtt_bottom_section
        jmp ggtt_mid_section

ggtt_top_section
        lda #1
        sta dbg39
        lda level0,y                    ; load the tile type index, using x as an offset
        rts
ggtt_mid_section
        lda #2
        sta dbg39
        lda level0+256,y
        rts

ggtt_bottom_section
        lda num1
        cmp #255                        ; .x gets erroneously set to $ff when it should be $00
        bne ggtt5                       ; when targeting first tile - I have no idea why :(
        lda #3                          ; so just return a 3 in that case, which is the value we're after
        rts
ggtt5   lda #3
        sta dbg39
        lda level0+512,y
        rts
