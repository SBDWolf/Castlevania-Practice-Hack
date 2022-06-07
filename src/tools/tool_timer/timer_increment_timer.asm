// here the code has already determined that timer should be incremented.
// this code incerements the frames part of the timer, and ticks over the seconds and minutes when needed.
// it also make sure that once the timer reaches 9:59:59, the timer caps.
// this looks up lag_frame_counter to determine if and for how long the game has just lagged.
// if it has, it takes those into account for the timer.
// TODO: add stuff that displays how much the game has lagged

INC {lag_frame_counter}
LDA {lag_frame_counter}
CLC
ADC {curr_timer_f}
STA {curr_timer_f}
LDA #$00
STA {lag_frame_counter}
LDA {curr_timer_f}
CMP #60
BCC done_incrementing_timer
SEC
SBC #60
STA {curr_timer_f}
INC {curr_timer_s}
LDA {curr_timer_s}
CMP #60
BCC done_incrementing_timer
LDA #$00
STA {curr_timer_s}
INC {curr_timer_m}
LDA {curr_timer_m}
CMP #10
BCC done_incrementing_timer
// i store 0x0A into the timer flag variable
// this is just a dirty way to save an LDA #$01 which would be a more typical flag value...
// ... and would make this code a little more readable
LDA #9
STA {curr_timer_m}
LDA #59
STA {curr_timer_s}
LDA #59
STA {curr_timer_f}
done_incrementing_timer:
RTS