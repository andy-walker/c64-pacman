; ------------------------------------------------
; Attract mode
; Subroutines for handling attract mode animations 
; ------------------------------------------------

line_counter = tmp1
upper_sprites_enabled = tmp2

attract_title_chmem = $045b
attract_line1_chmem = $04ab
attract_line2_chmem = $0523
attract_line3_chmem = $059b
attract_line4_chmem = $0613

amu_sprites_x = 86

init_attract_mode
        
        jsr cls                         ; clear screen
        jsr draw_attract_screen_upper
        ; jsr draw_level ; tmp

        lda #0                          ; reset timer
        sta line_counter
        sta timer_ticks
        sta timer_seconds
        sta upper_sprites_enabled

        ; init score sprites for attract mode

        sta score_charmap+4
        sta score_charmap+5
        
        lda #10
        sta score_charmap
        sta score_charmap+1
        sta score_charmap+2
        sta score_charmap+3

        jsr score_writer
        jsr reset_score

        rts


; --------------------------------------------------------------
; Set character memory for upper attract mode screen
; Will initially be set to black - each part will then be set to 
; its correct colour at the appropriate time in the animation
; --------------------------------------------------------------

draw_attract_screen_upper

        ldx #0
asu1    lda attract_title,x
        sta attract_title_chmem,x
        lda attract_line1,x
        sta attract_line1_chmem,x
        lda attract_line2,x
        sta attract_line2_chmem,x
        lda attract_line3,x
        sta attract_line3_chmem,x
        lda attract_line4,x
        sta attract_line4_chmem,x
        inx
        cpx #20
        bne asu1



        rts

; --------------------------------
; Animation timer for attract mode
; --------------------------------

attract_mode_timer_handler

        ldx timer_ticks
        cpx #8
        bne amth1
        inc timer_seconds
        ldx #255
amth1   inx
        stx timer_ticks
        rts

attract_mode_upper_animation

        rts

attract_mode_lower_animation

        rts


set_attract_upper_sprites

        lda #255 ;upper_sprites_enabled   ; enable all enabled upper sprites
        sta $d015
        lda #0                          ; unset all carry bits
        sta $d010

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

        rts 