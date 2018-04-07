; ----------------
; Initialise level
; ----------------

init_level
        lda #0
        sta frightened_mode
        
        sta ghost2_mode
        sta ghost3_mode

        lda #chase
        sta ghost0_mode

        ; pinky should leave ghost house when level begins
        lda #exit
        sta ghost1_mode

        ; ensure ghost 0 always moves to the left, and
        ; doesn't head back into the ghost house
        dec ghost0_x_sub

        rts

draw_level 
        
        ; load characters for each line
        lda lvlch1,x
        sta $0404,x
        lda lvlch2,x
        sta $042c,x
        lda lvlch3,x
        sta $0454,x
        lda lvlch4,x
        sta $047c,x
        lda lvlch5,x
        sta $04a4,x
        lda lvlch6,x
        sta $04cc,x
        lda lvlch7,x
        sta $04f4,x
        lda lvlch8,x
        sta $051c,x
        lda lvlch9,x
        sta $0544,x       
        lda lvlch10,x
        sta $056c,x  
        lda lvlch11,x
        sta $0594,x  
        lda lvlch12,x
        sta $05bc,x 
        lda lvlch13,x
        sta $05e4,x 
        lda lvlch14,x
        sta $060c,x 
        lda lvlch15,x
        sta $0634,x 
        lda lvlch16,x
        sta $065c,x 
        lda lvlch17,x
        sta $0684,x 
        lda lvlch18,x
        sta $06ac,x 
        lda lvlch19,x
        sta $06d4,x 
        lda lvlch20,x
        sta $06fc,x 
        lda lvlch21,x
        sta $0724,x 
        lda lvlch22,x
        sta $074c,x 
        lda lvlch23,x
        sta $0774,x 
        lda lvlch24,x
        sta $079c,x 
        lda lvlch25,x
        sta $07c4,x 

        ; load colour information for each line
        lda lvlcl1,x
        sta $d804,x
        lda lvlcl2,x
        sta $d82c,x
        lda lvlcl3,x
        sta $d854,x
        lda lvlcl4,x
        sta $d87c,x
        lda lvlcl5,x
        sta $d8a4,x
        lda lvlcl6,x
        sta $d8cc,x
        lda lvlcl7,x
        sta $d8f4,x
        lda lvlcl8,x
        sta $d91c,x
        lda lvlcl9,x
        sta $d944,x       
        lda lvlcl10,x
        sta $d96c,x  
        lda lvlcl11,x
        sta $d994,x
        lda lvlcl12,x
        sta $d9bc,x
        lda lvlcl13,x
        sta $d9e4,x
        lda lvlcl14,x
        sta $da0c,x
        lda lvlcl15,x
        sta $da34,x
        lda lvlcl16,x
        sta $da5c,x
        lda lvlcl17,x
        sta $da84,x
        lda lvlcl18,x
        sta $daac,x
        lda lvlcl19,x
        sta $dad4,x
        lda lvlcl20,x
        sta $dafc,x
        lda lvlcl21,x
        sta $db24,x
        lda lvlcl22,x
        sta $db4c,x
        lda lvlcl23,x
        sta $db74,x
        lda lvlcl24,x
        sta $db9c,x
        lda lvlcl25,x
        sta $dbc4,x

        inx
        cpx #33
        bne next_char
        ; jmp level_init_sprites
        rts
next_char
        jmp draw_level


; --------------------------------
; Initialise ghost frightened mode
; --------------------------------

init_frightened_mode
        
        lda #1                          ; set frightened_mode to 1
        sta frightened_mode
        lda #0                          ; zero timer_seconds / timer_ticks
        sta timer_ticks
        sta timer_seconds
        
        lda #blue                       ; set ghost sprites to blue
        sta sprite1_colour
        sta sprite2_colour
        sta sprite3_colour
        sta sprite4_colour                  
        
        lda #white                      ; set eye sprites to purple
        sta sprite5_colour
        sta sprite6_colour
        sta sprite7_colour
        sta sprite8_colour

        rts


