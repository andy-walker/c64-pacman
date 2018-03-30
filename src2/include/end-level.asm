; ------------------------------------------------
; Routine to run at the end of the level
; handles background flash, and starting new level
; ------------------------------------------------

level_end

        lda timer_seconds
        cmp #1
        beq level_end_reset

        inc timer_ticks
        lda timer_ticks
        cmp #75
        beq flash_white
        cmp #100
        beq flash_blue
        cmp #125
        beq flash_white
        cmp #150
        beq flash_blue
        cmp #175
        beq flash_white
        cmp #200
        beq flash_blue
        cmp #225
        beq flash_white
        cmp #250
        beq flash_blue
        cmp #255
        beq flash_end
        rts

flash_white
        lda #white
        jsr set_level_colour
        rts

flash_blue
        lda #blue
        jsr set_level_colour
        rts

flash_white2
        ldx #0
        lda #white                  
fw_loop sta $d800,x 
        sta $d900,x 
        sta $da00,x 
        sta $dae8,x 
        inx         
        bne fw_loop  
        rts

flash_blue2
        ldx #0
        lda #blue              
fb_loop sta $d800,x 
        sta $d900,x 
        sta $da00,x 
        sta $dae8,x 
        inx         
        bne fb_loop  
        rts

flash_end
        lda #0
        sta timer_ticks
        lda #1
        sta timer_seconds

level_end_reset
        inc timer_ticks
        lda timer_ticks
        cmp #50
        beq ler1
        cmp #75
        beq ler2
        rts

ler1    lda #0
        sta $d015 
        jsr cls
        rts
ler2
        inc level_number
        jsr init_level
        jsr draw_level
        lda #intro2
        sta game_mode
        rts


