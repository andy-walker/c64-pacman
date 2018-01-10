; -----------------------------------------
; Initialise first stage of the game intro
; Renders PLAYER ONE and READY! as sprites
; in order to display them centrally
; (character map is off-centre)
; -----------------------------------------
init_intro1
        
        lda #0
        sta timer_ticks

        lda #%00011111 
        sta $d015                       ; enable first 5 sprites

        ; set sprites

        lda #sprite_base+44
        sta $07f8

        lda #sprite_base+45
        sta $07f9

        lda #sprite_base+46
        sta $07fa

        lda #sprite_base+47
        sta $07fb

        lda #sprite_base+48
        sta $07fc

        ; set sprite positions

        lda #147
        sta $d000

        lda #171
        sta $d002

        lda #203
        sta $d004
        
        lda #115
        sta $d001
        sta $d003
        sta $d005

        lda #165
        sta $d006

        lda #189
        sta $d008

        lda #155
        sta $d007
        sta $d009

        ; set sprite colours

        lda #cyan
        sta $d027
        sta $d028
        sta $d029

        lda #yellow
        sta $d02a
        sta $d02b

        rts

intro1_run

        lda timer_ticks
        cmp #100
        bne i1r_end

        jsr init_intro2 

i1r_end inc timer_ticks
        rts


init_intro2
        
        lda #intro2
        sta game_mode
        
        ; ensure power pills are set to white (in case they were flashed off when player died)

        lda #white
        sta $d87d
        sta $d89b
        sta $dad5
        sta $daf3

        rts

;--------------------------------
; Run 2nd stage of the game intro
; (runs on raster line 255)
;--------------------------------
intro2_run

        ; set upper screen sprites + positions
        lda #$ff                    ; enable all 8 sprites
        sta $d015

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

        lda timer_ticks
        cmp #200
        bne i2r_end

        ; start the game

        jsr level_init_sprites          ; call init_level to reset the sprites
        lda #gameplay                   ; set game mode to 'gameplay'
        sta game_mode

        ; acknowledge current irq and reset callback for gameplay mode
        lda #<irq
        ldx #>irq
        sta $0314
        stx $0315

        ; Create interrupt at line 255 for primary raster irq
        ldy #255
        sty $d012
        asl $d019                       ; acknowledge raster irq
        jmp $ea81

i2r_end 
        inc timer_ticks
        lda #<i2_irq
        ldx #>i2_irq
        sta $0314
        stx $0315

        ; Set next interrupt at line 147 for secondary raster irq (lower half of screen)
        ldy #147
        sty $d012
        asl $d019                       ; acknowledge raster irq
        jmp $ea81       


; ----------------------------------------
; Secondary raster irq routine
; renders bottom half of the intro2 screen
; ----------------------------------------

i2_irq

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

        ; set next irq to primary raster irq (line 255)
        lda #<irq
        ldx #>irq
        sta $0314
        stx $0315

        ; Create interrupt at line 255 for primary raster irq
        ldy #255
        sty $d012
        asl $d019                       ; acknowledge raster irq
        jmp $ea81


; --------------------------------------
; Routine to initialise game over screen
; --------------------------------------

init_game_over

        lda #game_over
        sta game_mode

        lda #0
        sta timer_ticks
        
        lda #%00000111                  ; enable first 3 sprites
        sta $d015

        lda #0                          ; unset all sprite carry bits
        sta $d010
        
        lda #sprite_base+49
        sta $07f8

        lda #sprite_base+50
        sta $07f9

        lda #sprite_base+51
        sta $07fa

        lda #red
        sta $d027
        sta $d028
        sta $d029

        lda #151
        sta $d000

        lda #175
        sta $d002

        lda #199
        sta $d004
        
        lda #115
        sta $d001
        sta $d003
        sta $d005

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
        lda #0
        sta $d015
        rts
gor_reset
        lda #attract
        sta game_mode
        jsr init_attract_mode
gor_end rts