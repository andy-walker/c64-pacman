; ----------------------------------------------
; Start screen mode
; Subroutines for displaying the start screen 
; ----------------------------------------------

startscreen_line1_chmem = $04cf
startscreen_line2_chmem = $0547
startscreen_line3_chmem = $05bf

startscreen_line1_clmem = $d8cf
startscreen_line2_clmem = $d947
startscreen_line3_clmem = $d9bf

startscreen_line1_col = brown
startscreen_line2_col = cyan
startscreen_line3_col = orange

init_start_screen

        jsr cls
        jsr draw_start_screen
        
        rts

; ----------------------------------------------
; Set character / colour memory for start screen
; ----------------------------------------------

draw_start_screen
        
        ldx #0

dss1    lda startscreen_line1,x
        sta startscreen_line1_chmem,x
        lda startscreen_line2,x
        sta startscreen_line2_chmem,x
        lda startscreen_line3,x
        sta startscreen_line3_chmem,x

        lda #startscreen_line1_col
        sta startscreen_line1_clmem,x
        lda #startscreen_line2_col
        sta startscreen_line2_clmem,x
        lda #startscreen_line3_col
        sta startscreen_line3_clmem,x

        inx
        cpx #27
        bne dss1

        rts