set_level_colour

        sta $d804
        sta $d805
        sta $d806
        sta $d807
        sta $d808
        sta $d809
        sta $d80a
        sta $d80b
        sta $d80c
        sta $d80d
        sta $d80e
        sta $d80f
        sta $d810
        sta $d811
        sta $d812
        sta $d813
        sta $d814
        sta $d815
        sta $d816
        sta $d817
        sta $d818
        sta $d819
        sta $d81a
        sta $d81b
        sta $d81c
        sta $d81d
        sta $d81e
        sta $d81f
        sta $d820
        sta $d821
        sta $d822
        sta $d823
        sta $d824

        sta $d804+(1*40)
        sta $d814+(1*40)
        sta $d824+(1*40)

        sta $d804+(2*40)
        sta $d806+(2*40)
        sta $d807+(2*40)
        sta $d808+(2*40)
        sta $d809+(2*40)
        sta $d80b+(2*40)
        sta $d80c+(2*40)
        sta $d80d+(2*40)
        sta $d80e+(2*40)
        sta $d80f+(2*40)
        sta $d810+(2*40)
        sta $d811+(2*40)
        sta $d812+(2*40)
        sta $d814+(2*40)
        sta $d816+(2*40)
        sta $d817+(2*40)
        sta $d818+(2*40)
        sta $d819+(2*40)
        sta $d81a+(2*40)
        sta $d81b+(2*40)
        sta $d81c+(2*40)
        sta $d81d+(2*40)
        sta $d81f+(2*40)
        sta $d820+(2*40)
        sta $d821+(2*40)
        sta $d822+(2*40)
        sta $d824+(2*40)

        sta $d804+(3*40)
        sta $d806+(3*40)
        sta $d807+(3*40)
        sta $d808+(3*40)
        sta $d809+(3*40)
        sta $d80b+(3*40)
        sta $d80c+(3*40)
        sta $d80d+(3*40)
        sta $d80e+(3*40)
        sta $d81a+(3*40)
        sta $d81b+(3*40)
        sta $d81c+(3*40)
        sta $d81d+(3*40)
        sta $d81f+(3*40)
        sta $d820+(3*40)
        sta $d821+(3*40)
        sta $d822+(3*40)
        sta $d824+(3*40)

        sta $d804+(4*40)
        sta $d806+(4*40)
        sta $d807+(4*40)
        sta $d808+(4*40)
        sta $d809+(4*40)
        sta $d80b+(4*40)
        sta $d80c+(4*40)
        sta $d80d+(4*40)
        sta $d80e+(4*40)
        sta $d810+(4*40)
        sta $d811+(4*40)
        sta $d812+(4*40)
        sta $d813+(4*40)
        sta $d814+(4*40)
        sta $d815+(4*40)
        sta $d816+(4*40)
        sta $d817+(4*40)
        sta $d818+(4*40)
        sta $d81a+(4*40)
        sta $d81b+(4*40)
        sta $d81c+(4*40)
        sta $d81d+(4*40)
        sta $d81f+(4*40)
        sta $d820+(4*40)
        sta $d821+(4*40)
        sta $d822+(4*40)
        sta $d824+(4*40)

        sta $d804+(5*40)
        sta $d806+(5*40)
        sta $d807+(5*40)
        sta $d808+(5*40)
        sta $d809+(5*40)
        sta $d80b+(5*40)
        sta $d80c+(5*40)
        sta $d80d+(5*40)
        sta $d80e+(5*40)
        sta $d810+(5*40)
        sta $d811+(5*40)
        sta $d812+(5*40)
        sta $d813+(5*40)
        sta $d814+(5*40)
        sta $d815+(5*40)
        sta $d816+(5*40)
        sta $d817+(5*40)
        sta $d818+(5*40)
        sta $d81a+(5*40)
        sta $d81b+(5*40)
        sta $d81c+(5*40)
        sta $d81d+(5*40)
        sta $d81f+(5*40)
        sta $d820+(5*40)
        sta $d821+(5*40)
        sta $d822+(5*40)
        sta $d824+(5*40)        

        sta $d804+(6*40)
        sta $d814+(6*40)
        sta $d824+(6*40)

        sta $d804+(7*40)
        sta $d806+(7*40)
        sta $d807+(7*40)
        sta $d808+(7*40)
        sta $d809+(7*40)
        sta $d80b+(7*40)
        sta $d80c+(7*40)
        sta $d80d+(7*40)
        sta $d80e+(7*40)
        sta $d80f+(7*40)
        sta $d810+(7*40)
        sta $d811+(7*40)
        sta $d812+(7*40)
        sta $d814+(7*40)
        sta $d816+(7*40)
        sta $d817+(7*40)
        sta $d818+(7*40)
        sta $d819+(7*40)
        sta $d81a+(7*40)
        sta $d81b+(7*40)
        sta $d81c+(7*40)
        sta $d81d+(7*40)
        sta $d81f+(7*40)
        sta $d820+(7*40)
        sta $d821+(7*40)
        sta $d822+(7*40)
        sta $d824+(7*40)

        sta $d804+(8*40)
        sta $d80d+(8*40)
        sta $d80e+(8*40)
        sta $d81a+(8*40)       
        sta $d824+(8*40)

        sta $d804+(9*40)
        sta $d805+(9*40)
        sta $d806+(9*40)
        sta $d807+(9*40)
        sta $d808+(9*40)
        sta $d809+(9*40)
        sta $d80a+(9*40)
        sta $d80b+(9*40)
        sta $d80d+(9*40)
        sta $d80e+(9*40)
        sta $d80f+(9*40)
        sta $d810+(9*40)
        sta $d811+(9*40)
        sta $d812+(9*40)
        sta $d813+(9*40)
        sta $d815+(9*40)
        sta $d816+(9*40)
        sta $d817+(9*40)
        sta $d818+(9*40)
        sta $d819+(9*40)
        sta $d81a+(9*40)
        sta $d81c+(9*40)
        sta $d81d+(9*40)
        sta $d81e+(9*40)
        sta $d81f+(9*40)
        sta $d820+(9*40)
        sta $d821+(9*40)
        sta $d822+(9*40)
        sta $d823+(9*40)
        sta $d824+(9*40) 

        sta $d804+(10*40)
        sta $d805+(10*40)
        sta $d806+(10*40)
        sta $d807+(10*40)
        sta $d808+(10*40)
        sta $d809+(10*40)
        sta $d80a+(10*40)
        sta $d80b+(10*40)
        sta $d80d+(10*40)
        sta $d80e+(10*40)
        sta $d80f+(10*40)
        sta $d810+(10*40)
        sta $d811+(10*40)
        sta $d812+(10*40)
        sta $d813+(10*40)
        sta $d815+(10*40)
        sta $d816+(10*40)
        sta $d817+(10*40)
        sta $d818+(10*40)
        sta $d819+(10*40)
        sta $d81a+(10*40)
        sta $d81c+(10*40)
        sta $d81d+(10*40)
        sta $d81e+(10*40)
        sta $d81f+(10*40)
        sta $d820+(10*40)
        sta $d821+(10*40)
        sta $d822+(10*40)
        sta $d823+(10*40)
        sta $d824+(10*40) 

        sta $d804+(11*40)
        sta $d805+(11*40)
        sta $d806+(11*40)
        sta $d807+(11*40)
        sta $d808+(11*40)
        sta $d809+(11*40)
        sta $d80a+(11*40)
        sta $d80b+(11*40)
        sta $d80d+(11*40)
        sta $d80e+(11*40)
        sta $d80f+(11*40)
        sta $d810+(11*40)
        sta $d817+(11*40)
        sta $d818+(11*40)
        sta $d819+(11*40)
        sta $d81a+(11*40)
        sta $d81c+(11*40)
        sta $d81d+(11*40)
        sta $d81e+(11*40)
        sta $d81f+(11*40)
        sta $d820+(11*40)
        sta $d821+(11*40)
        sta $d822+(11*40)
        sta $d823+(11*40)
        sta $d824+(11*40) 

        sta $d810+(12*40)
        sta $d817+(12*40)
        sta $d818+(12*40)

        sta $d804+(13*40)
        sta $d805+(13*40)
        sta $d806+(13*40)
        sta $d807+(13*40)
        sta $d808+(13*40)
        sta $d809+(13*40)
        sta $d80a+(13*40)
        sta $d80b+(13*40)
        sta $d80d+(13*40)
        sta $d80e+(13*40)
        sta $d80f+(13*40)
        sta $d810+(13*40)
        sta $d817+(13*40)
        sta $d818+(13*40)
        sta $d819+(13*40)
        sta $d81a+(13*40)
        sta $d81c+(13*40)
        sta $d81d+(13*40)
        sta $d81e+(13*40)
        sta $d81f+(13*40)
        sta $d820+(13*40)
        sta $d821+(13*40)
        sta $d822+(13*40)
        sta $d823+(13*40)
        sta $d824+(13*40) 

        sta $d804+(14*40)
        sta $d805+(14*40)
        sta $d806+(14*40)
        sta $d807+(14*40)
        sta $d808+(14*40)
        sta $d809+(14*40)
        sta $d80a+(14*40)
        sta $d80b+(14*40)
        sta $d80d+(14*40)
        sta $d80e+(14*40)
        sta $d80f+(14*40)
        sta $d810+(14*40)
        sta $d811+(14*40)
        sta $d812+(14*40)
        sta $d813+(14*40)
        sta $d814+(14*40)
        sta $d815+(14*40)
        sta $d816+(14*40)
        sta $d817+(14*40)
        sta $d818+(14*40)
        sta $d819+(14*40)
        sta $d81a+(14*40)
        sta $d81c+(14*40)
        sta $d81d+(14*40)
        sta $d81e+(14*40)
        sta $d81f+(14*40)
        sta $d820+(14*40)
        sta $d821+(14*40)
        sta $d822+(14*40)
        sta $d823+(14*40)
        sta $d824+(14*40)

        sta $d804+(15*40)
        sta $d805+(15*40)
        sta $d806+(15*40)
        sta $d807+(15*40)
        sta $d808+(15*40)
        sta $d809+(15*40)
        sta $d80a+(15*40)
        sta $d80b+(15*40)
        sta $d80d+(15*40)
        sta $d80e+(15*40)
        sta $d80f+(15*40)
        sta $d810+(15*40)
        sta $d811+(15*40)
        sta $d812+(15*40)
        sta $d813+(15*40)
        sta $d814+(15*40)
        sta $d815+(15*40)
        sta $d816+(15*40)
        sta $d817+(15*40)
        sta $d818+(15*40)
        sta $d819+(15*40)
        sta $d81a+(15*40)
        sta $d81c+(15*40)
        sta $d81d+(15*40)
        sta $d81e+(15*40)
        sta $d81f+(15*40)
        sta $d820+(15*40)
        sta $d821+(15*40)
        sta $d822+(15*40)
        sta $d823+(15*40)
        sta $d824+(15*40)

        sta $d804+(16*40)
        sta $d814+(16*40)
        sta $d824+(16*40)

        sta $d804+(17*40)
        sta $d806+(17*40)
        sta $d807+(17*40)
        sta $d808+(17*40)
        sta $d809+(17*40)
        sta $d80b+(17*40)
        sta $d80c+(17*40)
        sta $d80d+(17*40)
        sta $d80e+(17*40)
        sta $d80f+(17*40)
        sta $d810+(17*40)
        sta $d811+(17*40)
        sta $d812+(17*40)
        sta $d814+(17*40)
        sta $d816+(17*40)
        sta $d817+(17*40)
        sta $d818+(17*40)
        sta $d819+(17*40)
        sta $d81a+(17*40)
        sta $d81b+(17*40)
        sta $d81c+(17*40)
        sta $d81d+(17*40)
        sta $d81f+(17*40)
        sta $d820+(17*40)
        sta $d821+(17*40)
        sta $d822+(17*40)
        sta $d824+(17*40)

        sta $d804+(18*40)
        sta $d808+(18*40)
        sta $d809+(18*40)
        sta $d81f+(18*40)
        sta $d824+(18*40)

        sta $d804+(19*40)
        sta $d805+(19*40)
        sta $d806+(19*40)
        sta $d808+(19*40)
        sta $d809+(19*40)
        sta $d80a+(19*40)
        sta $d80b+(19*40)
        sta $d80d+(19*40)
        sta $d80e+(19*40)
        sta $d810+(19*40)
        sta $d811+(19*40)
        sta $d812+(19*40)
        sta $d813+(19*40)
        sta $d814+(19*40)
        sta $d815+(19*40)
        sta $d816+(19*40)
        sta $d817+(19*40)
        sta $d818+(19*40)
        sta $d81a+(19*40)
        sta $d81c+(19*40)
        sta $d81d+(19*40)
        sta $d81e+(19*40)
        sta $d81f+(19*40)
        sta $d821+(19*40)
        sta $d822+(19*40)
        sta $d823+(19*40)
        sta $d824+(19*40)

        sta $d804+(20*40)
        sta $d805+(20*40)
        sta $d806+(20*40)
        sta $d808+(20*40)
        sta $d809+(20*40)
        sta $d80a+(20*40)
        sta $d80b+(20*40)
        sta $d80d+(20*40)
        sta $d80e+(20*40)
        sta $d810+(20*40)
        sta $d811+(20*40)
        sta $d812+(20*40)
        sta $d813+(20*40)
        sta $d814+(20*40)
        sta $d815+(20*40)
        sta $d816+(20*40)
        sta $d817+(20*40)
        sta $d818+(20*40)
        sta $d81a+(20*40)
        sta $d81c+(20*40)
        sta $d81d+(20*40)
        sta $d81e+(20*40)
        sta $d81f+(20*40)
        sta $d821+(20*40)
        sta $d822+(20*40)
        sta $d823+(20*40)
        sta $d824+(20*40)

        sta $d804+(21*40)
        sta $d80d+(21*40)
        sta $d80e+(21*40)
        sta $d814+(21*40)
        sta $d81a+(21*40)
        sta $d824+(21*40)

        sta $d804+(22*40)
        sta $d806+(22*40)
        sta $d807+(22*40)
        sta $d808+(22*40)
        sta $d809+(22*40)
        sta $d80a+(22*40)
        sta $d80b+(22*40)
        sta $d80c+(22*40)
        sta $d80d+(22*40)
        sta $d80e+(22*40)
        sta $d80f+(22*40)
        sta $d810+(22*40)
        sta $d811+(22*40)
        sta $d812+(22*40)
        sta $d814+(22*40)
        sta $d816+(22*40)
        sta $d817+(22*40)
        sta $d818+(22*40)
        sta $d819+(22*40)
        sta $d81a+(22*40)
        sta $d81b+(22*40)
        sta $d81c+(22*40)
        sta $d81d+(22*40)
        sta $d81e+(22*40)
        sta $d81f+(22*40)
        sta $d820+(22*40)
        sta $d821+(22*40)
        sta $d822+(22*40)
        sta $d824+(22*40)

        sta $d804+(23*40)
        sta $d824+(23*40)

        sta $d804+(24*40)
        sta $d805+(24*40)
        sta $d806+(24*40)
        sta $d807+(24*40)
        sta $d808+(24*40)
        sta $d809+(24*40)
        sta $d80a+(24*40)
        sta $d80b+(24*40)
        sta $d80c+(24*40)
        sta $d80d+(24*40)
        sta $d80e+(24*40)
        sta $d80f+(24*40)
        sta $d810+(24*40)
        sta $d811+(24*40)
        sta $d812+(24*40)
        sta $d813+(24*40)
        sta $d814+(24*40)
        sta $d815+(24*40)
        sta $d816+(24*40)
        sta $d817+(24*40)
        sta $d818+(24*40)
        sta $d819+(24*40)
        sta $d81a+(24*40)
        sta $d81b+(24*40)
        sta $d81c+(24*40)
        sta $d81d+(24*40)
        sta $d81e+(24*40)
        sta $d81f+(24*40)
        sta $d820+(24*40)
        sta $d821+(24*40)
        sta $d822+(24*40)
        sta $d823+(24*40)
        sta $d824+(24*40)

        rts