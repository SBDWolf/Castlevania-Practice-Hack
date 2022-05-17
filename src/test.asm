bank 5

org $1B00

STA $2003
LDY #$02
STY $4014

// check for stage 13-1, if anywhere else don't run this code
LDA {currstage}
CMP #$0D
BNE done
LDA {currsubstage}
CMP #$00
BNE done


LDA #$21
STA {PPU_ADDR}
LDA #$B1
STA {PPU_ADDR}
LDA {PPU_DATA}
CMP #$69
BNE setmaxhealth

LDA #$00
STA {simon_health}
BVC done

setmaxhealth:
LDA #$40
STA {simon_health}

done:
RTS
