irq1_startscreen

        ; disable all sprites for main display
        lda #0
        sta $d015

        jsr set_score_sprites

        lda #<irq2_startscreen          
        sta $314
        lda #>irq2_startscreen
        sta $315

        jmp $ea7e

irq2_startscreen                       ; triggered on scanline 0

        inc $d019
        lda #64
        sta $d012
        lda #$1b
        sta $d011

        ; enable all sprites for score display
        lda #%11111111
        sta $d015

        lda #<irq1_startscreen
        sta $314
        lda #>irq1_startscreen
        sta $315

        jmp $ea7e