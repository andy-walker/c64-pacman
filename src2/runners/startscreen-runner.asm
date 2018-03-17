irq1_startscreen                        ; triggered on scanline 250

        ; disable all sprites for main display
        lda #0
        sta $d015

        jsr set_score_sprites

        jsr detect_spacebar
        cmp #1
        bne irq1_startscreen_continue

        inc game_mode
        jsr init_intro1

irq1_startscreen_continue
        lda #<irq2_startscreen          
        sta $314
        lda #>irq2_startscreen
        sta $315

        jmp $ea7e

irq2_startscreen                       ; triggered on scanline 0

        inc $d019
        lda #$fa
        sta $d012
        lda #$1b
        sta $d011

        ; enable all sprites for score display
        lda #%11111111
        sta $d015

        lda #<irq1
        sta $314
        lda #>irq1
        sta $315

        jmp $ea7e