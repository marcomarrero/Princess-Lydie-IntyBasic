


'RAND31:  '31 values
'    '0 , 1 ,  2 , 3 ,  4 ,  5 ,  6 ,  7 ,  8 ,  9,   10 , 11 , 12 , 13 ,  14 ,  15 ,  16 ,  17 ,  18 ,  19 ,  20 ,  21 ,  22 ,  23 ,  24 ,  25 ,  26 ,  27 ,  28 ,  29 ,  30 ,  31 
'DATA 0 , 8 , 16 , 24 , 32 , 40 , 48 , 56 , 64 , 72 , 80 , 88 , 96 , 104 , 112 , 120 , 128 , 136 , 144 , 152 , 160 , 168 , 176 , 184 , 192 , 200 , 208 , 216 , 224 , 232 , 240 , 248, 8




'--game object----
'DEF FN GetTileInfo(Obj)= ti=Obj:GOSUB GetTileInfo_
'GetTileInfo_: PROCEDURE	
'	'---if moved, convert sprite coords to tile/Backtab coords--
'	tj=0:tx=bitmask8(ti):ty=bit(ti)
'			
'	xmoved=xmoved and tx:ymoved=ymoved and tx	'--mask move bits 
'	if xpos_(ti)<>xpre_(ti) THEN xpre_(ti)=xpos_(ti):xcard_(ti)=(xpos_(ti)-4)/8:xmoved=xmoved+ty:tj=ty
'	if ypos_(ti)<>ypre_(ti) THEN ypre_(ti)=ypos_(ti):ycard_(ti)=(ypos_(ti)-4)/8:ymoved=ymoved+ty:tj=ty
'	
'	'---#BACKTAB position--
'	IF tj THEN 
'		backtabpre_(ti)=backtabpos_(ti)	'--moved... save old position 
'		'backtabpos_(ti)=xcard_(ti)+(ycard_(ti)*BACKGROUND_COLUMNS) 
'		backtabpos_(ti)=xcard_(ti) + MUL20(ycard_(ti))
'		xmovedpre=xmoved:ymovedpre=ymoved
'	END IF 
'		
'	'--if sprite is offscreen, return "a wall of bricks" "a wall of bricks"
'	'IF (xpos_(ti)>=SPRITEMAXX+2) OR (ypos_(ti)>=SPRITEMAXY+8+2) OR (ypos_(ti)<4) THEN
'	'	FOR tx=0 TO 8:tiles(tx)=$ff:NEXT tx		
'	'END IF
'	
'	'--surrounding box starts 1 tile up, 1 tile left--
'	'#tc=backtabpos_(ti)-(BACKGROUND_COLUMNS-1)
'
'	'---Decide if well get 4 points (up,left,right,down), or full matrix
'	'IF (#state(ti) AND BIT_CHECK4)=0 THEN
'	'	'---get surrounding #BACKTAB onto tiles(j)---- monsters eyes can be 2 cards!
'	'	tj=0
'	'	FOR ty=0 TO 2
'	'		FOR tx=0 TO 2
'	'			tiles(tj)=#BACKTAB(#tc)/8
'	'			#tc=#tc+1:tj=tj+1
'	'		NEXT tx
'	'		#tc=#tc+(BACKGROUND_COLUMNS-3)
'	'	NEXT ty
'	'ELSE
'	'	'----get only 4 points---- 0[1]2 [3]4[5] 6[7]8, rest is junk
'	'	'----------------------+1   +20 +22   +41	untested!!!
'	'	tiles(1)=#BACKTAB(#tc+1)/8		'UP
'	'	tiles(3)=#BACKTAB(#tc+20)/8	'LEFT
'	'	tiles(5)=#BACKTAB(#tc+22)/8	'RIGHT
'	'	tiles(7)=#BACKTAB(#tc+41)/8	'DOWN
'	'END IF 
'	
'	'---done. clean result, minimize wrapped data--- Set tiles(x) that are offscreen with a constant value ---
'	'---- Ill use $FF as a "wall of bricks" a "wall of bricks"
'	'---process leftmost/rightmost tiles---
'	'IF xcard_(ti)=0 OR xcard_(ti)>25 THEN 
'	'	tiles(0)=$ff:tiles(3)=$ff:tiles(6)=$ff 	'xcard_(i)>25 is offscreen at left. all tiles will be wrong anyway		
'	'ELSEIF xcard_(ti)>=BACKGROUND_COLUMNS-1 THEN 
'	'	tiles(2)=$ff:tiles(5)=$ff:tiles(8)=$ff
'	'	IF xcard_(ti)>=BACKGROUND_COLUMNS THEN 
'	'		tiles(1)=$ff:tiles(4)=$ff:tiles(7)=$ff
'	'	END IF 
'	'END IF
'	
'	'---same with upper/lower---
'	'IF ycard_(ti)=0 OR ycard_(ti)>20 THEN 
'	'	tiles(0)=$ff:tiles(1)=$ff:tiles(2)=$ff  		
'	'ELSEIF ycard_(ti)>=BACKGROUND_ROWS-1 THEN 	'ycard_(i)>20 is offscreen at top. all tiles will be wrong anyway
'	'	tiles(6)=$ff:tiles(7)=$ff:tiles(8)=$ff		
'	'	IF ycard_(ti)>=BACKGROUND_ROWS THEN 
'	'		tiles(3)=$ff:tiles(4)=$ff:tiles(5)=$ff	
'	'	END IF
'	'END IF 
'END

'DEF FN InitObjectZ(ObjNum,xCoord,yCoord,SprColor)= ti=ObjNum:xpos_(ObjNum)=xCoord:ypos_(ObjNum)=yCoord:pcolor_(ObjNum)=SprColor:GOSUB InitObjectZ_
'InitObjectZ_: PROCEDURE
'	xdir_(ti)=0:ydir_(ti)='0:xpre_(ti)=0:ypre_(ti)=0
'	#state(ti)=BIT_MOVED + BIT_CHECK4	'--initialize, assume everything moved	
'	GetTileInfo(ti)
'END


'CONST cBLACK=0:CONST cBLUE=1:CONST cRED=2:CONST cTAN=3:CONST cDARKGREEN=4:CONST cGREEN=5:CONST cYELLOW=6:CONST cWHITE=7
'CONST cGREY=8:CONST cCYAN=9:CONST cORANGE=10:CONST cBROWN=11:CONST cPINK=12:CONST cLIGHTBLUE=13:CONST cYELLOWGREEN=14:CONST cPURPLE=15
'CONST cbBLACK=16:CONST cbBLUE=17:CONST cbRED=18:CONST cbTAN=19:CONST cbDARKGREEN=20:CONST cbGREEN=21:CONST cbYELLOW=22:CONST cbWHITE=23
'CONST cbGREY=24:CONST cbCYAN=25:CONST cbORANGE=26:CONST cbBROWN=27:CONST cbPINK=28:CONST cbLIGHTBLUE=29:CONST cbYELLOWGREEN=30:CONST cbPURPLE=31
'XColorIndex:	'-sprite color look-up'
'	DATA SPR_BLACK,SPR_BLUE,SPR_RED,SPR_TAN,SPR_DARKGREEN,SPR_GREEN,SPR_YELLOW,SPR_WHITE
'	DATA SPR_GREY,SPR_CYAN,SPR_ORANGE,SPR_BROWN,SPR_PINK,SPR_LIGHTBLUE,SPR_YELLOWGREEN,SPR_PURPLE
'	'--behind
'	DATA SPR_BLACK+BEHIND,SPR_BLUE+BEHIND,SPR_RED+BEHIND,SPR_TAN+BEHIND,SPR_DARKGREEN+BEHIND,SPR_GREEN+BEHIND,SPR_YELLOW+BEHIND,SPR_WHITE+BEHIND
'	DATA SPR_GREY+BEHIND,SPR_CYAN+BEHIND,SPR_ORANGE+BEHIND,SPR_BROWN+BEHIND,SPR_PINK+BEHIND,SPR_LIGHTBLUE+BEHIND,SPR_YELLOWGREEN+BEHIND,SPR_PURPLE



'================================================================================================
'Draw, turtle graphics. v2.0. Params: x,y,#b=address,#c=card
'Uses #P1x,#P1y,j,c,i,#b,#a,#c,#b  - Draw data: packed strings (see example)
'Draw(VARPTR DrawData(0),6,3,SPR26+CS_BLUE) 'Both below are same, different styles for PACKED data
'DrawData: DATA PACKED "B\0R\1R\3B\0F\1D\3C\9B\0G\1L\3B\0H\1U\3",0R\1R\3B\0F\1D\3C\9B\0G\1L\3B\0H\1U\3
'DrawData: DATA PACKED "B.R",1,"R",3,"B.F",1,"D",3,"C",9,"B.G",1,"L",3,"B.H",1,"U",3,0

Draw_: PROCEDURE
	tj=1		'Not blank
DrawAgain:
	'--ALL commands are in pairs, including [B]lank.
	PeekPacked(#ta,tk,ti):#ta=#ta+1
	'PRINT AT 0 COLOR CS_RED,"@",<>#a," c:",<>k," v:",<>i 
	'GOSUB AnyKey
	IF tk=0 or tk="0" THEN 	'--command=0, exit
		RETURN
	ELSEIF tk="B" THEN 		'--Blank
		tj=0  				'--TODO, use i for anything.
		GOTO DrawAgain
	ELSEIF tk="C" THEN 		'--Foreground color
		IF ti>7 THEN 		'--8+ are extended colors, ColorStack mode, bit 12		
			#tc=(#tc AND COLOR_STACK_FG_MASK) + $1000 + (ti AND 7)
		ELSE 
			#tc=(#tc AND COLOR_STACK_FG_MASK)+ti	'--regular color (0..7)
		END IF
		GOTO DrawAgain		
	ELSEIF tk="X" THEN		'--Coordinate X 
		tx=ti:GOTO DrawAgain
	ELSEIF tk="Y" THEN		'--Coordinate Y
		ty=ti:GOTO DrawAgain
	ELSEIF tk="E" THEN		'--45o (right+up)
		#P1x=1:#P1y=-1
	ELSEIF tk="F" THEN		'--315o (right+down)
		#P1x=1:#P1y=1
	ELSEIF tk="G" THEN		'--225o (left+down)
		#P1x=-1:#P1y=1
	ELSEIF tk="H" THEN		'--135o (left+up)
		#P1x=-1:#P1y=-1
	ELSEIF tk="R" THEN		'--right 
		#P1x=1:#P1y=0
	ELSEIF tk="L" THEN		'--left
		#P1x=-1:#P1y=0
	ELSEIF tk="U" THEN		'--up 
		#P1x=0:#P1y=-1
	ELSEIF tk="D" THEN		'--down 
		#P1x=0:#P1y=1 
	END IF
DrawPrint:	
	IF tj THEN #BACKTAB(screenpos(tx, ty))=#tc		'--if j<>0 draw something
	IF ti=0 THEN tj=1:GOTO DrawAgain 	'--check now, exit if d[i]stance=0. For exmple, R0 draws pixel w/o moving position
	tx=tx+#P1x:ty=ty+#P1y:ti=ti-1			'--move next, decrement d[i]stance
	GOTO DrawPrint 
END


'CardStackPrint_. Prints rounded objects, using card stack. Will use blank squares (FillerCard) to void 
CardStackPrint_: PROCEDURE	
	#BACKTAB(tx)=#tc + CS_ADVANCE
	#tc=#tc+8 'next position, next char 
	#BACKTAB(tx+1)=#tc + CS_ADVANCE
	FOR ti=tx+2 TO ty
		#BACKTAB(ti)=#tc
	Next ti
	#BACKTAB(ti)=#tc+8  + CS_ADVANCE
	#BACKTAB(ti+1)=#BACKTAB(ti+1) + CS_ADVANCE
END

PrintLine_: PROCEDURE
	FOR ti=tx TO ty:#BACKTAB(ti)=#tc:Next ti
END

'---Print Horizontal Line, #tc must be 3 sequential chars (left/middle/end)
PrintLineRound_: PROCEDURE
	#BACKTAB(tx)=#tc
	#tc=#tc+8 					'next position, next char 
	FOR ti=tx+1 TO ty:#BACKTAB(ti)=#tc:Next ti
	#BACKTAB(ti)=#tc+8
END

PrintLineRoundCS_: PROCEDURE
	#BACKTAB(tx)=#tc+CS_ADVANCE
	#tc=#tc+8 					'next position, next char 
	FOR ti=tx+1 TO ty:#BACKTAB(ti)=#tc:Next ti
	#BACKTAB(ti)=#tc+8
	#BACKTAB(ti+1)=(#BACKTAB(ti+1) AND CS_ADVANCE_MASK) + CS_ADVANCE
END

'==========================speed=============
'DIM #cycles
'BENCHX: PROCEDURE 
'	VDISK1:PRINT AT 8,<2>#cycles
'	#cycles=0
'END 

