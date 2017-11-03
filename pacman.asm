; ------
; Loader 
; ------

*=$0801
.byte $0b, $08, $00, $00, $9e, $32, $30, $36, $31, $00, $00, $00

left  = 0
right = 1
up    = 2
down  = 3

sprite_data_addr = $2000
char_data_addr   = $3800

pra              = $dc00                ; CIA#1 (Port Register A)
prb              = $dc01                ; CIA#1 (Port Register B)
ddra             = $dc02                ; CIA#1 (Data Direction Register A)
ddrb             = $dc03                ; CIA#1 (Data Direction Register B)


; -----------------------------------------
; Zero page addresses for program variables
; -----------------------------------------

num1             = $02
num2             = $03
pacman_x_tile    = $04
pacman_x_sub     = $05
pacman_y_tile    = $06
pacman_y_sub     = $07
pacman_direction = $08
matrix_offset    = $09
dbg_x            = $0a
dbg_y            = $0b

; ------------------
; Main program start
; ------------------

*=$080d

start  
        jsr cls

        ; character initialisation

        lda $d018
        ora #$0e                        ; set chars location to $3800 for displaying the custom font
        sta $d018                       ; Bits 1-3 ($400+512bytes * low nibble value) of $d018 sets char location
                                        ; $400 + $200*$0E = $3800

        ; sprite initialisation

        lda #$01 
        sta $d015                       ; Turn sprite 0 on 
        ;sta $d01c                      ; multi coloured sprite 

        lda #7 
        sta $d027                       ; set primary colour yellow

        lda #$00                        ; set black and white 
        sta $d025                       ; multi-colors global 
        lda #$01 
        sta $d026 

        jsr init_level

        ; irq initialisation (this should happen last)
        
        lda #%01111111                  ; switch off interrupt signals from CIA-1
        sta $dc0d
        and $d011                       ; clear most significant bit in VIC's raster register
        sta $d011
        lda #255                        ; set the raster line number where interrupt should occur
        sta $d012
        lda #<irq                       ; set the interrupt vector to point to the interrupt service routine below
        sta $0314
        lda #>irq
        sta $0315
        lda #%00000001                  ; enable raster interrupt signals from VIC
        sta $d01a

        ;rts
        jsr *


irq     
        jsr move_character
        asl $d019                       ; acknowledge raster irq
        jmp $ea31                       ; scan keyboard (only do once per frame)



; ----------------
; Initialise level
; ----------------

init_level
        ldx #0

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
        jmp init_sprites

next_char
        jmp loader_loop

init_sprites
        
        lda #5 ;#13
        sta pacman_x_tile
        lda #1 ;#15
        sta pacman_y_tile
        lda #5
        sta pacman_x_sub
        lda #5
        sta pacman_y_sub

        jsr set_pacman_sprite_left
        jsr update_pacman_sprite
        rts


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
        dec pacman_x_tile               ; decrement x tile position
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
        cmp #5                          ; does it equal 5?
        bne mls1                        ; if not, skip next instruction
        jsr eat_power_pill              ; if so, clear power pill and increment score              
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
        inc pacman_x_tile               ; increment x tile position
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
        cmp #5                          ; does it equal 5?
        bne mrs1                        ; if not, skip next instruction
        jsr eat_power_pill              ; if so, clear power pill and increment score  
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
        cmp #5                          ; does it equal 5?
        bne mus1                        ; if not, skip next instruction
        jsr eat_power_pill              ; if so, clear power pill and increment score  
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
        cmp #5                          ; does it equal 5?
        bne mds1                        ; if not, skip next instruction
        jsr eat_power_pill              ; if so, clear power pill and increment score  
mds1    jsr set_pacman_sprite_down
        jsr update_pacman_sprite
        lda #1                          ; return 1 in .a (moved)
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

; ------------------------------------------------------------
; Routine to locate the correct power pill character,
; remove it and increment player score.
; ------------------------------------------------------------

