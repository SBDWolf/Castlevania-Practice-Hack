bank 5

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






// checks if simon is currently moving. if he is update prevx for comparison later, if not then...
// simon has just finished a movement, and we should check whether it was correct or not.
// we also need to set started_moving_flag. this will be used in a bit
LDA {simon_substate}
AND #$83
BEQ is_not_moving

LDA {simon_x_low_byte}
STA {simon_prevx_low_byte}
LDA {simon_x_high_byte}
STA {simon_prevx_high_byte}

LDA #$01
STA {started_moving_flag}
RTS

is_not_moving:
// checks if simon has started moving
// this is used so that the logic for calculating whether the scroll glitch movement was correct or not only runs...
// if simon has actually moved
LDA {started_moving_flag}
CMP #$01
BEQ has_started_moving
RTS

has_started_moving:
// simon has just finished performing a movement. calculating whether the landing pixel was good or not.
CLV
LDA {simon_prevx_high_byte}
CMP {simon_prevx_high_byte}
BNE calculate_difference_between_target_and_actual_x
LDA {simon_prevx_low_byte}
CMP {simon_prevx_low_byte}
BNE calculate_difference_between_target_and_actual_x
BVC landing_pixel_was_correct


calculate_difference_between_target_and_actual_x:
// todo: this is the case for a failure, you need to calculate the difference bla bla
LDA $01
STA {simon_health}


landing_pixel_was_correct:
// landing pixel was correct, move phase counter and check whether all the movements for a given block have been performed
// if yes, checks if there's a new block to glitch, if not, calculates a new target pixel
INC {sg_phase_counter}
LDA {sg_phase_counter}
CMP {sg_phase_count_target}
BEQ end_of_sg_on_block

// there are still movements left to glitch a block. setting new target pixel
// it needs to figure out if it's a "leftward" or "rightward" sg to calulcate the next target pixels properly
CLV
LDY {current_sg_to_practice}
LDA {sg_tables}, y
CMP #$01
BEQ rightward_sg

// this is the case for a leftward scroll glitch
// determines whether simon is supposed to move forward or backwards next
LDA {sg_phase_counter}
AND #$01
CMP #$01
BEQ set_target_pixel_forward_on_leftward_sg
BVC set_target_pixel_backward_on_leftward_sg

rightward_sg:
// this is the case for a rightward scroll glitch
// determines whether simon is supposed to move forward or backwards next
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
BVC be_done
DEC {target_pixel_high_byte}
RTS

set_target_pixel_backward_on_leftward_sg:
CLV
CLC
LDA {target_pixel_low_byte}
ADC {walk_back_count}
STA {target_pixel_low_byte}
BVC be_done
INC {target_pixel_high_byte}
RTS




set_target_pixel_forward_on_rightward_sg:
CLV
CLC
LDA {target_pixel_low_byte}
ADC {walk_forward_count}
STA {target_pixel_low_byte}
BVC be_done
INC {target_pixel_high_byte}
RTS

set_target_pixel_backward_on_rightward_sg:
CLV
SEC
LDA {target_pixel_low_byte}
SBC {walk_back_count}
STA {target_pixel_low_byte}
BVC be_done
DEC {target_pixel_high_byte}
RTS

be_done:
RTS

end_of_sg_on_block:
// the scroll glitch was successful on the first block. We load the total amount of phases for the overall scroll glitch...
// ...and compare against the amount of phases that have we've gone through so far.
// if they match, that means we're done with the scroll glitch.
// if they don't match, that means we need to move the next target pixel at the start of the next block
LDY {current_sg_to_practice}
INY
INY
INY
INY
INY
INY
INY
LDA {walk_forward_count}
// this checks for 4-12 mode and decrements Y if true, since the phase target is different on that mode.
CMP #$0C
BNE skip_this_increment
INY
skip_this_increment:


LDA {sg_tables}, y
CMP {sg_phase_count_target}
BNE move_to_next_block
JMP {sg_success_offset}

move_to_next_block:
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
RTS














org {sg_success_offset}
LDA $00
STA {simon_health}
RTS


org {done_offset}
RTS





















































