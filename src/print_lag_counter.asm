// lag frame counter
LDA #$20
STA {PPU_ADDR}
LDA #$47
STA {PPU_ADDR}
LDX {total_lag_frame_counter}
LDA tens_digits_table, x
STA {PPU_DATA}
LDA ones_digits_table, x
STA {PPU_DATA}

RTS