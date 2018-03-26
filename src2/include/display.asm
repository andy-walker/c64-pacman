display_lower_game_sprites

        lda #0
        eor life_sprites_enabled
        sta $d015

        lda #yellow
        sta $d027 
        sta $d028
        lda #%11100000
        sta $d010
        lda #253
        sta $d001
        sta $d003
        lda #65
        sta $d000
        lda #89
        sta $d002
        lda sprite12_pointer
        sta $07f8
        lda sprite13_pointer
        sta $07f9

        lda #sprite_base+67
        sta $07fd
        lda #sprite_base+68
        sta $07fe
        lda #sprite_base+69
        sta $07ff

        lda #40
        sta $d00a
        sta $d00c
        sta $d00e

        lda #253
        sta $d00b
        sta $d00d
        sta $d00f

        lda #red
        sta $d02c
        lda #white
        sta $d02d
        lda #brown
        sta $d02e

        ldx #0
dls_loop
        nop
        nop
        inx
        cpx #200
        bne dls_loop

        rts