; ------------------------
; Preprocessor definitions 
; ------------------------

left  = 0
right = 1
up    = 2
down  = 3

black  = 0
white  = 1
red    = 2
cyan   = 3
pink   = 4
yellow = 7
orange = 10
purple = 14

; ghost modes (excl. frightened, which is a global mode)

idle         = 0
exit         = 1
chase        = 2
scatter      = 3
dead         = 4
cruise_elroy = 5

sprite_base      = $a0
sprite_data_addr = $2800
char_data_addr   = $3800
number_data_addr  = $2700

score_sprite1_addr = $2800+(53*64) 
score_sprite2_addr = $2800+(54*64) 

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

ghost0_mode      = $24
ghost1_mode      = $25
ghost2_mode      = $26
ghost3_mode      = $27

score_msb1       = $28
score_msb2       = $29
score_lsb1       = $2a
score_lsb2       = $2b

main_offset      = $2c

frightened_mode  = $2d
timer_seconds    = $2e
timer_ticks      = $2f

; temp storage space for general use

tmp1 = $30
tmp2 = $31
tmp3 = $32
tmp4 = $33
tmp5 = $34
tmp6 = $35

dot_counter   = $36
pacman_speed  = $37
ghost_speed   = $38
ghost_active  = $39
level_number  = $3a
game_mode     = $3b
test_mode     = $3c
lives         = $3d
flash_counter = $3e


; game states:

startup        = 0
attract        = 1
intro1         = 2
intro2         = 3
gameplay       = 4
life_lost      = 5
level_complete = 6
intermission1  = 7
intermission2  = 8
intermission3  = 9
game_over      = 10

dbg1 = $40
dbg2 = $41
dbg3 = $42
dbg4 = $43
dbg5 = $44
dbg6 = $45

dbg11 = $46
dbg12 = $47
dbg13 = $48
dbg14 = $49
dbg15 = $4a
dbg16 = $4b

dbg20 = $50
dbg21 = $51
dbg22 = $52
dbg23 = $53

; ------------------------------
; 6 locations reserved for score
; to be rendered as a decimal
; ------------------------------

out_decimal = $5a    ; -> $5f
score_charmap = $5a


; Sprite 0 - pacman

sprite_data     = $60

sprite0_pointer = $60
sprite0_x       = $61
sprite0_y       = $62
sprite0_carry   = $63
sprite0_colour  = $64

; Sprite 1 - ghost 0 body

sprite1_pointer = $65
sprite1_x       = $66
sprite1_y       = $67
sprite1_carry   = $68
sprite1_colour  = $69

; Sprite 2 - ghost 1 body

sprite2_pointer = $6a
sprite2_x       = $6b
sprite2_y       = $6c
sprite2_carry   = $6d
sprite2_colour  = $6e

; Sprite 3 - ghost 2 body

sprite3_pointer = $6f
sprite3_x       = $70
sprite3_y       = $71
sprite3_carry   = $72
sprite3_colour  = $73

; Sprite 4 - ghost 3 body

sprite4_pointer = $74
sprite4_x       = $75
sprite4_y       = $76
sprite4_carry   = $77
sprite4_colour  = $78


; Sprite 5 - ghost 0 eyes

sprite5_pointer = $79
sprite5_x       = $7a
sprite5_y       = $7b
sprite5_carry   = $7c
sprite5_colour  = $7d

; Sprite 6 - ghost 1 eyes

sprite6_pointer = $7e
sprite6_x       = $7f
sprite6_y       = $80
sprite6_carry   = $81
sprite6_colour  = $82

; Sprite 7 - ghost 2 eyes

sprite7_pointer = $83
sprite7_x       = $84
sprite7_y       = $85
sprite7_carry   = $86
sprite7_colour  = $87

; Sprite 8 - ghost 3 eyes

sprite8_pointer = $88
sprite8_x       = $89
sprite8_y       = $8a
sprite8_carry   = $8b
sprite8_colour  = $8c


; Sprite 9 - fruit colour 1

sprite9_pointer = $8d
sprite9_x       = $8e
sprite9_y       = $8f
sprite9_carry   = $90
sprite9_colour  = $91

; Sprite 10 - fruit colour 2

sprite10_pointer = $92
sprite10_x       = $93
sprite10_y       = $94
sprite10_carry   = $95
sprite10_colour  = $96

; Sprite 11 - fruit colour 3

sprite11_pointer = $97
sprite11_x       = $98
sprite11_y       = $99
sprite11_carry   = $9a
sprite11_colour  = $9b