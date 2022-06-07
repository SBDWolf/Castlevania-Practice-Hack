// NES PPU registers
define PPU_CTRL $2000
define PPU_ADDR $2006
define PPU_DATA $2007

// simon's x positioned, contained on 2 bytes
define simon_x_low_byte $40
define simon_x_high_byte $41
define simon_y_byte $3F

define simon_health $45

define item_slot $7B

// Current game state. This can be used to check when the game is on the title screen, intro screen etc...
// ...and avoid running certain code during those states.
//
// From Data Crystal:
// $00 = Start game
// $01 = Title Screen
// $02 = Demo
// $04 = Intro Animation
// $05 = Playing
// $06 = Dead
// $08 = Door Animation
// $0A = Entering Castle Animation
// $0C = Crystal ball
// $0D = Game Over
// $0F = End Credits
define game_state $18

// this is the frame counter the game uses for frame rules and item drops
// door only open shut if frame_counter % 0x10 = 0
define frame_counter $1A

// if the current frame is a lag frame = 0x1, otherwise = 0x0
define is_game_lagging $1B

define simon_facing_left $0450 //If left then 1 else 0

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

// if loading = 0xFF, else 0x01
define currently_loading $704

// new addresses used by my code
define prev_item_slot $7D3
define prev_frame_counter_for_item_on_enemy_death $7D8
define level_timer_m $7D9
define level_timer_s $7DA
define level_timer_f $7DB
define curr_timer_m $7E0
define curr_timer_s $7E1
define curr_timer_f $7E2
define prev_stage $7E3
define prev_substage $7E8
define prev_timer_m $7E9
define prev_timer_s $7EA
define prev_timer_f $7EB
define frame_counter_for_item_on_enemy_death $7F0
define already_transferred_room_time $7F1
define lag_frame_counter $7F2
define total_lag_frame_counter $7F3


//defining ram addresses that seem unused to overload for our own purposes
define is_death_tool_enabled $F0
// seems like $F1 is used by the demo
define is_multi_block_enabled $F1
define enable_value #$22 //1 out of 256 chance of this being set if ram is random on startup
define disable_value_multi_block #$22