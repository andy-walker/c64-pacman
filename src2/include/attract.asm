; ------------------------------------------------
; Attract mode
; Subroutines for handling attract mode animations 
; ------------------------------------------------

line_number = timer_seconds
line_counter = timer_ticks
attract_animation_stage = tmp1
upper_sprites_enabled = tmp2

attract_title_chmem = $045c
attract_line1_chmem = $04ac
attract_line2_chmem = $0524
attract_line3_chmem = $059c
attract_line4_chmem = $0614
attract_line5_chmem = $0755
attract_line6_chmem = $07a5

attract_title_clmem = $d85c
attract_line1_clmem = $d8ac
attract_line2_clmem = $d924
attract_line3_clmem = $d99c
attract_line4_clmem = $da14
attract_line5_clmem = $db55
attract_line6_clmem = $dba5

init_attract_mode
        
        jsr cls                         ; clear screen
        jsr draw_attract_screen_upper
        ; jsr draw_level ; tmp

        lda #0                          ; reset timer
        sta line_counter
        sta line_number
        sta upper_sprites_enabled
        sta attract_animation_stage

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
        lda attract_line5,x
        sta attract_line5_chmem,x
        lda attract_line6,x
        sta attract_line6_chmem,x

        lda #white
        sta attract_title_clmem,x
        sta attract_line1_clmem,x
        sta attract_line2_clmem,x
        sta attract_line3_clmem,x
        sta attract_line4_clmem,x
        sta attract_line5_clmem,x
        sta attract_line6_clmem,x

        inx
        cpx #20
        bne asu1

        rts

; --------------------------------
; Animation timer for attract mode
; --------------------------------

attract_mode_timer_handler
        
        ldx line_counter
        inx                             ; increment line counter
        cpx #0                          ; if we've wrapped around ..
        bne amth_end
        inc line_number                 ; increment line number
amth_end
        stx line_counter
        rts


attract_mode_upper_animation

        lda line_number
        ldx line_counter
        cpx #0
        beq amua_begin_line
        rts

amua_begin_line

        cmp #1
        beq amua_show_next_sprite
        cmp #2
        beq amua_show_next_sprite
        cmp #3
        beq amua_show_next_sprite
        cmp #4
        beq amua_show_next_sprite

        rts        

amua_show_next_sprite

        lda upper_sprites_enabled
        asl
        asl
        eor #%00000011
        sta upper_sprites_enabled

        rts

attract_mode_lower_animation

        rts


set_attract_upper_sprites

        lda upper_sprites_enabled       ; enable all enabled upper sprites
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

        lda #94                         ; line up all sprites along their x axes
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