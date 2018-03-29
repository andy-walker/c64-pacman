; ------------------------------------------------
; Routine to run at the end of the level
; handles background flash, and starting new level
; ------------------------------------------------

level_end

        lda timer_seconds
        cmp #1
        beq level_end_reset

        inc timer_ticks
        lda timer_ticks
        cmp #75
        beq flash_white
        cmp #100
        beq flash_blue
        cmp #125
        beq flash_white
        cmp #150
        beq flash_blue
        cmp #175
        beq flash_white
        cmp #200
        beq flash_blue
        cmp #225
        beq flash_white
        cmp #250
        beq flash_blue
        cmp #255
        beq flash_end
        rts

flash_white
        ldx #0
        lda #white                     
fw_loop sta $d800,x 
        sta $d900,x 
        sta $da00,x 
        sta $dae8,x 
        inx         
        bne fw_loop  
        rts

flash_blue
        ldx #0
        lda #blue              
fb_loop sta $d800,x 
        sta $d900,x 
        sta $da00,x 
        sta $dae8,x 
        inx         
        bne fb_loop  
        rts

flash_end
        lda #0
        sta timer_ticks
        lda #1
        sta timer_seconds

level_end_reset
        inc timer_ticks
        lda timer_ticks
        cmp #50
        beq ler1
        cmp #75
        beq ler2
        rts

ler1    lda #0
        sta $d015 
        jsr cls
        rts
ler2
        inc level_number
        jsr init_level
        jsr draw_level
        lda #intro2
        sta game_mode
        rts