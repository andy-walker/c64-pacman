; ----
; Data
; ----

translate0  .byte  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
translate1  .byte  0, 45, 46, 47, 49, 50, 51, 52, 54, 55, 56, 57, 59, 0, 61, 62, 64, 65, 66, 67, 69, 70, 71, 72, 74, 75, 0
translate2  .byte  0, 85, 0, 0, 0, 90, 0, 0, 0, 0, 0, 0, 99, 0, 101, 0, 0, 0, 0, 0, 0, 110, 0, 0, 0, 115, 0
translate3  .byte  0, 125, 0, 0, 0, 130, 0, 0, 0, 135, 136, 137, 139, 140, 141, 142, 144, 145, 0, 0, 0, 150, 0, 0, 0, 155, 0
translate4  .byte  0, 165, 0, 0, 0, 170, 0, 0, 0, 175, 0, 0, 0, 0, 0, 0, 0, 185, 0, 0, 0, 190, 0, 0, 0, 195, 0
translate5  .byte  0, 245, 246, 247, 249, 250, 251, 252, 254, 255, 0, 1, 3, 0, 5, 6, 8, 9, 10, 11, 13, 14, 15, 16, 18, 19, 0
translate6  .byte  0, 29, 0, 0, 0, 34, 0, 0, 0, 0, 0, 0, 2, 0, 2, 0, 0, 0, 0, 0, 0, 54, 0, 0, 0, 59, 0
translate7  .byte  0, 69, 70, 71, 73, 74, 75, 76, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 91, 93, 94, 95, 96, 98, 99, 0
translate8  .byte  0, 0, 0, 0, 0, 0, 0, 116, 0, 2, 0, 0, 0, 1, 0, 0, 0, 2, 0, 131, 0, 0, 0, 0, 0, 0, 0
translate9  .byte  0, 0, 0, 0, 0, 0, 0, 196, 0, 2, 0, 0, 0, 1, 0, 0, 0, 2, 0, 211, 0, 0, 0, 0, 0, 0, 0
translate10 .byte  0, 0, 0, 0, 0, 0, 0, 236, 0, 2, 0, 0, 0, 1, 0, 0, 0, 2, 0, 251, 0, 0, 0, 0, 0, 0, 0
translate11 .byte  0, 0, 0, 0, 0, 0, 0, 20, 0, 2, 0, 0, 0, 1, 0, 0, 0, 2, 0, 35, 0, 0, 0, 0, 0, 0, 0
translate12 .byte  0, 0, 0, 0, 0, 0, 0, 60, 0, 2, 0, 0, 0, 0, 0, 0, 0, 2, 0, 75, 0, 0, 0, 0, 0, 0, 0
translate13 .byte  0, 133, 134, 135, 137, 138, 139, 140, 142, 143, 144, 145, 147, 0, 149, 150, 152, 153, 154, 155, 157, 158, 159, 160, 162, 163, 0
translate14 .byte  0, 173, 0, 0, 0, 178, 0, 0, 0, 0, 0, 0, 187, 0, 189, 0, 0, 0, 0, 0, 0, 198, 0, 0, 0, 203, 0
translate15 .byte  0, 213, 214, 215, 0, 218, 219, 220, 222, 223, 224, 225, 227, 228, 229, 230, 232, 233, 234, 235, 237, 238, 0, 240, 242, 243, 0
translate16 .byte  0, 0, 0, 255, 0, 0, 0, 4, 0, 7, 0, 0, 0, 0, 0, 0, 0, 17, 0, 19, 0, 0, 0, 24, 0, 0, 0
translate17 .byte  0, 77, 78, 79, 81, 82, 83, 84, 0, 87, 88, 89, 91, 0, 93, 94, 96, 97, 0, 99, 101, 102, 103, 104, 106, 107, 0
translate18 .byte  0, 117, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 131, 0, 133, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 147, 0
translate19 .byte  0, 157, 158, 159, 161, 162, 163, 164, 166, 167, 168, 169, 171, 172, 173, 174, 176, 177, 178, 179, 181, 182, 183, 184, 186, 187, 0

