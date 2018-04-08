; ----------------------------------
; Entry point for ghost moving logic
; ----------------------------------

move_ghosts
        ldx #0                          ; initialise offset register to 0
mg1                                     ; begin iterating over ghosts ..
        lda ghost0_mode,x
        cmp #idle
        beq mg_idle
        cmp #exit
        beq mg_exit

        lda ghost0_direction,x          ; load ghost's current direction
        cmp #2                          ; if 2 or 3 (up / down)
        bcs mg1_ud                      ; branch to up / down handler                 

mg1_lr  ldy ghost0_x_sub,x
        cpy #5
        bne ghost_move_lr
        jmp mg1_cd

mg1_ud  ldy ghost0_y_sub,x
        cpy #5
        bne ghost_move_ud
        jmp mg1_cd

mg_idle jmp ghost_idle
mg_exit jmp ghost_exit

; Choose a direction to move in

mg1_cd  jsr get_available_directions
        ;jsr get_available_directions2
        ;jsr choose_random_direction
        ;jmp mg1_tmp2
        ; choose direction based on mode
        ; cpx #0
        ; bne mg1_tmp
        ;jsr filter_directions
mg1_tmp
        lda dir5
        sec
        sbc #1
        
        jsr choose_random

        tay
        lda dir1,y
mg1_tmp2
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
        bne ghost_move_left_sub         ; move left by sub position
                                        ; otherwise (if zero) ..
        ; tunnel wrap-around

        lda ghost0_x_tile,x
        cmp #1                          ; if x tile is 1
        bne gml1
        lda ghost0_y_tile,x
        cmp #10                         ; and y tile is 10
        bne gml1
        lda #26                         ; set x tile to 26 (will decrement in next step)
        sta ghost0_x_tile,x
        
        lda #1                          ; set sprite carry
        sta sprite1_carry,x
        sta sprite5_carry,x

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
        
        lda #0                          ; unset sprite carry
        sta sprite1_carry,x
        sta sprite5_carry,x

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
        cpx #2
        beq ghost_move_all_complete
        inx
        jmp mg1

ghost_move_all_complete
        rts

; ghost idle mode - move up and down within the ghost house until 'exit' mode triggered

ghost_idle
        lda ghost0_direction,x
        ldy ghost0_y_sub,x
        cmp #down
        beq gi_down
gi_up   cpy #5
        bne giu_mv
        lda ghost0_y_tile,x
        cmp #9
        bne giu_mv
        jmp gid_mv
giu_mv  jmp ghost_move_up
gi_down cpy #5
        bne gid_mv
        lda ghost0_y_tile,x
        cmp #11
        bne gid_mv
        jmp giu_mv
gid_mv  jmp ghost_move_down

; ghost exit mode - move left / right, then up and out of the ghost house

ghost_exit
        lda ghost0_y_tile,x
        cmp #7
        bne gex1
        inc ghost0_mode,x
gex1    cpx #pinky
        bne gex2
        jmp ghost_move_up
gex2    cpx #inky
        bne gex3


gex3        


; ----------------------------------------
; Get directions in which ghost can move
; .x should be loaded with the ghost index
; returns result in .a as a bitfield
; ----------------------------------------

get_available_directions

        lda #0
        sta dir5                        ; initialise dir5 to zero (length of available directions)

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
        tay                             ; transfer to y register (used as an offset in ghost_get_tile_type)
        
        lda ghost0_x_tile,x
        sec
        sbc #1
        sta num1

        lda ghost0_y_tile,x             ; load accumulator with ghost y tile position
        jsr ghost_get_tile_type
        cmp #$02
        bcc gd1
        lda ghost0_direction,x          ; check current direction
        cmp #right                      ; if it's right, skip to next
        beq gd1                         ; (cannot reverse direction)
        lda #1
        lda #left
        sta dir1
        inc dir5

gd1     lda tmp2                        ; restore the original offset (where the ghost is now)
        clc
        adc #1                          ; add 1 to look to the right
        tay                             ; transfer to y register (used as an offset in ghost_get_tile_type)

        lda ghost0_x_tile,x
        clc
        adc #1
        sta num1

        lda ghost0_y_tile,x             ; load accumulator with ghost y tile position

        jsr ghost_get_tile_type
        clc
        cmp #$02
        bcc gd2
        lda ghost0_direction,x          ; check current direction
        cmp #left                       ; if it's left, skip to next
        beq gd2                         ; (cannot reverse direction)
        lda #1
        ldy dir5
        lda #right
        sta dir1,y
        inc dir5

gd2     lda tmp2                        ; restore the original offset (where the ghost is now)
        sec
        sbc #27                         ; subtract 27 to look at the tile above
        tay                             ; transfer to y register (used as an offset in ghost_get_tile_type)
        
        lda ghost0_x_tile,x
        sta num1

        lda ghost0_y_tile,x             ; load accumulator with ghost y tile position
        sec
        sbc #1

        jsr ghost_get_tile_type
        cmp #$02
        bcc gd3
        lda ghost0_direction,x          ; check current direction
        cmp #down                       ; if it's down, skip to next
        beq gd3                         ; (cannot reverse direction)
        lda #1
        ldy dir5
        lda #up
        sta dir1,y
        inc dir5

