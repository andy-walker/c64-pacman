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

        jsr cls                         ; clear screen

        sei                             ; disable interrupts
        lda #$7f
        sta $dc0d
        sta $dd0d
        lda #$01
        sta $d01a

        ; character set initialisation

        lda $d018
        ora #$0e                        ; set chars location to $3800 for displaying the custom font
        sta $d018                       ; Bits 1-3 ($400+512bytes * low nibble value) of $d018 sets char location
                                        ; $400 + $200*$0E = $3800

        jsr init_character_map
        jsr sprite_writer

        ; irq initialisation
        
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

        lda $dc0d	                    ; clear interrupts and ack irq
        lda $dd0d
        asl $d019
        cli

        jsr *


irq
        ; do some stuff
        

        asl $d019                       ; acknowledge raster irq
        jmp $ea81


init_character_map
        
        ; set character data in the character map
        ldx #0
        lda #137
        clc
icm_loop
        sta char_1_1,x
        adc #1
        inx
        cpx #6
        bcc icm_loop

        ; enable first three sprites
        lda #%00000111
        sta $d015

        ; position sprites
        lda #100
        sta $d000

        lda #124
        sta $d002

        lda #148
        sta $d004

        lda #100
        sta $d001
        sta $d003
        sta $d005

        ; set colour to white
        lda #1
        sta $d027
        sta $d028
        sta $d029
        rts


; --------------------
; Clear screen routine
; --------------------

cls     lda #0
        sta $d020                       ; write to border colour register
        sta $d021                       ; write to screen colour register
        ldx #0
clsloop lda #7                          ; 7 = blank space char in our custom character set
        sta $0400,x                     ; fill four areas with 256 spacebar characters
        sta $0500,x 
        sta $0600,x 
        sta $06e8,x 
        inx         
        bne clsloop  
        rts

.include "sprite-writer.asm"

; load sprite data
*=sprite_data_addr	      
    .binary "../../resources/sprites.raw"

; load character data
*=char_data_addr
    .binary "../../resources/chars.raw"