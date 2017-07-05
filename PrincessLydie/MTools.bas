'Various generic subroutines, all vars
'Common Variables, obliterated by most functions: 
'tx,ty,ti,tj,tk,tl,#tc,#ta,#ts,#tm
'----------------------------------------------------------------
'(c)2017 Marco A. Marrero
'----------------------------------------------------------------

DIM tx,ty,ti,tj,tk,tl
DIM #ta,#tb,#tc,#ts,#tm,#ty
DIM #P1x,#P1y
DIM Frame0,Frame1,Frame4,Frame8		'-- extra counters

'---Player1
DIM #xpad_0,#xdir_0,#ydir_0, xaccel_0
DIM #anim_0,#anim_1,#anim_2, #tx
DIM pri_anim
DIM xpos_0,#ypos_0
DIM #s, ContYClear
DIM state_fall0, state_jump0, state_die0, state_stomp, state_kick
DIM state_scrollx,state_scrolly
DIM total_enemies

'---Fireball
DIM fire1_x,fire1_y, #fire1_xd, #fire1_yd, fire1_sprA, fire2_sprB
DIM fire2_x,fire2_y, #fire2_xd, #fire2_yd, fire2_sprA, fire1_sprB

'-- Princess sprites
CONST PRI_SKIN = SPR_WHITE 'SPR_WHITE, SPR_TAN
CONST PRI_DRESS1= SPR16+SPR_PINK:CONST PRI_DRESS2= SPR32+SPR_PINK 
CONST PRI_STAND = SPR18+PRI_SKIN:CONST PRI_SLIDE = SPR25+PRI_SKIN:CONST PRI_HI = SPR22+PRI_SKIN
CONST PRI_JUMP= SPR21+PRI_SKIN: CONST PRI_FALL =SPR24+PRI_SKIN 'PRI_Walk(01,23,45,67)
CONST PRI_KICK = SPR26+PRI_SKIN: CONST PRI_BUTTKICK = SPR28+PRI_SKIN

'--- Collision bits---
CONST COLLIDE_ENEMY_1 = 2:CONST COLLIDE_ENEMY_2 = 4:CONST COLLIDE_ENEMY_3 = 8
CONST COLLIDE_ENEMY_4 = 16:CONST COLLIDE_ENEMY_5 = 32:CONST COLLIDE_ENEMY_6 = 64
CONST SCROLL_X = $30:CONST SCROLL_Y = $31

'----Min/MAX
CONST SPRITEMAXX=168
CONST SPRITEMAXY=95:CONST DISABLED=127
CONST BAD_MINX=18: CONST BAD_MAXX=SPRITEMAXX-18
					
'--Game objects--- 6 sprites--- (0 and 7 are player)
DIM xpos_1,xpos_2,xpos_3,xpos_4,xpos_5,xpos_6
DIM ypos_1,ypos_2,ypos_3,ypos_4,ypos_5,ypos_6

DIM #xdir_1,#xdir_2,#xdir_3,#xdir_4,#xdir_5,#xdir_6

DIM BadType_1,BadType_2,BadType_3,BadType_4,BadType_5,BadType_6,BadType_7

DIM xcard_0,xcard_1,xcard_2,xcard_3,xcard_4,xcard_5,xcard_6
DIM ycard_0,ycard_1,ycard_2,ycard_3,ycard_4,ycard_5,ycard_6

DIM backtabpos_0,backtabpos_1,backtabpos_2,backtabpos_3,backtabpos_4,backtabpos_5,backtabpos_6
DIM backtabpre_1,backtabpre_2,backtabpre_3,backtabpre_4,backtabpre_5,backtabpre_6

DIM state_moved_1,state_moved_2,state_moved_3,state_moved_4,state_moved_5,state_moved_6
DIM state_eye_erase_1,state_eye_erase_2,state_eye_erase_3,state_eye_erase_4,state_eye_erase_5,state_eye_erase_6
DIM state_2ndcard_1,state_2ndcard_2,state_2ndcard_3,state_2ndcard_4,state_2ndcard_5,state_2ndcard_6

DIM statusOK_1,statusOK_2,statusOK_3,statusOK_4,statusOK_5,statusOK_6
DIM statusTurn_1,statusTurn_2,statusTurn_3,statusTurn_4,statusTurn_5,statusTurn_6
DIM statusDown_1,statusDown_2,statusDown_3,statusDown_4,statusDown_5,statusDown_6
DIM statusHit_1,statusHit_2,statusHit_3,statusHit_4,statusHit_5,statusHit_6
DIM statusWait_1,statusWait_2,statusWait_3,statusWait_4,statusWait_5,statusWait_6
DIM statusDie_1,statusDie_2,statusDie_3,statusDie_4,statusDie_5,statusDie_6
DIM statusFreeze_1,statusFreeze_2,statusFreeze_3,statusFreeze_4,statusFreeze_5,statusFreeze_6
DIM statusEtc_1,statusEtc_2,statusEtc_3,statusEtc_4,statusEtc_5,statusEtc_6

