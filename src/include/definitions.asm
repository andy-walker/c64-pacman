; ------------------------
; Preprocessor definitions 
; ------------------------

left  = 0
right = 1
up    = 2
down  = 3

blinky = 0
pinky  = 1
inky   = 2
clyde  = 3

counter_a = 0
counter_b = 1
counter_g = 2

black  = 0
white  = 1
red    = 2
cyan   = 3
pink   = 4
blue   = 6
yellow = 7
brown  = 8
orange = 10
purple = 14

; ghost modes (excl. frightened, which is a global mode)

idle         = 0
exit         = 1
chase        = 2
scatter      = 3
dead         = 4
cruise_elroy = 5

sprite_base      = $90
sprite_data_addr = $2400
char_data_addr   = $3800
number_data_addr = $2300

score_sprite1_addr   = $2400+(52*64) 
score_sprite2_addr   = $2400+(53*64) 
score_sprite3_addr   = $2400+(62*64) 
score_sprite4_addr   = $2400+(63*64) 
hiscore_sprite1_addr = $2400+(55*64)
hiscore_sprite2_addr = $2400+(56*64)

pra              = $dc00                ; CIA#1 (Port Register A)
prb              = $dc01                ; CIA#1 (Port Register B)
ddra             = $dc02                ; CIA#1 (Data Direction Register A)
ddrb             = $dc03                ; CIA#1 (Data Direction Register B)


; -----------------------------------------
; Zero page addresses for program variables
; -----------------------------------------

num1             = $02
num2             = $03
num3             = $04
num4             = $05

directions       = $06

pacman_x_tile    = $07
ghost0_x_tile    = $08
ghost1_x_tile    = $09
ghost2_x_tile    = $0a
ghost3_x_tile    = $0b

pacman_x_sub     = $0c
ghost0_x_sub     = $0d
ghost1_x_sub     = $0e
ghost2_x_sub     = $0f
ghost3_x_sub     = $10

pacman_y_tile    = $11
ghost0_y_tile    = $12
ghost1_y_tile    = $13
ghost2_y_tile    = $14
ghost3_y_tile    = $15

pacman_y_sub     = $16
ghost0_y_sub     = $17
ghost1_y_sub     = $18
ghost2_y_sub     = $19
ghost3_y_sub     = $1a

pacman_direction = $1b
ghost0_direction = $1c
ghost1_direction = $1d
ghost2_direction = $1e
ghost3_direction = $1f

ghost0_mode      = $20
ghost1_mode      = $21
ghost2_mode      = $22
ghost3_mode      = $23

ghost_dc_1       = $24
ghost_dc_2       = $25
ghost_dc_global  = $26
ghost_dc_timer   = $27
ghost_dc_mode    = $28

lowest_sprite    = $29
highest_sprite   = $2a
irq_scanline     = $2b


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

dot_counter    = $36
pacman_speed   = $37
ghost_speed    = $38
ghost_active   = $39
level_number   = $3a
game_mode      = $3b
test_mode      = $3c
lives          = $3d
flash_counter  = $3e
flash_counter2 = $3f

; game states:

startup        = 0
attract        = 1
startscreen    = 2
intro1         = 3
intro2         = 4
gameplay       = 5
life_lost      = 6
level_complete = 7
intermission1  = 8
intermission2  = 9
intermission3  = 10
game_over      = 11

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
dbg24 = $54

; Allocate memory to keep track of 12 game sprites

; Sprite 0  - pacman
; Sprite 1  - ghost 0 body
; Sprite 2  - ghost 1 body
; Sprite 3  - ghost 2 body
; Sprite 4  - ghost 3 body
; Sprite 5  - ghost 0 eyes
; Sprite 6  - ghost 1 eyes
; Sprite 7  - ghost 2 eyes
; Sprite 8  - ghost 3 eyes
; Sprite 9  - fruit colour 1
; Sprite 10 - fruit colour 2
; Sprite 11 - fruit colour 3
; Sprite 12 - life sprite 1
; Sprite 13 - life sprite 2
; Sprite 14 - life sprite 3

sprite_data      = $60

sprite0_pointer  = $60
sprite1_pointer  = $61
sprite2_pointer  = $62
sprite3_pointer  = $63
sprite4_pointer  = $64
sprite5_pointer  = $65
sprite6_pointer  = $66
sprite7_pointer  = $67
sprite8_pointer  = $68
sprite9_pointer  = $69
sprite10_pointer = $6a
sprite11_pointer = $6b

sprite0_x  = $6c
sprite1_x  = $6d
sprite2_x  = $6e
sprite3_x  = $6f
sprite4_x  = $70
sprite5_x  = $71
sprite6_x  = $72
sprite7_x  = $73
sprite8_x  = $74
sprite9_x  = $75
sprite10_x = $76
sprite11_x = $77

sprite0_y  = $78
sprite1_y  = $79
sprite2_y  = $7a
sprite3_y  = $7b
sprite4_y  = $7c
sprite5_y  = $7d
sprite6_y  = $7e
sprite7_y  = $7f
sprite8_y  = $80
sprite9_y  = $81
sprite10_y = $82
sprite11_y = $83

sprite0_carry  = $84
sprite1_carry  = $85
sprite2_carry  = $86
sprite3_carry  = $87
sprite4_carry  = $88
sprite5_carry  = $89
sprite6_carry  = $8a
sprite7_carry  = $8b
sprite8_carry  = $8c
sprite9_carry  = $8d
sprite10_carry = $8e
sprite11_carry = $8f

sprite0_colour  = $90
sprite1_colour  = $91
sprite2_colour  = $92
sprite3_colour  = $93
sprite4_colour  = $94
sprite5_colour  = $95
sprite6_colour  = $96
sprite7_colour  = $97
sprite8_colour  = $98
sprite9_colour  = $99
sprite10_colour = $9a
sprite11_colour = $9b

sprite12_pointer = $9c
sprite13_pointer = $9d
sprite14_pointer = $9e

game_sprites_enabled1 = $9f
game_sprites_enabled2 = $a0
life_sprites_enabled  = $a1

sprite_list = $a2
sprite1 = $a3
sprite2 = $a4
sprite3 = $a5
sprite4 = $a6
sprite5 = $a7 

out_decimal   = $e0
score_charmap = $e4

matrix_offset = $ee
main_offset   = $ef

score_1       = $f0
score_2       = $f1
score_3       = $f2

hiscore_1     = $f3
hiscore_2     = $f4
hiscore_3     = $f5

dir1 = $f6      ; tmp - will be removing these
dir2 = $f7
dir3 = $f8
dir4 = $f9
dir5 = $fa



score_sprite1_ptr = $fc
score_sprite2_ptr = $fe