// current room time
LDA #$20
STA {PPU_ADDR}
LDA #$61
STA {PPU_ADDR}
LDX {curr_timer_m}
LDA ones_digits_table, x
STA {PPU_DATA}


LDX {curr_timer_s}
LDA tens_digits_table, x
STA {PPU_DATA}
LDA ones_digits_table, x
STA {PPU_DATA}


LDX {curr_timer_f}
LDA tens_digits_table, x
STA {PPU_DATA}
LDA ones_digits_table, x
STA {PPU_DATA}

RTS