bank 5

org $1B00

STA $2003
LDY #$02
STY $4014



// check for stagse 13-1 and 6-1, if anywhere else don't run this code
CLV
LDA {currstage}
CMP #$0D
BNE check_for_stage_6
LDA {currsubstage}
BEQ stage_13_code
check_for_stage_6:
LDA {currstage}
CMP #$06
BNE done
LDA {currsubstage}
BEQ stage_6_code
BVC done



stage_13_code:
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
BVC done


stage_6_code:
LDA #$22
STA {PPU_ADDR}
LDA #$39
STA {PPU_ADDR}
LDA {PPU_DATA}
LDA {PPU_DATA}
CMP #$69
BNE check_second_block


kill_simon:
LDA #$00
STA {simon_health}
BVC done


check_second_block:
LDA #$22
STA {PPU_ADDR}
LDA #$35
STA {PPU_ADDR}
LDA {PPU_DATA}
LDA {PPU_DATA}
CMP #$30
BNE setmaxhealth
BVC kill_simon

setmaxhealth:
LDA #$40
STA {simon_health}


done:
RTS
