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