lvlch1  .byte  0,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  2,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  3
lvlch2  .byte  4, 65, 66, 67,  7, 64, 65, 66, 67,  7, 64, 65, 66, 67,  7, 64,  5, 66, 67,  7, 64, 65, 66, 67,  7, 64, 65, 66, 67,  7, 64, 65,  6 
lvlch3  .byte  4, 69,  8,  9, 10, 11, 69,  8,  9, 10, 12, 13, 13, 13, 14, 68, 15, 70, 16, 13, 13, 13, 17,  9, 10, 11, 69,  8,  9, 10, 11, 69,  6     
lvlch4  .byte  4, 78, 18, 19, 20, 21, 73, 18, 19, 20, 21, 73, 74, 75,  7, 72, 73, 74, 75,  7, 72, 73, 18, 19, 20, 21, 73, 18, 19, 20, 21, 78,  6
lvlch5  .byte  4, 76, 18, 22, 23, 21, 76, 18, 22, 23, 21, 76, 24, 25, 25, 25, 25, 25, 25, 25, 26, 76, 18, 22, 23, 21, 76, 18, 22, 23, 21, 76,  6
lvlch6  .byte  4,  7, 27, 28, 28, 29,  7, 27, 28, 28, 29,  7, 27, 28, 28, 28, 30, 28, 28, 28, 29,  7, 27, 28, 28, 29,  7, 27, 28, 28, 29,  7,  6
lvlch7  .byte  4, 65, 66, 67,  7, 64, 65, 66, 67,  7, 64, 65, 66, 67,  7, 64,  5, 66, 67,  7, 64, 65, 66, 67,  7, 64, 65, 66, 67,  7, 64, 65,  6
lvlch8  .byte  4, 69, 31, 32, 32, 33, 69, 31, 32, 34, 35, 32, 32, 32, 36,  7, 37,  7, 38, 32, 32, 32, 39, 32, 32, 40, 69, 31, 32, 32, 33, 69,  6
lvlch9  .byte  4, 73, 74, 75,  7, 72, 73, 74, 75, 41,  4,  7,  7,  7,  7,  7,  7,  7,  7,  7,  7,  7, 42, 75,  7, 72, 73, 74, 75,  7, 72, 73,  6
lvlch10 .byte 43, 25, 25, 25, 25, 25, 25, 44, 77, 41,  4,  7, 24, 25, 25, 26,  7, 24, 25, 25, 26,  7, 42, 77, 45, 25, 25, 25, 25, 25, 25, 25, 46
lvlch11 .byte 47, 48, 48, 48, 48, 48, 48, 49,  7, 41,  4,  7, 50, 28, 28, 29,  7, 27, 28, 51, 21,  7, 42,  7, 41, 52, 48, 48, 48, 48, 48, 48, 53
lvlch12 .byte 54, 55, 55, 55, 55, 55, 55, 56, 67, 57, 58,  7, 59,  7,  7,  7,  7,  7,  7, 60, 61,  7, 62, 67, 63, 55, 55, 55, 55, 55, 55, 55, 79
lvlch13 .byte  7,  7,  7,  7,  7,  7,  7,  7, 71,  7,  7,  7, 59,  7,  7,  7,  7,  7,  7, 60, 61,  7,  7, 71,  7,  7,  7,  7,  7,  7,  7,  7,  7
lvlch14 .byte 80, 81, 81, 81, 81, 81, 81, 82, 75, 83, 84,  7, 59,  7,  7,  7,  7,  7,  7, 60, 61,  7, 85, 75, 86, 87, 81, 81, 81, 81, 81, 81, 88
lvlch15 .byte 89, 25, 25, 25, 25, 25, 25, 90, 77, 41,  4,  7, 92, 25, 25, 25, 25, 25, 25, 93, 61,  7, 42, 77, 41, 94, 25, 25, 25, 25, 25, 25, 95
lvlch16 .byte 96,  1,  1,  1,  1,  1,  1, 97,  7, 98, 29,  7, 27, 28, 28, 28, 30, 28, 28, 28, 29,  7, 99,  7, 98,  1,  1,  1,  1,  1,  1,  1,100
lvlch17 .byte  4, 65, 66, 67,  7, 64, 65, 66, 67,  7, 64, 65, 66, 67,  7, 64,  5, 66, 67,  7, 64, 65, 66, 67,  7, 64, 65, 66, 67,  7, 64, 65,  6  
lvlch18 .byte  4, 69, 31, 32, 34, 11, 69, 31, 32, 32, 32, 32, 32, 32, 36, 68, 15, 70, 16, 13, 13, 13, 13, 13, 13, 33, 69,101, 13, 13, 33, 69,  6
lvlch19 .byte  4, 78, 74, 75, 60, 21, 73, 74, 75,  7, 72, 73, 74, 75,  7, 72, 73, 74, 75,  7, 72, 73, 74, 75,  7, 72, 73, 42, 75,  7, 72, 78,  6
lvlch20 .byte 102,25, 44, 77, 60,102, 25, 44, 77,103,104, 76, 24, 25, 25, 25, 25, 25, 25, 25,104, 76,105, 77, 45, 25, 25,106, 77, 45, 25, 25,107
lvlch21 .byte  0,  1, 97,  7, 98,  1,  1, 97,  7, 41,  4,  7, 27, 28, 28, 28, 30, 28, 28, 28, 29,  7, 42,  7, 98, 28, 28, 97,  7, 98, 28, 28,  3 
lvlch22 .byte  4, 65, 66, 67,  7, 64, 65, 66, 67, 41,  4, 65, 66, 67,  7, 64,  5, 66, 67,  7, 64, 65, 42, 67,  7, 64, 65, 66, 67,  7, 64, 65,  6 
lvlch23 .byte  4, 69, 31, 32, 32, 32, 32, 32, 32,108,109, 32, 32, 32, 36, 68, 15, 70, 16, 32, 32, 32,110, 32, 32, 32, 32, 32, 32, 32, 33, 69,  6
lvlch24 .byte  4, 73, 74, 75,  7, 72, 73, 74, 75,  7, 72, 73, 74, 75,  7, 72, 73, 74, 75,  7, 72, 73, 74, 75,  7, 72, 73, 74, 75,  7, 72, 73,  6
lvlch25 .byte 102,25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25,107   