eat_power_pill

        ldx matrix_offset               ; load the level offset we previously stored
        ldy translate0,x                ; query the translation matrix for this offset to get screen memory location
        lda #7                          ; write a 7 to this location (blank space character)
        ldx pacman_x_tile
        lda pacman_y_tile
        cmp #5
        beq epp1
        bcs epp2
        jmp eat1
epp1    cpx #10
        bcc eat1
        jmp eat2
epp2    cmp #11
        bcs eat3
        jmp eat2

eat1    lda #7
        sta $0400,y                        
        rts
eat2    lda #7
        sta $0500,y
        rts
eat3    lda #7
        sta $0600,y                        
        rts
eat4    lda #7
        sta $0700,y
        rts

; --------------------------------------------
; Routine to get the type of a tile
; .x should be loaded with the offset from 0,0
; .y should be loaded with the y offset
; returns tile type index in .a 
; --------------------------------------------

get_tile_type
        lda pacman_x_tile               ; load x tile position into .a  
        cpy #9                          ; compare y tile position with 8
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

; ----------------------------------------------------
; General 8bit * 8bit = 8bit multiply
; Multiplies "num1" by "num2" and returns result in .A
; by White Flame (aka David Holz) 20030207
;
; Input variables:
;   num1 (multiplicand)
;   num2 (multiplier), should be small for speed
;   Signedness should not matter
;
; .X and .Y are preserved
; num1 and num2 get clobbered
;
; Instead of using a bit counter, this routine ends 
; when num2 reaches zero, thus saving iterations.
; ----------------------------------------------------

multiply
        lda num1
        lda num2
        lda #$00
        beq enterLoop

doAdd   clc
        adc num1

loop    asl num1
enterLoop                               ; For an accumulating multiply (.A = .A + num1*num2), set up num1 and num2, then enter here
        lsr num2
        bcs doAdd
        bne loop
        rts

; --------------------
; Clear screen routine
; --------------------

cls     lda #0
        sta $d020                       ; write to border colour register
        sta $d021                       ; write to screen colour register

clsloop lda #7                          ; 7 = blank space char in our custom character set
        sta $0400,x                     ; fill four areas with 256 spacebar characters
        sta $0500,x 
        sta $0600,x 
        sta $06e8,x 
        inx         
        bne clsloop  
        rts

; ----
; Data
; ----

translate0  .byte  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
translate1  .byte  0, 45, 46, 47, 49, 50, 51, 52, 54, 55, 56, 57, 59, 0, 61, 62, 64, 65, 66, 67, 69, 70, 71, 72, 74, 75, 0
translate2  .byte  0, 85, 0, 0, 0, 90, 0, 0, 0, 0, 0, 0, 99, 0, 101, 0, 0, 0, 0, 0, 0, 110, 0, 0, 0, 115, 0
translate3  .byte  0, 125, 0, 0, 0, 130, 0, 0, 0, 135, 136, 137, 139, 140, 141, 142, 144, 145, 0, 0, 0, 150, 0, 0, 0, 155, 0
translate4  .byte  0, 165, 0, 0, 0, 170, 0, 0, 0, 175, 0, 0, 0, 0, 0, 0, 0, 185, 0, 0, 0, 190, 0, 0, 0, 195, 0
translate5  .byte  0, 245, 246, 247, 249, 250, 251, 252, 254, 255, 0, 1, 3, 0, 5, 6, 8, 9, 10, 11, 13, 14, 15, 16, 18, 19, 0
translate6  .byte  0, 29, 0, 0, 0, 34, 0, 0, 0, 0, 0, 0, 2, 0, 2, 0, 0, 0, 0, 0, 0, 54, 0, 0, 0, 59, 0
translate7  .byte  0, 69, 70, 71, 73, 74, 75, 76, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 91, 93, 94, 95, 96, 98, 99, 0
translate8  .byte  0, 0, 0, 0, 0, 0, 0, 116, 0, 2, 0, 0, 0, 1, 0, 0, 0, 2, 0, 131, 0, 0, 0, 0, 0, 0, 0
translate9  .byte  0, 0, 0, 0, 0, 0, 0, 196, 0, 2, 0, 0, 0, 1, 0, 0, 0, 2, 0, 211, 0, 0, 0, 0, 0, 0, 0
translate10 .byte  0, 0, 0, 0, 0, 0, 0, 236, 0, 2, 0, 0, 0, 1, 0, 0, 0, 2, 0, 251, 0, 0, 0, 0, 0, 0, 0
translate11 .byte  0, 0, 0, 0, 0, 0, 0, 13, 0, 2, 0, 0, 0, 1, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0


