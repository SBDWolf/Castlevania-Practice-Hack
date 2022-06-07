// checks current game state so that the timer only runs during gameplay

LDA {game_state}
CMP #$05
BCC misc_invalid_state
CMP #$0D
BCS misc_invalid_state
JMP is_valid_state_for_misc
misc_invalid_state:
JMP misc_done

is_valid_state_for_misc:
LDA {frame_counter_for_item_on_enemy_death}
CMP {prev_frame_counter_for_item_on_enemy_death}
BEQ print_item_slot
// frame counter % 16 on enemy death
LDA #$20
STA {PPU_ADDR}
LDA #$4C
STA {PPU_ADDR}
LDA {frame_counter_for_item_on_enemy_death}
TAY
LDA hex_digits_table, y
STA {PPU_DATA}

print_item_slot:
LDA {item_slot}
CMP {prev_item_slot}
BEQ print_simon_x
// current item slot
LDA #$20
STA {PPU_ADDR}
LDA #$4E
STA {PPU_ADDR}
LDA {item_slot}
AND #$03
TAY
LDA hex_digits_table, y
STA {PPU_DATA}

print_simon_x:
// simon x on screen
LDA #$20
STA {PPU_ADDR}
LDA #$58
STA {PPU_ADDR}
LDA {simon_x_high_byte}
AND #$0F
TAY
LDA hex_digits_table, y
STA {PPU_DATA}
LDA {simon_x_low_byte}
LSR
LSR
LSR
LSR
TAY
LDA hex_digits_table, y
STA {PPU_DATA}
LDA {simon_x_low_byte}
AND #$0F
TAY
LDA hex_digits_table, y
STA {PPU_DATA}

misc_done:
RTS

