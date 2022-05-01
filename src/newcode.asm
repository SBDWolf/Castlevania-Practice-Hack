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
BEQ check_stage
LDA #$00
STA {current_cursor_position}
STA {already_selected_sg_from_top_menu}
JMP {done_offset}

// check current stage, and store the corresponding scroll glitch in an area of memory.
// the moment the scroll glitch variables get initialized, check for this and use different variables depending on the value of current_sg_to_practice
// if equal to 0, go to a special case where you display that there's no sg to practice here.
check_stage:
CLV
// if already loaded the scroll glitch to practice from the top menu, skip this check, otherwise, load a value corresponding to a top menu
LDA {already_selected_sg_from_top_menu}
CMP #$01
BEQ check_menu_to_draw


LDA {currstage}
CMP #$0E
BNE check_for_stage_13
LDA {currsubstage}
CMP #$01
BNE check_for_stage_13
LDA {simon_x_high_byte}
CMP #$04
BCS top_floor_drop
// This value will indicate that there's multiple options for stage 14, advanced or simple
LDA {14_simple_or_advanced}
STA {current_sg_to_practice}
BVC check_menu_to_draw

top_floor_drop:
// This value will indicate that there's multiple options for stage 14, top single or top multiple
LDA {14_top_single_or_double}
STA {current_sg_to_practice}
BVC check_menu_to_draw
check_for_stage_13:
LDA {currstage}
CMP #$0D
BNE check_for_stage_06
LDA {currsubstage}
CMP #$00
BNE check_for_stage_06
LDA {13_sg}
STA {current_sg_to_practice}
BVC check_menu_to_draw
check_for_stage_06:
LDA {currstage}
CMP #$06
BNE check_for_stage_17
LDA {currsubstage}
CMP #$00
BNE check_for_stage_17
LDA {06_sg}
STA {current_sg_to_practice}
BVC check_menu_to_draw
check_for_stage_17:
LDA {currstage}
CMP #$11
BNE no_sg
LDA {currsubstage}
CMP #$01
BNE no_sg
LDA {17_top_or_bottom}
STA {current_sg_to_practice}
BVC check_menu_to_draw

no_sg:










check_menu_to_draw:

LDA {current_sg_to_practice}
CMP {14_top_single_or_double}
BCC anything_else_or_17_sg
BEQ set_14_top_single_or_double_menu

// 14_simple_or_advanced

LDY #$00
BVC draw_menu

set_14_top_single_or_double_menu:

// 14_top_single_or_double

LDY #$0A
BVC draw_menu

anything_else_or_17_sg:
CMP {17_top_or_bottom}
BCC set_anything_else

// 17_top_or_bottom
LDY #$14
BVC draw_menu


set_anything_else:

// Anything else
LDY #$1E

draw_menu:
LDA #$20
STA {PPU_ADDR}
LDA #$61
STA {PPU_ADDR}
LDA {menu_tables}, y
STA {PPU_DATA}
INY
LDA {menu_tables}, y
STA {PPU_DATA}
INY
LDA {menu_tables}, y
STA {PPU_DATA}
INY
LDA {menu_tables}, y
STA {PPU_DATA}
INY
LDA {menu_tables}, y
STA {PPU_DATA}
INY

LDA #$20
STA {PPU_ADDR}
LDA #$81
STA {PPU_ADDR}
LDA {menu_tables}, y
STA {PPU_DATA}
INY
LDA {menu_tables}, y
STA {PPU_DATA}
INY
LDA {menu_tables}, y
STA {PPU_DATA}
INY
LDA {menu_tables}, y
STA {PPU_DATA}
INY
LDA {menu_tables}, y
STA {PPU_DATA}
INY

check_cursor:
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
LDA {current_sg_to_practice}
CMP #$F0
BCS not_on_mode_selection_menu
JMP {mode_selection_menu}
not_on_mode_selection_menu:
LDA {currinput_oneframe}
AND #$C0
CMP #$80
BEQ set_scroll_glitch
CMP #$40
BEQ set_scroll_glitch
CMP #$C0
BEQ set_scroll_glitch
JMP {done_offset}

set_scroll_glitch:
LDA {current_cursor_position}
CMP #$00
BNE set_second_option

// Setting first option
// LDA #$00
// STA {current_cursor_position}
LDA {current_sg_to_practice}
CMP {14_simple_or_advanced}
BNE check_for_17_bottom_or_14_snl