DIM #pcolor_0,#pcolor_1,#pcolor_2,#pcolor_3,#pcolor_4,#pcolor_5,#pcolor_6,#pcolor_7

'-----timer
DIM PALcount, Timer, OldTimer

'---reused---
'DIM tiles(9) '--> tiles surrounding the player, for background interaction

'Process Pad, gamepad horizontal/vertical. Gamepad mode: 0 normal, 1=sideways (like NES)
'Variables used: GamePad1,GamePad2,#P1x,#P1y,#,P2y
'DIM GamePad1,GamePad2
'DEF FN VDISK1=IF GamePad1 THEN	#P1x=-CONT1.DOWN+CONT1.UP:#P1y=-CONT1.LEFT+CONT1.RIGHT ELSE #P1x=-CONT1.LEFT+CONT1.RIGHT:#P1y=-CONT1.UP+CONT1.DOWN
'DEF FN VDISK2=IF GamePad2 THEN	#P1x=-CONT2.DOWN+CONT2.UP:#P1y=-CONT2.LEFT+CONT2.RIGHT ELSE #P1x=-CONT2.LEFT+CONT2.RIGHT:#P1y=-CONT2.UP+CONT2.DOWN

'-----
CONST CS_ADVANCE_MASK = $DFFF
CONST COLOR_STACK_FG_MASK = $EFF8	'1110111111111000  'Color stack, mask FG color bits 12,2,1,0

'--- Engine uses bit 15 and 14 -----
CONST BIT_CARD2 = $8000:CONST MASK_CARD2=($FFFF - $8000)	'#STATE() bit 15: Erase 2 cards
CONST BIT_CHECK4= $4000:CONST MASK_CHECK4=($FFFF - $4000)	'#STATE() bit 14: 1=check 4 sides, 0=check all
CONST BIT_MOVED = $2000:CONST MASK_MOVED=$DFFF				'#STATE() bit 13: If character moved, update BACKTAB!

'==============================titLE================================================
CONST SCROLL_ROLL = SPR05
CONST SCROLL_R1 = SPR06:CONST SCROLL_R2 = SPR07:CONST SCROLL_R3 = SPR21:CONST SCROLL_RINV = SPR42:CONST SCROLL_RINV2 = SPR49
CONST SCROLL_TOP1 = SPR22:CONST SCROLL_TOP2 = SPR23:CONST SCROLL_TOPINV = SPR52
CONST PAPER_SOLID = SPR58:CONST PAPER_SOLID1 = SPR59:CONST PAPER_SOLID2 = SPR55
CONST PAPER_BLACK = SPR54

'--princess---
CONST PBKG1 = SPR61:CONST PBKG2 = SPR62
CONST PHAIR= SPR60: CONST PNOO1 = SPR41: CONST PNOO2 = SPR54

'-- gradients---
CONST GradHi = SPR01:CONST GradLo = SPR02
CONST VWall = SPR62 
'---princess death---
CONST PDeath1 = SPR17:CONST PDeath2 = SPR18:CONST PDeath3 = SPR30:CONST PDeath4 = SPR31
CONST PDDress1= SPR55:CONST PDDress2= SPR56:CONST PDDress3= SPR57

'---dress animation, used in both
DressAnim: DATA PBKG2,PBKG2,PBKG1,PBKG1,PBKG2,PBKG2,PBKG1,PBKG1

'---nooooo animation (low lives)
NoAnimA: DATA PHAIR,PHAIR,PNOO2,PNOO2,PNOO1,PNOO1,PNOO1,PNOO1
'---- hair animation (many lives)
HairAnimA: DATA PNOO2,PNOO2,PNOO1,PNOO1,PHAIR,PHAIR,PHAIR,PHAIR
'--- death animation
DeathAnimA: DATA PDeath1,PDeath1,PDeath2,PDeath2,PDeath3,PDeath3,PDeath4,PDeath4
DeathAnimB: DATA PDDress1,PDDress1,PDDress2,PDDress2,PDDress3,PDDress3,PDDress3,PDDress3
'========================================================

