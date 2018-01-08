; ------------------------------
; Attract mode
; Handles title screen animation 
; ------------------------------

init_attract_mode

        jsr cls                         ; clear screen
        lda #0                          ; reset timer
        sta timer_ticks
        sta timer_seconds        
        
        ; init lower sprite x positions
        lda #255                        ; set pacman x screen position
        sta tmp1
        lda #0                          ; secondary 0-9 counter to animate pacman frames
        sta tmp4                        ; dot flashing second counter (0-2)
        sta tmp2                    
        lda #1                          ; used for dot flashing (toggled between 0/1)
        sta tmp3
        rts

; -------------------------------
; Routine to run the attract mode 
; pacman animation
; -------------------------------

attract_animation

        lda tmp3
        cmp #0
        bne aa1
        lda #black
        sta $dba8
        sta $dab0
        jmp aa3
aa1    
        lda #white
        sta $dba8
        sta $dab0
aa3
        lda timer_seconds
        cmp #93
        bcs aa5
        dec tmp1
        
        ldx tmp2
        cpx #0
        beq aa4
        dex
        stx tmp2
        rts
aa4     ldx #9
        stx tmp2
        rts
aa5     inc tmp1
        ldx tmp2
        cpx #9
        beq aa6
        inx
        stx tmp2
        rts
aa6
        ldx #0
        stx tmp2
        rts

; ------------------------------------------------------
; Routine to handle upper half of attract mode animation
; ------------------------------------------------------

attract_mode_upper

        ; Detect if spacebar pressed

        lda #%01111111                  ; select row 7
        sta pra 
        lda prb                         ; load column information
        and #%00010000                  ; test space key  
        bne am_continue
        
        ; If so ...

        lda #intro1                     ; set to mode: intro1
        sta game_mode
        jsr init_game                   ; init new game
        jsr init_level                  ; init new level
        jsr init_intro1                 ; init game intro
        rts                             ; and return

        ; Otherwise, continue with the animation ...

am_continue

        jsr set_screen_upper_sprites

        ldy timer_seconds
        cpy #6
        bcc am_done
        jsr am_stage1
        cpy #9
        bcc am_done
        jsr am_stage2
        cpy #15
        bcc am_done
        jsr am_stage3
        cpy #18
        bcc am_done
        jsr am_stage4
        cpy #21
        bcc am_done
        jsr am_stage5
        cpy #27
        bcc am_done
        jsr am_stage6
        cpy #30
        bcc am_done
        jsr am_stage7
        cpy #33
        bcc am_done
        jsr am_stage8
        cpy #39
        bcc am_done
        jsr am_stage9
        cpy #42
        bcc am_done
        jsr am_stage10
        cpy #45
        bcc am_done
        jsr am_stage11
        cpy #51
        bcc am_done
        jsr am_stage12
        cpy #54
        bcc am_done
        jsr am_stage13
        cpy #60
        bcc am_done
        jsr am_stage14
        cpy #66
        bcc am_done
        jsr am_stage15
        cpy #72
        bcc am_done
amc2    jsr attract_animation
        cpy #150
        bcc am_done
        
        jsr init_attract_mode
        rts

am_done
        ldx timer_ticks
        inx
        cpx #8                          ; was 10, but speed up slightly
        bcc am_end
        ldx #0
        inc timer_seconds
        ldy tmp4
        iny
        cpy #6
        bcc am_end
        ldy #0
        lda tmp3
        eor #%00000001
        sta tmp3
am_end
        stx timer_ticks
        sty tmp4
        rts


am_stage1
        ldx #0
ams1_start
        lda attract_title,x
        sta $045b,x
        lda #white
        sta $d85b,x
        inx
        cpx #20
        bne ams1_start
        rts

am_stage2
        lda $d015                       ; enable sprite 0
        eor #%00000011
        sta $d015
        rts

am_stage3
        ldx #0
ams3_start
        lda attract_name1,x
        sta $04ab,x
        lda #red
        sta $d8ab,x
        inx
        cpx #8
        bne ams3_start
        rts

am_stage4
        ldx #0
ams4_start
        lda attract_nick1,x
        sta $04b6,x
        lda #red
        sta $d8b6,x
        inx
        cpx #8
        bne ams4_start
        rts

am_stage5
        lda $d015                       ; enable sprite 1
        eor #%00001100
        sta $d015
        rts

am_stage6
        ldx #0
