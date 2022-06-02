LDA {currsubstage}
CMP #$00
BNE skip_13

LDA {simon_x_high_byte}
CMP #$00
BNE skip_13

LDA {simon_x_low_byte}
CMP #$20
BPL skip_13

LDA #$21
STA {PPU_ADDR}
LDA #$B1
STA {PPU_ADDR}
LDA {PPU_DATA}
CMP #$69
BNE skip_13
JMP kill_simon


skip_13:
JMP done