lvlch1  .byte  0,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  2,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  3
lvlch2  .byte  4, 65, 66, 67,  7, 64, 65, 66, 67,  7, 64, 65, 66, 67,  7, 64,  5, 66, 67,  7, 64, 65, 66, 67,  7, 64, 65, 66, 67,  7, 64, 65,  6 
lvlch3  .byte  4, 69,  8,  9, 10, 11, 69,  8,  9, 10, 12, 13, 13, 13, 14, 68, 15, 70, 16, 13, 13, 13, 17,  9, 10, 11, 69,  8,  9, 10, 11, 69,  6     
lvlch4  .byte  4, 78, 18, 19, 20, 21, 73, 18, 19, 20, 21, 73, 74, 75,  7, 72, 73, 74, 75,  7, 72, 73, 18, 19, 20, 21, 73, 18, 19, 20, 21, 78,  6
lvlch5  .byte  4, 76, 18, 22, 23, 21, 76, 18, 22, 23, 21, 76, 24, 25, 25, 25, 25, 25, 25, 25, 26, 76, 18, 22, 23, 21, 76, 18, 22, 23, 21, 76,  6
lvlch6  .byte  4,  7, 27, 28, 28, 29,  7, 27, 28, 28, 29,  7, 27, 28, 28, 28, 30, 28, 28, 28, 29,  7, 27, 28, 28, 29,  7, 27, 28, 28, 29,  7,  6
lvlch7  .byte  4, 65, 66, 67,  7, 64, 65, 66, 67,  7, 64, 65, 66, 67,  7, 64,  5, 66, 67,  7, 64, 65, 66, 67,  7, 64, 65, 66, 67,  7, 64, 65,  6
lvlch8  .byte  4, 69, 31, 32, 32, 33, 69, 31, 32, 34, 35, 32, 32, 32, 36,  7, 37,  7, 38, 32, 32, 32, 39, 32, 32, 40, 69, 31, 32, 32, 33, 69,  6

lvlch9  .byte  4, 73, 74, 75,  7, 72, 73, 74, 75, 41,  4,  7,  7,  7,  7,  7,  7,  7,  7,  7,  7,  7, 42, 75,  7, 72, 73, 74, 75,  7, 72, 73,  6

