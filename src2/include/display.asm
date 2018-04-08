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
        cpx #92
        bne dls_loop

        rts

display_main_game_sprites

        ldy game_mode
        cpy #gameplay
        bne dms1
        lda #%11111111
        jmp dms_end
dms1    cpy #life_lost
        bne dms2
        lda #%00000001
        jmp dms_end
dms2    lda #%00000111          ; assume game over
dms_end
        sta $d015

        lda #0                  ; use num1 to keep track of carry bits - initially zeroed
        sta num1
        ldx #0

        lda lowest_sprite
        cmp #0
        bne *+3
        inx

        lda sprite0_pointer,x
        sta $07f8
        lda sprite0_x,x
        sta $d000
        lda sprite0_y,x
        sta $d001
        lda sprite0_colour,x
        sta $d027
        lda sprite0_carry,x
        cmp #1
        bne dmgs1
        lda num1
        eor #%00000001
        sta num1
dmgs1
        lda sprite1_pointer,x
        sta $07f9
        lda sprite1_x,x
        sta $d002
        lda sprite1_y,x
        sta $d003
        lda sprite1_colour,x
        sta $d028
        lda sprite1_carry,x        
        cmp #1
        bne dmgs2
        lda num1
        eor #%00000010
        sta num1
dmgs2
        lda sprite2_pointer,x
        sta $07fa
        lda sprite2_x,x
        sta $d004
        lda sprite2_y,x
        sta $d005
        lda sprite2_colour,x
        sta $d029
        lda sprite2_carry,x  
        cmp #1
        bne dmgs3
        lda num1
        eor #%00000100
        sta num1
dmgs3
        lda sprite3_pointer,x
        sta $07fb
        lda sprite3_x,x
        sta $d006
        lda sprite3_y,x
        sta $d007
        lda sprite3_colour,x
        sta $d02a
        lda sprite3_carry,x
        cmp #1
        bne dmgs4
        lda num1
        eor #%00001000
        sta num1
dmgs4
        lda sprite4_pointer,x
        sta $07fc
        lda sprite4_x,x
        sta $d008
        lda sprite4_y,x
        sta $d009
        lda sprite4_colour,x
        sta $d02b
        lda sprite4_carry,x 
        cmp #1
        bne dmgs5
        lda num1
        eor #%00010000
        sta num1
dmgs5
        lda lowest_sprite
        cmp #5
        bne *+3
        inx

        lda sprite5_pointer,x
        sta $07fd
        lda sprite5_x,x
        sta $d00a
        lda sprite5_y,x
        sta $d00b
        lda sprite5_colour,x
        sta $d02c
        lda sprite5_carry,x
        cmp #1
        bne dmgs6
        lda num1
        eor #%00100000
        sta num1

dmgs6
        lda lowest_sprite
        cmp #6
        bne *+3
        inx

        lda sprite6_pointer,x
        sta $07fe
        lda sprite6_x,x
        sta $d00c
        lda sprite6_y,x
        sta $d00d
        lda sprite6_colour,x
        sta $d02d
        lda sprite6_carry,x  
        cmp #1
        bne dmgs7
        lda num1
        eor #%01000000   
        sta num1     

dmgs7
        lda lowest_sprite
        cmp #7
        bne *+3
        inx

        lda sprite7_pointer,x
        sta $07ff
        lda sprite7_x,x
        sta $d00e
        lda sprite7_y,x
        sta $d00f
        lda sprite7_colour,x
        sta $d02e
        lda sprite7_carry,x
        cmp #1
        bne dmgs8
        lda num1
        eor #%10000000   
        sta num1 
dmgs8
        lda num1
        sta $d010
        rts


display_secondary_game_sprites
        
        ldx lowest_sprite
        ldy highest_sprite
        lda sprite0_pointer,x
        sta $07f8,y
        lda sprite0_colour,x
        sta $d027,y

        lda sprite0_carry,x
        cmp #1
        bne dsgs4

        cpy #0
        bne dsgs1
        lda $d010
        ora #%00000001
        jmp dsgs8
dsgs1
        cpy #5
        bne dsgs2
        lda $d010
        ora #%00100000
        jmp dsgs8
dsgs2
        cpy #6
        bne dsgs3
        lda $d010
        ora #%01000000
        jmp dsgs8
dsgs3
        cpy #7
        bne dsgs9
        lda $d010
        ora #%10000000
        jmp dsgs8

dsgs4
        cpy #0
        bne dsgs5
        lda $d010
        and #%11111110
        jmp dsgs8
dsgs5
        cpy #5
        bne dsgs6
        lda $d010
        and #%11011111
        jmp dsgs8
dsgs6
        cpy #6
        bne dsgs7
        lda $d010
        and #%10111111
        jmp dsgs8

dsgs7
        cpy #7
        bne dsgs9
        lda $d010
        and #%01111111
        jmp dsgs8

dsgs8
        sta $d010
dsgs9

        tya
        asl
        tay

        lda sprite0_x,x
        sta $d000,y
        lda sprite0_y,x
        sta $d001,y
        rts