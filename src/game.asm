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
dir1             = $04
dir2             = $05
dir3             = $06
dir4             = $07
dir5             = $08
pacman_x_tile    = $09
pacman_x_sub     = $0a
pacman_y_tile    = $0b
pacman_y_sub     = $0c
pacman_direction = $0d
matrix_offset    = $0e
directions       = $0f


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

; temp storage space for general use

tmp1 = $24
tmp2 = $25
tmp3 = $26
tmp4 = $27

dbg1 = $28
dbg2 = $29
dbg3 = $2a
dbg4 = $2b

dbg5 = $2c
dbg6 = $2d
dbg7 = $2e
dbg8 = $2f

dbg9 = $30
dbg10 = $31
dbg11 = $32
dbg12 = $33

dbg13 = $34

dbg16 = $38
dbg17 = $39
dbg18 = $3a
dbg19 = $3b

dbg20 = $3c
dbg21 = $3d
dbg22 = $3e
dbg23 = $3f

dbg24 = $40
dbg25 = $41
dbg26 = $42
dbg27 = $43

dbg36 = $48
dbg37 = $49
dbg38 = $4a
dbg39 = $4b

dbg40 = $4c
dbg41 = $4d
dbg42 = $4e
dbg43 = $4f

dbg44 = $50
dbg45 = $51
dbg46 = $52
dbg47 = $53

; ------------------
; Main program start
; ------------------

*=$080d

start  
        jsr cls

        lda #0
        sta dir1
        sta dir2
        sta dir3
        sta dir4
        
        sta ghost0_x_tile
        sta ghost1_x_tile
        sta ghost2_x_tile
        sta ghost3_x_tile  

        sta ghost0_x_sub   
        sta ghost1_x_sub    
        sta ghost2_x_sub  
        sta ghost3_x_sub 

        sta ghost0_y_tile 
        sta ghost1_y_tile  
        sta ghost2_y_tile 
        sta ghost3_y_tile

        sta ghost0_y_sub
        sta ghost1_y_sub
        sta ghost2_y_sub
        sta ghost3_y_sub       

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