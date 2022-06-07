LDA {currsubstage}
CMP #$01
BNE end_14_checks

check_14_advanced:
LDA {simon_x_high_byte}
CMP #$02
BNE check_14_standard
incsrc "src/tools/tool_death/death_stage_14_advanced.asm"

check_14_standard:
CMP #$03
BNE check_14_top
incsrc "src/tools/tool_death/death_stage_14_standard.asm"


check_14_top:
CMP #$04
BNE end_14_checks
incsrc "src/tools/tool_death/death_stage_14_top.asm"

end_14_checks:
JMP done