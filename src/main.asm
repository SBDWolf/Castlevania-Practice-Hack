arch nes.cpu
header

// TODO:
// - Implement the intial printing of information during the hijack of useless information
// - Come up with a top level menu/orchestration to enable/disable various tools...
// ...as it is, there's flickering so i might wanna allow people to disable simon's x or the real time updating timer

banksize $4000

incsrc "src/defines.asm"
incsrc "src/hijack.asm"
bank 5
org $1B00; base $9B00
incsrc "src/tools/tools_handler_main.asm"
incsrc "src/tables/digits_table_decimal.asm"
incsrc "src/tables/digits_table_hex.asm"
org $3000; base $B000
incsrc "src/setup_code/enemy_death.asm"
bank 7
org $3F28; base $FF28
incsrc "src/setup_code/increment_lag_counter.asm"

