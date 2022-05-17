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




