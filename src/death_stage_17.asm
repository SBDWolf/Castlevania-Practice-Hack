LDA {currsubstage}
CMP #$01
BNE skip_17


LDA {simon_x_high_byte}
CMP #$1
BMI skip_17

//If multi_block practice disabled then skip first block
LDA {is_multi_block_enabled}
CMP {disable_value}
BEQ stage_17_block_2

stage_17_block_1:
LDA #$26
STA {PPU_ADDR}
LDA #$00
STA {PPU_ADDR}
LDA {PPU_DATA}
LDA {PPU_DATA}
CMP #$02
BNE stage_17_block_2
JMP kill_simon

stage_17_block_2:
LDA #$21
STA {PPU_ADDR}
LDA #$BC
STA {PPU_ADDR}
LDA {PPU_DATA}
LDA {PPU_DATA}
CMP #$1C
BNE skip_17
JMP kill_simon

skip_17:
JMP done