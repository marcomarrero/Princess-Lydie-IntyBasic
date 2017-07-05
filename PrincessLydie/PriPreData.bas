'=======Eyecards======= Card,CardNext
EYECARDS:
DATA SPR08,SPR08,SPR09, SPR10
DATA SPR00, SPR01, SPR02, SPR03, SPR04, SPR05, SPR06, SPR07 '1
DATA SPR00, SPR01, SPR02, SPR03, SPR04, SPR05, SPR06, SPR07	'2
DATA SPR00, SPR01, SPR02, SPR03, SPR04, SPR05, SPR06, SPR07	'3
DATA SPR00, SPR01, SPR02, SPR03, SPR04, SPR05, SPR06, SPR07	'4
DATA SPR00, SPR01, SPR02, SPR03, SPR04, SPR05, SPR06, SPR07	'5
DATA SPR00, SPR01, SPR02, SPR03, SPR04, SPR05, SPR06, SPR07	'6
DATA SPR00, SPR01, SPR02, SPR03, SPR04, SPR05, SPR06, SPR07	'7
DATA SPR00, SPR01, SPR02, SPR03, SPR04, SPR05, SPR06, SPR07	'8
DATA SPR00, SPR01, SPR02, SPR03, SPR04, SPR05, SPR06, SPR07	'9
DATA SPR00, SPR01, SPR02, SPR03, SPR04, SPR05, SPR06, SPR07	'10
DATA SPR00, SPR01, SPR02, SPR03, SPR04, SPR05, SPR06, SPR07	'11
DATA SPR00, SPR01, SPR02, SPR03, SPR04, SPR05, SPR06, SPR07	'12
DATA SPR00, SPR01, SPR02, SPR03, SPR04, SPR05, SPR06, SPR07	'13
DATA SPR00, SPR01, SPR02, SPR03, SPR04, SPR05, SPR06, SPR07	'14
DATA SPR00, SPR01, SPR02, SPR03, SPR04, SPR05, SPR06, SPR07	'15
DATA SPR00, SPR01, SPR02, SPR03, SPR04, SPR05, SPR06, SPR07	'16
DATA SPR00, SPR01, SPR02, SPR03, SPR04, SPR05, SPR06, SPR07	'17
DATA SPR00, SPR01, SPR02, SPR03, SPR04, SPR05, SPR06, SPR07	'18
DATA SPR00, SPR01, SPR02, SPR03, SPR04, SPR05, SPR06, SPR07	'19
DATA SPR00, SPR01, SPR02, SPR03, SPR04, SPR05, SPR06, SPR07	'20
DATA SPR00, SPR01, SPR02, SPR03, SPR04, SPR05, SPR06, SPR07	'21

'====EYECARDS2=====  4 + (21*8) = 172
EYECARDS2:
DATA 0, 0, 0, 0
DATA 0, 0, 0, 0, 0, SPR08, SPR09, SPR10	'1
DATA 0, 0, 0, 0, 0, SPR08, SPR09, SPR10	'2
DATA 0, 0, 0, 0, 0, SPR08, SPR09, SPR10	'3
DATA 0, 0, 0, 0, 0, SPR08, SPR09, SPR10	'4
DATA 0, 0, 0, 0, 0, SPR08, SPR09, SPR10	'5
DATA 0, 0, 0, 0, 0, SPR08, SPR09, SPR10	'6
DATA 0, 0, 0, 0, 0, SPR08, SPR09, SPR10	'7
DATA 0, 0, 0, 0, 0, SPR08, SPR09, SPR10	'8
DATA 0, 0, 0, 0, 0, SPR08, SPR09, SPR10	'9
DATA 0, 0, 0, 0, 0, SPR08, SPR09, SPR10	'10
DATA 0, 0, 0, 0, 0, SPR08, SPR09, SPR10	'11
DATA 0, 0, 0, 0, 0, SPR08, SPR09, SPR10	'12
DATA 0, 0, 0, 0, 0, SPR08, SPR09, SPR10	'13
DATA 0, 0, 0, 0, 0, SPR08, SPR09, SPR10	'14
DATA 0, 0, 0, 0, 0, SPR08, SPR09, SPR10	'15
DATA 0, 0, 0, 0, 0, SPR08, SPR09, SPR10	'16
DATA 0, 0, 0, 0, 0, SPR08, SPR09, SPR10	'17
DATA 0, 0, 0, 0, 0, SPR08, SPR09, SPR10	'18
DATA 0, 0, 0, 0, 0, SPR08, SPR09, SPR10	'19
DATA 0, 0, 0, 0, 0, 0, 0, 0 	'20
DATA 0, 0, 0, 0, 0, 0, 0, 0 	'21

