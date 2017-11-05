; ------
; Loader 
; ------

*=$0801
.byte $0b, $08, $00, $00, $9e, $32, $30, $36, $31, $00, $00, $00

left  = 0
right = 1
up    = 2
down  = 3

sprite_data_addr = $2000
char_data_addr   = $3800

pra              = $dc00                ; CIA#1 (Port Register A)
prb              = $dc01                ; CIA#1 (Port Register B)
ddra             = $dc02                ; CIA#1 (Data Direction Register A)
ddrb             = $dc03                ; CIA#1 (Data Direction Register B)


; -----------------------------------------
; Zero page addresses for program variables
; -----------------------------------------

num1             = $02
num2             = $03
pacman_x_tile    = $04
pacman_x_sub     = $05
pacman_y_tile    = $06
pacman_y_sub     = $07
pacman_direction = $08
matrix_offset    = $09
directions       = $0a


ghost0_x_tile    = $10
ghost1_x_tile    = $11
ghost2_x_tile    = $12
ghost3_x_tile    = $13

ghost0_x_sub     = $14
ghost1_x_sub     = $15
ghost2_x_sub     = $16
ghost3_x_sub     = $17

ghost0_y_tile    = $18
ghost1_y_tile    = $19
ghost2_y_tile    = $1a
ghost3_y_tile    = $1b

ghost0_y_sub     = $1c
ghost1_y_sub     = $1d
ghost2_y_sub     = $1e
ghost3_y_sub     = $1f

ghost0_direction = $20
ghost1_direction = $21
ghost2_direction = $22
ghost3_direction = $23


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

        ; character initialisation

        lda $d018
        ora #$0e                        ; set chars location to $3800 for displaying the custom font
        sta $d018                       ; Bits 1-3 ($400+512bytes * low nibble value) of $d018 sets char location
                                        ; $400 + $200*$0E = $3800

        jsr game_init_sprites
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

        ;rts
        jsr *


irq     
        jsr move_character
        jsr move_ghosts
        asl $d019                       ; acknowledge raster irq
        jmp $ea31                       ; scan keyboard (only do once per frame)


.include "level.asm"
.include "pacman.asm"
.include "ghosts.asm"
.include "sprites.asm"
.include "utils.asm"
.include "data.asm"