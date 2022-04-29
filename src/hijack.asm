bank 7

// org $CC6C
// Overwriting: LDA $7FC, y
// This makes the score counter read from my timer's addresses, instead
// LDA $7F0, y

// org $CC65
// Skipping the score drawing routine to make space for my stuff
// NOP
// NOP
// NOP
// NOP
// NOP
// NOP
// NOP
// NOP
// NOP
// NOP
// NOP
// NOP
// NOP
// NOP
// NOP
// NOP
// db $50,$D3

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




