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
         
        sei                             ; disable interrupts
        jsr cls                         ; clear screen
        jsr main_init
        
        lda #0                          ; enable/disable test mode (unlimited lives)
        sta test_mode

        lda #attract
        sta game_mode
        jsr init_attract_mode

        ; set initial irq handler pointing to irq1

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

irq1    ; irq1 fires in all modes at the start of vblank - mode runners
        ; will complement it with a number of other handlers specific
        ; to the mode we're in (eg: attract, gameplay)

        inc $d019           ; req'd to open borders - must execute before anything else
        lda #$00
        sta $d012
        sta $d011

        ldx flash_counter
        inx
        cpx #24
        bne irq_timer1
        ldx #0
irq_timer1
        stx flash_counter   

        ldx flash_counter2
        inx
        cpx #33
        bne irq_timer2
        ldx #0
irq_timer2
        stx flash_counter2

        ; now hand control to the relevant mode runner

        lda game_mode
        cmp #gameplay
        beq mode_game
        cmp #level_complete
        beq mode_level_complete
        cmp #attract
        beq mode_attract
        cmp #startscreen
        beq mode_startscreen
        cmp #intro1
        beq mode_intro1
        cmp #intro2
        beq mode_intro2


mode_attract
        jmp irq1_attract
mode_startscreen
        jmp irq1_startscreen
mode_intro1
        jmp irq1_intro1
mode_intro2
        jmp irq1_intro2
mode_game
        jmp irq1_game
mode_level_complete
        jmp irq1_endlevel


main_init
        
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
        
        ; reset score + hi-score
        jsr reset_score
        jsr reset_hiscore

        rts



.include "runners/attract-runner.asm"
.include "runners/startscreen-runner.asm"
.include "runners/intro1-runner.asm"
.include "runners/intro2-runner.asm"
.include "runners/game-runner.asm"
.include "runners/endlevel-runner.asm"

.include "include/game.asm"
.include "include/data.asm"
.include "include/sprites.asm"
.include "include/utils.asm"

*=$4000

.include "include/attract.asm"
.include "include/start-screen.asm"
.include "include/end-level.asm"
.include "include/intro1.asm"
.include "include/intro2.asm"
.include "include/level.asm"
.include "include/display.asm"
.include "include/pacman.asm"
.include "include/ghosts.asm"
.include "include/score.asm"