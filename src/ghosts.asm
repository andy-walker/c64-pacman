; ----------------------------------
; Entry point for ghost moving logic
; ----------------------------------

move_ghosts

        ldx #0
mg1     lda ghost0_direction,x
        cmp #2
        bcs mg1_ud
mg1_lr  ldy ghost0_x_sub
        cpy #5
        bne ghost_move_lr
        jsr get_available_directions


mg1_ud  ldy ghost0_y_sub
        cpy #5
        bne ghost_move_ud
        jsr get_available_directions

ghost_move_lr

        ;inx
        rts

ghost_move_ud
        rts


; ----------------------------------------
; Get directions in which ghost can move
; .x should be loaded with the ghost index
; returns result in .a as a bitfield
; ----------------------------------------

get_available_directions
        
        lda #0                          ; zero the available directions
        sta directions

        lda #27
        sta num1                        ; set multiplicand to 27 (the length of a row)
        lda ghost0_y_tile,x
        sta num2                        ; set multiplier to ghost y tile
        jsr multiply
        adc ghost0_x_tile,x             ; add the x tile offset
        pha                             ; push the offset (where the ghost is now) to stack
        sbc #1                          ; subtract 1 to look to the left
        tay                             ; transfer to y register (used as an offset in ghost_get_tile_type)
        lda ghost0_y_tile,x             ; load accumulator with ghost y tile position
        jsr ghost_get_tile_type
        cmp #0
        beq gad1
        lda directions
        ora #%00000001
        sta directions
        
gad1   
        pla                             ; restore the original offset to .a
        pha                             ; but also retain it on the stack
        adc #1                          ; add 1 to look to the right
        tay                             ; transfer to y register (used as an offset in ghost_get_tile_type)
        lda ghost0_y_tile,x             ; load accumulator with ghost y tile position
        jsr ghost_get_tile_type
        cmp #0
        beq gad2
        lda directions
        ora #%00000010
        sta directions
gad2    pla                             ; restore the original offset to .a
        pha                             ; but also retain it on the stack
        sbc #27                         ; subtract 27 to look at the tile above
        tay                             ; transfer to y register (used as an offset in ghost_get_tile_type)
        lda ghost0_y_tile,x             ; load accumulator with ghost y tile position
        jsr ghost_get_tile_type
        cmp #0
        beq gad3
        lda directions
        ora #%00000100
        sta directions
gad3    pla                             ; restore the original offset to .a
        adc #27                         ; add 27 to look at the tile below
        tay                             ; transfer to y register (used as an offset in ghost_get_tile_type)
        lda ghost0_y_tile,x             ; load accumulator with ghost y tile position
        jsr ghost_get_tile_type
        cmp #0
        beq gad4
        lda directions
        ora #%00001000
gad4    lda directions
        rts
   



; --------------------------------------------
; Routine to get the type of a tile
; .y should be loaded with the offset from 0,0
; .a should be loaded with the y offset
; returns tile type index in .a 
; --------------------------------------------

ghost_get_tile_type
        ;lda ghost_x_tile,x             
        cmp #9                          ; compare y tile position with 8
        bcc ggtt_top_section            ; if less than 9, branch to top section handler
        beq ggtt2                       ; if it's equal to 9, go to second check
        bcs ggtt3                       ; if it's greater than 9, go to third check
ggtt2   pha                             ; push accumulator to stack
        lda ghost0_x_tile,x             ; load ghost x tile position into .a  
        cmp #13                         ; compare x tile position with 13
        bcs ggtt_mid_section            ; if >= 13, branch to mid section handler
        jmp ggtt_top_section            ; otherwise, branch to top section handler
ggtt3   pla                             ; restore accumulator
        cmp #18
        beq ggtt4
        bcs ggtt_bottom_section
        jmp ggtt_mid_section            ; tmp - todo: more conditions for bottom section
ggtt4   cmp #25
        beq ggtt_bottom_section
        jmp ggtt_mid_section

ggtt_top_section
        lda level0,y                    ; load the tile type index, using x as an offset
        rts
ggtt_mid_section
        lda level0+256,y
        rts

ggtt_bottom_section
        cpy #255                        ; .x gets erroneously set to $ff when it should be $00
        bne ggtt5                       ; when targeting first tile - I have no idea why :(
        lda #3                          ; so just return a 3 in that case, which is the value we're after
        rts
ggtt5   lda level0+512,y
        rts
