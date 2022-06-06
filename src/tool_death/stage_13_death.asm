LDA {currsubstage}
CMP #$00
BNE done

LDA {simon_x_high_byte}
CMP #$00
BNE done

LDA {simon_x_low_byte}
CMP #$20
BPL done


LDA #$21
STA {PPU_ADDR}
LDA #$B1
STA {PPU_ADDR}
LDA {PPU_DATA}
CMP #$69
BNE done

