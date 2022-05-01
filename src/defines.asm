// NES PPU registers
define PPU_CTRL $2000
define PPU_ADDR $2006
define PPU_DATA $2007

// simon's x positioned, contained on 2 bytes
define simon_x_low_byte $40
define simon_x_high_byte $41


define game_state $18


// respectively, current stage (the number in the top right of the screen, to be clear), and current substage (each stage can be made up of up 2 two screens, that value is defined by the current screen)
define currstage $28
define currsubstage $46

// 0x1 if the game is paused, 0x0 if not
define pause_flag $22

// These contain the current input on the controller. The former holds the input for one frame, the latter holds it for as long as the button is held down.
// Their values go as follows:
// 0x1 = right
// 0x2 = left
// 0x4 = down
// 0x8 = up
// 0x10 = start
// 0x20 = select
// 0x40 = B
// 0x80 = A
define currinput_oneframe $F5
define currinput_continuous $F6

// This has different bits set depending on a few things:
// 
// 0x0 = not moving
// 0z1 = moving right
// 0x2 = moving left
// 0x4 = crouching
// 0x40 = attacking
// 0x80 = jumping
// 
// These can be combined, so if simon is jumping to the right, the value contained will be 0x81

define simon_substate $584

// new addresses used by my code
define current_cursor_position $7E0
define sg_practice_active_flag $7E1
define walk_forward_count $7E2
define walk_back_count $7E3
define target_pixel_low_byte $7E8
define target_pixel_high_byte $7E9
define sg_phase_counter $7EA
define started_moving_flag $7EB
define sg_phase_count_target $7F0
define failure_pixel_count $7F1
define failed_sg_flag $7F2
define current_sg_to_practice $7F3
define already_selected_sg_from_top_menu $7DB


// defining some ROM addresses of MY OWN CODE here and using them as variables, because labels seem broken when using the jmp instruction...
define done_offset $A000
define sg_trainer_code $9E00
define mark_success $A005
define sg_success_offset $A480
define early_failure_offset $A100
define late_failure_offset $A180
define failure_amount_offset $A200
define idle_leftward $A280
define idle_rightward $A300
define mode_selection_menu $A580

// tables
define menu_tables $A380
define sg_tables $A400

// constants
define 14_simple_index #$00
define 14_advanced_index #$09
define 14_top_single_index #$12
define 14_top_double_index #$1B
define 13_sg #$24
define 06_sg #$2D
define 17_sg_bottom #$36
define 17_sg_top #$3F
define 14_simple_or_advanced #$FF
define 14_top_single_or_double #$FE
define 17_top_or_bottom #$FD

