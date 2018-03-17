; -----------------------------------------
; Initialise first stage of the game intro
; Renders PLAYER ONE and READY! as sprites
; in order to display them centrally
; (character map is off-centre)
; -----------------------------------------

init_intro1

        jsr cls
        jsr draw_level
        rts