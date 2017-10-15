; ------
; Loader 
; ------

*=$0801
.byte $0b, $08, $00, $00, $9e, $32, $30, $36, $31, $00, $00, $00

bgpic      = $2000
bitmap     = bgpic
video      = bgpic+$1f40
color      = bgpic+$2328
background = bgpic+$2710
spritedata = $2000

; ------------------
; Main program start
; ------------------

*=$080d

start   sei
        jsr cls
        ;jmp s_init

        ;lda #5        ; ascii control code for white letters
        ;jsr $e716     ; output to screen
        
        ; Transfer video / colour information 
        ldx #$00
loop
        ; Transfer video data
        lda video,x
        sta $0400,x
        lda video+$100,x
        sta $0500,x
        lda video+$200,x
        sta $0600,x
        lda video+$2e8,x
        sta $06e8,x
        
        ; Transfer color data
        lda color,x
        sta $d800,x
        lda color+$100,x
        sta $d900,x
        lda color+$200,x
        sta $da00,x
        lda color+$2e8,x
        sta $dae8,x
        inx
        bne loop

        lda #$3b            ; bitmap mode on
        sta $d011

        lda #$d8            ; multicolor on
        sta $d016
        
        ; ----------------------------
        ; When bitmap address is $2000
        ; Screen at $0400 
        ; Value of $d018 is $18
        ;-----------------------------

        lda #$18
        sta $d018

        ; sprite initialisation
s_init        
         lda #$01 
           sta $d015    ; Turn sprite 0 on 
           ;sta $d01c    ;multi colored sprite 
            
            lda #7 
            sta $d027    ; Make it yellow
            
            lda #$00        ;set black and white 
            sta $d025      ;multi-colors global! 
            lda #$01 
            sta $d026 


            lda #$80 
           sta $d000    ; set x coordinate to 40 
           sta $d001    ; set y coordinate to 40 
           lda #$60 
           sta $07f8    ; set pointer: sprite data at $2000    

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


        jmp *
        ; rts


irq     asl $d019      ; acknowledge raster irq
        jmp $ea31      ; scan keyboard (only do once per frame)


; --------------------
; Clear screen routine
; --------------------

cls     lda #0
        sta $d020      ; write to border colour register
        sta $d021      ; write to screen colour register

clsloop lda #$20       ; #$20 is the spacebar screencode
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




; load sprite data
;*=spritedata	      
;    .binary "resources/sprites.raw"

; load bitmap data
*=bgpic
    .binary "resources/level.kla",2