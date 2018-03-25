; --------------------
; Reset score to zero
; --------------------

reset_score

        lda #0

        sta score_1
        sta score_2
        sta score_3
        rts


; --------------------
; Reset hi-score to zero
; --------------------

reset_hiscore

        lda #0

        sta hiscore_1
        sta hiscore_2
        sta hiscore_3
        rts


; ------------------------------------------------
; Add to score
; num1 - points msb as a binary-coded decimal
; num2 - points lsb as a binary-coded decimal
; ------------------------------------------------

add_to_score
    
        clc
        sed

        lda score_3
        adc num2
        sta score_3
        lda score_2
        adc num1
        sta score_2
        lda score_1
        adc #0
        sta score_1

        cld

construct_charmap

        lda score_1
        lsr
        lsr
        lsr
        lsr
        sta score_charmap

        lda score_1
        and #%00001111
        sta score_charmap+1

        lda score_2
        lsr
        lsr
        lsr
        lsr
        sta score_charmap+2

        lda score_2
        and #%00001111
        sta score_charmap+3

        lda score_3
        lsr
        lsr
        lsr
        lsr
        sta score_charmap+4

        lda score_3
        and #%00001111
        sta score_charmap+5


; ----------------------------------------------
; Routine to write score to upper border sprites
; ----------------------------------------------

score_writer
        
        ldx #0                      ; digit counter (0-5) - one for each of the 6 digits in the display

sw_loop
        lda score_charmap,x         ; get the number we're supposed to be printing
        
        asl                         ; multiply it by 8 
        asl                         ; .. as each character def is 8 bytes long
        asl                         ; this will then become our offset against #number_data_addr
                                    ; for retrieving the character data

        tay                         ; then transfer the offset we calculated to .y
        
        cpx #3                      ; for digit 4, 5 and 6, set sprite 2
        bcs sw_set_sprite2
                                    ; for digit 1, 2 and 3, set sprite 1
sw_set_sprite1

        ; copy character data to second row of sprite 1

        lda number_data_addr,y
        sta score_sprite1_addr+(9*3),x
        sta score_sprite3_addr+(9*3),x

        lda number_data_addr+1,y
        sta score_sprite1_addr+(10*3),x
        sta score_sprite3_addr+(10*3),x

        lda number_data_addr+2,y
        sta score_sprite1_addr+(11*3),x
        sta score_sprite3_addr+(11*3),x

        lda number_data_addr+3,y
        sta score_sprite1_addr+(12*3),x
        sta score_sprite3_addr+(12*3),x

        lda number_data_addr+4,y
        sta score_sprite1_addr+(13*3),x
        sta score_sprite3_addr+(13*3),x

        lda number_data_addr+5,y
        sta score_sprite1_addr+(14*3),x
        sta score_sprite3_addr+(14*3),x

        lda number_data_addr+6,y
        sta score_sprite1_addr+(15*3),x
        sta score_sprite3_addr+(15*3),x

        lda number_data_addr+7,y
        sta score_sprite1_addr+(16*3),x
        sta score_sprite3_addr+(16*3),x

        jmp end_set_sprite

sw_set_sprite2

        ; copy character data to second row of sprite 2

        lda number_data_addr,y
        sta score_sprite2_addr+(8*3),x
        sta score_sprite4_addr+(8*3),x

        lda number_data_addr+1,y
        sta score_sprite2_addr+(9*3),x
        sta score_sprite4_addr+(9*3),x

        lda number_data_addr+2,y
        sta score_sprite2_addr+(10*3),x
        sta score_sprite4_addr+(10*3),x

        lda number_data_addr+3,y
        sta score_sprite2_addr+(11*3),x
        sta score_sprite4_addr+(11*3),x

        lda number_data_addr+4,y
        sta score_sprite2_addr+(12*3),x
        sta score_sprite4_addr+(12*3),x

        lda number_data_addr+5,y
        sta score_sprite2_addr+(13*3),x
        sta score_sprite4_addr+(13*3),x

        lda number_data_addr+6,y
        sta score_sprite2_addr+(14*3),x
        sta score_sprite4_addr+(14*3),x

        lda number_data_addr+7,y
        sta score_sprite2_addr+(15*3),x
        sta score_sprite4_addr+(15*3),x

