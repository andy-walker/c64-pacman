irq1_game

        jsr set_score_sprites

        lda #<irq2_game         
        sta $314
        lda #>irq2_game
        sta $315

        jmp $ea7e


irq2_game                        ; triggered on scanline 0

        inc $d019
        
        lda #$fa
        sta $d012
        lda #$1b
        sta $d011

        ; enable all sprites for score display
        lda #%00111111
        sta $d015

        lda #<irq1
        sta $314
        lda #>irq1
        sta $315

        jmp $ea7e