lvlch10 .byte 43, 25, 25, 25, 25, 25, 25, 44, 77, 41,  4,  7, 24, 25, 25, 26,  7, 24, 25, 25, 26,  7, 42, 77, 45, 25, 25, 25, 25, 25, 25, 25, 46
lvlch11 .byte 47, 48, 48, 48, 48, 48, 48, 49,  7, 41,  4,  7, 50, 28, 28, 29,  7, 27, 28, 51, 21,  7, 42,  7, 41, 52, 48, 48, 48, 48, 48, 48, 53
lvlch12 .byte 54, 55, 55, 55, 55, 55, 55, 56, 67, 57, 58,  7, 59,  7,  7,  7,  7,  7,  7, 60, 61,  7, 62, 67, 63, 55, 55, 55, 55, 55, 55, 55, 79
lvlch13 .byte  7,  7,  7,  7,  7,  7,  7,  7, 71,  7,  7,  7, 59,  7,  7,  7,  7,  7,  7, 60, 61,  7,  7, 71,  7,  7,  7,  7,  7,  7,  7,  7,  7
lvlch14 .byte 80, 81, 81, 81, 81, 81, 81, 82, 75, 83, 84,  7, 59,  7,  7,  7,  7,  7,  7, 60, 61,  7, 85, 75, 86, 87, 81, 81, 81, 81, 81, 81, 88
lvlch15 .byte 89, 25, 25, 25, 25, 25, 25, 90, 77, 41,  4,  7, 92, 25, 25, 25, 25, 25, 25, 93, 61,  7, 42, 77, 41, 94, 25, 25, 25, 25, 25, 25, 95
lvlch16 .byte 96,  1,  1,  1,  1,  1,  1, 97,  7, 98, 29,  7, 27, 28, 28, 28, 30, 28, 28, 28, 29,  7, 99,  7, 98,  1,  1,  1,  1,  1,  1,  1,100
lvlch17 .byte  4, 65, 66, 67,  7, 64, 65, 66, 67,  7, 64, 65, 66, 67,  7, 64,  5, 66, 67,  7, 64, 65, 66, 67,  7, 64, 65, 66, 67,  7, 64, 65,  6  
lvlch18 .byte  4, 69, 31, 32, 34, 11, 69, 31, 32, 32, 32, 32, 32, 32, 36, 68, 15, 70, 16, 13, 13, 13, 13, 13, 13, 33, 69,101, 13, 13, 33, 69,  6
lvlch19 .byte  4, 78, 74, 75, 60, 21, 73, 74, 75,  7, 72, 73, 74, 75,  7, 72, 73, 74, 75,  7, 72, 73, 74, 75,  7, 72, 73, 42, 75,  7, 72, 78,  6
lvlch20 .byte 102,25, 44, 77, 60,102, 25, 44, 77,103,104, 76, 24, 25, 25, 25, 25, 25, 25, 25,104, 76,105, 77, 45, 25, 25,106, 77, 45, 25, 25,107
lvlch21 .byte  0,  1, 97,  7, 98,  1,  1, 97,  7, 41,  4,  7, 27, 28, 28, 28, 30, 28, 28, 28, 29,  7, 42,  7, 98, 28, 28, 97,  7, 98, 28, 28,  3 
lvlch22 .byte  4, 65, 66, 67,  7, 64, 65, 66, 67, 41,  4, 65, 66, 67,  7, 64,  5, 66, 67,  7, 64, 65, 42, 67,  7, 64, 65, 66, 67,  7, 64, 65,  6 
lvlch23 .byte  4, 69, 31, 32, 32, 32, 32, 32, 32,108,109, 32, 32, 32, 36, 68, 15, 70, 16, 32, 32, 32,110, 32, 32, 32, 32, 32, 32, 32, 33, 69,  6
lvlch24 .byte  4, 73, 74, 75,  7, 72, 73, 74, 75,  7, 72, 73, 74, 75,  7, 72, 73, 74, 75,  7, 72, 73, 74, 75,  7, 72, 73, 74, 75,  7, 72, 73,  6
lvlch25 .byte 102,25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25,107   