gd3     lda tmp2                        ; restore the original offset (where the ghost is now)
        clc
        adc #27                         ; add 27 to look at the tile below
        tay                             ; transfer to y register (used as an offset in ghost_get_tile_type)
        
        lda ghost0_x_tile,x
        sta num1
        
        lda ghost0_y_tile,x             ; load accumulator with ghost y tile position
        clc
        adc #1

        jsr ghost_get_tile_type
        cmp #$02
        bcc gd4
        lda ghost0_direction,x          ; check current direction
        cmp #up                         ; if it's up, skip to end
        beq gd4                         ; (cannot reverse direction)
        lda #1
        ldy dir5
        lda #down
        sta dir1,y
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
        bcs ggtt_bottom_section
        jmp ggtt_mid_section

ggtt_top_section
        lda level0,y                    ; load the tile type index, using x as an offset
        rts
ggtt_mid_section
        lda level0+256,y
        rts
ggtt_bottom_section
        lda tmp1
        cmp #19
        beq ggtt7
        lda num1
        cmp #26
        beq ggtt6
        cpy #255                        ; .y gets erroneously set to $ff when it should be $00
        beq ggtt5                       ; when targeting first tile - I have no idea why :(
        jmp ggtt6
ggtt5   lda #3                          
        rts
ggtt6   lda #0
        rts
ggtt7   lda #3
        lda level0+512,y
        rts


; ----------------------------------------------------------
; Calculate ghost's target tile and choose a direction from
; the available directions (in dir1-4) based on that
; .x is our ghost index counter (0-3)
; Return the chosen direction in .a
; ----------------------------------------------------------

filter_directions

        lda dir1
        sta dbg1
        lda dir2
        sta dbg2
        lda dir3
        sta dbg3
        lda dir4
        sta dbg4
        lda dir5
        sta dbg5        
        
        stx tmp1                        ; save .x register temporarily, as we'll need it below

        lda dir5
        cmp #1
        bne fd_start
        rts

fd_start

; set up a bitfield of available directions (todo: would be good
; if dir1-5 were replaced with a bitfield in the future)
        
        ldy #0
        lda #%00000000
cd_loop ldx dir1,y
        cpx #left
        bne cdc_right
        eor #%00001000
cdc_right
        cpx #right
        bne cdc_up
        eor #%00000100
cdc_up
        cpx #up
        bne cdc_down
        eor #%00000010
cdc_down
        cpx #down
        bne cdc_end
        eor #%00000001
cdc_end
        iny
        cpy dir5
        bcc cd_loop

        ldx tmp1                        ; restore x register
        sta tmp1                        ; temporarily save the bitfield value to tmp1
        sta dbg6

; check which ghost we are and set the target square
; depending on which mode we're in.
; .a will be set to target x tile
; .y will be set to target y tile

check_ghost0      
        cpx #0
        bne check_ghost1
        lda pacman_x_tile               ; Blinky always targets pacman, even in scatter mode
        ldy pacman_y_tile

check_ghost1
        cpx #1
        bne check_ghost2

check_ghost2
        cpx #2
        bne check_ghost3

check_ghost3
        ; if we got to here, we must be ghost3 - so skip .x register check
        
; check which directions are available, and calculate the 
; best one to take to reach the target tile in the shortest route

        sta num1                        ; store target x in num1
        sty num2                        ; store target y in num2
        lda tmp1                        ; load .a with our bitfield

        ldy #0
        sty dbg20
        sty dbg21
        sty dbg22
        sty dbg23

        ldy ghost0_x_tile,x             ; load .y with ghost x
        cpy num1                        ; compare to target x
        beq cgd_y
        bcc cgd_xgt
cgd_xlt                                 ; if target x is less
        and #%11111011                  ; unset right
        sta dbg20
        jmp cgd_y
cgd_xgt                                 ; if target x is greater
        and #%11110111                  ; unset left
        sta dbg21
cgd_y
        ldy ghost0_y_tile,x             ; load .y with ghost y
        cpy num2                        ; compare with target y
        beq cgd_filter_dir
        bcc cgd_ygt
cgd_ylt                                 ; if target y is less
        and #%11111110                  ; unset down
        sta dbg22
        jmp cgd_filter_dir
cgd_ygt                                 ; if target y is greater
        and #%11111101                  ; unset up
        sta dbg23
cgd_filter_dir 
        ldy #0
        sta num1
        sta dbg16
        lda num1
        and #%00001000
        cmp #0
        beq cgd_right
        lda #left
        sta dir1,y
        iny 
cgd_right
        lda num1
        and #%00000100
        cmp #0
        beq cgd_up
        lda #right
        sta dir1,y
        iny
cgd_up  
        lda num1
        and #%00000010
        cmp #0
        beq cgd_down
        lda #up
        sta dir1,y
        iny
cgd_down
        lda num1
        and #%00000001
        cmp #0
        beq cgd_end
        lda #down
        sta dir1,y
        iny

cgd_end
        sty dir5

        lda dir1
        sta dbg11
        lda dir2
        sta dbg12
        lda dir3
        sta dbg13
        lda dir4
        sta dbg14
        lda dir5
        sta dbg15


        rts