GameInit: PROCEDURE
	ResetSprites(0,7)
	PLAY SIMPLE
	'MODE 0,STACK_BLACK,STACK_BLUE,STACK_BLACK,CS_DARKGREEN
	'MODE 0,STACK_BLACK,STACK_LIGHTBLUE,STACK_BLACK,STACK_BLUE
	MODE SCREEN_FB:CLS:WAIT
	DEFINE 0,16,Sprite0:WAIT
	DEFINE 16,16,Sprite16:WAIT 
	DEFINE 32,16,Sprite32:WAIT 
	DEFINE 48,16,Sprite48:WAIT
END

TitleCardsReset: PROCEDURE 
	ResetSprites(0,7)
	DEFINE DEF00,16,Sprite64:WAIT
	DEFINE DEF16,16,Sprite80:WAIT
	DEFINE DEF32,16,Sprite96:WAIT
	DEFINE DEF48,16,Sprite112:WAIT
END 
'---score screen update
TitleCard2: PROCEDURE
    DEFINE DEF01,2,Sprite128:WAIT     
END
'---death animation
TitleCard3: PROCEDURE
    DEFINE DEF01,2,Sprite128:DEFINE ALTERNATE DEF17,2,Sprite130:WAIT
    DEFINE DEF30,2,Sprite132:DEFINE ALTERNATE DEF55,3,Sprite134:WAIT
END
'=========================================
'---Reset sprites 
ResetSprites_:PROCEDURE
	FOR ti=tx TO ty:ResetSprite(ti):NEXT ti
END

' Wait for a key to be pressed. Ignores CLR
AnyKey: PROCEDURE	
	DO:DO:WAIT:LOOP WHILE CONT=0 OR CONT.KEY=10	
    DO:WAIT:LOOP WHILE CONT<>0
    LOOP WHILE CONT.KEY=10
END

NoKey: PROCEDURE 	'Wait for a key to be released
	NoKey1: WAIT:IF CONT<>0 THEN GOTO NoKey1
END

