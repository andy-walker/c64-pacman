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

        lda number_data_addr+1,y
        sta score_sprite1_addr+(10*3),x

        lda number_data_addr+2,y
        sta score_sprite1_addr+(11*3),x

        lda number_data_addr+3,y
        sta score_sprite1_addr+(12*3),x

        lda number_data_addr+4,y
        sta score_sprite1_addr+(13*3),x

        lda number_data_addr+5,y
        sta score_sprite1_addr+(14*3),x

        lda number_data_addr+6,y
        sta score_sprite1_addr+(15*3),x

        lda number_data_addr+7,y
        sta score_sprite1_addr+(16*3),x

        jmp end_set_sprite

sw_set_sprite2

        ; copy character data to second row of sprite 2

        lda number_data_addr,y
        sta score_sprite2_addr+(8*3),x

        lda number_data_addr+1,y
        sta score_sprite2_addr+(9*3),x

        lda number_data_addr+2,y
        sta score_sprite2_addr+(10*3),x

        lda number_data_addr+3,y
        sta score_sprite2_addr+(11*3),x

        lda number_data_addr+4,y
        sta score_sprite2_addr+(12*3),x

        lda number_data_addr+5,y
        sta score_sprite2_addr+(13*3),x

        lda number_data_addr+6,y
        sta score_sprite2_addr+(14*3),x

        lda number_data_addr+7,y
        sta score_sprite2_addr+(15*3),x

end_set_sprite

        inx                         ; increment (next digit)
        cpx #6                      ; is 6th digit?
        bcc sw_loop

        rts