'--Multiplication table *20, up to 40*20
MUL20:
DATA 0,20,40,60,80,100,120,140,160,180,200,220,240,260,280,300,320,340,360,380,400,420,440,460,480,500,520,540,560,580,600,620,640,660,680,700,720,740,760,780,800

'--sprite2card table: xcard_1=(xsprite_1 - 4)/8. from 0 to 200.
SPRITECARD:
DATA 0 ,0 ,0 ,0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1 , 1 , 1 , 1 , 1 , 1 , 1 , 1 , 2 , 2 , 2 , 2 , 2 , 2 , 2 , 2 , 3 
DATA 3 , 3 , 3 , 3 , 3 , 3 , 3 , 4 , 4 , 4 , 4 , 4 , 4 , 4 , 4 , 5 , 5 , 5 , 5 , 5 , 5 , 5 , 5 , 6 , 6 , 6 , 6 , 6 
DATA 6 , 6 , 6 , 7 , 7 , 7 , 7 , 7 , 7 , 7 , 7 , 8 , 8 , 8 , 8 , 8 , 8 , 8 , 8 , 9 , 9 , 9 , 9 , 9 , 9 , 9 , 9 , 10 
DATA 10 , 10 , 10 , 10 , 10 , 10 , 10 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 11 , 12 , 12 , 12 , 12 , 12 , 12 , 12 , 12 
DATA 13 , 13 , 13 , 13 , 13 , 13 , 13 , 13 , 14 , 14 , 14 , 14 , 14 , 14 , 14 , 14 , 15 , 15 , 15 , 15 , 15 , 15 , 15 
DATA 15 , 16 , 16 , 16 , 16 , 16 , 16 , 16 , 16 , 17 , 17 , 17 , 17 , 17 , 17 , 17 , 17 , 18 , 18 , 18 , 18 , 18 , 18 
DATA 18 , 18 , 19 , 19 , 19 , 19 , 19 , 19 , 19 , 19 , 20 , 20 , 20 , 20 , 20 , 20 , 20 , 20 , 21 , 21 , 21 , 21 , 21 
DATA 21 , 21 , 21 , 22 , 22 , 22 , 22 , 22 , 22 , 22 , 22 , 23 , 23 , 23 , 23 , 23 , 23 , 23 , 23 , 24 , 24 , 24 , 24 
DATA 24 , 24 , 24 , 24 , 25 

DIVBY8: 'is SPRITE x divisible by 8?
DATA 1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0, 0

'----fireball flips, colors. 0-3
'FireBall: DATA 0, FLIPX, FLIPY, MIRROR
'FireBall1AColor: DATA SPR_RED,SPR_ORANGE,SPR_YELLOW,SPR_ORANGE
'FireBall1BColor: DATA SPR_YELLOW,SPR_RED,SPR_ORANGE,SPR_RED
'FireBall2AColor: DATA SPR_BLUE,SPR_LIGHTBLUE,SPR_CYAN,SPR_PURPLE
'FireBall2BColor: DATA SPR_PURPLE,SPR_CYAN,SPR_LIGHTBLUE,SPR_LIGHTBLUE