; ------------------------------------------------------------
; Routine to locate the correct dot or power pill character,
; remove it and increment player score.
; ------------------------------------------------------------

eat_dot

        ldx matrix_offset
        ldy pacman_y_tile
        lda pacman_x_tile
        jsr get_translated

        lda pacman_y_tile
        ldx pacman_x_tile
        cmp #5
        beq ed1
        bcs ed2
        jmp eat1
ed1     cpx #10
        bcc eat1
        jmp eat2
ed2     cmp #11
        bcs ed3
        jmp eat2
ed3     cmp #16
        bcs ed4
        jmp eat3
ed4     cpy #255
        beq eat3
        jmp eat4

eat1    lda $0400,y                     ; check if contents of screen memory is 7 (blank space)
        cmp #7                          ; if so, has already been eaten
        beq ed_end                      ; (go to end of routine)
        lda #7                          ; otherwise set screen memory to 7 (blank space character)                       
        sta $0400,y                        
        jmp ed_final

eat2    lda $0500,y                     ; check if contents of screen memory is 7 (blank space)
        cmp #7                          ; if so, has already been eaten
        beq ed_end                      ; (go to end of routine)
        lda #7                          ; otherwise set screen memory to 7 (blank space character)  
        sta $0500,y
        jmp ed_final

eat3    lda $0600,y                     ; check if contents of screen memory is 7 (blank space)
        cmp #7                          ; if so, has already been eaten
        beq ed_end                      ; (go to end of routine)
        lda #7                          ; otherwise set screen memory to 7 (blank space character)  
        sta $0600,y                        
        jmp ed_final

eat4    lda $0700,y                     ; check if contents of screen memory is 7 (blank space)
        cmp #7                          ; if so, has already been eaten
        beq ed_end                      ; (go to end of routine)
        lda #7                          ; otherwise set screen memory to 7 (blank space character)  
        sta $0700,y

ed_final

        ; if we ate something ..
        
        inc dot_counter

        ldx matrix_offset
        ldy pacman_y_tile
        lda pacman_x_tile

        jsr get_tile_type
        cmp #4                          ; if it's not 4 (power pill)                       
        bne ed_10                       ; jump to ed_10 ..
        jsr init_frightened_mode        ; otherwise initialise frightened mode (power pill eaten)
        
        ; add 50 points to player score

        lda #$00
        sta num1
        lda #$50
        sta num2
        jsr add_to_score

        jmp ed_end

        ; add 10 points to player score
ed_10   
        lda #$00
        sta num1
        lda #$10
        sta num2
        jsr add_to_score

ed_end  rts


; ----------------------------------------------
; Initialise character sprites to their starting 
; positions at the beginning of a level
; ----------------------------------------------

level_init_sprites

        lda %00000001                   ; set only blinky as active on level start
        sta ghost_active

        ; set sprite colours

        lda #yellow 
        sta sprite0_colour              ; sprite 0: colour yellow
        lda #red
        sta sprite1_colour              ; sprite 1: colour red
        lda #pink
        sta sprite2_colour              ; sprite 2: colour purple
        lda #cyan
        sta sprite3_colour              ; sprite 3: colour cyan
        lda #orange
        sta sprite4_colour              ; sprite 4: colour orange
        lda #white
        sta sprite5_colour
        sta sprite6_colour
        sta sprite7_colour
        sta sprite8_colour

        lda #0
        sta sprite0_carry
        sta sprite1_carry
        sta sprite2_carry
        sta sprite3_carry
        sta sprite4_carry
        sta sprite5_carry
        sta sprite6_carry
        sta sprite7_carry

        lda #13                         ; initialise pacman tile position
        sta pacman_x_tile
        lda #15
        sta pacman_y_tile
        
        lda #13                         ; initialise ghost0 (blinky) tile position
        sta ghost0_x_tile
        lda #7
        sta ghost0_y_tile

        lda #13
        sta ghost1_x_tile
        lda #9
        sta ghost1_y_tile

        lda #5                          ; initialise all x sub positions to 5 (tile centre)
        sta pacman_x_sub
        sta ghost0_x_sub
        sta ghost1_x_sub

        lda #5                          ; initialise all y sub positions to 5 (tile centre)
        sta ghost0_y_sub
        sta pacman_y_sub

        lda #7
        sta ghost1_y_sub

        jsr set_pacman_sprite_left
        jsr update_pacman_sprite

        ldx #0                          ; set .x to ghost index (0)
        ldy #left                       ; set .y to ghost direction
        sty ghost0_direction            ; store direction

        jsr set_ghost_sprite            ; set and update ghost[0] sprites
        jsr update_ghost_sprite

        ldx #1                          ; set .x to ghost index (1)
        ldy #up                         ; set .y to ghost direction
        sty ghost1_direction            ; store direction

        jsr set_ghost_sprite            ; set and update ghost[1] sprites
        jsr update_ghost_sprite

        rts


