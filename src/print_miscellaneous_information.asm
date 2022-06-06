// checks current game state so that the timer only runs during gameplay
LDA {game_state}
CMP #$05
BEQ is_valid_state_for_misc
CMP #$06
BEQ is_valid_state_for_misc
CMP #$08
BEQ is_valid_state_for_misc
CMP #$0A
BEQ is_valid_state_for_misc
CMP #$0C
BEQ is_valid_state_for_misc
JMP misc_done

is_valid_state_for_misc:
// frame counter % 16 on enemy death
LDA #$20
STA {PPU_ADDR}
LDA #$4C
STA {PPU_ADDR}
LDA {frame_counter_for_item_on_enemy_death}
TAY
LDA hex_digits_table, y
STA {PPU_DATA}

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



misc_done:
RTS