; ------
; Loader 
; ------

*=$0801
.byte $0b, $08, $00, $00, $9e, $32, $30, $36, $31, $00, $00, $00

blue = 6

sprite_data_addr = $2000
char_data_addr = $3800

; ------------------
; Main program start
; ------------------

*=$080d

start   sei

        jsr cls

        ; character initialisation

        lda $d018
        ora #$0e       ; set chars location to $3800 for displaying the custom font
        sta $d018      ; Bits 1-3 ($400+512bytes * low nibble value) of $d018 sets char location
                       ; $400 + $200*$0E = $3800

        ; sprite initialisation

        lda #$01 
        sta $d015     ; Turn sprite 0 on 
        ;sta $d01c    ; multi coloured sprite 

        lda #7 
        sta $d027     ; set primary colour yellow

        lda #$00      ; set black and white 
        sta $d025     ; multi-colors global 
        lda #$01 
        sta $d026 


        lda #$c0 
        sta $d000    ; set x coordinate to 40 
        sta $d001    ; set y coordinate to 40 
        lda #$80 
        sta $07f8    ; set pointer: sprite data at $2000    

        jsr init_level

        ; irq initialisation (this should happen last)
        
        lda #%01111111 ; switch off interrupt signals from CIA-1
        sta $dc0d
        and $d011      ; clear most significant bit in VIC's raster register
        sta $d011
        lda #210       ; set the raster line number where interrupt should occur
        sta $d012
        lda #<irq      ; set the interrupt vector to point to the interrupt service routine below
        sta $0314
        lda #>irq
        sta $0315
        lda #%00000001 ; enable raster interrupt signals from VIC
        sta $d01a

        ;rts
        jsr *


irq     asl $d019      ; acknowledge raster irq
        jmp $ea31      ; scan keyboard (only do once per frame)


; ----------------
; Initialise level
; ----------------

init_level
        ldx #0

loader_loop 
        
        ; load characters for each line
        lda lvlch1,x
        sta $0404,x
        lda lvlch2,x
        sta $042c,x
        lda lvlch3,x
        sta $0454,x
        lda lvlch4,x
        sta $047c,x
        lda lvlch5,x
        sta $04a4,x
        lda lvlch6,x
        sta $04cc,x
        lda lvlch7,x
        sta $04f4,x
        lda lvlch8,x
        sta $051c,x
        lda lvlch9,x
        sta $0544,x       
        lda lvlch10,x
        sta $056c,x  
        lda lvlch11,x
        sta $0594,x  
        lda lvlch12,x
        sta $05bc,x 


        ; load colour information for each line
        lda lvlcl1,x
        sta $d804,x
        lda lvlcl2,x
        sta $d82c,x
        lda lvlcl3,x
        sta $d854,x
        lda lvlcl4,x
        sta $d87c,x
        lda lvlcl5,x
        sta $d8a4,x
        lda lvlcl6,x
        sta $d8cc,x
        lda lvlcl7,x
        sta $d8f4,x
        lda lvlcl8,x
        sta $d91c,x
        lda lvlcl9,x
        sta $d944,x       
        lda lvlcl10,x
        sta $d96c,x  
        lda lvlcl11,x
        sta $d994,x
        lda lvlcl12,x
        sta $d9bc,x

        inx
        cpx #33
        bne load_next_line
        rts

load_next_line
        jmp loader_loop

; --------------------
; Clear screen routine
; --------------------

cls     lda #0
        sta $d020      ; write to border colour register
        sta $d021      ; write to screen colour register

clsloop lda #7         ; 7 = blank space char in our custom character set
        sta $0400,x    ; fill four areas with 256 spacebar characters
        sta $0500,x 
        sta $0600,x 
        sta $06e8,x 
        lda #$0c       ; puts into the associated colour ram dark grey ($0c)...
        sta $d800,x    ; and this will become colour of the scroll text
        sta $d900,x
        sta $da00,x
        sta $dae8,x
        inx         
        bne clsloop  
        rts