lvlcl1  .byte  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6
lvlcl2  .byte  6, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,  6, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,  6
lvlcl3  .byte  6, 10,  6,  6,  6,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6, 10,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6, 10,  6,  6,  6,  6, 10,  6
lvlcl4  .byte  6,  1,  6,  6,  6,  6, 10,  6,  6,  6,  6, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,  6,  6,  6,  6, 10,  6,  6,  6,  6,  1,  6
lvlcl5  .byte  6, 10,  6,  6,  6,  6, 10,  6,  6,  6,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6,  6, 10,  6,  6,  6,  6, 10,  6,  6,  6,  6, 10,  6
lvlcl6  .byte  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6
lvlcl7  .byte  6, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,  6, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,  6
lvlcl8  .byte  6, 10,  6,  6,  6,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6, 10,  6,  6,  6,  6, 10,  6
lvlcl9  .byte  6, 10, 10, 10, 10, 10, 10, 10, 10,  6,  6, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,  6, 10, 10, 10, 10, 10, 10, 10, 10, 10,  6
lvlcl10 .byte  6,  6,  6,  6,  6,  6,  6,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6,  6
lvlcl11 .byte  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6
lvlcl12 .byte  6,  6,  6,  6,  6,  6,  6,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6,  6
lvlcl13 .byte  6,  6,  6,  6,  6,  6,  6,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6,  6
lvlcl14 .byte  6,  6,  6,  6,  6,  6,  6,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6,  6
lvlcl15 .byte  6,  6,  6,  6,  6,  6,  6,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6,  6
lvlcl16 .byte  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6
lvlcl17 .byte  6, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,  6, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,  6
lvlcl18 .byte  6, 10,  6,  6,  6,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6, 10,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6, 10,  6,  6,  6,  6, 10,  6
lvlcl19 .byte  6,  1, 10, 10,  6,  6, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,  6, 10, 10, 10,  1,  6
lvlcl20 .byte  6,  6,  6, 10,  6,  6,  6,  6, 10,  6,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6,  6, 10,  6, 10,  6,  6,  6,  6, 10,  6,  6,  6,  6
lvlcl21 .byte  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6
lvlcl22 .byte  6, 10, 10, 10, 10, 10, 10, 10, 10,  6,  6, 10, 10, 10, 10, 10,  6, 10, 10, 10, 10, 10,  6, 10, 10, 10, 10, 10, 10, 10, 10, 10,  6
lvlcl23 .byte  6, 10,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6, 10,  6, 10,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6, 10,  6
lvlcl24 .byte  6, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,  6
lvlcl25 .byte  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6

