; ------------------------------
; Routine to reset score to zero
; ------------------------------

reset_score

    lda #0
    sta score_msb1
    sta score_msb2
    sta score_lsb1
    sta score_lsb2

    rts
    

; ------------------------------------------------
; Routine to add to score
; num1 should be set with the msb of points to add
; num2 should be set with the lsb of points to add
; ------------------------------------------------

add_to_score
    
    clc
    
    lda score_lsb2
    adc num2
    sta score_lsb2
    lda score_lsb1
    adc num1
    sta score_lsb1
    lda score_msb2
    adc #0
    sta score_msb2
    lda score_msb1
    adc #0
    sta score_msb1

    rts

