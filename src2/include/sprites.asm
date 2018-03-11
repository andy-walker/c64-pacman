set_score_sprites
        
        lda #%00000000
        sta $d015

        lda #sprite_base+53             ; '1 UP' sprites
        sta $07f8
        lda #sprite_base+54
        sta $07f9

        lda #24
        sta $d000

        lda #48
        sta $d002

        lda #16
        sta $d001
        sta $d003

        lda #white
        sta $d027 
        sta $d028

        rts


        