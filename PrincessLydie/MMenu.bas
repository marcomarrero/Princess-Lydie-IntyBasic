'IntyMusic Menu. 
'- -- - - --- - - -
'MMenu_idx_start: Initial selection (will autoscroll). Will be cleared
'MMEnu_idx		: Selection to be returned
'========================================================================================
CONST MMENU_START_COL = 2		'Start Column (0-19)
CONST MMENU_START_ROW = 4		'Start Row (1-11), can't use row 0 (top border)

CONST MMENU_WIDTH = 15			'15 characters per menu item
CONST MMENU_HEIGHT= 5			'5 Rows at a time 
CONST MMENU_MAX_ITEMS=9			'Total items in menu. Max, 20 items
CONST MMenu_Frames=8
CONST MMenu_Colors=4

DIM MMEnu_Data(MMENU_MAX_ITEMS+1)	'String length

CONST MMENU_CURSOR_POS = 18		'Cursor x position, at bottom right.
CONST MMENU_KIOSK = 0			'Set to nonzero for Kiosk Mode (gamepad disabled), AutoSelect must be set
								'If MMENU_KIOSK=0 and AutoSelect is enabled, Gamepad will disable Autoselect entirely

CONST INTYMUSIC_MENU_COLOR  =FG_BLACK
CONST INTYMUSIC_TITLE_COLOR =FG_BLUE
CONST INTYMUSIC_MENU_BORDER =FG_DARKGREEN	'--- Menu Border color
'======================
DIM MMENU_IDX, MMENU_IDX_START
'DIM backtabpos_1	---> MMENU_AUTOSELECT
'DIM backtabpos_2 --> MMENU_POS
'DIM backtabpos_3 --> MMENU_USER_OVERRIDE

'-----NTSC menu------			
MMEnu_Text:
DATA "\269\271\284\264\271 - \266\281\264\283\266\284\306",$FF	'start - normal 1

MMEnu_Text_PAL:
DATA "\269\271\284\264\271 - \268\284\269\289",$FF 'start - easy 2

'DATA "Music On/Off" 3
DATA "\283\266\295\269\299\267\272\281\266/\281\292\292", $FF 

'DATA "Title Screen",$FF	4
DATA "\271\299\271\306\268\272\269\267\264\268\268\266",$FF

'DATA "Memory Map", $FF		5
DATA "\283\266\268\283\266\281\264\289\272\283\266\284\294",$FF

'DATA "IntyMusic Player", $FF 6
DATA "\283\266\295\269\299\267\272\294\306\284\289\268\264",$FF
 
'DATA "Credits",$FF  7
DATA "\267\264\268\291\299\271\269",$FF

DATA $FF '8
DATA "\269\271\284\264\271-\319\299\266\269\284\266\268\319",$FF '9
DATA $FF

MMenu_Text_IntyMusic:
DATA "Exit",$FF
DATA "World 1",$FF
DATA "Unfinished",$FF
DATA "Game Over",$FF
DATA "Round Clear",$FF
DATA "Start 1",$FF
DATA "Start 2",$FF
DATA $FF,$FF,$FF,$FF,$FF

'----Border-----
MMenu_Print_Border: PROCEDURE
	if IntyMusic=0 THEN 
		ty=(MMENU_START_ROW-1)*20
		ti=(MMENU_START_ROW+MMENU_HEIGHT)*20
		WAIT
		FOR tx=MMENU_START_COL TO 19
			PRINT AT ty+tx+120 COLOR CS_BLACK, "\279"
			PRINT AT ty+tx COLOR CS_TAN,"\278" 		
		NEXT tx		
		PRINT AT ty,"\261\278"	'paper
		PRINT COLOR 0	
		WHILE ty<=160
			ty=ty+20:PRINT AT ty,"\315\277"		
		WEND 	
		IF MusicOn THEN #BACKTAB(0)=319*8 ELSE #BACKTAB(0)=272*8
		#BACKTAB(60)=#BACKTAB(60) + CS_ADVANCE		'black
		#BACKTAB(80)=#BACKTAB(80) + CS_ADVANCE		'tan
		#BACKTAB(200)=#BACKTAB(200) + CS_ADVANCE 	'black
		#BACKTAB(220)=#BACKTAB(220) + CS_ADVANCE 	'pink		
	ELSE
		PRINT COLOR INTYMUSIC_MENU_BORDER
		ty=(MMENU_START_ROW-1)*20
		ti=(MMENU_START_ROW+MMENU_HEIGHT)*20
		FOR tx=MMENU_START_COL TO 19
			PRINT AT ty+tx,"\202"
			PRINT AT ti+tx,"\201"
		NEXT tx
		'--3D CornersPRINT AT ty+tx,"\121":PRINT AT ti+tx,"\123"			
		'--Sides
		tx=(MMENU_START_ROW*20)+19
		FOR ty=MMENU_START_ROW TO (MMENU_START_ROW+MMENU_HEIGHT)-1
			PRINT AT tx,"\165"  '"\190"
			tx=tx+20
		NEXT ty
	END IF 
