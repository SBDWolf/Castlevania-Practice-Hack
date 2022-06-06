LDA {curr_timer_f}
STA {prev_timer_f}
CLC
ADC {level_timer_f}
CMP #60
BCC move_to_seconds
INC {level_timer_s}
SEC
SBC #60
move_to_seconds:
STA {level_timer_f}

LDA {curr_timer_s}
STA {prev_timer_s}
CLC
ADC {level_timer_s}
CMP #60
BCC move_to_minutes
INC {level_timer_m}
SEC
SBC #60
move_to_minutes:
STA {level_timer_s}
LDA {curr_timer_m}
STA {prev_timer_m}
CLC
ADC {level_timer_m}
CMP #10
BCC done_transferring
LDA #$09
STA {level_timer_m}
LDA #59
STA {level_timer_s}
LDA #59
STA {level_timer_f}

done_transferring:
LDA #$00
STA {curr_timer_m}
STA {curr_timer_s}
STA {curr_timer_f}
RTS
