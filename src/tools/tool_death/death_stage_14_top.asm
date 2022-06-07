LDA {simon_y_byte}
CMP #$5A
BPL skip_14_top

LDA #$25
STA {PPU_ADDR}
LDA #$8A
STA {PPU_ADDR}
LDA {PPU_DATA}
CMP #$60

BNE skip_14_top
JMP kill_simon

skip_14_top:
JMP done
