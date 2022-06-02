// The general logic here is:
// If holding select we are in special config mode
// If B is pressed for the first frame, toggle between 0 and disable_value for is_death_tool_enabled
// If A is pressed for the first frame, toggle between 0 andi disable_value for is_multi_block_enabled
// 
// Whenever select is pressed, we end all other death tool processing for this frame.
// If select is not pressed, we skip the remainder of this file and continue to death tool processing
// assuming is_death_tool_enabled == 0


//If holding select
LDA {currinput_continuous}
AND #$20
CMP #$20
BNE should_execute_stage_checks

//If just pressed b
LDA {currinput_oneframe}
AND #$40
CMP #$40

BNE check_if_a_pressed


LDA {is_death_tool_enabled}
CMP {disable_value}
BNE set_to_tool_disable_value 
LDA #$00
JMP update_tool_enable_value

set_to_tool_disable_value:
LDA {disable_value}


update_tool_enable_value:
STA {is_death_tool_enabled}
JMP skip_all_death_this_frame


check_if_a_pressed:
LDA {currinput_oneframe}
AND #$80
CMP #$80
BNE skip_all_death_this_frame


LDA {is_multi_block_enabled}
CMP {disable_value}
BNE set_to_multi_block_disable_value 
LDA #$00
JMP update_multi_block_enable_value

set_to_multi_block_disable_value:
LDA {disable_value}

update_multi_block_enable_value:
STA {is_multi_block_enabled}

skip_all_death_this_frame:
JMP done

