init_intro2
        lda #0
        sta timer_ticks
        rts

set_intro2_upper_sprites
        
        ; set upper screen sprites + positions

        lda #sprite_base+23         ; set ghost sprites
        sta $07f8
        sta $07f9
        sta $07fa
        sta $07fb

        lda #sprite_base+25         ; eyes-left sprite
        sta $07fc
        lda #sprite_base+28         ; eyes-down sprite
        sta $07fd
        sta $07ff
        lda #sprite_base+27         ; eyes-up sprite
        sta $07fe

        lda #180
        sta $d000
        sta $d008
        
        lda #112
        sta $d001
        sta $d009

        lda #163
        sta $d002
        sta $d00a

        lda #180
        sta $d004
        sta $d00c

        lda #197
        sta $d006
        sta $d00e

        lda #135
        sta $d003
        sta $d007
        sta $d00b
        sta $d00f

        lda #137
        sta $d005
        sta $d00d

        ; set ghost sprite colours
        
        lda #red
        sta $d027
        lda #pink
        sta $d028
        lda #purple
        sta $d029
        lda #orange
        sta $d02a

        ; set eyes sprites to white
        lda #white
        sta $d02b
        sta $d02c
        sta $d02d
        sta $d02e

        lda #%11111111                    ; enable all 8 sprites
        sta $d015
        lda #0
        sta $d010

        rts

set_intro2_lower_sprites

        lda #yellow                     ; set all bottom-half sprites to yellow
        sta $d027
        sta $d02b
        sta $d02c


        lda #sprite_base+47
        sta $07f8

        lda #sprite_base+48
        sta $07fc

        lda #sprite_base
        sta $07fd

        lda #165
        sta $d000

        lda #189
        sta $d008

        lda #155
        sta $d001
        sta $d009

        lda #180
        sta $d00a

        lda #192
        sta $d00b

        rts