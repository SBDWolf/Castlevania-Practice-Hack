LDA {total_lag_frame_counter}
CMP #96
BCC done_capping_lag_counter
LDA #95
STA {total_lag_frame_counter}


done_capping_lag_counter:
RTS