bank 5

org $1B00

STA $2003
LDY #$02
STY $4014


LDA {game_state}
CMP #$05
BCS no_game_over_and_credits
JMP {done_offset}
no_game_over_and_credits:
CMP #$0D
BCC check_failed_sg_flag
JMP {done_offset}

check_failed_sg_flag:
LDA {failed_sg_flag}
CMP #$00
BEQ clear_HUD_area
LDA {currinput_oneframe}
AND #$10
CMP #$10
BEQ restore_menu
JMP {done_offset}
restore_menu:
LDA #$01
STA {pause_flag}
DEC {failed_sg_flag}

clear_HUD_area:
LDA #$20
STA {PPU_ADDR}
LDA #$60
STA {PPU_ADDR}
LDA #$00
STA {PPU_DATA}
LDA #$00
STA {PPU_DATA}
LDA #$00
STA {PPU_DATA}
LDA #$00
STA {PPU_DATA}
LDA #$00
STA {PPU_DATA}
LDA #$00
STA {PPU_DATA}

LDA #$20
STA {PPU_ADDR}
LDA #$80
STA {PPU_ADDR}
LDA #$00
STA {PPU_DATA}
LDA #$00
STA {PPU_DATA}
LDA #$00
STA {PPU_DATA}
LDA #$00
STA {PPU_DATA}
LDA #$00
STA {PPU_DATA}
LDA #$00
STA {PPU_DATA}

check_sg_flag:
LDA {sg_practice_active_flag}
CMP #$01
BNE check_pause_flag
JMP {sg_trainer_code}

check_pause_flag:
LDA {pause_flag}
CMP #$01
BEQ draw_menu
LDA #$00
STA {current_cursor_position}
JMP {done_offset}



draw_menu:

LDA #$20
STA {PPU_ADDR}
LDA #$60
STA {PPU_ADDR}
LDA #$00
STA {PPU_DATA}
LDA #$D2
STA {PPU_DATA}
LDA #$DD
STA {PPU_DATA}
LDA #$D1
STA {PPU_DATA}
LDA #$D4
STA {PPU_DATA}
LDA #$00
STA {PPU_DATA}

LDA #$20
STA {PPU_ADDR}
LDA #$80
STA {PPU_ADDR}
LDA #$00
STA {PPU_DATA}
LDA #$D4
STA {PPU_DATA}
LDA #$DD
STA {PPU_DATA}
LDA #$D1
STA {PPU_DATA}
LDA #$D2
STA {PPU_DATA}

// check for select input to change menu option
LDA {currinput_oneframe}
AND #$20
CMP #$20
BNE draw_cursor
CLC
LDA {current_cursor_position}
ADC #$80
STA {current_cursor_position}

draw_cursor:
LDA {current_cursor_position}
CMP #$00
BNE draw_on_second_option
LDA #$20
STA {PPU_ADDR}
LDA #$60
STA {PPU_ADDR}
LDA #$DC
STA {PPU_DATA}
BVC skip

draw_on_second_option:
LDA #$20
STA {PPU_ADDR}
LDA #$80
STA {PPU_ADDR}
LDA #$DC
STA {PPU_DATA}

skip:
LDA {currinput_oneframe}
AND #$C0
CMP #$80
BEQ set_mode
CMP #$40
BEQ set_mode
JMP {done_offset}

set_mode:
LDA {current_cursor_position}
CMP #$00
BNE four_twelve_mode
// two fourteen mode
LDA #$0E
STA {walk_forward_count}
LDA #$02
STA {walk_back_count}
LDA #$03
STA {target_pixel_high_byte}
LDA #$28
STA {target_pixel_low_byte}

LDA #$01
STA {sg_practice_active_flag}
STA {sg_phase_counter}
LDA #$05
STA {sg_phase_count_target}

LDA #$00
STA {pause_flag}
JMP {done_offset}

four_twelve_mode:
LDA #$0C
STA {walk_forward_count}
LDA #$04
STA {walk_back_count}
LDA #$03
STA {target_pixel_high_byte}
LDA #$28
STA {target_pixel_low_byte}

