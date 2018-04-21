; --------------------------------------
; Routine to initialise game over screen
; --------------------------------------

init_game_over

        lda #game_over
        sta game_mode

        jsr set_lower_border_sprites

        lda #0
        sta timer_ticks
        

        lda #0                          ; unset all sprite carry bits
        sta sprite0_carry
        sta sprite1_carry
        sta sprite2_carry
        
        lda #sprite_base+49
        sta sprite0_pointer

        lda #sprite_base+50
        sta sprite1_pointer

        lda #sprite_base+51
        sta sprite2_pointer

        lda #red
        sta sprite0_colour
        sta sprite1_colour
        sta sprite2_colour

        lda #151
        sta sprite0_x

        lda #175
        sta sprite1_x

        lda #199
        sta sprite2_x
        
        lda #115
        sta sprite0_y
        sta sprite1_y
        sta sprite2_y

        rts


game_over_run
        ldx timer_ticks
        inx
        stx timer_ticks
        cpx #150
        bcc gor_end
        beq gor_cls
        cpx #175
        bcs gor_reset
        rts
gor_cls jsr cls
        ;lda #0
        ;sta $d015
        rts
gor_reset
        lda #attract
        sta game_mode
        jsr init_attract_mode
gor_end rts