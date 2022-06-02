LDA #$20
STA {PPU_ADDR}
LDA #$59
STA {PPU_ADDR}

LDA {is_death_tool_enabled}
CMP {enable_value}
BNE death_tool_is_disabled


LDA #$DD
STA {PPU_DATA}

LDA {is_multi_block_enabled}
CMP {disable_value_multi_block}
BEQ multi_block_is_disabled

multi_block_is_enabled:
LDA #$DD
STA {PPU_DATA}
JMP death_print_done

multi_block_is_disabled:
LDA #$00
STA {PPU_DATA}
JMP death_print_done

death_tool_is_disabled:
LDA #$00
STA {PPU_DATA}
STA {PPU_DATA}


death_print_done:
RTS