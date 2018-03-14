irq1_attract                        ; triggered on scanline 250 

        jsr detect_spacebar
        cmp #1
        bne irq1_attract_continue
        
        inc game_mode
        jsr init_start_screen
        jmp irq1_attract_end

irq1_attract_continue
        jsr attract_mode_timer_handler
        jsr attract_mode_upper_animation
        ; jsr attract_mode_lower_animation
        jsr set_score_sprites
irq1_attract_end
        lda #<irq2_attract          
        sta $314
        lda #>irq2_attract
        sta $315

        jmp $ea7e

irq2_attract                        ; triggered on scanline 0

        inc $d019
        lda #64
        sta $d012
        lda #$1b
        sta $d011

        ; enable all sprites for score display
        lda #%11111111
        sta $d015

        lda #<irq3_attract
        sta $314
        lda #>irq3_attract
        sta $315

        jmp $ea7e

irq3_attract                        ; triggered on scanline 64

        inc $d019
        lda #$fa
        sta $d012
        lda #$1b
        sta $d011
       
        jsr set_attract_upper_sprites

        lda #<irq1
        sta $314
        lda #>irq1
        sta $315         

        jmp $ea7e
