//You walk over this area from other direction - this prevents immediate death
LDA {simon_facing_left}
CMP #$01
BEQ skip_14_standard

//This prevents death when you turn right walking on stairs
LDA {simon_y_byte}
CMP #$A0
BMI skip_14_standard


LDA #$2A
STA {PPU_ADDR}
LDA #$A1
STA {PPU_ADDR}
LDA {PPU_DATA}

CMP #$69

BNE skip_14_standard
JMP kill_simon

skip_14_standard:
JMP done
