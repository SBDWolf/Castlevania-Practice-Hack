// checks current game state so that the timer only runs during gameplay
// also checks for "stage 20" which is the value currstage takes up during map screens
// in second quest, that variable rolls back down to 0, so it won't be an issue for that
// we are still drawing the current timer values so that they show up
// TODO: make the timer handle lag frames
// TODO: also make level timer transfer upon orb grab on stage 18

LDA {currstage}
CMP #$14
BNE valid_level
JMP on_map_screen
valid_level:
LDA {game_state}
CMP #$05
BCC invalid_state
CMP #$0D
BCS invalid_state
JMP is_valid_state
invalid_state:
JMP timer_done

// i have considered making the timer not run while the game is paused.
// this would be pretty convenient to time certain things in a rough way...
// ...but since the speedrunning route includes some pauses (like on dracula, some scroll glitch setups, and some other enemy manips)...
// ...i have decided against it.
//
// we're also checking for door transition here, so that if we're in the middle of one, the timer doesn't get transferred.
// currstage increases at different timings depending on whether the door is left or right facing...
// so skipping this code during door transition acts as a workaround to make behavior consistent
//



is_valid_state:
CMP #$08
BNE not_in_door_transition
JMP go_increment_timer
not_in_door_transition:
CMP #$0C
BNE not_in_orb_grab
LDA {currstage}
BNE not_in_stage_00
JMP timer_done
not_in_stage_00:
CMP #$12
BNE not_in_stage_18
LDA {currsubstage}
CMP #$01
BNE not_in_stage_18_01
JMP stage_18_orb_grab_special_case

not_in_stage_18:
not_in_stage_18_01:
not_in_orb_grab:
LDA #$00
STA {already_transferred_room_time}
LDA {prev_stage}
CMP {currstage}
BNE changed_room
LDA {prev_substage}
CMP {currsubstage}
BNE changed_room
JMP go_increment_timer

changed_room:
JSR transfer_room_time

LDA {currstage}
STA {prev_stage}
LDA {currsubstage}
STA {prev_substage}

JSR draw_previous_room_timer


go_increment_timer:
JSR increment_timer
gp_print_lag_counter:
JSR cap_lag_counter
JSR print_lag_counter
go_draw_timer:
JSR draw_timer




timer_done:
RTS

// special case for map screen
on_map_screen:
LDA {already_transferred_room_time}
CMP #$01
BEQ go_draw_timer
LDA #$01
STA {already_transferred_room_time}
INC {prev_stage}
LDA #$00
STA {prev_substage}

JSR transfer_room_time
JSR draw_previous_room_timer
JSR cap_lag_counter
JSR print_lag_counter

LDA #$00
STA {level_timer_m}
STA {level_timer_s}
STA {level_timer_f}
STA {total_lag_frame_counter}
RTS

// this makes the timer stop and the timer transfers happen upon dracula orb grab
// i check specifically for 18-1 because for some reason game_state changes to 0x0C during the screen transition...
// ...between stages 17 and 18
stage_18_orb_grab_special_case:
LDA {already_transferred_room_time}
CMP #$01
BEQ go_draw_timer
LDA #$01
STA {already_transferred_room_time}



JSR transfer_room_time
JSR draw_timer
JSR draw_previous_room_timer
JSR cap_lag_counter
JSR print_lag_counter
LDA #$00
STA {level_timer_m}
STA {level_timer_s}
STA {level_timer_f}
STA {total_lag_frame_counter}
RTS



transfer_room_time:
incsrc "src/transfer_room_time.asm"
increment_timer:
incsrc "src/increment_timer.asm"
draw_timer:
incsrc "src/draw_timer.asm"
draw_previous_room_timer:
incsrc "src/draw_previous_room_timer.asm"
cap_lag_counter:
incsrc "src/cap_lag_counter.asm"
print_lag_counter:
incsrc "src/print_lag_counter.asm"