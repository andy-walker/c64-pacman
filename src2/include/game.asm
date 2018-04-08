
init_game

        lda #0
        sta dot_counter
        sta ghost_dc_mode
        ; jsr level_init_sprites

        rts