LDA #$01
STA {sg_practice_active_flag}
STA {sg_phase_counter}
LDA #$07
STA {sg_phase_count_target}

LDA #$00
STA {pause_flag}
JMP {done_offset}

// check current stage somewhere, and store the corresponding scroll glitch in an area of memory.
// the momend the scroll glitch variables get initialized, check for this and use different variables depending on the value of current_sg_to_practice
// if equal to 0, go to a special case where you display that there's no sg to practice here.
// check_stage:
// LDA {currstage}
// CMP #$0E
// BNE +
// LDA {currsubstage}
// CMP #$01
// BNE +
// LDA #$01
// STA {current_sg_to_practice}
// JMP somewhere idk
// +:
// CMP #$0D
// BNE +
// LDA {currsubstage}
// CMP #$00
// BNE +
// LDA #$02
// STA {current_sg_to_practice}
// +:
// JMP somewhere idk










org {sg_trainer_code}
// draw stuff that indicates sg trainer is active
LDA #$20
STA {PPU_ADDR}
LDA #$60
STA {PPU_ADDR}
LDA #$00
STA {PPU_DATA}
LDA #$E6
STA {PPU_DATA}
LDA #$EE
STA {PPU_DATA}
LDA #$EE
STA {PPU_DATA}
LDA #$E3
STA {PPU_DATA}
LDA #$00
STA {PPU_DATA}

LDA #$20
STA {PPU_ADDR}
LDA #$80
STA {PPU_ADDR}
LDA #$00
STA {PPU_DATA}
LDA #$EB
STA {PPU_DATA}
LDA #$F4
STA {PPU_DATA}
LDA #$E2
STA {PPU_DATA}
LDA #$EA
STA {PPU_DATA}
LDA #$00
STA {PPU_DATA}

// checking if sg_phase_counter is even or odd
// if odd simon has to go right, if even simon has to go left
LDA {sg_phase_counter}
AND #$01
CMP #$01
BEQ check_rightward_motion

// checking leftward motion
LDA {simon_substate}
AND #$01
CMP #$01
BNE not_moving_right

// it might be possible to cheese the scroll glitch from the other direction, idk, maybe not
// this case is for moving right immediately after a frame where you moved left
// todo: I think I need to check the high byte first, it won't matter for 14 glitch but it will for expanding the code to other SG's
SEC
CLV
LDA {simon_x_low_byte}
SBC #$01
CMP {target_pixel_low_byte}
BCC failure_to_turning_right_too_late
BNE failure_to_turning_right_too_soon  
BVS check_against_underflown_high_byte
LDA {simon_x_high_byte}
CMP {target_pixel_high_byte}
BNE failure_to_turning_right_too_soon 
JMP {mark_success}

check_against_underflown_high_byte:
SEC
CLV
LDA {simon_x_high_byte}
SBC #$01
CMP {target_pixel_high_byte}
BNE failure_to_turning_right_too_soon 
JMP {mark_success}

failure_to_turning_right_too_late:
CLC
LDA {target_pixel_low_byte}
ADC #$01
SEC
SBC {simon_x_low_byte}
CLC
ADC #$D0
STA {failure_pixel_count}
JMP {late_failure_offset}


failure_to_turning_right_too_soon:
SEC
LDA {simon_x_low_byte}
SBC #$01
SBC {target_pixel_low_byte}
CLC
ADC #$D0
STA {failure_pixel_count}
JMP {early_failure_offset}

not_moving_right:
LDA {simon_substate}
AND #$02
CMP #$02
BEQ moving_left
JMP {idle_leftward}

moving_left:
// if moving left
LDA #$01
STA {started_moving_flag}

