irq1_attract

        lda #<irq2_attract
        sta $314
        lda #>irq2_attract
        sta $315

        jsr set_score_sprites
        jmp $ea7e

irq2_attract

        inc $d019
        lda #$fa
        sta $d012
        lda #$1b
        sta $d011
        lda #<irq1
        sta $314
        lda #>irq1
        sta $315

        ; enable all sprites for score display
        lda #%11111111
        sta $d015

        jmp $ea7e    