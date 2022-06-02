// Check if user is configuring death tool
// If so, included code will properly configure it.
incsrc "src/death_manage_toggles.asm"


//If tool is not enabled, we skip everything else
should_execute_stage_checks:
LDA {is_death_tool_enabled}
CMP {disable_value}
BNE start_stage_checks
JMP done


// We now check multiple times what stage we are in.
// If we are in a stage with a scroll glitch then we
// include a source file that contains all the scroll
// glitch death logic for that section.
//
// That included logic has the contract of either calling
// "kill_simon" or "done" before they exit.
// those labels are defined at the bottom of this file.

start_stage_checks:
LDA {currstage}

stage_06_check:
CMP #$06
BNE stage_13_check
incsrc "src/death_stage_06.asm"

stage_13_check:
CMP #$0D
BNE stage_14_check
incsrc "src/death_stage_13.asm"

stage_14_check:
CMP #$0E
//workaround for so much stuff in stage 14 asm
BEQ enter_stage_14_check
JMP stage_17_check
enter_stage_14_check:
incsrc "src/death_stage_14.asm"

stage_17_check:
LDA {currstage}
CMP #$11
BNE done
incsrc "src/death_stage_17.asm"

kill_simon:
LDA #$00
STA {simon_health}

done:
RTS


