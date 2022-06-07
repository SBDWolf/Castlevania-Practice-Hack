// This is inside of bank 7. We have VERY, very few bytes to work with. I think About 20.
// Minimal check to avoid increasing total_lag_frame_counter during loading screens...
// ...otherwise just blindly increasing memory addresses and letting the code in bank 5 take care of the rest.
INC {lag_frame_counter}
LDA {currently_loading}
CMP #$FF
BEQ lag_done
INC {total_lag_frame_counter}
lag_done:
LDA $FE
LDX $1F
RTS
