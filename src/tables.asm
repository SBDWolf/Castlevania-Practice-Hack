org {menu_tables}

// FF = 14 simple or advanced
// Y = 0x0
db $D1,$D4,$F2,$EF,$EB // 14SPL
db $D1,$D4,$E0,$E3,$F5 // 14ADV
// FE = 14 top single or double
// Y = 0xA,
db $F3,$EF,$F2,$ED,$EB // TPSNL
db $F3,$EF,$E3,$E1,$EB // TPDBL
// FD = 17 bottom or top
// Y = 0x14
db $D1,$D7,$E1,$F3,$EC // 17BTM
db $D1,$D7,$F3,$EE,$EF // 17TOP
// Anything else
// Y = 0x1E
db $D2,$DD,$D1,$D4,$00 // 2-14
db $D4,$DD,$D1,$D2,$00 // 4-12



org {sg_tables}

// Tables for values of each scroll glitch
// in order:
// direction of sg (#$00 if leftward, #$01 if rightward)
// intial target high byte for first block
// intial target low byte for first block
// phase counter in 2-14 mode for first block
// phase counter in 4-12 mode for first block
// intial target high byte for second block
// intial target low byte for second block
// total phase counter in 2-14 mode
// total phase counter in 4-12 mode
// if there's ever a scroll glitch found that requires moving three blocks, the table could be expanded

// idea: could have an extra entry on the table detailing the amount of blocks that need to be glitched, and use that to more dynamically...
// ...calculate the target phase counters.

// stage 14 simple
db $01,$03,$28,$05,$07,$03,$28,$05,$07
// stage 14 advanced
db $01,$02,$C4,$07,$09,$03,$28,$0B,$0F
// stage 14 top single
db $00,$04,$5B,$07,$09,$04,$5B,$07,$09
// stage 14 top double
db $00,$04,$5B,$07,$09,$04,$3B,$0D,$11
// stage 13
db $01,$00,$A4,$07,$09,$00,$A4,$07,$09
// stage 06 crushers
db $00,$01,$D9,$07,$09,$01,$B9,$0D,$11
// stage 17 bottom route
db $00,$02,$19,$07,$09,$01,$FB,$0D,$11
// stage 17 top route
db $00,$02,$1B,$07,$09,$01,$FB,$0D,$11