lvlcl1  .byte  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6
lvlcl2  .byte  6, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,  6, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,  6
lvlcl3  .byte  6, 10,  6,  6,  6,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6, 10,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6, 10,  6,  6,  6,  6, 10,  6
lvlcl4  .byte  6,  1,  6,  6,  6,  6, 10,  6,  6,  6,  6, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,  6,  6,  6,  6, 10,  6,  6,  6,  6,  1,  6
lvlcl5  .byte  6, 10,  6,  6,  6,  6, 10,  6,  6,  6,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6,  6, 10,  6,  6,  6,  6, 10,  6,  6,  6,  6, 10,  6
lvlcl6  .byte  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6
lvlcl7  .byte  6, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,  6, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,  6
lvlcl8  .byte  6, 10,  6,  6,  6,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6, 10,  6,  6,  6,  6, 10,  6
lvlcl9  .byte  6, 10, 10, 10, 10, 10, 10, 10, 10,  6,  6, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,  6, 10, 10, 10, 10, 10, 10, 10, 10, 10,  6
lvlcl10 .byte  6,  6,  6,  6,  6,  6,  6,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6,  6
lvlcl11 .byte  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6
lvlcl12 .byte  6,  6,  6,  6,  6,  6,  6,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6,  6
lvlcl13 .byte  6,  6,  6,  6,  6,  6,  6,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6,  6
lvlcl14 .byte  6,  6,  6,  6,  6,  6,  6,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6,  6
lvlcl15 .byte  6,  6,  6,  6,  6,  6,  6,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6,  6
lvlcl16 .byte  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6
lvlcl17 .byte  6, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,  6, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,  6
lvlcl18 .byte  6, 10,  6,  6,  6,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6, 10,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6, 10,  6,  6,  6,  6, 10,  6
lvlcl19 .byte  6,  1, 10, 10,  6,  6, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,  6, 10, 10, 10,  1,  6
lvlcl20 .byte  6,  6,  6, 10,  6,  6,  6,  6, 10,  6,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6,  6, 10,  6, 10,  6,  6,  6,  6, 10,  6,  6,  6,  6
lvlcl21 .byte  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6
lvlcl22 .byte  6, 10, 10, 10, 10, 10, 10, 10, 10,  6,  6, 10, 10, 10, 10, 10,  6, 10, 10, 10, 10, 10,  6, 10, 10, 10, 10, 10, 10, 10, 10, 10,  6
lvlcl23 .byte  6, 10,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6, 10,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6, 10,  6
lvlcl24 .byte  6, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,  6
lvlcl25 .byte  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6

level0  .byte  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
level1  .byte  0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0
level2  .byte  0, 3, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 3, 0, 3, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 3, 0
level3  .byte  0, 4, 0, 0, 0, 3, 0, 0, 0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0, 0, 0, 3, 0, 0, 0, 4, 0
level4  .byte  0, 3, 0, 0, 0, 3, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 3, 0, 0, 0, 3, 0
level5  .byte  0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0
level6  .byte  0, 3, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 2, 0, 2, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 3, 0
level7  .byte  0, 3, 3, 3, 3, 3, 3, 3, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 3, 3, 3, 3, 3, 3, 3, 0
level8  .byte  0, 0, 0, 0, 0, 0, 0, 3, 0, 2, 0, 0, 0, 1, 0, 0, 0, 2, 0, 3, 0, 0, 0, 0, 0, 0, 0
level9  .byte  0, 0, 0, 0, 0, 0, 0, 3, 0, 2, 0, 1, 1, 1, 1, 1, 0, 2, 0, 3, 0, 0, 0, 0, 0, 0, 0
level10 .byte  5, 5, 5, 5, 5, 5, 5, 3, 2, 2, 0, 1, 1, 1, 1, 1, 0, 2, 2, 3, 5, 5, 5, 5, 5, 5, 5
level11 .byte  0, 0, 0, 0, 0, 0, 0, 3, 0, 2, 0, 1, 1, 1, 1, 1, 0, 2, 0, 3, 0, 0, 0, 0, 0, 0, 0
level12 .byte  0, 0, 0, 0, 0, 0, 0, 3, 0, 2, 0, 0, 0, 0, 0, 0, 0, 2, 0, 3, 0, 0, 0, 0, 0, 0, 0
level13 .byte  0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0
level14 .byte  0, 3, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 3, 0, 3, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 3, 0
level15 .byte  0, 4, 3, 3, 0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0, 3, 3, 4, 0
level16 .byte  0, 0, 0, 3, 0, 0, 0, 3, 0, 3, 0, 0, 0, 0, 0, 0, 0, 3, 0, 3, 0, 0, 0, 3, 0, 0, 0
level17 .byte  0, 3, 3, 3, 3, 3, 3, 3, 0, 3, 3, 3, 3, 0, 3, 3, 3, 3, 0, 3, 3, 3, 3, 3, 3, 3, 0
level18 .byte  0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0
level19 .byte  0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0
level20 .byte  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 



; load sprite data
*=sprite_data_addr	      
    .binary "resources/sprites.raw"

; load character data
*=char_data_addr
    .binary "resources/chars.raw"