END
'=============================================== MENU =============================================
MMenu_Demo: PROCEDURE 
MMenu_Redo:
	IntyMusic=0
	state_kick=0			'<--- 0=This menu, 1=IntyMusic	
	CLS:BORDER BORDER_WHITE,0
	MODE 0,STACK_PINK,STACK_BLACK,STACK_TAN,STACK_BLACK
	WAIT 
	GOSUB TitleCardsReset
	tl=0:#tc=2:GOSUB PRINCESSLYDIE	
	MMenu_idx_start=1				'--Initial menu selection
	'backtabpos_1=0				'--AutoSelect, delay 30 frames ~1 sec. Moving pad resets, unless MMENU_KIOSK is set
									'--It will start countdown after Autoscrolling/MMenu_idx_start\
	backtabpos_3=0			'--Change to 1 when user overrides. Used to avoid autoselecting again	
MMenu_Again:		
	GOSUB MMenu_Strings_Parse		'--Parse string lengths	
	#tc=0	
	backtabpos_1=0
	GOSUB NoKey
MMenu_Nop:	
	GOSUB MMenu_Show:MMenu_idx=MMenu_idx-NTSC
	IF MMenu_idx=0 THEN 		'--start, normal (NTSC only)
		Difficulty=0		
	ELSEIF MMenu_idx=1 THEN 	'--start, easy
		Difficulty=200		
	ELSEIF MMenu_idx=2 THEN 	'--Music
		MusicOn=MusicOn XOR 1
		GOTO MMenu_Redo 
	ELSEIF MMenu_idx=3 THEN		'--Title screen
		#tc=1
	ELSEIF MMenu_idx=4 THEN		'--Memory Map
		GOSUB MemCheck
		GOTO MMenu_Redo		
	ELSEIF MMenu_idx=5 THEN		'--IntyMusic!
		IntyMusic=1:state_kick=1:MMenu_idx=1			
		GOSUB INTYMUSIC_PlayNow		'--show menu, play
		GOSUB TitleCardsReset		'---get back title screen cards
		GOTO MMenu_Redo
	ELSEIF MMenu_idx=6 THEN 
		GOSUB Info
		GOTO MMenu_Redo 
	ELSEIF MMenu_idx=8 THEN
		Difficulty=0
		Level=31		
	ELSE
		GOTO MMenu_Redo 
	END IF 
	GOSUB NoKey
END 
'========================================================================================================
'---Parse menu strings, determine length of each one, create lenght/offset map
'--MMEnu_Data(0)=total strings, MMEnu_Data(1)=Length of 1st menu item, etc.
MMenu_GET: PROCEDURE 
	if state_kick=0 THEN 
		if NTSC THEN 
			#ta=VARPTR MMEnu_Text(0)		'menu Text, strings are terminate with $FF (nulls are spaces..)
		ELSE
			#ta=VARPTR MMEnu_Text_PAL(0)	'PAL version
		END IF 
	ELSE
		#ta=VARPTR MMenu_Text_IntyMusic(0)
	END IF 
END 

CONST SCROLL_FIRST = 64				'--used as a flag to scroll first

MMenu_ResetAll: PROCEDURE	
	xaccel_0=0:	#p1x=0:	#p1y=0:	#xdir_0=0
	#ydir_0=0:	tj=0:	#anim_0=0	
	#anim_1=1:MMenu_idx=1:pri_anim=1
	backtabpos_2=MMENU_START_ROW+2	'--"cursor" Position
	
	GOSUB MMenu_Reset_Input			'Reset cursor position, clear text. MENU_CURSOR_POS	at bottom of screen.
	GOSUB MMenu_Print_Border
	GOSUB MMenu_Print_Menu			'--Initial menu
	GOSUB MMenu_Idx_Update
	GOSUB MMenu_Display_Sprites