; ----------------------------------------------------
; Routine to run at the beginning of each cycle
; of the game loop - handles gameplay mode, timers etc
; ----------------------------------------------------

level_init_frame
        
        ldx flash_counter
        cpx #12
        beq lf_flash_black
        cpx #0
        beq lf_flash_white
        jmp lf_next
lf_flash_black
        lda #black
        jmp lf_flash
lf_flash_white
        lda #white
        ldx #0
        
lf_flash
        sta $d87d
        sta $d89b
        sta $dad5
        sta $daf3
lf_next 

        ; handle timer for frightened mode

        lda frightened_mode             
        cmp #0                          ; if ghosts not in frightened mode 
        beq lf_exit                     ; skip to end of subroutine
        jmp lf0
lf_exit jmp lf_end                                       
lf0     cmp #2
        bne lf2
        ldx timer_ticks
        cpx #0
        bne lf1

        lda #white                      ; set ghost sprites to white   
        sta sprite1_colour
        sta sprite2_colour
        sta sprite3_colour
        sta sprite4_colour

        lda #pink                       ; set eye sprites to pink
        sta sprite5_colour
        sta sprite6_colour
        sta sprite7_colour
        sta sprite8_colour

        jmp lf2

lf1     cpx #25
        bne lf2

        lda #blue                       ; set ghost sprites to blue
        sta sprite1_colour
        sta sprite2_colour
        sta sprite3_colour
        sta sprite4_colour

        lda #white                      ; set eye sprites to white
        sta sprite5_colour
        sta sprite6_colour
        sta sprite7_colour
        sta sprite8_colour             

lf2     inc timer_ticks                 ; increment timer ticks
        ldx timer_ticks                 ; and load into .x
        cpx #50                         ; compare to 50 (framerate = 50fps)
        bne lf_end                      ; if not equal, skip to end of sub
                                        ; otherwise (if equal) ..
        inc timer_seconds               ; increment timer seconds
        lda timer_seconds               ; and load the value into .a
        ldx #0                          ; reset ticks to zero                
        stx timer_ticks

        cmp #5                          ; if less than 5
        bcc lf_end                      ; skip to end of subroutine (remain in frightened mode)
        beq lf_frightened_mode_flash    ; if equal to 5, increment mode (to cause ghosts to flash)

        cmp #8                          ; if 8 seconds ..
        beq lf_end_frightened_mode      ; jump to end frightened mode branch
        jmp lf_end                      ; otherwise, skip to end of sub

lf_frightened_mode_flash

        inc frightened_mode             ; increment frightened mode to 2
        jmp lf_end                      ; then jump to end 

lf_end_frightened_mode

        lda #0                          ; set frightened mode to zero
        sta frightened_mode

        lda #red 
        sta sprite1_colour              ; sprite 1: colour red
        lda #pink
        sta sprite2_colour              ; sprite 2: colour purple
        lda #cyan
        sta sprite3_colour              ; sprite 3: colour cyan
        lda #orange
        sta sprite4_colour              ; sprite 4: colour orange
        
        lda #white
        sta sprite5_colour
        sta sprite6_colour
        sta sprite7_colour
        sta sprite8_colour          

lf_end  rts

