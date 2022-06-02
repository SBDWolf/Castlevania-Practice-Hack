LDA {simon_facing_left}
CMP #$01
BEQ skip_14_advanced

//Protection so regular 14 works even if miss 14 advanced
LDA {simon_x_low_byte}
CMP #$EB
BPL skip_14_advanced

LDA #$2D
STA {PPU_ADDR}
LDA #$B4
STA {PPU_ADDR}
LDA {PPU_DATA}

CMP #$68

BNE skip_14_advanced
JMP kill_simon

skip_14_advanced:
JMP done