'slower 0-7
FireBall: DATA 0,0, FLIPX,FLIPX,FLIPY,FLIPY,MIRROR,MIRROR
FireBall1AColor: DATA SPR_RED,SPR_RED,SPR_ORANGE,SPR_ORANGE,SPR_YELLOW,SPR_YELLOW,SPR_ORANGE,SPR_ORANGE
FireBall1BColor: DATA SPR_YELLOW,SPR_YELLOW,SPR_RED,SPR_RED,SPR_ORANGE,SPR_ORANGE,SPR_RED,SPR_RED
'FireBall2AColor: DATA SPR_BLUE,SPR_BLUE,SPR_LIGHTBLUE,SPR_LIGHTBLUE,SPR_CYAN,SPR_CYAN,SPR_PURPLE,SPR_PURPLE
'FireBall2BColor: DATA SPR_PURPLE,SPR_PURPLE,SPR_CYAN,SPR_CYAN,SPR_LIGHTBLUE,SPR_LIGHTBLUE,SPR_LIGHTBLUE,SPR_LIGHTBLUE
FireBall2AColor: DATA SPR_BLUE,SPR_BLUE,SPR_CYAN,SPR_CYAN,SPR_WHITE,SPR_WHITE,SPR_LIGHTBLUE,SPR_LIGHTBLUE
FireBall2BColor: DATA SPR_CYAN,SPR_CYAN,SPR_BLUE,SPR_BLUE,SPR_LIGHTBLUE,SPR_LIGHTBLUE,SPR_WHITE,SPR_WHITE


'=====Bit/Bitmask==================
'Bit: DATA $1,$2,$4,$8,$10,$20,$40,$80,$100,$200,$400,$800,$1000,$2000,$4000,$8000
'BitMask8: DATA $FE,$FD,$FB,$F7,$EF,$DF,$BF,$7F
'BitMask16: DATA $FFFE,$FFFD,$FFFB,$FFF7,$FFEF,$FFDF,$FFBF,$FF7F,$FEFF,$FDFF,$FBFF,$F7FF,$EFFF,$DFFF,$BFFF,$7FFF

'---color look-up table for MODE1 background color ---- GRAM/GROM bit 11 NOT set ---
FGBG_BK_Color:  '--bits 9,10,12,13 only
DATA 0,$200,$400,$600,$2000,$2200,$2400,$2600,$1000,$1200,$1400,$1600,$3000,$3200,$3400,$3600

PriPreText:
'DATA $3848,$3949,$3F00,$4000,$4100,$4200,$4300,$4400,$4400,$4747,$3848,$3949,$4000,$5D00,$3F00,$5300,0
'It's now Lydie...
DATA $3848,$3949,$3F00,$4000,$4100,$4200,$4300,$4400,$4400,$4747,$3848,$474B,$5800,$5A00,$4000,$4300,$0

MonkeyJump:
DATA SPR43,SPR43,SPR39,SPR39,SPR40
'----0 1   2      3     4     5    6    7     8

ContX:
'----controller, left/right (up/down in gamepad mode)
'----0 1 2 3 4  5 6 7 8 9 0 1 2 3 4 5 6 7 . USAGE: #x=CONTX(CONT1 AND 15)
DATA 0,1,1,0,-1,0,0,0,-1,0,0,0,0,0,0,0,0

'==========================[Princess data]==================================

'-- Princess walk
Pri_Walk: CONST PriWalkLen = 4	'2 sprites per frame, 4 frames. PRI_Walk(01,23,45,67)
'DATA SPR18+SPR_WHITE, SPR16+SPR_PINK, SPR19+SPR_WHITE, SPR32+SPR_PINK
'DATA SPR18+SPR_WHITE, SPR16+SPR_PINK, SPR20+SPR_WHITE, SPR32+SPR_PINK

'--slower... repeat 2
DATA SPR18+SPR_WHITE, SPR16+SPR_PINK, SPR18+SPR_WHITE, SPR16+SPR_PINK	'0-3
DATA SPR19+SPR_WHITE, SPR32+SPR_PINK, SPR19+SPR_WHITE, SPR32+SPR_PINK	'4-7
DATA SPR18+SPR_WHITE, SPR16+SPR_PINK, SPR18+SPR_WHITE, SPR16+SPR_PINK	'8-11
DATA SPR20+SPR_WHITE, SPR32+SPR_PINK, SPR20+SPR_WHITE, SPR32+SPR_PINK	'12-15

Snake_Color:
DATA 0,SPR_BLUE, SPR_LIGHTBLUE,SPR_DARKGREEN
DATA SPR_PURPLE,SPR_ORANGE,SPR_GREY

