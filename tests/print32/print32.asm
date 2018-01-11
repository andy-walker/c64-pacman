value = $02
result = $06

; ------
; Loader 
; ------

*=$0801
.byte $0b, $08, $00, $00, $9e, $32, $30, $36, $31, $00, $00, $00


; ------------------
; Main program start
; ------------------

*=$080d

        lda #$ff
        sta value
        sta value+1
        sta value+2
        lda #0

        sta value+3

        jsr print32
        rts

; -----------------------------------------------
; Test routine to print a 32 bit value in decimal
; -----------------------------------------------

print32
        jsr hex2dec

        ldx #9
l1      lda result,x
        bne l2
        dex             ; skip leading zeros
        bne l1

l2      lda result,x
        ora #$30
        jsr $ffd2
        dex
        bpl l2
        rts

        ; converts 10 digits (32 bit values have max. 10 decimal digits)
hex2dec
        ldx #0
l3      jsr div10
        sta result,x
        inx
        cpx #10
        bne l3
        rts

        ; divides a 32 bit value by 10
        ; remainder is returned in akku
div10
        ldy #32         ; 32 bits
        lda #0
        clc
l4      rol
        cmp #10
        bcc skip
        sbc #10
skip    rol value
        rol value+1
        rol value+2
        rol value+3
        dey
        bpl l4
        rts
