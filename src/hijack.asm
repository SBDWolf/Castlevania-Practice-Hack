bank 7

org $CC6F
// Skipping the score drawing routine to make space for my stuff
NOP
NOP
NOP

org $C088
// Overwriting: LDA #$00 | STA $2003 | LDY #$02 | STY $4014
LDA #$05
STA $8000
LDA #$00
JSR $9B00

org $E0F8
// Overwriting: JSR $DF61 | LDY $0434, x | CPY #$0B
// This is inside the function that runs on enemy death, to determine whether it should drop an item or not
// We intercept this to display some useful data on the HUD
// (This jumps to enemy_death.asm)
LDA #$05
STA $8000
JSR $B000

org $C0E6
// Overwriting: LDA $FE | LDX $1F 
// This makes the game do stuff during a lag frame
// It prepares a few memory addresses to be used when the game is done lagging
JSR $FF28
NOP



// org $CE0B
// Overwriting SCORE-, PLAYER and ENEMY text data that the game uses to draw to the HUD.
// db $00,$00,$00,$00,$00,$00
// org $CE14
// db $00,$00,$00,$00,$00
// org $CE21
// db $00,$00,$00,$00,$00,$00

bank 6
org $A192
// Skips the writing of any unnecessary text in the HUD, such as SCORE-, PLAYER, ENEMY, TIME, etc.
NOP
NOP
NOP
NOP
NOP
NOP


