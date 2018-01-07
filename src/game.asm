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
        
        lda #1                          ; enable test mode (unlimited lives)
        sta test_mode

        lda #attract
        sta game_mode
        jsr init_attract_mode

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

	lda $dc0d	                ; clear interrupts and ack irq
	lda $dd0d
	asl $d019
	cli

        jsr *


; -------------------------------------------------
; Routine to perform general setup / initialisation
; when beginning a new game
; -------------------------------------------------

init_game
        lda #1                          ; set level = 1
        sta level_number
        lda #2                          ; set lives = 2
        sta lives
        jsr reset_score
        rts

; -------------------------------------
; Primary irq routine
; Handles main gameplay functions
; triggered at raster 255
; -------------------------------------

irq     lda game_mode
        cmp #gameplay
        beq mode_gameplay
        cmp #life_lost
        beq mode_life_lost
        cmp #level_complete
        beq mode_level_complete
        cmp #game_over
        beq mode_game_over
        cmp #attract
        beq mode_attract

mode_gameplay
        jsr level_init_frame
        jsr move_character
        jsr move_ghosts
        jsr level_end_frame
        jmp irq_ack

mode_life_lost
        jsr level_life_lost
        jmp irq_ack

mode_level_complete
        jsr level_end
        jmp irq_ack

mode_game_over
        ; todo: handle game over

mode_attract
        jsr attract_mode_upper

irq_ack 
        lda #<irq2
	ldx #>irq2
	sta $0314
	stx $0315

	; Create interrupt at line 165 for secondary raster irq
	ldy #165
	sty $d012

        asl $d019                       ; acknowledge raster irq
        jmp $ea81


irq2
        lda game_mode
        cmp #attract
        bne irq2_ack
        jsr attract_mode_lower
irq2_ack
        lda #<irq
	ldx #>irq
	sta $0314
	stx $0315

	; Create interrupt at line 255 for primary raster irq
	ldy #255
	sty $d012
        asl $d019                       ; acknowledge raster irq
        jmp $ea81


.include "level.asm"
.include "score.asm"
.include "pacman.asm"
.include "ghosts.asm"
.include "sprites.asm"
.include "utils.asm"
.include "data.asm"

*=$4000

.include "attract.asm"