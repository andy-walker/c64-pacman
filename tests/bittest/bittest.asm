value = $02
result = $06

; ------
; Loader 
; ------

*=$0801
.byte $0b, $08, $00, $00, $9e, $32, $30, $36, $31, $00, $00, $00


; ------------------
; Main program start
; ------------------

*=$080d

test1
        lda #0
        and #%00001000
        cmp #1
        bcs failed1
success1
        lda #1
        sta $02
        jmp test2
failed1
        lda #0
        sta $02

test2
        lda #%01001000
        and #%00001000
        cmp #1
        bcc failed2
success2
        lda #1
        sta $03
        jmp test3
failed2
        lda #0
        sta $03

test3
        jmp *
        