ams6_start
        lda attract_name2,x
        sta $0523,x
        lda #pink
        sta $d923,x
        inx
        cpx #8
        bne ams6_start
        rts

am_stage7
        ldx #0
ams7_start
        lda attract_nick2,x
        sta $052e,x
        lda #pink
        sta $d92e,x
        inx
        cpx #8
        bne ams7_start
        rts

am_stage8
        lda $d015                       ; enable sprite 2
        eor #%00110000
        sta $d015
        rts

am_stage9
        ldx #0
ams9_start
        lda attract_name3,x
        sta $059b,x  
        lda #purple
        sta $d99b,x
        inx
        cpx #8
        bne ams9_start
        rts

am_stage10
        ldx #0
ams10_start
        lda attract_nick3,x
        sta $05a6,x  
        lda #purple
        sta $d9a6,x
        inx
        cpx #8
        bne ams10_start
        rts

am_stage11
        lda $d015                       ; enable sprite 3
        eor #%11000000
        sta $d015
        rts

am_stage12
        ldx #0
ams12_start
        lda attract_name4,x
        sta $0613,x 
        lda #orange
        sta $da13,x
        inx
        cpx #8
        bne ams12_start
        rts

am_stage13
        ldx #0
ams13_start
        lda attract_nick4,x
        sta $061e,x  
        lda #orange
        sta $da1e,x
        inx
        cpx #8
        bne ams13_start
        rts

am_stage14
        ldx #0
ams14_start
        lda attract_points1,x
        sta $0758,x 
        lda attract_points2,x
        sta $07a8,x 
        lda #white
        sta $db58,x
        sta $dba8,x
        inx
        cpx #8
        bne ams14_start
        lda #orange
        sta $db58
        rts

am_stage15
        cpy #93
        bcc ams15_1
        lda #7
        jmp ams15_2
ams15_1 lda #154
ams15_2 sta $06b0
        lda #white
        sta $dab0
        rts


; ---------------------------------------------------------------------
; Routine to set sprites for the upper half of the screen
; (because of sprite multiplexing, this needs to be done on each frame)
; ---------------------------------------------------------------------

set_screen_upper_sprites

        lda #0                          ; disable all sprites
        sta $d015

        lda #0
        sta $d010                       ; unset all carry bits

        lda #sprite_base+23             ; set odd numbered sprites to ghost sprite
        sta $07f8
        sta $07fa
        sta $07fc
        sta $07fe

        lda #sprite_base+26             ; set even numbered sprites to eyes-right sprite
        sta $07f9
        sta $07fb
        sta $07fd
        sta $07ff

        lda #86                         ; line up all sprites along their x axes
        sta $d000
        sta $d002
        sta $d004
        sta $d006
        sta $d008
        sta $d00a
        sta $d00c
        sta $d00e

        lda #78                         ; set sprite y axes
        sta $d001
        sta $d003

        lda #102
        sta $d005
        sta $d007

        lda #126
        sta $d009
        sta $d00b

        lda #150
        sta $d00d
        sta $d00f

        ; set sprite colours

        lda #red
        sta $d027                     
        lda #pink 
        sta $d029                     
        lda #purple
        sta $d02b                      
        lda #orange
        sta $d02d
        lda #white
        sta $d028   
        sta $d02a
        sta $d02c
        sta $d02e
        rts


; ------------------------------------------------------
; Routine to handle lower half of attract mode animation
; ------------------------------------------------------

attract_mode_lower
        
        lda timer_seconds
        cmp #72
        bcc aml_end
        cmp #110
        bcs aml_end

        lda #$ff
        sta $d015

        ldy tmp2

        lda timer_seconds
        cmp #93
        bcs aml2

        ; set pacman sprite for leftward movement

        cpy #6
        bcs aml1
        lda #sprite_base              
        clc
        adc tmp2
        jmp aml_set_sprites
aml1    lda #sprite_base+10
        sec
        sbc tmp2
        jmp aml_set_sprites
        
        ; set pacman sprite for rightward movement

aml2    cpy #0
        beq aml3
        cpy #6
        bcs aml4
        bcc aml5
aml3    lda #sprite_base
        jmp aml_set_sprites
aml4    lda #sprite_base+20
        sec
        sbc tmp2
        jmp aml_set_sprites
aml5    lda #sprite_base+10
        clc
        adc tmp2
        
aml_set_sprites    
        sta $07f8
        lda #yellow
        sta $d027 
        lda tmp1
        sta $d000
        lda #182
        sta $d001
aml_end
        rts