END

'---show menu, wait for selection, animate selection----
MMenu_Show: PROCEDURE	
	GOSUB MMenu_ResetAll
	GOSUB NoKey	
	'--Preselection is an offset, 19= move 19 times, which reaches item #20
	IF MMenu_idx_start>0 THEN MMenu_idx_start=MMenu_idx_start-1

	'--Wait until selection is made. MMEnu_idx holds result!
	WHILE pri_anim
		GOSUB MMenu_ReadControls		
	WEND 	
	GOSUB MMenu_Animate_Selection
	ResetSprites(0,7)	
END

'=============================================
'--MMenu_Idx++, move cursor, scroll if necessary
MMEnu_Idx_Next: PROCEDURE
	#p1x=0			'--show sprite select	
	
	IF MMEnu_idx<MMENU_MAX_ITEMS THEN 
		MMenu_Idx=MMenu_Idx+1		'--Increase index
		
		'-- Sprite cursor/scroller movement.
		IF backtabpos_2<=(MMENU_HEIGHT+MMENU_START_ROW) THEN
			'--Just update sprite position 
			backtabpos_2=backtabpos_2+1			
		ELSE
			'--Sprite is now at bottom, scroll if necessary
			IF MMEnu_idx>MMENU_HEIGHT THEN
				#anim_1=#anim_1+1
				GOSUB MMenu_Print_Menu
			END IF
		END IF
	END IF
END 

'--MMenu_Idx--, move cursor, scroll if necessary
MMenu_Idx_Previous: PROCEDURE 
	#p1x=0			'--show sprite select
	
	IF MMEnu_idx>1 THEN 
		MMenu_Idx=MMenu_Idx-1		'--Decrease index
		
		'-- Sprite cursor/scroller movement.
		IF backtabpos_2>MMENU_START_ROW+2 THEN	
			backtabpos_2=backtabpos_2-1
		ELSE
			#anim_1=#anim_1-1
			GOSUB MMenu_Print_Menu
		END IF
	END IF
END	

'--update vars for gamepad--
MMenu_Pad_Touch: PROCEDURE
	backtabpos_3=1		'-- User Override 
	backtabpos_1=0		'-- Stop and skip countdown
	#ydir_0=20		'-- Ok, moved. Ignore pad for 20 frames if held
END

'-Read gamepads ------------------------------
MMenu_ReadControls: PROCEDURE	
	GOSUB MMenu_Idx_Update			'--update sprite data
	GOSUB MMenu_Display_Sprites	'--display sprites 
	GOSUB MMenu_AutoScroll			'--autoscroll to selection
	WAIT
	'---kiosk mode, skip check----- if backtabpos_1 is zero, freeze...
	IF MMENU_KIOSK<>0 THEN GOTO SkipCheckingControllers
	
	'---check disc and triggers----
	IF CONT.KEY=12 THEN				'--- no key pressed? Check controller pad and buttons
		#xdir_0=1					'-- Ok, user depressed keys and pad. I can check for keys next time
		IF CONT.DOWN OR CONT.RIGHT THEN	'---Down or Right: Move!
			IF #ydir_0=0 THEN				
				GOSUB MMenu_Pad_Touch
				GOSUB MMenu_Idx_Next		'-- Select next item on menu				
			ELSE
				#ydir_0=#ydir_0-1	'-- If held, count back
			END IF
			
		ELSEIF CONT.UP OR CONT.LEFT THEN 	'---UP or Left: Move!
			IF #ydir_0=0 THEN
				GOSUB MMenu_Pad_Touch
				GOSUB MMenu_Idx_Previous	'-- Select previous item on menu				
			ELSE
				#ydir_0=#ydir_0-1	'-- If held, count back
			END IF		
			
		ELSEIF CONT.BUTTON THEN			'---Button? Selected! Exit.
			GOSUB MMenu_Pad_Touch
			pri_anim=0
		ELSE
			#ydir_0=0				'--- Pad not pressed? Ok, it's not held
		END IF
			
		
	'---CONT.KEY<>12.. check numeric keypad-----
	ELSE 
		IF #xdir_0 THEN			'--Avoid re-reading same value again, set when CONT.KEY=12
			IF CONT.KEY=10 THEN 			'---Clear!
				GOSUB MMenu_ResetAll
				backtabpos_1=0		'-- Stop and skip countdown
				backtabpos_3=1		'--control was taken
				
			ELSEIF CONT.KEY=11 THEN  		'--Enter key!
				GOSUB MMenu_Input_Number				
				
			ELSEIF CONT.KEY>=0 AND CONT.KEY<=9 THEN	'---number! 0-9
				PRINT AT 220+xpos_0, (CONT.KEY+16)*8	'-- Just print, I will read #Backtab later
				IF xpos_0=MMENU_CURSOR_POS THEN 		'--2 digits, move sprite cursor 
					xpos_0=xpos_0+1
				ELSE
					xpos_0=xpos_0-1
				END IF 
				backtabpos_1=0		'-- Stop and skip countdown
				backtabpos_3=1		'--control was taken
			END IF 			
			#xdir_0=0
		END IF
	END IF 'Cont.key=12
	
