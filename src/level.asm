; ----------------
; Initialise level
; ----------------

init_level
        ldx #0
        stx frightened_mode
        stx dot_counter
        stx flash_counter

loader_loop 
        
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
        jmp level_init_sprites

next_char
        jmp loader_loop


level_init_sprites

        lda #%01100111 
        sta $d015                       ; enable sprites

        lda #0
        sta $d010                       ; unset all carry bits

        lda %00000001                   ; set only blinky as active on level start
        sta ghost_active

        ; set sprite colours

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

        lda #13                         ; initialise pacman tile position
        sta pacman_x_tile
        lda #15
        sta pacman_y_tile
        
        lda #13                         ; initialise ghost0 (blinky) tile position
        sta ghost0_x_tile
        lda #7
        sta ghost0_y_tile

        lda #11
        sta ghost1_x_tile
        lda #9
        sta ghost1_y_tile

        lda #5                          ; initialise all x sub positions to 5 (tile centre)
        sta pacman_x_sub
        sta ghost0_x_sub
        sta ghost1_x_sub

        lda #5                          ; initialise all y sub positions to 5 (tile centre)
        sta ghost0_y_sub
        sta ghost1_y_sub
        sta pacman_y_sub

        jsr set_pacman_sprite_left
        jsr update_pacman_sprite

        ldx #0                          ; set .x to ghost index (0)
        ldy #left                       ; set .y to ghost direction
        sty ghost0_direction            ; store direction

        jsr set_ghost_sprite            ; set and update ghost0 sprites
        jsr update_ghost_sprite

        ldx #1                          ; set .x to ghost index (1)
        ldy #down                       ; set .y to ghost direction
        sty ghost1_direction            ; store direction

        jsr set_ghost_sprite            ; set and update ghost0 sprites
        jsr update_ghost_sprite

        rts


; ----------------------------------------------------
; Routine to run at the beginning of each cycle
; of the game loop - handles gameplay mode, timers etc
; ----------------------------------------------------

level_init_frame
        
        ldx flash_counter
        inx
        cpx #12
        beq lf_flash_black
        cpx #24
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
        stx flash_counter

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
       
        lda #1                          ; set ghost sprites to white
        sta $d028
        sta $d029       
        sta $d02a                 
        sta $d02b                       
        lda #4                         ; set eye sprites to purple
        sta $d02c
        sta $d02d
        sta $d02e
        jmp lf2

lf1     cpx #25
        bne lf2

        lda #6                          ; set ghost sprites to blue
        sta $d028
        sta $d029       
        sta $d02a                 
        sta $d02b                       
        lda #1                          ; set eye sprites to purple
        sta $d02c
        sta $d02d
        sta $d02e                

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

lf_end  rts


; --------------------------------
; Initialise ghost frightened mode
; --------------------------------

init_frightened_mode
        
        lda #1                          ; set frightened_mode to 1
        sta frightened_mode
        lda #0                          ; zero timer_seconds / timer_ticks
        sta timer_ticks
        sta timer_seconds
        
        lda #6                          ; set ghost sprites to blue
        sta $d028
        sta $d029       
        sta $d02a                 
        sta $d02b                       
        lda #1                          ; set eye sprites to purple
        sta $d02c
        sta $d02d
        sta $d02e
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
        bne ed_end                      ; jump to end
        jsr init_frightened_mode        ; otherwise initialise frightened mode (power pill eaten)

ed_end  rts

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
        beq gtt_bottom_section
        jmp gtt_mid_section

gtt_top_section
        lda level0,x                    ; load the tile type index, using x as an offset
        rts
gtt_mid_section
        lda level0+256,x
        rts

gtt_bottom_section
        cpx #255                        ; .x gets erroneously set to $ff when it should be $00
        bne gtt5                        ; when targeting first tile - I have no idea why :(
        lda #3                          ; so just return a 3 in that case, which is the value we're after
        rts
gtt5    lda level0+512,x
        rts


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
        cmp #211
        bcc lef_end
        
        ; we've reached the end of the level (all dots eaten)
        
        lda #%00000001                  ; disable ghost sprites
        sta $d015                       

        lda #sprite_base                ; set default pacman sprite
        sta $07f8

        lda #level_complete
        sta game_mode

lef3    lda #0
        sta timer_seconds
        sta timer_ticks

lef_end rts


; ------------------------------------------------
; Routine to run at the end of the level
; handles background flash, and starting new level
; ------------------------------------------------

level_end

        lda timer_seconds
        cmp #1
        beq level_end_reset

        inc timer_ticks
        lda timer_ticks
        cmp #75
        beq flash_white
        cmp #100
        beq flash_blue
        cmp #125
        beq flash_white
        cmp #150
        beq flash_blue
        cmp #175
        beq flash_white
        cmp #200
        beq flash_blue
        cmp #225
        beq flash_white
        cmp #250
        beq flash_blue
        cmp #255
        beq flash_end
        rts

flash_white
        ldx #0
fw_loop lda #1                          ; 7 = blank space char in our custom character set
        sta $d800,x                     ; fill four areas with 256 spacebar characters
        sta $d900,x 
        sta $da00,x 
        sta $dae8,x 
        inx         
        bne fw_loop  
        rts

flash_blue
        ldx #0
fb_loop lda #6                          ; 7 = blank space char in our custom character set
        sta $d800,x                     ; fill four areas with 256 spacebar characters
        sta $d900,x 
        sta $da00,x 
        sta $dae8,x 
        inx         
        bne fb_loop  
        rts

flash_end
        lda #0
        sta timer_ticks
        lda #1
        sta timer_seconds

level_end_reset
        inc timer_ticks
        lda timer_ticks
        cmp #50
        beq ler1
        cmp #100
        beq ler2
        rts

ler1    lda #0
        sta $d015 
        jsr cls
        rts
ler2
        inc level_number
        lda #gameplay
        sta game_mode
        jsr init_level
        rts


; -------------------------------
; Routine to handle losing a life
; -------------------------------

level_life_lost
        
        lda timer_ticks
        cmp #50
        bne lll1
        lda #%00000001                  ; disable ghost sprites
        sta $d015
        lda #sprite_base+20
        sta $07f8
lll1    cmp #55
        bne lll2
        lda #sprite_base+34
        sta $07f8
lll2    cmp #60
        bne lll3
        lda #sprite_base+35
        sta $07f8
lll3    cmp #65
        bne lll4
        lda #sprite_base+36
        sta $07f8
lll4    cmp #70
        bne lll5
        lda #sprite_base+37
        sta $07f8
lll5    cmp #75
        bne lll6
        lda #sprite_base+38
        sta $07f8
lll6    cmp #80
        bne lll7
        lda #sprite_base+39
        sta $07f8
lll7    cmp #85
        bne lll8
        lda #sprite_base+40
        sta $07f8
lll8    cmp #90
        bne lll9
        lda #sprite_base+41
        sta $07f8
lll9    cmp #95
        bne lll10
        lda #sprite_base+42
        sta $07f8
lll10   cmp #100
        bne lll11
        lda #sprite_base+43
        sta $07f8
lll11   cmp #125
        bne lll12
        lda #0
        sta $d015 
lll12   cmp #150
        bne lll13
        jsr init_intro2
        lda test_mode
        cmp #1
        beq ll_resume
        ldy lives
        cpy #0
        beq all_lives_lost
        dey
        sty lives
ll_resume
        jsr level_init_sprites

        rts
lll13
        inc timer_ticks
        rts

all_lives_lost
        lda #game_over
        sta game_mode
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
