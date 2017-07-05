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
DATA VarPtr Level0(0), VarPtr Level1(0), VarPtr Level2(0), VarPtr Level3(0),  VarPtr Level4(0), VarPtr Level5(0)
DATA VarPtr Level6(0), VarPtr Level7(0)
'-----------------------------------    
' STACK_BLACK, STACK_BLUE, STACK_RED,   STACK_TAN,  STACK_DARKGREEN, STACK_GREEN, STACK_YELLOW, STACK_WHITE
' STACK_GREY,  STACK_CYAN, STACK_ORANGE,STACK_BROWN,STACK_PINK, STACK_LIGHTBLUE, STACK_YELLOWGREEN, STACK_PURPLE, STACK_OVERFLOW

Level0:
DATA STACK_BLUE,STACK_LIGHTBLUE
DATA $23e0, $3340, $3340, $68f8, $f863, $3368, $3340, $60f8, $1873, $ffff

Level1:
DATA STACK_RED,STACK_ORANGE 
DATA $23e0, $98f8, $2033, $f833, $3358, $3340, $68f8, $c063, $ffff

Level2:
DATA STACK_GREEN,STACK_YELLOWGREEN
DATA $23e0, $2350, $2340, $58f8, $101b, $1053, $f81b, $4348, $4320, $68f8, $2063, $ffff

Level3:
DATA STACK_BLUE, STACK_PURPLE
DATA $13e8, $a0f8, $302b, $f82b, $23f8, $1310, $1320, $2310, $70f8, $2853, $ffff

Level4:
DATA STACK_DARKGREEN, STACK_GREEN 
DATA $13e8, $10f8, $f883, $8348, $90f8, $f87b, $ff48

Level5:
DATA STACK_YELLOW, STACK_ORANGE 
DATA $13e8, $33e8, $5b40, $4b50, $2360, $f8f8, $6310, $5348, $4358, $ff30

Level6:
DATA STACK_PINK,STACK_RED
DATA $13e8, $1360, $1350, $13e8, $1320, $23d0, $3360, $1328, $1310, $1b28, $0b90, $63c0, $ffc0

Level7:
DATA STACK_LIGHTBLUE,STACK_WHITE 
DATA $13e8, $1360, $1350, $13e8, $1320, $23d0, $3360, $1328, $1310, $1b28, $0b90, $63c0, $ffc0


