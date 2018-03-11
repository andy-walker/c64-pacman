; ------------------------------------------------
; Attract mode
; Subroutines for handling attract mode animations 
; ------------------------------------------------

init_attract_mode
        
        jsr cls                         ; clear screen
        jsr draw_level ; tmp
        lda #0                          ; reset timer
        sta timer_ticks
        sta timer_seconds

        ; init score sprites to match with original
        ; when in attract mode

        sta score_charmap+4
        sta score_charmap+5
        
        lda #10
        sta score_charmap
        sta score_charmap+1
        sta score_charmap+2
        sta score_charmap+3

        jsr score_writer
        jsr reset_score

        rts