lvlch1  .byte  0,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  2,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  3
lvlch2  .byte  4, 65, 66, 67,  7, 64, 65, 66, 67,  7, 64, 65, 66, 67,  7, 64,  5, 66, 67,  7, 64, 65, 66, 67,  7, 64, 65, 66, 67,  7, 64, 65,  6 
lvlch3  .byte  4, 69,  8,  9, 10, 11, 69,  8,  9, 10, 12, 13, 13, 13, 14, 68, 15, 70, 16, 13, 13, 13, 17,  9, 10, 11, 69,  8,  9, 10, 11, 69,  6     
lvlch4  .byte  4, 78, 18, 19, 20, 21, 73, 18, 19, 20, 21, 73, 74, 75,  7, 72, 73, 74, 75,  7, 72, 73, 18, 19, 20, 21, 73, 18, 19, 20, 21, 78,  6
lvlch5  .byte  4, 76, 18, 22, 23, 21, 76, 18, 22, 23, 21, 76, 24, 25, 25, 25, 25, 25, 25, 25, 26, 76, 18, 22, 23, 21, 76, 18, 22, 23, 21, 76,  6
lvlch6  .byte  4,  7, 27, 28, 28, 29,  7, 27, 28, 28, 29,  7, 27, 28, 28, 28, 30, 28, 28, 28, 29,  7, 27, 28, 28, 29,  7, 27, 28, 28, 29,  7,  6
lvlch7  .byte  4, 65, 66, 67,  7, 64, 65, 66, 67,  7, 64, 65, 66, 67,  7, 64,  5, 66, 67,  7, 64, 65, 66, 67,  7, 64, 65, 66, 67,  7, 64, 65,  6 
lvlch8  .byte  4, 69, 31, 32, 32, 33, 69, 31, 32, 34, 35, 32, 32, 32, 36,  7, 37,  7, 38, 32, 32, 32, 39, 32, 32, 40, 69, 31, 32, 32, 33, 69,  6
lvlch9  .byte  4, 73, 74, 75,  7, 72, 73, 74, 75, 41,  4,  7,  7,  7,  7,  7,  7,  7,  7,  7,  7,  7, 42, 75,  7, 72, 73, 74, 75,  7, 72, 73,  6
lvlch10 .byte 43, 25, 25, 25, 25, 25, 25, 44, 77, 41,  4,  7, 24, 25, 25, 26,  7, 24, 25, 25, 26,  7, 42, 77, 45, 25, 25, 25, 25, 25, 25, 25, 46
lvlch11 .byte 47, 48, 48, 48, 48, 48, 48, 49,  7, 41,  4,  7, 50, 28, 28, 29,  7, 27, 28, 51, 21,  7, 42,  7, 41, 52, 48, 48, 48, 48, 48, 48, 53
lvlch12 .byte 54, 55, 55, 55, 55, 55, 55, 56, 67, 57, 58,  7, 59,  7,  7,  7,  7,  7,  7, 60, 61,  7, 62, 67, 63, 55, 55, 55, 55, 55, 55, 55, 79


lvlcl1  .byte  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6
lvlcl2  .byte  6, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,  6, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,  6
lvlcl3  .byte  6, 10,  6,  6,  6,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6, 10,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6, 10,  6,  6,  6,  6, 10,  6
lvlcl4  .byte  6,  1,  6,  6,  6,  6, 10,  6,  6,  6,  6, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,  6,  6,  6,  6, 10,  6,  6,  6,  6,  1,  6
lvlcl5  .byte  6, 10,  6,  6,  6,  6, 10,  6,  6,  6,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6,  6, 10,  6,  6,  6,  6, 10,  6,  6,  6,  6, 10,  6
lvlcl6  .byte  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6
lvlcl7  .byte  6, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,  6, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,  6
lvlcl8  .byte  6, 10,  6,  6,  6,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6, 10,  6,  6,  6,  6, 10,  6
lvlcl9  .byte  6, 10, 10, 10, 10, 10, 10, 10, 10,  6,  6, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,  6, 10, 10, 10, 10, 10, 10, 10, 10, 10,  6
lvlcl10 .byte  6,  6,  6,  6,  6,  6,  6,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6,  6
lvlcl11 .byte  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6
lvlcl12 .byte  6,  6,  6,  6,  6,  6,  6,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6,  6


; load sprite data
*=sprite_data_addr	      
    .binary "resources/sprites.raw"

; load character data
*=char_data_addr
    .binary "resources/chars.raw"