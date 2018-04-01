irq1_gameover

        jsr display_lower_game_sprites
        jsr game_over_run
        jsr set_score_sprites
        jsr level_end_frame
        
        lda #<irq2_gameover        
        sta $314
        lda #>irq2_gameover
        sta $315

        jmp $ea7e


irq2_gameover                        ; triggered on scanline 0

        inc $d019
        
        lda #44
        sta $d012
        lda #$1b
        sta $d011

        ; enable first 6 sprites for score display
        lda #%00111111
        sta $d015

        lda #<irq3_gameover
        sta $314
        lda #>irq3_gameover
        sta $315

        jmp $ea7e

irq3_gameover                       ; triggered on scanline 44

        inc $d019
        jsr display_main_game_sprites
 
        lda #$fa

        sta $d012
        lda #$1b
        sta $d011

        lda #<irq1
        sta $314
        lda #>irq1
        sta $315         

        jmp $ea7e