'==================================[Sound, NTSC,PAL interleaved]==========================
Sound_Slip:
'NTSCDATA $33,$29,$35,$27,$37,0
DATA $39,$33,$2E,$29,$3B,$35,$2C,$27,$3D,$37,0,0

Sound_Explode: 	'<--must be 2nd sound, before slip. I cut off slip when falling
'NTSCDATA $4600,$3C00,$3201,$2800,$1E01,$1401,$A00,$801,$400,$301,$200,$100,0
DATA $4E39,$4600,$430C,$3C00,$37E1,$3201,$2CB3,$2800,$2187,$1E01,$165B,$1401,$B2D,$A00,$8F2,$801,$478,$400,$35B,$301,$23C,$200,$11E,$100,0,0

Sound_Stomp:
'NTSCDATA $03C0,$03D1,$03F1,$0441,$0491,$5501,$6F01,0
DATA $431,$03C0,$444,$03D1,$468,$03F1,$4C1,$0441,$51A,$0491,$5EFD,$5501,$7C0B,$6F01,0,0

Sound_Jump:
'NTSCDATA $140,$131,$125,$105,$95,$141,$131,$124,$131,$124,$151,$130,$161,$141,0
DATA $166,$140,$155,$131,$147,$125,$124,$105,$A7,$95,$167,$141,$155,$131,$146,$124,$155,$131,$146,$124,$179,$151,$154,$130,$18A,$161,$167,$141,0,0

Sound_Die:
'NTSCDATA $0600,$0400,$0500,$0300,$0601,$0400,$0200
'NTSCDATA $0600,$0400,$0500,$0300,$0601,$0400,$0200
'DATA $0600,$0400,$0501,$0300,$0601,$0400,$0200
'DATA $0600,$0400,$0501,$0360,$0601,$0400,$0200
'DATA $0600,$0400,$0501,$0360,$0601,$0400,$0200
DATA $6B4,$0600,$478,$0400,$596,$0500,$35A,$0300,$6B6,$0601,$478,$0400,$23C,$0200
DATA $6B4,$0600,$478,$0400,$596,$0500,$35A,$0300,$6B6,$0601,$478,$0400,$23C,$0200
DATA $6B4,$0600,$478,$0400,$597,$0501,$35A,$0300,$6B6,$0601,$478,$0400,$23C,$0200
DATA $6B4,$0600,$478,$0400,$597,$0501,$3C5,$0360,$6B6,$0601,$478,$0400,$23C,$0200
DATA $6B4,$0600,$478,$0400,$597,$0501,$3C5,$0360,$6B6,$0601,$478,$0400,$23C,$0200
DATA 0,0

Sound_Kick:  '$30,$41,$51,$61,$81,$101,0
DATA $36,$30,$49,$41,$5B,$51,$6C,$61,$91,$81,$11F,$101,0,0

Sound_Kick2: 'A00,$781,$501,$281,$200,$101,$C0,$81,$40,$0
DATA $B2D,$A00,$863,$781,$597,$501,$2CC,$281,$23C,$200,$11F,$101,$D7,$C0,$90,$81,$48,$40,0,0

Sound_Kick3: '$D54,$A01,$6AA,$355,$2AA,$155,$100,$AB,$55,$0
DATA $EE5,$D54,$B2E,$A01,$772,$6AA,$3B9,$355,$2FA,$2AA,$17D,$155,$11E,$100,$BF,$AB,$5F,$55,0,0

Sound_Kick4: '$1400,$F01,$A00,$501,$400,$201,$180,$101,$81,$0
DATA $1659,$1400,$10C4,$F01,$B2D,$A00,$597,$501,$478,$400,$23D,$201,$1AD,$180,$11F,$101,$90,$81,0,0

Sound_Laugh:
DATA $166,$140,$154,$130,$142,$120,$130,$110,$7E,$71,$179,$151,$166,$140,$154,$130,$142,$120,$90,$81,$18A,$161,$177,$150
DATA $166,$140,$154,$130,$A2,$91,$19C,$171,$189,$160,$177,$150,$1AE,$181,$19B,$170,$1C0,$191,$1AD,$180,0,0
