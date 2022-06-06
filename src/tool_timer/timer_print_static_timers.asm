// previous room time
LDA #$20
STA {PPU_ADDR}
LDA #$81
STA {PPU_ADDR}
LDX {prev_timer_m}
LDA ones_digits_table, x
STA {PPU_DATA}


LDX {prev_timer_s}
LDA tens_digits_table, x
STA {PPU_DATA}
LDA ones_digits_table, x
STA {PPU_DATA}


LDX {prev_timer_f}
LDA tens_digits_table, x
STA {PPU_DATA}
LDA ones_digits_table, x
STA {PPU_DATA}

// level timer
LDA #$20
STA {PPU_ADDR}
LDA #$41
STA {PPU_ADDR}
LDX {level_timer_m}
LDA ones_digits_table, x
STA {PPU_DATA}


LDX {level_timer_s}
LDA tens_digits_table, x
STA {PPU_DATA}
LDA ones_digits_table, x
STA {PPU_DATA}


LDX {level_timer_f}
LDA tens_digits_table, x
STA {PPU_DATA}
LDA ones_digits_table, x
STA {PPU_DATA}
RTS