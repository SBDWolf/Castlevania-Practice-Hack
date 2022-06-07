STA $2003
LDY #$02
STY $4014

JSR death_main
JSR timer_main
JSR print_miscellaneous_information

RTS

death_main:
incsrc "src/tools/tool_death/death_main.asm"

timer_main:
incsrc "src/tools/tool_timer/timer_main.asm"

print_miscellaneous_information:
incsrc "src/tools/tool_misc_info/print_miscellaneous_information.asm"

