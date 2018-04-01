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
        ;nop
        ;nop
        inx
        cpx #100
        bne dls_loop

        rts

display_main_game_sprites

        ldy game_mode
        cpy #gameplay
        bne dms1
        lda #%01100111
        jmp dms_end
dms1    cpy #life_lost
        bne dms2
        lda #%00000001
        jmp dms_end
dms2    lda #%00000111          ; assume game over
dms_end
        sta $d015

        lda #0                  ; use .a to keep track of carry bits - initially zeroed

        ldx sprite0_pointer
        stx $07f8
        ldx sprite0_x
        stx $d000
        ldx sprite0_y
        stx $d001
        ldx sprite0_colour
        stx $d027
        eor sprite0_carry

        ldx sprite1_pointer
        stx $07f9
        ldx sprite1_x
        stx $d002
        ldx sprite1_y
        stx $d003
        ldx sprite1_colour
        stx $d028
        ldy sprite1_carry        
        cpy #1
        bne dmgs2
        eor #%00000010
dmgs2
        ldx sprite2_pointer
        stx $07fa
        ldx sprite2_x
        stx $d004
        ldx sprite2_y
        stx $d005
        ldx sprite2_colour
        stx $d029
        ldy sprite2_carry  
        cpy #1
        bne dmgs3
        eor #%00000100
dmgs3
dmgs5
        ldx sprite5_pointer
        stx $07fd
        ldx sprite5_x
        stx $d00a
        ldx sprite5_y
        stx $d00b
        ldx sprite5_colour
        stx $d02c
        ldy sprite5_carry  
        cpy #1
        bne dmgs6
        eor #%00100000

dmgs6
        ldx sprite6_pointer
        stx $07fe
        ldx sprite6_x
        stx $d00c
        ldx sprite6_y
        stx $d00d
        ldx sprite6_colour
        stx $d02d
        ldy sprite6_carry  
        cpy #1
        bne dmgs7
        eor #%01000000        

dmgs7

        sta $d010
        rts