; ----------------
; Initialise level
; ----------------

init_level
        ldx #0
        stx frightened_mode
        stx dot_counter
        stx flash_counter

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
        lda #1                          ; set ghost sprites to white
        ;sta $d028
        ;sta $d029       
        ;sta $d02a                 
        ;sta $d02b                       
        lda #4                          ; set eye sprites to purple
        ;sta $d02c
        ;sta $d02d
        ;sta $d02e
        jmp lf2

lf1     cpx #25
        bne lf2

        lda #6                          ; set ghost sprites to blue
        ;sta $d028
        ;sta $d029       
        ;sta $d02a                 
        ;sta $d02b                       
        lda #1                          ; set eye sprites to purple
        ;sta $d02c
        ;sta $d02d
        ;sta $d02e                

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
        ;sta $d028                       ; sprite 1: colour red
        lda #4
        ;sta $d029                       ; sprite 2: colour purple
        lda #3
        ;sta $d02a                       ; sprite 3: colour cyan
        lda #10
        ;sta $d02b                       ; sprite 4: colour orange
        lda #1
        ;sta $d02c
        ;sta $d02d
        ;sta $d02e

lf_end  rts