end_set_sprite

        inx                         ; increment (next digit)
        cpx #6                      ; is 6th digit?
        beq sw_end
        jmp sw_loop
sw_end

compare_hiscore

        ; is score greater than hi-score?

        lda score_1                 ; compare high bytes
        cmp hiscore_1
        bcc hs_unbeaten             ; if NUM1H < NUM2H then NUM1 < NUM2
        bne hs_beaten               ; if NUM1H <> NUM2H then NUM1 > NUM2 (so NUM1 >= NUM2)
        lda score_2                 ; compare middle bytes
        cmp hiscore_2
        bcc hs_unbeaten             ; if NUM1M < NUM2M then NUM1 < NUM2
        bne hs_beaten               ; if NUM1M <> NUM2M then NUM1 > NUM2 (so NUM1 >= NUM2)
        lda score_3                 ; compare low bytes
        cmp hiscore_3
        beq hs_unbeaten
        bcs hs_beaten               ; if NUM1L >= NUM2L then NUM1 >= NUM2

hs_unbeaten
        rts

hs_beaten
        
        lda score_1
        sta hiscore_1
        lda score_2
        sta hiscore_2
        lda score_3
        sta hiscore_3

hiscore_writer

        ldx #0                      ; digit counter (0-5) - one for each of the 6 digits in the display

hs_loop
        lda score_charmap,x         ; get the number we're supposed to be printing
        
        asl                         ; multiply it by 8 
        asl                         ; .. as each character def is 8 bytes long
        asl                         ; this will then become our offset against #number_data_addr
                                    ; for retrieving the character data

        tay                         ; then transfer the offset we calculated to .y
        
        cpx #3                      ; for digit 4, 5 and 6, set sprite 2
        bcs hs_set_sprite2
                                    ; for digit 1, 2 and 3, set sprite 1        

hs_set_sprite1

        ; copy character data to second row of sprite 1

        lda number_data_addr,y
        sta hiscore_sprite1_addr+(9*3),x

        lda number_data_addr+1,y
        sta hiscore_sprite1_addr+(10*3),x

        lda number_data_addr+2,y
        sta hiscore_sprite1_addr+(11*3),x

        lda number_data_addr+3,y
        sta hiscore_sprite1_addr+(12*3),x

        lda number_data_addr+4,y
        sta hiscore_sprite1_addr+(13*3),x

        lda number_data_addr+5,y
        sta hiscore_sprite1_addr+(14*3),x

        lda number_data_addr+6,y
        sta hiscore_sprite1_addr+(15*3),x

        lda number_data_addr+7,y
        sta hiscore_sprite1_addr+(16*3),x

        jmp end_set_hs_sprite

hs_set_sprite2

        ; copy character data to second row of sprite 2

        lda number_data_addr,y
        sta hiscore_sprite2_addr+(8*3),x

        lda number_data_addr+1,y
        sta hiscore_sprite2_addr+(9*3),x

        lda number_data_addr+2,y
        sta hiscore_sprite2_addr+(10*3),x

        lda number_data_addr+3,y
        sta hiscore_sprite2_addr+(11*3),x

        lda number_data_addr+4,y
        sta hiscore_sprite2_addr+(12*3),x

        lda number_data_addr+5,y
        sta hiscore_sprite2_addr+(13*3),x

        lda number_data_addr+6,y
        sta hiscore_sprite2_addr+(14*3),x

        lda number_data_addr+7,y
        sta hiscore_sprite2_addr+(15*3),x

end_set_hs_sprite
        inx                         ; increment (next digit)
        cpx #6                      ; is 6th digit?
        beq hs_end
        jmp hs_loop
hs_end
        rts