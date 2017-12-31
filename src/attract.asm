; ------------------------------
; Attract mode
; Handles title screen animation 
; ------------------------------

init_attract_mode

        jsr cls                         ; clear screen
        lda #0                          ; reset timer
        sta timer_ticks
        sta timer_seconds

        jsr am_stage1
        jsr am_stage3
        jsr am_stage4
        jsr am_stage6
        jsr am_stage7
        jsr am_stage9
        jsr am_stage10
        jsr am_stage12
        jsr am_stage13
        
        lda #$ff                        ; temporary - enable all sprites
        sta $d015

        lda #0
        sta $d010                       ; unset all carry bits

        lda #sprite_base+23             ; set odd numbered sprites to ghost sprite
        sta $07f8
        sta $07fa
        sta $07fc
        sta $07fe

        lda #sprite_base+26             ; set even numbered sprites to eyes-right sprite
        sta $07f9
        sta $07fb
        sta $07fd
        sta $07ff

        lda #82
        sta $d000
        sta $d002
        sta $d004
        sta $d006
        sta $d008
        sta $d00a
        sta $d00c
        sta $d00e

        lda #78
        sta $d001
        sta $d003

        lda #102
        sta $d005
        sta $d007

        lda #126
        sta $d009
        sta $d00b

        lda #150
        sta $d00d
        sta $d00f

        ; set sprite colours

        lda #red
        sta $d027                     
        lda #pink 
        sta $d029                     
        lda #cyan
        sta $d02b                      
        lda #orange
        sta $d02d
        lda #white
        sta $d028   
        sta $d02a
        sta $d02c
        sta $d02e

        rts

attract_mode
        rts


am_stage1
        ldx #0
ams1_start
        lda attract_title,x
        sta $045b,x
        lda #white
        sta $d85b,x
        inx
        cpx #20
        bne ams1_start
        rts

am_stage3
        ldx #0
ams3_start
        lda attract_name1,x
        sta $04ab,x
        lda #red
        sta $d8ab,x
        inx
        cpx #8
        bne ams3_start
        rts

am_stage4
        ldx #0
ams4_start
        lda attract_nick1,x
        sta $04b6,x
        lda #red
        sta $d8b6,x
        inx
        cpx #8
        bne ams4_start
        rts



am_stage6
        ldx #0
ams6_start
        lda attract_name2,x
        sta $0523,x
        lda #pink
        sta $d923,x
        inx
        cpx #8
        bne ams6_start
        rts

am_stage7
        ldx #0
ams7_start
        lda attract_nick2,x
        sta $052e,x
        lda #pink
        sta $d92e,x
        inx
        cpx #8
        bne ams7_start
        rts



am_stage9
        ldx #0
ams9_start
        lda attract_name3,x
        sta $059b,x  
        lda #cyan
        sta $d99b,x
        inx
        cpx #8
        bne ams9_start
        rts

am_stage10
        ldx #0
ams10_start
        lda attract_nick3,x
        sta $05a6,x  
        lda #cyan
        sta $d9a6,x
        inx
        cpx #8
        bne ams10_start
        rts


am_stage12
        ldx #0
ams12_start
        lda attract_name4,x
        sta $0613,x 
        lda #orange
        sta $da13,x
        inx
        cpx #8
        bne ams12_start
        rts

am_stage13
        ldx #0
ams13_start
        lda attract_nick4,x
        sta $061e,x  
        lda #orange
        sta $da1e,x
        inx
        cpx #8
        bne ams13_start
        rts