// EDIT: TRYING TO MAKE NO CHECKS HAPPEN HERE
// LDA {simon_x_high_byte}
// CMP {target_pixel_high_byte}
// if less, mark as failure
// BCC failure_to_holding_left_too_long
// if equal, compare low byte
// BEQ compare_low_byte2
// if stictly greater, do nothing
// NOTE: THERE MIGHT BE AN ISSUE WITH DOING NOTHING HERE
JMP {done_offset}
// compare_low_byte2:
// LDA {simon_x_low_byte}
// CMP {target_pixel_low_byte}
// >= comparison
// BCS move_to_done2


// failure_to_holding_left_too_long:
// SEC
// LDA {target_pixel_low_byte}
// SBC {simon_x_low_byte}
// CLC
// ADC #$D0
// STA {failure_pixel_count}
// JMP {late_failure_offset}

// move_to_done2:
// JMP {done_offset}




check_rightward_motion:
LDA {simon_substate}
AND #$02
CMP #$02
BNE not_moving_left
CLC
CLV
LDA {simon_x_low_byte}
ADC #$01
CMP {target_pixel_low_byte}
BCC failure_to_turning_left_too_soon
BNE failure_to_turning_left_too_late
BVS check_against_underflown_high_byte
LDA {simon_x_high_byte}
CMP {target_pixel_high_byte}
BNE failure_to_turning_left_too_soon 
JMP {mark_success}

check_against_underflown_high_byte:
CLC
CLV
LDA {simon_x_high_byte}
ADC #$01
CMP {target_pixel_high_byte}
BNE failure_to_turning_left_too_soon 
JMP {mark_success}

failure_to_turning_left_too_late:
CLC
LDA {simon_x_low_byte}
ADC #$01
SEC
SBC {target_pixel_low_byte}
CLC
ADC #$D0
STA {failure_pixel_count}
JMP {late_failure_offset}

failure_to_turning_left_too_soon:
SEC
LDA {target_pixel_low_byte}
SBC #$01
SBC {simon_x_low_byte}
CLC
ADC #$D0
STA {failure_pixel_count}
JMP {early_failure_offset}

not_moving_left:
LDA {simon_substate}
AND #$01
CMP #$01
BEQ moving_right
JMP {idle_rightward}

moving_right:
// if moving right




LDA #$01
STA {started_moving_flag}
// LDA {target_pixel_high_byte}
// CMP {simon_x_high_byte}
// if less, mark as failure
// BCC failure_to_holding_right_too_long
// if equal, compare low byte
// BEQ compare_low_byte
// if stictly greater, do nothing
JMP {done_offset}
// compare_low_byte:
// LDA {target_pixel_low_byte}
// CMP {simon_x_low_byte}
// >= comparison
// BCS move_to_done
// failure_to_holding_right_too_long:
// SEC
// LDA {simon_x_low_byte}
// SBC {target_pixel_low_byte}
// CLC
// ADC #$D0
// STA {failure_pixel_count}
// JMP {late_failure_offset}
// move_to_done:
// JMP {done_offset}

org {idle_rightward}
not_moving:
// if not currently moving, check if simon has previously started already, if he hasn't don't do anything...
// if he has, compare against target pixel and do appropriate stuff
LDA {started_moving_flag}
CMP #$01
BEQ continue
JMP {done_offset}
continue:
LDA {simon_x_low_byte}
CMP {target_pixel_low_byte}
BCC failure_to_undershooting_pixel
BNE failure_to_overshooting_pixel
LDA {simon_x_high_byte}
CMP {target_pixel_high_byte}
BCC failure_to_undershooting_pixel
BNE failure_to_overshooting_pixel
LDA #$00
STA {started_moving_flag}
JMP {mark_success}

failure_to_undershooting_pixel:
SEC
LDA {target_pixel_low_byte}
SBC {simon_x_low_byte}
CLC
ADC #$D0
STA {failure_pixel_count}
JMP {early_failure_offset}

failure_to_overshooting_pixel:
SEC
LDA {simon_x_low_byte}
SBC {target_pixel_low_byte}
CLC
ADC #$D0
STA {failure_pixel_count}
JMP {late_failure_offset}


