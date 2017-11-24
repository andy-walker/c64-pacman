; ------------------------------
; Routine to reset score to zero
; ------------------------------

reset_score

    lda #0
    sta score_msb1
    sta score_msb2
    sta score_lsb1
    sta score_lsb2