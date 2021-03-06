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


; -----------------------------------------------------------
; Routine to generate a random number between 0 and n (max 3)
; for choosing a random direction from available directions
; .x should be preloaded with the ghost index
; .a should be loaded with n (the upper range)
; returns output in .a
; -----------------------------------------------------------

choose_random
        tay
        cpy #0
        bne cr1
        rts
cr1
        lda sprite1_x,x
        sta num4
crloop  lda timer_ticks
        eor num4
        eor flash_counter,x
        eor flash_counter2,x
        ;lsr
        ;lsr
        cpy #1
        bne cr2
        and #%00000001
        rts
cr2     
        and #%00000011
        cpy #2
        bne cr3
        cmp #4
        bcc cr3
        lda num4
        lsr
        sta num4
        jmp crloop
cr3     rts



choose_random_direction
        ldy #0
        lda directions
        and #%00001000
        bne crd1
        lda #left
        sta tmp1
        iny
crd1    lda directions
        and #%00000100
        bne crd2
        lda #right
        sta tmp1,y
        iny
crd2    lda directions
        and #%00000010
        bne crd3
        lda #up
        sta tmp1,y
        iny
crd3    lda directions
        and #%00000001
        bne crd4
        lda #down
        sta tmp1,y
        iny
crd4    tya
        jsr choose_random
        tay
        lda tmp1,y
        rts


; --------------------
; Clear screen routine
; --------------------

cls     lda #0
        sta $d021                       ; write to screen colour register
        ; lda #red                        ; temp set border colour red 
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


; --------------------------
; Detect if spacebar pressed
; Returns 0 or 1 in .a
; --------------------------

detect_spacebar

        lda #%01111111                  ; select row 7
        sta pra 
        lda prb                         ; load column information
        and #%00010000                  ; test space key  
        beq spacebar_pressed
        lda #0
        rts
spacebar_pressed
        lda #1
        rts