; ---------------------------------------------------------
; Routine to run at the end of each cycle
; of the game loop - triggers level end when all dots eaten,
; checks for collisions with ghosts
; ---------------------------------------------------------

level_end_frame

        ; check for collisions between pacman and ghosts

        jsr detect_collisions
        cmp #0
        beq lef2

        lda #life_lost                  ; set game mode to life_lost
        sta game_mode

        jmp lef3                        ; jump to end of sub (initialising timer)


lef2    lda dot_counter
        cmp #210
        bcc lef_end
        
        ; we've reached the end of the level (all dots eaten)
        
        lda #sprite_base                ; set default pacman sprite
        sta sprite0_pointer

        lda #level_complete
        sta game_mode

        lda #0
        sta dot_counter                 ; reset the dot counter ready for next level

lef3    lda #0
        sta timer_seconds
        sta timer_ticks

lef_end rts


; -----------------------------------------------
; Get translated row offset (helper for the above 
; routine - may be useful elsewhere)
; .x should be loaded with the matrix offset
; .y should be loaded with y tile position
; .a should be loaded with x tile position
; returns translated offset in .y
; -----------------------------------------------

get_translated
        cpy #9
        bcc gtr_top_section
        beq gtr2
        bcs gtr3
gtr2    cmp #13
        bcs gtr_mid_section
        jmp gtr_top_section
gtr3    cpy #18
        beq gtr4
        bcs gtr_bottom_section
        jmp gtr_mid_section
gtr4    cmp #25
        beq gtr_bottom_section
        jmp gtr_mid_section

gtr_top_section
        ldy translate0,x                ; load the translation offset, using x as an offset
        rts

gtr_mid_section
        ldy translate0+256,x
        rts

gtr_bottom_section
        cpx #255                        ; .x gets erroneously set to $ff when it should be $00
        bne gtr5                        ; when targeting first tile - I have no idea why :(
        ldy #147                        ; so just return a 147 in that case, which is the value we're after
        rts
gtr5    ldy translate0+512,x
        rts


; --------------------------------------------
; Routine to get the type of a tile
; .x should be loaded with the offset from 0,0
; .y should be loaded with the y tile index
; returns tile type index in .a 
; --------------------------------------------

get_tile_type
        lda pacman_x_tile               ; load x tile position into .a  
        cpy #9                          ; compare y tile position with 9
        bcc gtt_top_section             ; if less than 9, branch to top section handler
        beq gtt2                        ; if it's equal to 9, go to second check
        bcs gtt3                        ; if it's greater than 9, go to third check
gtt2    cmp #13                         ; compare x tile position with 13
        bcs gtt_mid_section             ; if >= 13, branch to mid section handler
        jmp gtt_top_section             ; otherwise, branch to top section handler
gtt3    cpy #18
        beq gtt4
        bcs gtt_bottom_section
        jmp gtt_mid_section             ; tmp - todo: more conditions for bottom section
gtt4    cmp #25
        bcs gtt_bottom_section
        jmp gtt_mid_section

gtt_top_section
        lda level0,x                    ; load the tile type index, using x as an offset
        rts
gtt_mid_section
        lda level0+256,x
        rts

gtt_bottom_section
        stx dbg16
        cpx #254
        beq gtt6
        cpx #255                        ; .x gets erroneously set to $ff when it should be $00
        bcc gtt5                        ; when targeting first tile - I have no idea why :(
        lda #3                          ; so just return a 3 in that case, which is the value we're after
        rts
gtt5    lda level0+512,x
        rts
gtt6    lda #0
        rts


; -----------------------------------------------------------------
; Detect collisions between pacman and ghosts
; Result returned in .a (0 = no collision, 1-4 ghost collided with)
; -----------------------------------------------------------------

detect_collisions
        
        ldx #0

dc_begin
        
        lda ghost0_x_tile,x
        cmp pacman_x_tile
        bne dc_next
        lda ghost0_y_tile,x
        cmp pacman_y_tile
        bne dc_next

        inx 
        txa
        rts

dc_next
        inx
        cpx #2
        bne dc_begin
        lda #0
dc_end
        rts