// setting 14_simple option (top option)
LDA {14_simple_index}
STA {current_sg_to_practice}
LDA #$01
STA {already_selected_sg_from_top_menu}
JMP {done_offset}

check_for_17_bottom_or_14_snl:
CMP {14_top_single_or_double}
BNE set_17_btm

// setting 14 top single (top option)
LDA {14_top_single_index}
STA {current_sg_to_practice}
LDA #$01
STA {already_selected_sg_from_top_menu}
JMP {done_offset}

set_17_btm:
LDA {17_sg_bottom}
STA {current_sg_to_practice}
LDA #$01
STA {already_selected_sg_from_top_menu}
JMP {done_offset}


set_second_option:
LDA #$00
STA {current_cursor_position}
LDA {current_sg_to_practice}
CMP {14_simple_or_advanced}
BNE check_for_17_top_or_14_dbl

// setting 14_advanced option (bottom option)
LDA {14_advanced_index}
STA {current_sg_to_practice}
LDA #$01
STA {already_selected_sg_from_top_menu}
JMP {done_offset}

check_for_17_top_or_14_dbl:
CMP {14_top_single_or_double}
BNE set_17_top

// setting 14 top double (bottom option)
LDA {14_top_double_index}
STA {current_sg_to_practice}
LDA #$01
STA {already_selected_sg_from_top_menu}
JMP {done_offset}

set_17_top:
LDA {17_sg_top}
STA {current_sg_to_practice}
LDA #$01
STA {already_selected_sg_from_top_menu}
JMP {done_offset}









org {mode_selection_menu}
on_mode_selection_menu:
LDA {currinput_oneframe}
AND #$C0
CMP #$80
BEQ set_mode
CMP #$40
BEQ set_mode
CMP #$C0
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
LDY {current_sg_to_practice}
INY
LDA {sg_tables},y
STA {target_pixel_high_byte}
INY
LDA {sg_tables},y
STA {target_pixel_low_byte}
INY
LDA {sg_tables},y
STA {sg_phase_count_target}

LDA #$01
STA {sg_practice_active_flag}
STA {sg_phase_counter}

LDA #$00
STA {pause_flag}
JMP {done_offset}

four_twelve_mode:
LDA #$0C
STA {walk_forward_count}
LDA #$04
STA {walk_back_count}
LDY {current_sg_to_practice}
INY
LDA {sg_tables},y
STA {target_pixel_high_byte}
INY
LDA {sg_tables},y
STA {target_pixel_low_byte}
INY
INY
LDA {sg_tables},y
STA {sg_phase_count_target}

LDA #$01
STA {sg_practice_active_flag}
STA {sg_phase_counter}

LDA #$00
STA {pause_flag}
JMP {done_offset}









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
CLV
LDY {current_sg_to_practice}
LDA {sg_tables}, y
CMP #$01
BEQ rightward_sg

// leftward sg
LDA {sg_phase_counter}
AND #$01
CMP #$01
BEQ check_leftward_motion
BVC check_rightward_motion

rightward_sg:
LDA {sg_phase_counter}
AND #$01
CMP #$01
BEQ check_rightward_motion
BVC check_leftward_motion

// checking leftward motion
check_leftward_motion:
LDA {simon_substate}
AND #$01
CMP #$01
BNE not_moving_right

// it might be possible to cheese the scroll glitch from the other direction, idk, maybe not
// this case is for moving right immediately after a frame where you moved left
// todo: I think I need to check the high byte first, it won't matter for 14 glitch but it will for expanding the code to other SG's
// actually, maybe not
// actually, yes

LDA {simon_x_high_byte}
CMP {target_pixel_high_byte}
BCC failure_to_turning_right_too_late

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


LDA {target_pixel_high_byte}
CMP {simon_x_high_byte}
BCC failure_to_turning_right_too_late

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
LDA {simon_x_high_byte}
CMP {target_pixel_high_byte}
BCC failure_to_undershooting_pixel
BNE failure_to_overshooting_pixel
LDA {simon_x_low_byte}
CMP {target_pixel_low_byte}
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
LDA {simon_x_high_byte}
CMP {target_pixel_high_byte}
BCC failure_to_overshooting_pixel2
BNE failure_to_undershooting_pixel2
LDA {simon_x_low_byte}
CMP {target_pixel_low_byte}
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
BEQ end_of_sg_on_block

// set new target pixel
CLV
LDY {current_sg_to_practice}
LDA {sg_tables}, y
CMP #$01
BEQ rightward_sg2