CONST HEXCOLOR=CS_YELLOW
HEX16_: PROCEDURE 
	PRINT HexData((#tc AND $F000)/4096)
	PRINT HexData((#tc AND $F00)/256)
	PRINT HexData((#tc AND $F0)/16)
	PRINT HexData(#tc AND $F)
END
'HEX8_: PROCEDURE 
'	PRINT HexData((#tc AND $F0)/16)
'	PRINT HexData(#tc AND $F)
'END
HEXDATA: 
DATA 16*8+HEXCOLOR, 17*8+HEXCOLOR, 18*8+HEXCOLOR, 19*8+HEXCOLOR, 20*8+HEXCOLOR
DATA 21*8+HEXCOLOR, 22*8+HEXCOLOR, 23*8+HEXCOLOR, 24*8+HEXCOLOR, 25*8+HEXCOLOR
DATA 33*8+HEXCOLOR, 34*8+HEXCOLOR, 35*8+HEXCOLOR, 36*8+HEXCOLOR, 37*8+HEXCOLOR, 38*8+HEXCOLOR

CLSC_: PROCEDURE 
    FOR tx=0 TO BACKGROUND_COLUMNS*BACKGROUND_ROWS -1
        #BACKTAB(tx)=#ts
    NEXT tx
END

HLine_: PROCEDURE 
    ti=ti*BACKGROUND_COLUMNS
    FOR tx=ti TO ti+BACKGROUND_COLUMNS-1
        #BACKTAB(tx)=#ts
    NEXT tx   
END

'--print numbers, princess font
PriNum_: PROCEDURE 
    #ts=10
    IF ti>0 THEN FOR tj=1 TO ti:#BACKTAB(tx)=PrintNumX(0)+#tm:tx=tx-1:NEXT tj
    DO
        #tb=#ta % #ts  
        #ta=#ta / #ts
        #BACKTAB(tx)=PrintNumX(#tb)+#tm
        tx=tx-1        
    LOOP WHILE #ta<>0    
END
PrintNumX:   '0     1       2      3      4      5      6      7      8      9 
DATA        281*8, 265*8, 280*8, 288*8, 289*8, 260*8, 282*8, 283*8, 290*8, 270*8
'-----
MultiWait: PROCEDURE
    for tk=0 to 7:WAIT:Next tk
END 

FillZeroes_: PROCEDURE    
    FOR ti=tx to tx+5        
        IF #BACKTAB(ti)=1536 THEN 
            #BACKTAB(ti)= SPR25 + #tc 'STACK_TAN
        ELSE 
            EXIT FOR 
        END IF 
    NEXT ti
END

'---sleep
Sleep_: PROCEDURE
	for ty=1 to tx:WAIT:next ty
END
'===============================================================
REM SEGMENT ADDRESS RANGE  SIZE  NOTES
REM    0    $5000 to $6FFF $2000 - Default segment
REM    1    $A000 to $BFFF $2000
REM    2    $C040 to $FFFF $3FC0 - Avoid STIC aliasing.
REM    3    $2100 to $2FFF $0F00 
REM    4    $7100 to $7FFF $0F00 - Avoid EXEC's ECS ROM probe.
REM    5    $4810 to $4FFF $0800 - Account for game's ECS ROM mapping out code.
MemCheck: PROCEDURE 	
	CLS	
	PRINT AT 3 COLOR CS_BLACK,"\283\266\268\283\266\281\264\289\272\283\266\284\294" 'Memory Map
	'Start, Curr, Max
	PRINT AT 20+0 COLOR CS_DARKGREEN,"\269\271\284\264\271":PRINT AT 20+8,"\267\295\264\264":PRINT AT 20+15,"\283\266\284\256"
	#P1y=60
	#s=VARPTR EndProgram50(0):#ta=$5000:#tb=$6FFF:GOSUB MemCheckPrint		'--Default segment
	#s=VARPTR EndProgramC0(0):#ta=$C040:#tb=$FFFF:GOSUB MemCheckPrint		'--main 
	#s=VARPTR EndProgramA0(0)+634:#ta=$A000:#tb=$BFFF:GOSUB MemCheckPrint	'--2nd main + intybasic epilogue
	
	#s=VARPTR EndProgram71(0):#ta=$7100:#tb=$7FFF:GOSUB MemCheckPrint
	#s=VARPTR EndProgram21(0):#ta=$2100:#tb=$2FFF:GOSUB MemCheckPrint	
	#s=VARPTR EndProgram48(0):#ta=$4810:#tb=$4FFF:GOSUB MemCheckPrint	
	PRINT AT 200 COLOR CS_BLUE,"-- \294\264\268\269\269\272\284\266\289\272\301\268\289 --"
	GOSUB AnyKey
END
MemCheckPrint: PROCEDURE
	PRINT AT #P1y:#P1y=#P1y+20
	IF #s>=#tb THEN PRINT COLOR CS_RED ELSE PRINT COLOR CS_TAN
	
	PRINT "$":Hex16(#ta)
	IF (#s>=#ta) AND (#s<=#tb) THEN
		PRINT " ($":Hex16(#s)
	ELSE
		'     " ($0000"
		PRINT " ( \266/\284 " 'n/a
	END IF 
	PRINT ") $":Hex16(#tb)
END 

'============================================================
' r0=start line (#BACKTAB)
' r1=lines to copy (11=full screen)
ASM SCROLLUPX: PROC	
	asm movr	r5,r2				;---save R5 in R2---
	'asm mvii #11,r1			;scroll BACKGROUND_ROWS-1 lines (12-1)

	asm movr r0,r5		;#BackTAB --> r5

	asm movr r0,r4 
	asm addi #20,r4 		;#BackTab+Line below --> r4
'----
asm @@CopyLoop:
	asm REPEAT 20
		asm mvi@ r4,r0		;[r4++] --> R0	'--in card from below
		asm mvo@ r0,r5		;r0 --> [R5++]	'--out card above
	asm ENDR
	
	asm decr r1				;done row..
	asm bne @@CopyLoop
'------
	asm jr	r2				;----return @R2
asm ENDP

'==============================================================================
' r0=start line (#BACKTAB+240-20)
' r1=lines to copy (11=full screen)
ASM SCROLLDOWNX: PROC		
	asm movr r5,r2	;==save return to R2==

	'asm mvii #11,r1	;--scroll BACKGROUND_ROWS-1 lines (12-1)
	asm movr r0,r5		;--r0-->start line (#BACKTAB+240 -20)
	
	asm movr r0,r4		;--r0-->r4 start line (#BACKTAB+240 -20)
	asm subi #20,r4		;--r4=now above r5 

	asm mvii	#40,r3		;--constant: move up BACKGROUND_COLUMNS*2  (20*2)	
	
'----
asm @@CopyLoop:
	asm REPEAT 20
		asm mvi@ r4,r0	;--[r4++] --> R0	'--in card from above
		asm mvo@ r0,r5	;--r0 --> [R5++]	'--out card to below
	asm ENDR
	
	asm subr r3,r4		;--r4=r4-40 (go up twice)
	asm subr r3,r5		;--r5=r5-40 (go up twice)
	
	asm decr r1			;--done row..
	asm bne @@CopyLoop

asm @@Bye:
	asm jr r2	;==pop return address in R2===
asm ENDP


'--Hack IntyBasic _music_t (time base) variable
'CALL MUSIC_TEMPO(t)
ASM MUSIC_TEMPO: PROC       ;r0=1st parameter
    asm mvo    r0,_music_t  ; r0-->_music_t  
    asm jr    r5            ;return
asm ENDP