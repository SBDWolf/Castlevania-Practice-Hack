
LDA {currsubstage}
CMP #$00
BNE skip_06



LDA {simon_x_high_byte}
CMP #$01
BNE skip_06

//If multi_block practice disabled then skip first block
LDA {is_multi_block_enabled}
CMP {disable_value_multi_block}
BEQ stage_06_block_2


stage_06_block_1:
LDA #$2A
STA {PPU_ADDR}
LDA #$38
STA {PPU_ADDR}
LDA {PPU_DATA}
LDA {PPU_DATA}
CMP #$68
BNE stage_06_block_2
JMP kill_simon

stage_06_block_2:
LDA #$2A
STA {PPU_ADDR}
LDA #$36
STA {PPU_ADDR}
LDA {PPU_DATA}
LDA {PPU_DATA}
CMP #$09
BNE skip_06
JMP kill_simon

skip_06:
JMP done