SkipCheckingControllers:

	'---Autoselect countdown----- Only start counting after scrolling to selection ---
	IF backtabpos_1<>0 AND MMenu_idx_start=0 THEN 
		IF xaccel_0=0 THEN	'-Only when counter is odd (skip every other frame)
			backtabpos_1=backtabpos_1-1
			IF backtabpos_1=1 THEN		'-Time to go?
				pri_anim=0		'-Clear flag, exit
			END IF
		END IF
	END IF
END

'-----at start, or at selection, scroll to MMenu_idx_start, slowly-------
MMenu_AutoScroll: PROCEDURE	
	IF MMenu_idx_start<>0 THEN 					'--If nonzero, scroll # number of times.
		IF xaccel_0=0 THEN					'--xaccel_0 is just a delay, see MMenu_Idx_Update
			'--"positive", decrease until zero
			IF MMenu_idx_start<64 THEN
				MMenu_idx_start=MMenu_idx_start-1
				GOSUB MMenu_Idx_Next 
			ELSE			
				'--"negative". Add until wraps from 255 to 0
				MMenu_idx_start=MMenu_idx_start+1
				GOSUB MMenu_Idx_Previous
			END IF			
		END IF
	ELSE
		'---if I entered number on keypad, I scrolled until target. Now, if autoselect is $FF, complete selection and exit.
		IF pri_anim=SCROLL_FIRST THEN pri_anim=0
	END IF
END


