init_intro1
        
        lda #0
        sta timer_seconds
        sta timer_ticks

        lda #%00011111 
        sta $d015                       ; enable first 5 sprites

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

        rts

intro1_run
        rts