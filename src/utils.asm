; ----------------------------------------------------
; General 8bit * 8bit = 8bit multiply
; Multiplies "num1" by "num2" and returns result in .A
; by White Flame (aka David Holz) 20030207
;
; Input variables:
;   num1 (multiplicand)
;   num2 (multiplier), should be small for speed
;   Signedness should not matter
;
; .X and .Y are preserved
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

; --------------------
; Clear screen routine
; --------------------

cls     lda #0
        sta $d020                       ; write to border colour register
        sta $d021                       ; write to screen colour register

clsloop lda #7                          ; 7 = blank space char in our custom character set
        sta $0400,x                     ; fill four areas with 256 spacebar characters
        sta $0500,x 
        sta $0600,x 
        sta $06e8,x 
        inx         
        bne clsloop  
        rts