; ------------------------
; Preprocessor definitions 
; ------------------------

left  = 0
right = 1
up    = 2
down  = 3

white = 1
red = 2
cyan = 14
pink = 4
orange = 10

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

dot_counter  = $34
pacman_speed = $35
ghost_speed  = $36
ghost_active = $37
level_number = $38
game_mode    = $39
test_mode    = $3a
lives        = $3b

startup        = 0
attract        = 1
gameplay       = 2
life_lost      = 3
level_complete = 4
intermission1  = 5
intermission2  = 6
intermission3  = 7
game_over      = 8

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


