; -------------------------------
; Routine to handle losing a life
; -------------------------------

level_life_lost

        lda timer_ticks
        cmp #50
        bne lll1

        lda #sprite_base+20
        sta sprite0_pointer
lll1    cmp #55
        bne lll2
        lda #sprite_base+34
        sta sprite0_pointer
lll2    cmp #60
        bne lll3
        lda #sprite_base+35
        sta sprite0_pointer
lll3    cmp #65
        bne lll4
        lda #sprite_base+36
        sta sprite0_pointer
lll4    cmp #70
        bne lll5
        lda #sprite_base+37
        sta sprite0_pointer
lll5    cmp #75
        bne lll6
        lda #sprite_base+38
        sta sprite0_pointer
lll6    cmp #80
        bne lll7
        lda #sprite_base+39
        sta sprite0_pointer
lll7    cmp #85
        bne lll8
        lda #sprite_base+40
        sta sprite0_pointer
lll8    cmp #90
        bne lll9
        lda #sprite_base+41
        sta sprite0_pointer
lll9    cmp #95
        bne lll10
        lda #sprite_base+42
        sta sprite0_pointer
lll10   cmp #100
        bne lll11
        lda #sprite_base+43
        sta sprite0_pointer
lll11   cmp #125
        bne lll12
        ;lda #0
        ;sta $d015 
lll12   cmp #150
        bne lll13
        ldx #0
        stx frightened_mode
        jsr init_intro2
        lda test_mode
        cmp #1
        beq ll_resume
        ldy lives
        cpy #255
        beq all_lives_lost
        ;dey
        ;sty lives
ll_resume
        jsr level_init_sprites
        lda #intro2
        sta game_mode
        rts
lll13
        inc timer_ticks
        rts

all_lives_lost
        lda #game_over
        sta game_mode
        lda #0
        sta lives
        jsr init_game_over
        rts