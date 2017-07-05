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
DATA STACK_RED,STACK_ORANGE 
'Level: [C:\Apps\Intellivision\bin\PriPre\Levels\level0.ico] 4/1/2017 10:53:00 PM
DATA $23e0, $08f8, $f863, $3b70, $3b20, $80f8, $6843, $4033, $201b, $2023, $081b, $ffff

Level1:
DATA STACK_BLUE,STACK_LIGHTBLUE
'Level: [C:\Apps\Intellivision\bin\PriPre\Levels\level1.ico] 4/1/2017 8:11:22 PM
DATA $23e0, $2b48, $2b40, $70f8, $f863, $2b70, $2b40, $68f8, $1873, $ffff

Level2:
DATA STACK_GREEN,STACK_YELLOWGREEN
'Level: [C:\Apps\Intellivision\bin\PriPre\Levels\level2.ico] 4/1/2017 10:56:06 PM
DATA $13e8, $2b50, $2b40, $68f8, $3023, $f823, $4360, $4320, $68f8, $2063, $ffff

Level3:
DATA STACK_BLUE, STACK_PURPLE
'Level: [C:\Apps\Intellivision\bin\PriPre\Levels\level3.ico] 4/1/2017 8:12:45 PM
DATA $13e8, $b0f8, $301b, $f81b, $18f8, $101b, $2013, $1013, $f81b, $5378, $ff28

Level4:
DATA STACK_DARKGREEN, STACK_GREEN 
'Level: [C:\Apps\Intellivision\bin\PriPre\Levels\level4.ico] 4/1/2017 8:12:55 PM
DATA $13e8, $10f8, $f87b, $7b58, $90f8, $f873, $ff50

Level5:
DATA STACK_YELLOW, STACK_ORANGE 
'Level: [C:\Apps\Intellivision\bin\PriPre\Levels\level5.ico] 4/1/2017 8:13:07 PM
DATA $13e8, $3bf0, $3b20, $2310, $2350, $1b10, $1b60, $f8f8, $6318, $5348, $4358, $ff30

Level6:
DATA STACK_PINK,STACK_WHITE
'Level: [C:\Apps\Intellivision\bin\PriPre\Levels\level6.ico] 4/1/2017 8:13:23 PM
DATA $13e8, $1360, $1350, $13e8, $1320, $1bd8, $1b60, $1310, $1320, $1310, $1320, $70f8, $c063, $ffff

Level7:
DATA STACK_LIGHTBLUE,STACK_WHITE 
'Level: [C:\Apps\Intellivision\bin\PriPre\Levels\level7.ico] 4/1/2017 9:39:50 PM
DATA $13e8, $3348, $5340, $3b60, $2328, $2b28, $2380, $1b80, $2338, $0b38, $f8f8, $6310, $ff20



