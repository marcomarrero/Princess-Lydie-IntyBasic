include "constants.bas"
CLS
GOSUB GameInit

DIM tx,ty,ti,tj,tk,tl
DIM #ta,#tb,#tc,#ts,#tm
DIM x 

x=0
Eternal:
    #tb=AllLevels(x)
    GOSUB DrawLevelX
    WAIT
    GOSUB AnyKey
    x=x+1:if x>5 then x=0
GOTO Eternal

'=============================================== DRAW LEVEL ================================================
'-----Levels--------------------
CONST SPR_FLOOR_FORE = SPR45  '--normal, foreground colors 0-7
CONST SPR_FLOOR_BACK = SPR29  '--inverted, foreground colors 8-15

DrawLevelX: PROCEDURE
    CLS
    tx=0    
    #ta=PEEK(#tb) '--foreground
    #tc=PEEK(#tb+1) '--background    
    'if foreground color > 7, swap, set different card
    IF #tc>7 then         
        #tm= #ta + FGBG_BK_Color(#tc)  '--color 
        #ta=SPR_FLOOR_BACK + #tm        '--left floor
        #tc=SPR_FLOOR_BACK + 8 + #tm    '---middle
        #ts=SPR_FLOOR_BACK + 16 + #tm   '--right
    ELSE
        #tm=#tc + FGBG_BK_Color(#ta)    '--color
        #ta=SPR_FLOOR_FORE + #tm        '--left floor
        #tc=SPR_FLOOR_FORE + 8 + #tm    '---middle
        #ts=SPR_FLOOR_FORE + 16 + #tm   '--right
    END IF 
    #tb=#tb+2
    DO
        #tm=PEEK(#tb)
        ti=(#tm AND $FF) '--lo byte        
        if ti=$FF THEN RETURN         
        GOSUB DrawLevelXDecode
        ti=(#tm/256)   '--hi byte
        if ti=$FF THEN RETURN
        GOSUB DrawLevelXDecode
        #tb=#tb+1
    LOOP WHILE tx<(BACKGROUND_COLUMNS*BACKGROUND_ROWS)    
END 
DrawLevelXDecode: PROCEDURE
    '=== #ta:left, #tc:middle, #ts=last ===
    tj=(ti AND 3)   '---char
    tl=(ti/8)       '---len    
    'PRINT AT 180,"CHAR:",<5>tj:PRINT AT 200,"LEN :",<5>tl:PRINT AT 220,"ADDR:",<5>#tb:GOSUB AnyKey 

    '--if tl=0, place object. This game doesn't support it.
    if tj=0 THEN tx=tx+tl:RETURN     '--if char 0, just skip all
    '--In this game I only use 1 type of flooe,so I'll ignore the value in tj
    '---draw floor. Take care of special cases of 1 and 2 --
    if tl=1 THEN #BACKTAB(tx)=#tb:tx=tx+1:RETURN '--only 1, middle   
    #BACKTAB(tx)=#ta:tx=tx+1    '<--left floor
    IF tl<>2 THEN   '--if only 2, don't draw middle
        FOR tk=3 TO tl
            #BACKTAB(tx)=#tc:tx=tx+1 '<--middle floor
        NEXT tk
    END IF 
    #BACKTAB(tx)=#ts:tx=tx+1    '<--left floor    
END

'--- FG_COLOR, BG_COLOR, Data... IF Foreground color>7 will use trick, BG MUST BE <8
AllLevels: 
DATA VarPtr Level1(0), VarPtr Level2(0), VarPtr Level3(0),  VarPtr Level4(0), VarPtr Level5(0)
DATA VarPtr Level6(0)
'-----------------------------------    
Level1:
DATA STACK_BLUE,STACK_LIGHTBLUE
DATA $23e0, $2b40, $2b50, $60f8, $f86b, $3368, $3340, $60f8, $1873, $ffff

Level2:
DATA STACK_RED,STACK_ORANGE 
DATA $23e0, $a8f8, $2023, $f823, $3368, $3340, $70f8, $c853, $ffff

Level3:
DATA STACK_RED,STACK_ORANGE 
DATA $23b0, $2310, $2310, $80f8, $2853, $701b, $f81b, $4348, $4320, $68f8, $2063, $ffff

Level4:
DATA STACK_RED,STACK_ORANGE 
DATA $13e8, $2b58, $2b30, $f8f8, $48f8, $101b, $1023, $1023, $f81b, $5370, $ff28

Level5:
DATA STACK_RED,STACK_ORANGE 
DATA $13e8, $83f8, $4bb0, $4b10, $70f8, $f853, $2380, $2340, $ff10

Level6:
DATA STACK_RED,STACK_ORANGE 
DATA $23a0, $1328, $4b28, $5b50, $6b40, $7b30, $4320, $f8f8, $7308, $6338, $ffc0






'------- done -------


'---color look-up table for MODE1 background color ---- GRAM/GROM bit 11 NOT set --- bits 9,10,12,13 only. 
FGBG_BK_Color:  '--in other words, use it to pick correct background color 0-15
DATA 0,$200,$400,$600,$2000,$2200,$2400,$2600,$1000,$1200,$1400,$1600,$3000,$3200,$3400,$3600

GameInit: PROCEDURE
	'ResetSprites(0,7)
	'PLAY SIMPLE
	'MODE 0,STACK_BLACK,STACK_BLUE,STACK_BLACK,CS_DARKGREEN
	'MODE 0,STACK_BLACK,STACK_LIGHTBLUE,STACK_BLACK,STACK_BLUE
	MODE SCREEN_FB
	CLS:WAIT 
	DEFINE 0,16,Sprite0:WAIT
	DEFINE 16,16,Sprite16:WAIT 
	DEFINE 32,16,Sprite32:WAIT 
	DEFINE 48,16,Sprite48:WAIT
END

AnyKey: PROCEDURE	
	DO:DO:WAIT:LOOP WHILE CONT=0 OR CONT.KEY=10	
    DO:WAIT:LOOP WHILE CONT<>0
    LOOP WHILE CONT.KEY=10
END

CONST HEXCOLOR=CS_YELLOW
HEX16_: PROCEDURE 
	PRINT HexData((#tc AND $F000)/4096)
	PRINT HexData((#tc AND $F00)/256)
	PRINT HexData((#tc AND $F0)/16)
	PRINT HexData(#tc AND $F)
END
HEX8_: PROCEDURE 
	PRINT HexData((#tc AND $F0)/16)
	PRINT HexData(#tc AND $F)
END
HEXDATA: 
DATA 16*8+HEXCOLOR, 17*8+HEXCOLOR, 18*8+HEXCOLOR, 19*8+HEXCOLOR, 20*8+HEXCOLOR
DATA 21*8+HEXCOLOR, 22*8+HEXCOLOR, 23*8+HEXCOLOR, 24*8+HEXCOLOR, 25*8+HEXCOLOR
DATA 33*8+HEXCOLOR, 34*8+HEXCOLOR, 35*8+HEXCOLOR, 36*8+HEXCOLOR, 37*8+HEXCOLOR, 38*8+HEXCOLOR

include "C:\Apps\Intellivision\bin\PriPre\PriPreGraphics.bas"
