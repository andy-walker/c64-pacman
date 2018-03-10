.include "include/definitions.asm"

; ------
; Loader 
; ------

*=$0801
.byte $0b, $08, $00, $00, $9e, $32, $30, $36, $31, $00, $00, $00


; ------------------
; Main program start
; ------------------

*=$080d
         
        sei

        ; init random number generator using SID's noise waveform generator
        ; read from $d41b to get random number 

        lda #$ff                        ; maximum frequency value 
        sta $d40e                       ; voice 3 frequency low byte 
        sta $d40f                       ; voice 3 frequency high byte 
        lda #$80                        ; noise waveform, gate bit off 
        sta $d412                       ; voice 3 control register 

        ; character set initialisation

        lda $d018
        ora #$0e                        ; set chars location to $3800 for displaying the custom font
        sta $d018                       ; Bits 1-3 ($400+512bytes * low nibble value) of $d018 sets char location
                                        ; $400 + $200*$0E = $3800
        
        lda #0                          ; enable/disable test mode (unlimited lives)
        sta test_mode

        lda #attract
        sta game_mode
    
        lda #$02
        sta $d020
        lda #$00
        sta $d021
        lda #<irq1
        sta $314
        lda #>irq1
        sta $315
        lda #$7f
        sta $dc0d
        lda #$1b
        sta $d011
        lda #$01
        sta $d01a
        cli
        jmp *
irq1    inc $d019
        lda #$00
        sta $d012
        lda #$00
        sta $d011
        lda #<irq2
        sta $314
        lda #>irq2
        sta $315
        jmp $ea7e
irq2    inc $d019
        lda #$fa
        sta $d012
        lda #$1b ;If you want to display a bitmap pic, use #$3b instead
        sta $d011
        lda #<irq1
        sta $314
        lda #>irq1
        sta $315
        jmp $ea7e

.include "include/data.asm"