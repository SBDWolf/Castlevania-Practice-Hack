LDA {frame_counter}
AND #$0F
STA {frame_counter_for_item_on_enemy_death}


enemy_death_done:
JSR $DF61
LDY $0434, x
CPY #$0B
RTS