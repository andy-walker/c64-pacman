irq1_game

        jsr level_init_frame
        jsr set_score_sprites
        jsr move_character

        lda #<irq2_game         
        sta $314
        lda #>irq2_game
        sta $315

        jmp $ea7e


irq2_game                        ; triggered on scanline 0

        inc $d019
        
        lda #44
        sta $d012
        lda #$1b
        sta $d011

        ; enable first 6 sprites for score display
        lda #%00111111
        sta $d015

        lda #<irq3_game
        sta $314
        lda #>irq3_game
        sta $315

        jmp $ea7e

irq3_game                        ; triggered on scanline 44

        inc $d019
        lda #$fa
        sta $d012
        lda #$1b
        sta $d011
       
        ; set all game sprites ..

        lda #0                  ; use .a to keep track of carry bits - initially zeroed

        ldx sprite0_pointer
        stx $07f8

        ldx sprite0_x
        stx $d000

        ldx sprite0_y
        stx $d001

        ldx sprite0_colour
        stx $d027

        eor sprite0_carry
        
        
        sta $d010


        lda #<irq1
        sta $314
        lda #>irq1
        sta $315         

        jmp $ea7e