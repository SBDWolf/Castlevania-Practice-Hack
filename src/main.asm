arch nes.cpu
header

banksize $4000

incsrc "src/defines.asm"
incsrc "src/hijack.asm"
bank 5
org $1B00; base $9B00
incsrc "src/tools_handler_main.asm"
incsrc "src/digits_table_for_timer.asm"
incsrc "src/digits_table_hex.asm"
org $3000; base $B000
incsrc "src/enemy_death.asm"
bank 7
org $3F28; base $FF28
incsrc "src/increment_lag_counter.asm"

