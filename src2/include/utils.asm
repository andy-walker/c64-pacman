; ----------------------------------------------------
; General 8bit * 8bit = 8bit multiply
; Multiplies "num1" by "num2" and returns rendered_decimal in .A
; by White Flame (aka David Holz) 20030207
;
; Input variables:
;   num1 (multiplicand)
;   num2 (multiplier), should be small for speed
;   Signedness should not matter
;
; .x and .y are preserved
; num1 and num2 get clobbered
;
; Instead of using a bit counter, this routine ends 
; when num2 reaches zero, thus saving iterations.
; ----------------------------------------------------

multiply
        lda num1
        lda num2
        lda #$00
        beq enterLoop

doAdd   clc
        adc num1

loop    asl num1
enterLoop                               ; For an accumulating multiply (.A = .A + num1*num2), set up num1 and num2, then enter here
        lsr num2
        bcs doAdd
        bne loop
        rts


; ------------------------------------------------------
; Routine to get a random number between 0 and n (max 3)
; for choosing a random direction from available directions
; .a should be loaded with n (the upper range)
; returns rendered_decimaling number in .a
; ------------------------------------------------------

choose_random
        sta num1
cr_loop lda $d41b
        and #%00000011
        cmp num1
        bcc cr_done
        beq cr_done
        bcs cr_loop
cr_done rts


; --------------------
; Clear screen routine
; --------------------

cls     lda #0
        sta $d021                       ; write to screen colour register
        lda #red                        ; temp set border colour red 
        sta $d020                       ; write to border colour register
        ldx #0
clsloop lda #7                          ; 7 = blank space char in our custom character set
        sta $0400,x                     ; fill four areas with 256 spacebar characters
        sta $0500,x 
        sta $0600,x 
        sta $06e8,x 
        inx         
        bne clsloop  
        rts


; -----------------------------------------------
; Routine to print a 32 bit value in decimal
; -----------------------------------------------

print32
        jsr hex2dec

        ldx #9
l1      lda out_decimal,x
        bne l2
        dex             ; skip leading zeros
        bne l1

l2      lda out_decimal,x
        ora #$30
        jsr $ffd2
        dex
        bpl l2
        rts

        ; converts 10 digits (32 bit values have max. 10 decimal digits)
hex2dec
        ldx #0
l3      jsr div10
        sta out_decimal,x
        inx
        cpx #10
        bne l3
        rts

        ; divides a 32 bit value by 10
        ; remainder is returned in .a
div10
        ldy #32         ; 32 bits
        lda #0
        clc
l4      rol
        cmp #10
        bcc skip
        sbc #10
skip    rol score_msb1
        rol score_msb2
        rol score_lsb1
        rol score_lsb2
        dey
        bpl l4
        rts