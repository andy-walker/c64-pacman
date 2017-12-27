.include "definitions.asm"

; ------
; Loader 
; ------

*=$0801
.byte $0b, $08, $00, $00, $9e, $32, $30, $36, $31, $00, $00, $00


; ------------------
; Main program start
; ------------------

*=$080d

start  
        jsr cls
        
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
        
        lda #1
        sta level_number
        
        jsr reset_score
        jsr init_level

        ; irq initialisation (this should happen last)
        
        lda #%01111111                  ; switch off interrupt signals from CIA-1
        sta $dc0d
        and $d011                       ; clear most significant bit in VIC's raster register
        sta $d011
        lda #255                        ; set the raster line number where interrupt should occur
        sta $d012
        lda #<irq                       ; set the interrupt vector to point to the interrupt service routine below
        sta $0314
        lda #>irq
        sta $0315
        lda #%00000001                  ; enable raster interrupt signals from VIC
        sta $d01a

        jsr *


irq     lda level_state
        cmp #0
        bne lvl_end
        jsr level_init_frame
        jsr move_character
        jsr move_ghosts
        jsr level_end_frame
        jmp irq_end
lvl_end jsr level_end
irq_end asl $d019                       ; acknowledge raster irq
        jmp $ea31                       ; scan keyboard (only do once per frame)


.include "level.asm"
.include "score.asm"
.include "pacman.asm"
.include "ghosts.asm"
.include "sprites.asm"
.include "utils.asm"
.include "data.asm"