'---Get input numbers, convert to decimal----
MMenu_Input_Number: PROCEDURE
	'-convert chars to decimal, validate. If OK, set xpos_0=0 and MMEnu_idx
	'--Read digit: convert from STIC to digit. Char data start at bit 3 (hence /8). $7F8 strips all bits except 3-10 	
	tx=(#BACKTAB(MMENU_CURSOR_POS+220)AND $7F8)	'--Read Char from Backtab, strip/mask all except char ($7F8)
	
	'--blank means there is no input. Cant select, Enter and Up are interconnected... just ignore
	IF tx=0 THEN RETURN
	'tx=MMenu_idx+1  '--It always moves up before Enter!! Go back down! .. ok.. fail. I cannot tell if its 1 or 2
	'	IF MMenu_idx>1 THEN tx=MMenu_idx+1	
	'	GOTO MMenu_Input_IGotit
	'END IF
	
	'--- shift bits right, substract char "0" to get 0-9 
	tx=((tx/8)-"0")
	
	'--check if there is a 2nd char. 
	ty=(#BACKTAB(MMENU_CURSOR_POS+221)AND $7F8)
	IF ty<>0 THEN								'--if blank, it is only 1 digit	
		tx=(tx*10) + ((ty/8)-"0")		'--Decimal
	END IF

'MMenu_Input_IGotit:
	'--is a valid menu selection?
	IF (tx>0) AND (tx<=MMENU_MAX_ITEMS) THEN
		'---Done. I will scroll list, then select it----
		pri_anim=SCROLL_FIRST				'--Flag to indicate I want to scroll first
		MMenu_idx_start=tx-MMenu_idx	'-move down or up
	ELSE
		'--bad number, clear
		GOSUB MMenu_Reset_Input
	END IF 		
END

'--clear #Backtab digits
MMenu_Reset_Input: PROCEDURE
	xpos_0=MMENU_CURSOR_POS		'--reset cursor position 
	PRINT AT 220+xpos_0,"  "	'--clear input area
END

MMenu_Strings_Parse: PROCEDURE 
	#anim_1=0						'x=array index 
	MMEnu_Data(0)=0						'total strings
	GOSUB MMenu_GET
	'--read strings to determine length 
	DO
		#anim_1=#anim_1+1		'Array index++		
		MMEnu_Data(#anim_1)=0			'Clear length		
		
		WHILE PEEK(#ta)<>$FF							'Count until Terminator ($FF)
			MMEnu_Data(#anim_1)=MMEnu_Data(#anim_1)+1	'store ++length
			#ta=#ta+1							'address++
		WEND
		#ta=#ta+1				'next address, skip $FF
	LOOP UNTIL #anim_1=MMENU_MAX_ITEMS+1	'stop at 21. I expect terminators on all 20 items.
	
	'--first MMEnu_Data(0) with zero length is end of list
	#anim_1=1
	WHILE MMEnu_Data(#anim_1)<>0
		#anim_1=#anim_1+1
	WEND
	MMEnu_Data(0)=#anim_1-1		'Total menu items
END 

'--Print menu row to screen. 
'-- In: #anim_1=string index of starting item
MMenu_Print_Menu: PROCEDURE
	'---Menu item index is from 1 to MMENU_MAX_ITEMS. Ill add each offset to get memory address of 1st item 
	
	'--never go past last item...
	IF #anim_1<=(MMENU_MAX_ITEMS-MMENU_HEIGHT+1) THEN 
		GOSUB MMenu_GET				'---1st item address
		ty=1
		WHILE ty<#anim_1
			#ta=#ta+MMEnu_Data(ty)+1	'---address+
			ty=ty+1
		WEND
		
		'---Print all strings. 
		FOR ty=#anim_1 TO #anim_1+MMENU_HEIGHT-1							'---y starts from index			
			PRINT AT screenpos(MMENU_START_COL,MMENU_START_ROW + (ty-#anim_1))	'---new screen position (start row+0, then +1, etc)
			IF ty<=MMENU_MAX_ITEMS THEN 
				PRINT COLOR INTYMUSIC_TITLE_COLOR,<.2>ty, "."					'---do not print if past item max
						
				'---Print one string until $ff or reach width
				FOR tx=0 TO MMENU_WIDTH-1
					#tc=PEEK(#ta+tx)					'---Read char value
					IF #tc=$FF THEN EXIT FOR			'---If terminated exit, print spaces 			
					PRINT #tc*8 + INTYMUSIC_MENU_COLOR 					
				NEXT tx
			END IF 
			
			'--Print blanks if string already at end, until width 
			WHILE tx <= MMENU_WIDTH-1
				PRINT " "
				tx=tx+1
			WEND
			
			#ta=#ta+MMEnu_Data(ty)+1		'--next string. (add string length to address)		
		NEXT ty
	END IF
	IF #anim_1>=MMENU_MAX_ITEMS THEN #anim_1=MMENU_MAX_ITEMS
END				


'----Update cursor and selection sprite---
MMenu_Idx_Update: PROCEDURE 
	'--Sprite effect and color
	xaccel_0=xaccel_0+1
	IF xaccel_0>=5 THEN 			'-- frames to cycle animation 
		xaccel_0=0 						
		#anim_0=#anim_0+1	'--- change animation frame
		IF #anim_0>=MMenu_Frames THEN 	
			#anim_0=0				
			GOSUB MMenu_Check_Status_Text		'-- Change status text counter at every 42 frames or so
		END IF
	END IF 
	
	'---Color effect				
	tj=tj+1
	IF tj>=29 THEN 
		tj=0
		tk=tk+1: IF tk>=MMenu_Colors THEN tk=0
	END IF
	'--start from main color
	tl=tk	
	
	'-start GROM from main frame
	ti=#anim_0
END

'-- Change billboard text ----
MMenu_Check_Status_Text: PROCEDURE
	#p1y=#p1y+1
	IF #p1y = 1 THEN		
		IF IntyMusic=1 THEN 
			PRINT AT 221,"Use control disc:"	'-must be 17 chars or less, I avoid col0 to avoid disrupting CS_ADVANCE
		ELSE 
			PRINT AT 221,"\295\269\268\272\267\281\266\271\264\281\283\272\291\299\269\267:"
		END IF 

	ELSEIF #p1y=7 THEN	
		IF IntyMusic=1 THEN 
			PRINT AT 221,"Press any button"
		ELSE 
			PRINT AT 221,"\294\264\268\269\269\272\284\266\289\272\275\295\271\271\281\266"
		END IF 
	ELSEIF #p1y=14 THEN	
		IF IntyMusic=1 THEN 
			PRINT AT 221,"Type # and Enter"
		ELSE 
			PRINT AT 221,"\271\289\294\268\272# \284\266\291\272\268\266\271\268\264"		
		END IF 
	ELSEIF #p1y=21 THEN		
		IF IntyMusic=1 THEN 
			PRINT AT 221,"Clr moves to top"
		ELSE 
			PRINT AT 221,"\267\298\264\272\283\266\281\285\268\269\272\271\281\272\271\281\294"
		END IF 
	ELSEIF #p1y>=27 THEN
		#p1y=0
	END IF
END

'----display sprites, the big rotating thing unerneath text----
MMenu_Display_Sprites: PROCEDURE
	'--7 sprites
	FOR tx=1 TO 7	
		tl=tl+1:IF tl>=MMenu_Colors THEN tl=0
	
		'--- animated sprite, horizontal ----
		SPRITE tx,(18*tx)+23+VISIBLE+ZOOMX2,((backtabpos_2-1)*8)+ZOOMY2 ,MMenu_Block_Animation(ti)+MMenu_Color_Animation(tl)+BEHIND		
		ti=ti+1:IF ti>=MMenu_Frames THEN ti=0
	NEXT tx

	'---text cursor---- 	#p1x 	MMenu_cursor
	'Cursor is shared between text and graphical
	#p1x=#p1x+1
	IF #p1x<16 THEN
		SPRITE 0,9 + VISIBLE, ((backtabpos_2-1)*8) + ZOOMY2, MMenu_Picker_Animation(tl)+MMMenu_Cursor_Colors(tl)
	ELSE
		SPRITE 0, 8+(xpos_0 *8)+ VISIBLE, 96+ZOOMY2, (203 *8) + MMMenu_Cursor_Colors(tl) +BEHIND
		IF #p1x>=31 THEN #p1x=0
	END IF
END 

'--Sprite animation to show selection
MMenu_Animate_Selection: PROCEDURE	
	SPRITE 0,9 + VISIBLE, ((backtabpos_2-1)*8) + ZOOMY2, (8*95) + SPR_RED 
	
	FOR #ta=0 TO 6
		GOSUB MMenu_Idx_Update			
		FOR tx=1 TO 7	
			tl=tl+1:IF tl>=MMenu_Colors THEN tl=0			
			SPRITE tx,(18*tx)+23+VISIBLE+ZOOMX2,((backtabpos_2-1)*8)+ZOOMY2 ,MMenu_Select_Animation(#ta)+MMenu_Color_Select(tl)+BEHIND
			ti=ti+1:IF ti>=MMenu_Frames THEN ti=0
		NEXT tx
		WAIT:WAIT: IF NTSC=1 THEN WAIT
	NEXT #ta
END

MMenu_Select_Animation:
DATA 196*8,197*8,198*8,199*8,209*8,212*8,95*8

MMenu_Color_Select:
DATA SPR_ORANGE, SPR_PINK, SPR_PURPLE, SPR_RED

'Animated blocks
MMenu_Block_Animation:
DATA 95*8,212*8,208*8,211*8,205*8,206*8,209*8,212*8 '8

MMenu_Color_Animation:
'DATA SPR_LIGHTBLUE,SPR_GREY,SPR_CYAN,SPR_GREY	'4
DATA SPR_BLUE,SPR_LIGHTBLUE,SPR_CYAN,SPR_LIGHTBLUE

MMMenu_Cursor_Colors:
'DATA SPR_RED,SPR_PURPLE,SPR_PINK,SPR_PURPLE '4
DATA SPR_DARKGREEN,SPR_GREEN,SPR_BROWN,SPR_GREEN
'DATA SPR_RED,SPR_GREEN,SPR_BLUE,SPR_BLACK '4

MMenu_Picker_Animation:
'DATA 95*8,210*8,95*8,212*8
DATA 208*8,201*8,202*8,209*8

'DATA 196*8,197*8,198*8,199*8
'DATA 95*8,210*8,95*8,212*8 '4
'DATA 95*8,210*8,164*8,165*8 '4

'DATA SPR_DARKGREEN,SPR_GREEN,SPR_WHITE,SPR_GREEN	4
'DATA SPR_DARKGREEN,SPR_BROWN,SPR_GREEN,SPR_YELLOWGREEN,SPR_YELLOW	5
