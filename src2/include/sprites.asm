set_score_sprites
        
        lda #%00000000
        sta $d015

        ldx #sprite_base+52             ; 1 UP / score sprites
        ldy #sprite_base+53

        lda game_mode
        cmp #intro1
        bcc sss1

        lda flash_counter2
        cmp #17
        bcs sss1

        ldx #sprite_base+62
        ldy #sprite_base+63

sss1
        stx $07f8
        sty $07f9

        lda #sprite_base+54             ; High score sprites
        sta $07fa
        lda #sprite_base+55
        sta $07fb
        lda #sprite_base+56
        sta $07fc
        lda #sprite_base+57
        sta $07fd

        lda #sprite_base+58             ; 2 UP sprites
        sta $07fe
        lda #sprite_base+59
        sta $07ff

        lda #60
        sta $d000
        lda #84
        sta $d002

        lda #140
        sta $d004
        lda #164
        sta $d006
        lda #188
        sta $d008
        lda #212
        sta $d00a

        lda #6
        sta $d00c
        lda #30
        sta $d00e

        lda #27
        sta $d001
        sta $d003
        sta $d005
        sta $d007
        sta $d009
        sta $d00b
        sta $d00d
        sta $d00f

        lda #white
        sta $d027 
        sta $d028
        sta $d029
        sta $d02a
        sta $d02b
        sta $d02c
        sta $d02d
        sta $d02e
        sta $d02f
        
        ; set carry bits for last two sprite (2 up)
        lda #%11000000
        sta $d010

        rts


