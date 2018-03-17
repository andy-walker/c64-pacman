irq1_intro2                         ; triggered on scanline 250

        ; disable all sprites for main display
        lda #0
        sta $d015

        inc timer_ticks
        lda timer_ticks
        cmp #200
        bne irq_intro2_timer1
        
        ;inc game_mode
        ;jsr init_intro2

irq_intro2_timer1

        jsr set_score_sprites

irq1_intro2_continue

        lda #<irq2_intro2         
        sta $314
        lda #>irq2_intro2
        sta $315

        jmp $ea7e

irq2_intro2                         ; triggered on scanline 0

        inc $d019
        lda #64
        sta $d012
        lda #$1b
        sta $d011

        ; enable first 6 sprites for score display
        lda #%00111111
        sta $d015

        lda #<irq3_intro2
        sta $314
        lda #>irq3_intro2
        sta $315

        jmp $ea7e

irq3_intro2                         ; triggered on scanline 64

        inc $d019
        lda #147
        sta $d012
        ;lda #$1b
        ;sta $d011

        jsr set_intro2_upper_sprites

        lda #<irq4_intro2
        sta $314
        lda #>irq4_intro2
        sta $315

        jmp $ea7e

irq4_intro2                         ; triggered on scanline 147

        inc $d019
        lda #$fa
        sta $d012
        lda #$1b
        sta $d011

        jsr set_intro2_lower_sprites

        lda #<irq1
        sta $314
        lda #>irq1
        sta $315

        jmp $ea7e