org {idle_leftward}
not_moving:
// if not currently moving, check if simon has previously started already, if he hasn't don't do anything...
// if he has, compare against target pixel and do appropriate stuff
LDA {started_moving_flag}
CMP #$01
BEQ continue2
JMP {done_offset}
continue2:
LDA {simon_x_low_byte}
CMP {target_pixel_low_byte}
BCC failure_to_overshooting_pixel2
BNE failure_to_undershooting_pixel2
LDA {simon_x_high_byte}
CMP {target_pixel_high_byte}
BCC failure_to_overshooting_pixel2
BNE failure_to_undershooting_pixel2
LDA #$00
STA {started_moving_flag}
JMP {mark_success}

failure_to_undershooting_pixel2:
SEC
LDA {simon_x_low_byte}
SBC {target_pixel_low_byte}
CLC
ADC #$D0
STA {failure_pixel_count}
JMP {early_failure_offset}

failure_to_overshooting_pixel2:
SEC
LDA {target_pixel_low_byte}
SBC {simon_x_low_byte}
CLC
ADC #$D0
STA {failure_pixel_count}
JMP {late_failure_offset}



org {mark_success}
mark_success:
// if landing pixel is perfect
INC {sg_phase_counter}
LDA {sg_phase_counter}
CMP {sg_phase_count_target}
BNE set_new_target_pixel
// if scroll glitch was successful:
JMP {sg_success_offset}



set_new_target_pixel:
AND #$01
CMP #$01
BEQ set_target_pixel_forward
SEC
LDA {target_pixel_low_byte}
SBC {walk_back_count}
STA {target_pixel_low_byte}
BVC go_to_done
DEC {target_pixel_high_byte}
JMP {done_offset}

set_target_pixel_forward:
CLC
LDA {target_pixel_low_byte}
ADC {walk_forward_count}
STA {target_pixel_low_byte}
BVC go_to_done
INC {target_pixel_high_byte}
JMP {done_offset}

go_to_done:
JMP {done_offset}



org {sg_success_offset}
LDA #$00
STA {sg_practice_active_flag}
LDA #$20
STA {PPU_ADDR}
LDA #$40
STA {PPU_ADDR}
LDA #$EF
STA {PPU_DATA}
LDA #$E4
STA {PPU_DATA}
LDA #$F1
STA {PPU_DATA}
LDA #$E5
STA {PPU_DATA}
LDA #$E4
STA {PPU_DATA}
LDA #$E2
STA {PPU_DATA}
LDA #$F3
STA {PPU_DATA}
JMP {done_offset}


org {early_failure_offset}
LDA #$20
STA {PPU_ADDR}
LDA #$60
STA {PPU_ADDR}
LDA #$E4
STA {PPU_DATA}
LDA #$E0
STA {PPU_DATA}
LDA #$F1
STA {PPU_DATA}
LDA #$EB
STA {PPU_DATA}
LDA #$F8
STA {PPU_DATA}
JMP {failure_amount_offset}

org {late_failure_offset}
LDA #$20
STA {PPU_ADDR}
LDA #$60
STA {PPU_ADDR}
LDA #$EB
STA {PPU_DATA}
LDA #$E0
STA {PPU_DATA}
LDA #$F3
STA {PPU_DATA}
LDA #$E4
STA {PPU_DATA}
LDA #$00
STA {PPU_DATA}
JMP {failure_amount_offset}



org {failure_amount_offset}
LDA #$20
STA {PPU_ADDR}
LDA #$80
STA {PPU_ADDR}
LDA #$E1
STA {PPU_DATA}
LDA #$F8
STA {PPU_DATA}
LDA #$00
STA {PPU_DATA}
LDA {failure_pixel_count}
STA {PPU_DATA}
LDA #$E5
STA {PPU_DATA}

LDA #$00
STA {sg_practice_active_flag}
STA {started_moving_flag}
LDA #$01
STA {pause_flag}
STA {failed_sg_flag}
JMP {done_offset}






org {done_offset}
.done:
RTS