level0  .byte  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
level1  .byte  0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0
level2  .byte  0, 3, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 3, 0, 3, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 3, 0
level3  .byte  0, 4, 0, 0, 0, 3, 0, 0, 0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0, 0, 0, 3, 0, 0, 0, 4, 0
level4  .byte  0, 3, 0, 0, 0, 3, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 3, 0, 0, 0, 3, 0
level5  .byte  0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0
level6  .byte  0, 3, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 2, 0, 2, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 3, 0
level7  .byte  0, 3, 3, 3, 3, 3, 3, 3, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 3, 3, 3, 3, 3, 3, 3, 0
level8  .byte  0, 0, 0, 0, 0, 0, 0, 3, 0, 2, 0, 0, 0, 1, 0, 0, 0, 2, 0, 3, 0, 0, 0, 0, 0, 0, 0
level9  .byte  0, 0, 0, 0, 0, 0, 0, 3, 0, 2, 0, 1, 1, 1, 1, 1, 0, 2, 0, 3, 0, 0, 0, 0, 0, 0, 0
level10 .byte  5, 5, 5, 5, 5, 5, 5, 3, 2, 2, 0, 1, 1, 1, 1, 1, 0, 2, 2, 3, 5, 5, 5, 5, 5, 5, 5
level11 .byte  0, 0, 0, 0, 0, 0, 0, 3, 0, 2, 0, 1, 1, 1, 1, 1, 0, 2, 0, 3, 0, 0, 0, 0, 0, 0, 0
level12 .byte  0, 0, 0, 0, 0, 0, 0, 3, 0, 2, 0, 0, 0, 0, 0, 0, 0, 2, 0, 3, 0, 0, 0, 0, 0, 0, 0
level13 .byte  0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0
level14 .byte  0, 3, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 3, 0, 3, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 3, 0
level15 .byte  0, 4, 3, 3, 0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0, 3, 3, 4, 0
level16 .byte  0, 0, 0, 3, 0, 0, 0, 3, 0, 3, 0, 0, 0, 0, 0, 0, 0, 3, 0, 3, 0, 0, 0, 3, 0, 0, 0
level17 .byte  0, 3, 3, 3, 3, 3, 3, 3, 0, 3, 3, 3, 3, 0, 3, 3, 3, 3, 0, 3, 3, 3, 3, 3, 3, 3, 0
level18 .byte  0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0
level19 .byte  0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0
level20 .byte  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 

attract_title .byte 113, 118, 111, 128, 111, 113, 130, 115, 128, 7, 149, 7, 124, 119, 113, 121, 124, 111, 123, 115  ; character / nickname
attract_name1 .byte 148, 129, 118, 111, 114, 125, 133, 7    ; -shadow
attract_nick1 .byte 147, 112, 122, 119, 124, 121, 135, 147  ; "blinky"
attract_name2 .byte 148, 129, 126, 115, 115, 114, 135, 7    ; -speedy
attract_nick2 .byte 147, 126, 119, 124, 121, 135, 147, 7    ; "pinky"
attract_name3 .byte 148, 112, 111, 129, 118, 116, 131, 122  ; -bashful
attract_nick3 .byte 147, 119, 124, 121, 135, 147, 7, 7      ; "inky"
attract_name4 .byte 148, 126, 125, 121, 115, 135, 7, 7      ; -pokey
attract_nick4 .byte 147, 113, 122, 135, 114, 115, 147, 7    ; "clyde"

attract_points1 .byte 153, 7, 138, 137, 7, 150, 151, 152    ; 10 pts
attract_points2 .byte 154, 7, 142, 137, 7, 150, 151, 152    ; 50 pts

; load sprite data
*=sprite_data_addr	      
    .binary "../resources/sprites.raw"

; load character data
*=char_data_addr
    .binary "../resources/chars.raw"