// leftward sg2
LDA {sg_phase_counter}
AND #$01
CMP #$01
BEQ set_target_pixel_forward_on_leftward_sg
BVC set_target_pixel_backward_on_leftward_sg

rightward_sg2:
LDA {sg_phase_counter}
AND #$01
CMP #$01
BEQ set_target_pixel_forward_on_rightward_sg
BVC set_target_pixel_backward_on_rightward_sg


set_target_pixel_forward_on_leftward_sg:
CLV
SEC
LDA {target_pixel_low_byte}
SBC {walk_forward_count}
STA {target_pixel_low_byte}
BVC go_to_done
DEC {target_pixel_high_byte}
JMP {done_offset}

set_target_pixel_backward_on_leftward_sg:
CLV
CLC
LDA {target_pixel_low_byte}
ADC {walk_back_count}
STA {target_pixel_low_byte}
BVC go_to_done
INC {target_pixel_high_byte}
JMP {done_offset}




set_target_pixel_forward_on_rightward_sg:
CLV
CLC
LDA {target_pixel_low_byte}
ADC {walk_forward_count}
STA {target_pixel_low_byte}
BVC go_to_done
INC {target_pixel_high_byte}
JMP {done_offset}

set_target_pixel_backward_on_rightward_sg:
CLV
SEC
LDA {target_pixel_low_byte}
SBC {walk_back_count}
STA {target_pixel_low_byte}
BVC go_to_done
DEC {target_pixel_high_byte}
JMP {done_offset}






go_to_done:
JMP {done_offset}

end_of_sg_on_block:
// if sg glitch was successful on the first target block:
LDY {current_sg_to_practice}
INY
INY
INY
INY
INY
INY
INY
LDA {walk_forward_count}
CMP #$0E
BEQ skip_this_increment
INY
skip_this_increment:
LDA {sg_tables}, y
CMP {sg_phase_count_target}
BNE move_to_next_block
JMP {sg_success_offset}

move_to_next_block:
// LDA {sg_tables}, y
STA {sg_phase_count_target}

LDY {current_sg_to_practice}
INY
INY
INY
INY
INY


LDA {sg_tables}, y
STA {target_pixel_high_byte}
INY
LDA {sg_tables}, y
STA {target_pixel_low_byte}
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
CMP #$DA
BCC draw_number_as_is
LDA #$DD
draw_number_as_is:
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



org {menu_tables}

// FF = 14 simple or advanced
// Y = 0x0
db $D1,$D4,$F2,$EF,$EB // 14SPL
db $D1,$D4,$E0,$E3,$F5 // 14ADV
// FE = 14 top single or double
// Y = 0xA,
db $F3,$EF,$F2,$ED,$EB // TPSNL
db $F3,$EF,$E3,$E1,$EB // TPDBL
// FD = 17 bottom or top
// Y = 0x14
db $D1,$D7,$E1,$F3,$EC // 17BTM
db $D1,$D7,$F3,$EE,$EF // 17TOP
// Anything else
// Y = 0x1E
db $D2,$DD,$D1,$D4,$00 // 2-14
db $D4,$DD,$D1,$D2,$00 // 4-12



org {sg_tables}

// Tables for values of each scroll glitch
// in order:
// direction of sg (#$00 if leftward, #$01 if rightward)
// intial traget high byte for first block
// intial traget low byte for first block
// phase counter in 2-14 mode for first block
// phase counter in 4-12 mode for first block
// intial traget high byte for second block
// intial traget low byte for second block
// total phase counter in 2-14 mode
// total phase counter in 4-12 mode
// if there's ever a scroll glitch found that requires moving three blocks, the table could be expanded

// stage 14 simple
db $01,$03,$28,$05,$07,$03,$28,$05,$07
// stage 14 advanced
db $01,$02,$C4,$07,$09,$03,$28,$0B,$0F
// stage 14 top single
db $00,$04,$5B,$07,$09,$04,$5B,$07,$09
// stage 14 top double
db $00,$04,$5B,$07,$09,$04,$3B,$0D,$11
// stage 13
db $01,$00,$A4,$07,$09,$00,$A4,$07,$09
// stage 06 crushers
db $00,$01,$D9,$07,$09,$01,$B9,$0D,$11
// stage 17 bottom route
db $00,$02,$19,$07,$09,$01,$FB,$0D,$11
// stage 17 top route
db $00,$02,$1B,$07,$09,$01,$FB,$0D,$11


