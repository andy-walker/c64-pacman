; -----------------------------------------
; Initialise first stage of the game intro
; Renders PLAYER ONE and READY! as sprites
; in order to display them centrally
; (character map is off-centre)
; -----------------------------------------

init_intro1

        jsr cls
        jsr draw_level
        
        lda #0
        sta timer_ticks

        lda #3
        sta lives
        jsr set_lower_border_sprites
        
        rts

set_intro1_main_sprites
        
        ; set sprites

        lda #sprite_base+44
        sta $07f8

        lda #sprite_base+45
        sta $07f9

        lda #sprite_base+46
        sta $07fa

        lda #sprite_base+47
        sta $07fb

        lda #sprite_base+48
        sta $07fc

        ; set sprite positions

        lda #147
        sta $d000

        lda #171
        sta $d002

        lda #203
        sta $d004
        
        lda #115
        sta $d001
        sta $d003
        sta $d005

        lda #165
        sta $d006

        lda #189
        sta $d008

        lda #155
        sta $d007
        sta $d009

        ; set sprite colours

        lda #cyan
        sta $d027
        sta $d028
        sta $d029

        lda #yellow
        sta $d02a
        sta $d02b

        lda #%00011111 
        sta $d015                       ; enable first 5 sprites

        rts