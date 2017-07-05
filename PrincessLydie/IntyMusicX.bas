'IntyMusic by Marco A. Marrero.  Started at 7/30/2016, v8/10/2016, big revision: v10/15/2016, Thisversion 3/18/2017
'========================== Options #1 - customization ===================================================================
OPTION EXPLICIT ON

IntyMusic_Init: PROCEDURE 
	backtabpre_6 = 12	'--- PLAY VOLUME. 0=silence, 15=maximum. Also used by Volume meter
	statusDie_6=6	'--- 0=scroll only when any note changes, 1=scroll every frame (too fast!),
								'--- 2=skip one frame, 3=skip 2, etc. 255=AutoScroll (synch to music)
								'---- Large numbers will not freeze player, it always scrolls when any note plays and resets count to 0
								'---- In previous versions, it was 1 or 0. Use 4 or 5 on this version instead
	ypos_6=1	'---- INTYMUSIC_SCROLL_FROMPIANO : 0=scroll from top (as previous version), 1=scroll from bottom
	'CONST INTYMUSIC_SONG_TITLE = 1		'--- 0 to disable vertical song title

	'IntyMusicMENU.bas has its own autoselect functionality, see MMenu_idx_start=x and MMENU_AUTOSELECT = backtabpos_1=x
	#pcolor_4 = 0			'--- Stop playing song, each second should be 1.2. 0=disable
									'---  it will also automatically fade out. Btw, 72=1 minute, 144=2 minutes, etc.
	CONST INTYMUSIC_AUTOSELECT_MENU = 0	'-- Autoselect menu, 0=disable, Cannot be >255! One second=15, 75=5 seconds, etc.

	'---Debug: Letter display (C#2 B 5 D 4) instead of notes. It scrolls the opposite direction! (mimic text editor output)
	xpos_2 = 0	'<--- DEBUG_MUSIC: 0=disable, 1+ to debug, use line number of first MUSIC statement
	'---Starting value is a counter, set to line# first MUSIC statement of your text editor. (do not leave empty lines !)
	'----For example, open TypeWriter.bas in a text editor, MUSIC starts at 6, so, change xpos_2 = 6
	'-- It will also override statusDie_6 with current music speed. 


	'--- volume bar on each sound channel---
	CONST INTYMUSIC_VOLUMECARD = 42 '-- GRAM card,volume bar. 40:solid(off), 41:checkerboard, 42=Eq, 43=bandaid, 29=note, 28=thing

	CONST INTYMUSIC_STAFF_COLOR	= FG_BLACK	'-- staff color. Colors:FG_BLACK,FG_BLUE,FG_RED,FG_TAN,FG_DARKGREEN,FG_GREEN,FG_YELLOW,FG_WHITE
	'CONST INTYMUSIC_TITLE_COLOR = FG_BLUE	'---Song title Color
	'CONST INTYMUSIC_MENU_COLOR = FG_BLACK	'--- Menu color, if there is more than 1 item
	

	'----Color stack----alternating background colors. STACK_BLACK,STACK_BLUE,STACK_RED,STACK_TAN,STACK_DARKGREEN,STACK_GREEN,STACK_YELLOW,STACK_WHITE
	'STACK_GREY,STACK_CYAN,STACK_ORANGE,STACK_BROWN,STACK_PINK,STACK_LIGHTBLUE,STACK_YELLOWGREEN,STACK_PURPLE

	DIM iMusicTime(3)			' _music_tc (time base), _music_t (note count), and _music_frame (1=skipped a frame on ntsc)

	WAIT
	CLS
	BORDER BORDER_WHITE,0
	MODE 0,STACK_WHITE,STACK_TAN,STACK_WHITE,STACK_TAN
	WAIT
	DEFINE 0,16,MusicSprite0:WAIT
	DEFINE 16,16,MusicSprite16:WAIT
	DEFINE 32,16,MusicSprite32:WAIT
	DEFINE 48,8,MusicSprite48:WAIT
	total_enemies=0	'--1=quit
END 

'IntyMusicInit_Credits: PROCEDURE
	'--colors:FG_BLACK,FG_BLUE,FG_RED,FG_TAN,FG_DARKGREEN,FG_GREEN,FG_YELLOW,FG_WHITE
	'20 char max 1234567890123456789.  80+(half row)-(half of text length)
	'PRINT COLOR FG_BLACK
	'PRINT AT 80+10-2,"Song"
	'PRINT COLOR FG_DARKGREEN
	'PRINT AT 100+10-6,"demonstration"
	'PRINT COLOR FG_GREEN
	'PRINT AT 120+10-4,""
'END	
'===============================================================================
IntyMusic_Menu_Select: PROCEDURE
	WAIT:CLS:GOSUB DrawMainScreen:GOSUB DrawFanFoldBorder	
	
	'---If there is only one, just play it w/o showing menu. And does not disable credits after song ends.	
	IF MMENU_MAX_ITEMS=1 THEN
		MMenu_idx_start=1
		xpos_3=1				'<--- iMusicSelection
		xpos_1=0				'<--- 
	ELSE
	'---Autoselect last entry, go to next song ----
		MMenu_idx_start=MMEnu_idx
		
		IF backtabpos_3=0 THEN
			PRINT AT 15 COLOR FG_GREEN,"Auto"
			IF MMenu_idx_start<>0 THEN MMenu_idx_start=MMenu_idx_start+1:IF MMenu_idx_start>MMENU_MAX_ITEMS THEN MMenu_idx_start=0
			backtabpos_1=INTYMUSIC_AUTOSELECT_MENU		'<-- delay before auto-selecting
		ELSE
			backtabpos_1=0
			#pcolor_4=0
		END IF
		GOSUB MMenu_Show
		xpos_3= MMEnu_idx
	END IF	

	'--Selection done. Play song-----
	xpos_3=xpos_3-1	'--Selection must start at 0..
	PLAY FULL
	PLAY VOLUME backtabpre_6	'--Ready to play	
	WAIT

	ON xpos_3 GOTO Song01,Song02,Song03,Song04,Song05,Song06,Song07,Song08,Song09,Song10,Song11,Song12,Song13,Song14,Song15,Song16,Song17,Song18,Song19,Song20,Song21

	Song01: total_enemies=1:RETURN	'--exit
	Song02: #P1x=VARPTR MyMusicTitle01(0):GOSUB IntyMusic_CopySongTitle:PLAY MyMusic:RETURN
	Song03: #P1x=VARPTR MyMusicTitle02(0):GOSUB IntyMusic_CopySongTitle:PLAY MyMusic02:RETURN
	Song04: #P1x=VARPTR MyMusicTitle03(0):GOSUB IntyMusic_CopySongTitle:PLAY MyMusic03:RETURN
	Song05: #P1x=VARPTR MyMusicTitle04(0):GOSUB IntyMusic_CopySongTitle:PLAY MyMusic04:RETURN
	Song06: #P1x=VARPTR MyMusicTitle05(0):GOSUB IntyMusic_CopySongTitle:PLAY MyMusic05:RETURN
	Song07: #P1x=VARPTR MyMusicTitle06(0):GOSUB IntyMusic_CopySongTitle:PLAY MyMusic06:RETURN
	Song08: #P1x=VARPTR MyMusicTitle07(0):GOSUB IntyMusic_CopySongTitle:PLAY MyMusic07:RETURN
	Song09: #P1x=VARPTR MyMusicTitle08(0):GOSUB IntyMusic_CopySongTitle:PLAY MyMusic08:RETURN
	Song10: #P1x=VARPTR MyMusicTitle09(0):GOSUB IntyMusic_CopySongTitle:PLAY MyMusic09:RETURN
	Song11: #P1x=VARPTR MyMusicTitle10(0):GOSUB IntyMusic_CopySongTitle:PLAY MyMusic10:RETURN
	Song12: #P1x=VARPTR MyMusicTitle11(0):GOSUB IntyMusic_CopySongTitle:PLAY MyMusic11:RETURN
	Song13: #P1x=VARPTR MyMusicTitle12(0):GOSUB IntyMusic_CopySongTitle:PLAY MyMusic12:RETURN
	Song14: #P1x=VARPTR MyMusicTitle13(0):GOSUB IntyMusic_CopySongTitle:PLAY MyMusic13:RETURN
	Song15: #P1x=VARPTR MyMusicTitle14(0):GOSUB IntyMusic_CopySongTitle:PLAY MyMusic14:RETURN
	Song16: #P1x=VARPTR MyMusicTitle15(0):GOSUB IntyMusic_CopySongTitle:PLAY MyMusic15:RETURN
	Song17: #P1x=VARPTR MyMusicTitle16(0):GOSUB IntyMusic_CopySongTitle:PLAY MyMusic16:RETURN
	Song18: #P1x=VARPTR MyMusicTitle17(0):GOSUB IntyMusic_CopySongTitle:PLAY MyMusic17:RETURN
	Song19: #P1x=VARPTR MyMusicTitle18(0):GOSUB IntyMusic_CopySongTitle:PLAY MyMusic18:RETURN
	Song20: #P1x=VARPTR MyMusicTitle19(0):GOSUB IntyMusic_CopySongTitle:PLAY MyMusic19:RETURN
	Song21: #P1x=VARPTR MyMusicTitle20(0):GOSUB IntyMusic_CopySongTitle:PLAY MyMusic20:RETURN
END

'Copy song title to buffer
IntyMusic_CopySongTitle: PROCEDURE	
	IF PEEK(#P1x)="*" THEN #P1x=VARPTR MyDefaultName(0)	'-if it is *, pick default name
	FOR state_scrollx=0 TO 11	'Read, if $FF, pad rest with spaces
		state_scrolly=PEEK(#P1x):IF state_scrolly=$FF THEN state_scrolly=" " ELSE #P1x=#P1x+1
		MMEnu_Data(state_scrollx)=state_scrolly
	NEXT state_scrollx	
	statusWait_6=6:GOSUB ScrollStaffToStartPlay
END

MyDefaultName:
DATA " IntyMusic",$FF	'--Default name. 12 characters MAX. Use $FF to terminate (space IS zero!!)

'IntyMusic by Marco A. Marrero.
'IntyMusic_Player.bas | Main code.
'Public domain, feel free to use/modify. Feel free to contact me in the Intellivision Programming forum @ AtariAge.com

'--- arrays used to copy values from IntyBasic music player, in IntyBasic_epilogue.asm, 3 voices/sound channels -----
DIM iMusicNote(3)			'Notes 0,1,2	(from IntyBasic_epilogue)
DIM iMusicVol(3)			'Volume (from IntyBasic_epilogue)
DIM iMusicWaveForm(3)		'Waveform. Will hit 1 for new notes.
DIM iMusicVolumeLast(3)		'store last volume values
DIM iMusicDrawNote(3)		'Draw new note, by voice channel

'========================================================================== Play ========================
INTYMUSIC_PlayNow: PROCEDURE
GOSUB IntyMusic_Init

'--This one has 3 timing/counter variables from IntyBasic_epilogue---
statusEtc_5 = 0:statusEtc_6 = 1:statusEtc_4 = 2

'DIM MMEnu_Data(12)		'Song name, displayed vertically

xpos_3=1			'Menu initial selection
xpos_1=0			'Show credits at start
xpos_4=0			'To verify if MUSIC.PLAY=0 is really what happened... MUSIC JUMP can cause it!

'====================== RESET =========================================
IntyMusicReset:

'----show title screen and credits- once -- also prints vertical song name ---
#pcolor_2=CS_ADVANCE 

IF xpos_1=0 THEN 
	'GOSUB IntyMusicCredits
	'GOSUB AnyKey	
	'statusWait_6=5:GOSUB ScrollStaffToStartPlay
	xpos_1=1
END IF 

'--Volume, and graph display----
IF backtabpre_6<2 OR backtabpre_6>15 THEN backtabpre_6=15	'-- Volume must be 2 to 15..
#xdir_6 = (INTYMUSIC_VOLUMECARD*8) + 2048				'--GRAM card for volume: 40, 41 or 43 for volume bar. I prefer 43.
#ypos_0 = 97+12 -(15-backtabpre_6) + ZOOMY2	'-- 14 seems too low, 13 is ok, 12 touches piano noticeably, etc.
statusOK_6=backtabpre_6	'Ill use this to fade music 

'--Debug mode-----
#xdir_5=xpos_2

'---50Hz frame counter. Used to autostop song ----
Frame8=0
#pcolor_3=1

#pcolor_5=#pcolor_4					'--do not forget autostop value
IF #xdir_5<>0 THEN ypos_6=1	'--always scroll backwards in List Mode
FOR #pcolor_7=0 TO 2:iMusicDrawNote(#pcolor_7)=0:NEXT #pcolor_7	'--clear notes to play

'==== PLAY! ====
GOSUB MMenu_Strings_Parse	'--reset IntyMusic menu strings. I'm using VAR on player itself...
WAIT
GOSUB IntyMusic_Menu_Select: if total_enemies<>0 then RETURN
'----init----
BadType_6=0			'Need to scroll screen?
ypos_5=0		'Scroll counter
state_moved_6=0

backtabpos_6=1					'Piano hilite index, 0 or 1 (Ill XOR it later)

'-- Get and change scroll speed if #xdir_5 is enabled, or AutoScroll=255
IF #xdir_5<>0 OR statusDie_6=255 THEN 
	CALL IMUSICGETINFOV2(VARPTR iMusicVol(0), VARPTR iMusicNote(0), VARPTR iMusicWaveForm(0),VARPTR iMusicTime(0))
	statusDie_6=iMusicTime(statusEtc_5)	'_music_t (time base)
END IF

'---- main loop -----
PlayLoop:
	WAIT 

	'--- The BadType_6 is modified in ON FRAME GOSUB... code is in DoStuffAfterWait: PROCEDURE ---
	IF BadType_6<>0 THEN	
	
		'Scroll... I am only moving part of the screen to avoid redrawing
		'IF ypos_6=0 THEN CALL MUSICSCROLL ELSE CALL MUSICSCROLLUP
		CALL MUSICSCROLLX(ypos_6)
		BadType_6=0
		
		'---Alternate colors if enabled---
		#BACKTAB(0)=#pcolor_2:#BACKTAB(220)=#pcolor_2			
		PRINT AT 221		'<--- Do NOT remove! 	
		
		'---Draw letter, C3# A4 B5-----	
		FOR state_eye_erase_6=0 TO 2
			BadType_1=iMusicNote(state_eye_erase_6)	'--Get note value, look-up tables 
			#P1x=iMusicNoteColor(state_eye_erase_6)	'Get note color
			
			PRINT 2280+iMusicDrawNote(state_eye_erase_6)				'---Note, blink if it is a new note 
			PRINT #xdir_6+iMusicPianoColorB(state_eye_erase_6)		'---Volume meter, background (Color is Hilite color of piano key)
			PRINT BadType_1Letter(BadType_1)+#P1x				'---Note letter (CDEFGAB)
			PRINT BadType_1Sharp(BadType_1)+#P1x				'---Sharp?
			PRINT BadType_1Octave(BadType_1)+#P1x,0			'---Octave number, space (0)
		NEXT state_eye_erase_6

		'====List mode=======
		IF #xdir_5<>0 THEN
			PRINT AT 181 COLOR 0, <.5>#xdir_5,0	'-- Line number			
			
			FOR state_eye_erase_6=0 TO 2								
				'--If playing, Get note value, look-up tables.		
				IF iMusicDrawNote(state_eye_erase_6)=0 THEN BadType_1=0 ELSE BadType_1=iMusicNote(state_eye_erase_6)	
				#P1x=iMusicNoteColor(state_eye_erase_6)
				
				PRINT BadType_1Letter(BadType_1)+#P1x		'---Note letter (CDEFGAB)
				PRINT BadType_1Sharp(BadType_1)+#P1x		'---Sharp?
				PRINT BadType_1Octave(BadType_1)+#P1x,0	'---Octave number, space (0)
			NEXT state_eye_erase_6
			#xdir_5=#xdir_5+1		'---line counter
			
		
		'====Print notes=====
		ELSE 
			IF ypos_6=0 THEN 
				state_scrolly=0 	'--draw at top 
			ELSE
				state_scrolly=180	'--draw at bottom
			END IF 
			'----Done updating lower screen. Clear top line, draw staff---
			FOR state_scrollx=1 TO 18
				#BACKTAB(state_scrollx+state_scrolly)=BadType_1BlankLine(state_scrollx)	+ INTYMUSIC_STAFF_COLOR
			NEXT state_scrollx
			
			FOR state_eye_erase_6=0 TO 2
				BadType_1=iMusicNote(state_eye_erase_6)	'--Get note 
		
				'---Draw Note. Up to 2 notes per card. I used spreadsheet for lookup data: GRAM card, position, offset, etc.--
				IF iMusicDrawNote(state_eye_erase_6) THEN 
					#BACKTAB(BadType_1Onscreen(BadType_1)+state_scrolly)=BadType_1GRAM(BadType_1) + iMusicNoteColor(state_eye_erase_6)									
				END IF
			NEXT state_eye_erase_6
		
		END IF '--List Mode
				
		'---Use MusicSprites to "hilite" piano keys and draw notes-----
		backtabpos_6=backtabpos_6 XOR 1	'backtabpos_6 piano key hilite, 1 or 0
		FOR state_eye_erase_6=0 TO 2
			BadType_1=iMusicNote(state_eye_erase_6)	'--Get note 
			
			'---Overlay MusicSprites on piano keys. Flash colors---
			IF backtabpos_6 THEN #P1x=iMusicPianoColorA(state_eye_erase_6) ELSE #P1x=iMusicPianoColorB(state_eye_erase_6)				
			IF iMusicVol(state_eye_erase_6)=0 THEN
				resetSprite(state_eye_erase_6)
			ELSE
				SPRITE state_eye_erase_6,16 + VISIBLE + IntyPianoMusicSpriteOffset(BadType_1),88 + ZOOMY2, IntyPianoMusicSprite(BadType_1) + #P1x
			END IF		

			'----CLEAR MUSIC Note playing indicator-------
			iMusicDrawNote(state_eye_erase_6)=0
		NEXT state_eye_erase_6
	END IF '<--iMusicTime
	
	'---Update volume MusicSprite.. It just moves offscreen instead of changing shape --- 
	state_scrollx=8
	FOR state_eye_erase_6=0 TO 2
		'Volume meter...
		SPRITE state_eye_erase_6+5,16 + VISIBLE + state_scrollx,(#ypos_0-iMusicVol(state_eye_erase_6))+ZOOMY2, SPR40 + BEHIND + iMusicPianoColorA(state_eye_erase_6) 
		state_scrollx=state_scrollx+48		
	NEXT state_eye_erase_6	
	
	'---- Clr: user reset----
	IF Cont.KEY=12 THEN 
		state_moved_6=1
	ELSE		
		IF state_moved_6=1 THEN 			
			IF Cont.KEY=10 THEN 	'CLR key
				IF #pcolor_4<>1 THEN		'--fade out. Make it a bit faster too...
					#pcolor_4=1
					statusOK_6=statusOK_6-5: IF statusOK_6<5 THEN statusOK_6=5
				END IF
				state_moved_6=0
			END IF			
		END IF		
	END IF	
	
	'---Check Autostop, if reached, fade out, then exit----
	IF #pcolor_4>0 THEN
		IF #pcolor_3>#pcolor_4 THEN
			IF (#pcolor_3 AND 1) THEN					'--only on odd periods (fade every other frame)
				IF statusOK_6>2 THEN 				
					statusOK_6=statusOK_6-1	'--fade out
					PLAY VOLUME statusOK_6
				ELSE
					#pcolor_4=#pcolor_5
					GOTO KillMusicAndRestart
				END IF
			END IF
		END IF
	END IF
	
	'----Music stop?--- MUSIC JUMP causes a momentary STOP!! countdown first!!--
	IF MUSIC.PLAYING=0 THEN
		xpos_4=xpos_4+1
		IF xpos_4>30 THEN 
			GOTO KillMusicAndRestart
		END IF
	ELSE
		xpos_4=0
	END IF
GOTO PlayLoop

'---Forcefully kills music
KillMusicAndRestart:
	WAIT:PLAY OFF						
	WAIT:SOUND 0,1,0:	SOUND 1,1,0:	SOUND 2,1,0:SOUND 4,1,$38
	CALL IMUSICKILL	'works too well...
GOTO IntyMusicReset
END

'**********************************************************************
'== Assembly language routines ========================================
'    _______________
'___/ IMUSICGETINFO2 \_________________________________________________
'Get IntyBasic_epilogue data onto IntyBasic. Ill copy note, volume, and timing variables
'Call IMUSICGETINFO(VARPTR iMusicVol(0-2), VARPTR iMusicNote(0-2), VARPTR iMusicWaveform(0-2),VARPTR iMusicTime(0-3))	
ASM IMUSICGETINFOV2: PROC	
'r0 = 1st parameter, VARPTR iMusicVol(0 to 2)
'r1 = 2nd parameter, VARPTR iMusicNote(0 to 2)
'r2 = 3rd parameter, VARPTR iMusicWaveform(0 to 2)
'r3 = 4rd parameter, VARPTR iMusicTime(0 to 2), statusEtc_5 = 0,statusEtc_6 = 1,statusEtc_4 = 2
'asm pshr r5				;push return
		
'--- iMusicTime(0)=_music_t (Time Base),iMusicTime(1)=_music_tc (note time), iMusicTime(2)=_music_frame (0 to 5) 0=skipped frame!
	asm movr	r3,r4				; r3 --> r4 		r4=&iMusicTime(0)
	asm mvi _music_t,r3			; _music_t --> r3 (time base)
'----nooo-	asm decr r3 					; r3-- (time base=time base)
	asm mvo@ r3,r4				; r3 --> [r4++]	
	
	asm mvi	_music_tc,r3			; _music_tc --> r3 (time)	
	asm mvo@ r3,r4				; r3 --> [r4++]

	asm mvi	_music_frame,r3		; _music_frame --> r3 (time, 0 to 5). In pal, it should be always zero...
	asm add	_ntsc,r3				; if NTSC then r3++ (time is now 1 to 6, now I can test if it is 1 when skipped)
	asm mvo@ r3,r4				; r3 --> [r4++]
	
	asm cmpi #1,r3				; if (r3==1) then music skipped! We already have all the values, no need to re-read
	asm beq @@GoodBye		

'---- get volume, to know when same note played again ---
	asm movr	r0,r4			;r0 --> r4 (r4=r0=&iMusicVol(0))
	
	asm mvi	_music_vol1,r3	;  --> r3
	asm mvo@ r3,r4			;r3 --> [r4++]
	asm mvi	_music_vol2,r3	; --> r3
	asm mvo@ r3,r4			;r3 --> [r4++]
	asm mvi	_music_vol3,r3	; --> r3
	asm mvo@ r3,r4			;r3 --> [r4++]
	
'--- get notes ---
	asm movr	r1,r4			;r1 --> r4. (r4=&iMusicNote(0))
	asm mvi	_music_n1,r3		;_music_n1 --> r3
	asm mvo@ r3,r4			;r3 --> [r4++]
	asm mvi	_music_n2,r3 	;_music_n2 --> r3
	asm mvo@ r3,r4			;r3 --> [r4++]
	asm mvi	_music_n3,r3		;_music_n3 --> r3
	asm mvo@ r3,r4			;r3 --> [r4++]

'--- Get WaveForm (to detect if same note went again) ----iMusicWaveform(x) ----
	asm movr r2,r4				;r2 --> r4  (r4= &iMusicWaveform(0))
	asm mvi _music_s1,r3
	asm mvo@ r3,r4				; r3 --> [r4++]
	asm mvi _music_s2,r3
	asm mvo@ r3,r4				; r3 --> [r4++]
	asm mvi _music_s3,r3
	asm mvo@ r3,r4				; r3 --> [r4++]

'-------------------------------------------------------------	
asm @@GoodBye:
	asm jr	r5				;return 
asm ENDP


'    ____________
'___/ MUSICSCROLL \____________________ 
'Only Scroll 10 rows, and only columns 2 to 18 (17 lines). 
'Copying from bottom to top, I am guessing it is better in case VBLANK is over and screen refreshes while copying...
'r0 = 1st parameter, 0=DOWN, 1=UP
ASM MUSICSCROLLX: PROC	
	asm mvii #9,r1				;Loop 9 lines
	
	asm tstr r0
	asm bne @@goup

asm @@godown:	
	asm mvii #2,r4				;Skip 2 chars

	asm mvii #$0200 + 198,r2		;#BackTAB + 198--> R2
	asm mvii	#$0200 + 178,r3		;Line above --> r3 
	asm b @@CopyLoop
	
asm @@goup:
	asm mvii #$0200+18,r2			;Rightmost char row 0, #BackTAB+18 --> R2
	asm mvii	#$0200+18+20,r3		;Line BELOW --> r3 

	asm mvii #$FFDA,r4			;"Skip 2 chars". Substract -38: 20+20-2=38... LineAlreadySubstracted+NextLine-CharsToSkip
	
asm @@CopyLoop:
	asm REPEAT 18
		asm mvi@ r3,r0		;[r3] --> R0
		asm decr r3
		asm mvo@ r0,r2		;r0 --> [R2]		
		asm decr r2 
	asm ENDR
	
	asm subr r4,r2			;skip 2 chars 
	asm subr r4,r3 
	
	asm decr r1			;done row..
	asm bne @@CopyLoop
	
	asm jr	r5				;return
asm ENDP		


'    ____________
'___/ IMUSICKILL \___________________________
'PLAY NONE seems not to work.... This kills IntyBasic musis player notes. I wonder if I should also clear other things
ASM IMUSICKILL: PROC	
		
'--- kill notes ---
	asm xorr r0,r0			;clear r0
	asm mvo	r0,_music_n1
	asm mvo	r0,_music_n2
	asm mvo 	r0,_music_n3
	asm jr	r5				;return 
asm ENDP

'**********************************************************************
'=========IntyMusic credits/title screen================



IntyMusicCredits: PROCEDURE
	FOR #P1x=0 TO 7:resetSprite(#P1x):NEXT #P1x
	CLS
	WAIT
	GOSUB DrawMainScreen
	'---me---		
	'PRINT AT 160 COLOR FG_BLUE,"\285"
	'PRINT COLOR FG_BLACK," IntyMusic Player "
	'PRINT COLOR FG_BLUE,"\286"
	'PRINT AT 182 COLOR FG_BLACK,"by Marco Marrero"
	'GOSUB IntyMusicInit_Credits
	BadType_7=18:GOSUB DrawPianoX			
	'PRINT AT 221 COLOR FG_BLUE,"Any button to play"
	'PRINT AT 0	
	GOSUB DrawFanFoldBorder	
END

DrawMainScreen: PROCEDURE
	state_scrollx=0			
	'--draw a bit of the staff	
	FOR #P1x=0 TO 3*20
		#BACKTAB(#P1x)=BadType_1BlankLine(state_scrollx)	+ INTYMUSIC_STAFF_COLOR
		state_scrollx=state_scrollx+1:IF state_scrollx>19 THEN state_scrollx=0
	NEXT #P1x

	'Draw &
	PRINT AT 9 COLOR 0,"\277\269\272\261"
	PRINT AT 29,"\278\270\273\262"
	
	'draw )
	PRINT AT 5,"\271\263"
	PRINT AT 25,"\273\262"
	PRINT AT 46,"\279"

	BadType_7=19:GOSUB DrawPianoX	'Draw all 20 piano keys
END

DrawFanFoldBorder: PROCEDURE
	state_scrollx=0
	FOR state_moved_6=1 TO 10
		#BACKTAB(state_scrollx)=#BACKTAB(state_scrollx)+#pcolor_2
		state_scrollx=state_scrollx+20
	NEXT state_moved_6		
END

'----
DrawPianoX: PROCEDURE			'- Draw piano, clear bottom lines 1st---
	FOR #P1x=0 TO BadType_7
		#BACKTAB(200+#P1x)= IntyPiano(#P1x)		
	NEXT #P1x		
	
	#BACKTAB(220)=#pcolor_2
	FOR #P1x=221 TO 238 
		#BACKTAB(#P1x)= 0
	NEXT #P1x	
END

'--Scroll staff, slowly, used before playing song. Also print song title.
ScrollStaffToStartPlay: PROCEDURE		
	FOR state_scrollx=1 TO 12				
		WAIT				
		CALL SCROLLDOWNX(BACKTAB_ADDR+240-20,11)
		'CALL SCROLLUPX(BACKTAB_ADDR,11)
		BadType_7=18:GOSUB DrawPianoX
				
		#BACKTAB(0)=#pcolor_2
		FOR #P1x=1 TO 19
			#BACKTAB(#P1x)=BadType_1BlankLine(#P1x)	+ INTYMUSIC_STAFF_COLOR
		NEXT #P1x	
				
		'Print song name -- I am scrolling so I am printing one char at a time...
		'IF INTYMUSIC_SONG_TITLE THEN 
			'#BACKTAB(19)=MMEnu_Data(12-state_scrollx)*8 + INTYMUSIC_TITLE_COLOR	
			#BACKTAB(19)=MMenu_Data_Hint(12-state_scrollx)*8 + INTYMUSIC_TITLE_COLOR	
			
			IF state_scrollx<10 THEN
				#BACKTAB(239)=0
			ELSEIF state_scrollx=10 THEN 				
				#BACKTAB(219)=0		'Stop drawing all piano keys when title is nearby			
				#BACKTAB(239)=0
			END IF
		'END IF
			
		'sleep...		
		IF statusWait_6>0 THEN FOR #P1x=1 TO statusWait_6: WAIT:NEXT #P1x
	NEXT state_scrollx 
END

MMenu_Data_Hint: 
'     123456789012
DATA "Clr to stop ",$FF

'============== IntyMusic Look-up values ==============================
'-------
'IntyBasic notes are values from 1 to 61, C2 to C7. In most of these first value is dummy, notes start from 1-18
'To understand all these values, look at the spreadsheet, it mostly documents what I am trying to documents
'It also helps a lot understanding how STIC MusicSprites and GRAM cards work, see http://wiki.intellivision.us/index.php?title=STIC
'

'---Note relative to screen (1-18). 2 notes per card, FIRST ENTRY IS DUMMY (duplicated 1st value) (Btw, I am shouting at myself, I keep forgetting what I did...)
BadType_1Onscreen:
DATA 1,1,1,1,1,2,2,2,3,3,3,3,4,4,4,5,5,5,6,6,6,6,7,7,7,8,8,8,8,9,9,9,10,10,10,10,11,11,11,12,12,12,13,13,13,13,14,14,14,15,15,15,15,16,16,16,17,17,17,17,18,18,18,18

'--Note Alpha/letter... was GROM card values. C,D,E,F,G,A or B etc..  no # here. FIRST ENTRY IS DUMMY, 0
'--Now its a GRAM Card... (MusicSprite 32+(letter A=0) *8)+bit11 (2048)
BadType_1Letter:
DATA 0,2320,2320,2328,2328,2336,2344,2344,2352,2352,2304,2304,2312,2320,2320,2328,2328,2336,2344,2344,2352,2352,2304,2304,2312,2320,2320,2328,2328,2336,2344,2344,2352,2352,2304,2304,2312,2320,2320,2328,2328,2336,2344,2344,2352,2352,2304,2304,2312,2320,2320,2328,2328,2336,2344,2344,2352,2352,2304,2304,2312,2320,2320,2320

'--Sharp notes, according to value. 24=GROM Card #. FIRST ENTRY IS DUMMY
BadType_1Sharp:
'DATA " "," ","#"," ","#"," "," ","#"," ","#"," ","#"," "," ","#"," ","#"," "," ","#"," ","#"," ","#"," "," ","#"," ","#"," "," ","#"," ","#"," ","#"," "," ","#"," ","#"," "," ","#"," ","#"," ","#"," "," ","#"," ","#"," "," ","#"," ","#"," ","#"," "," "
'DATA 0,0,24,0,24,0,0,24,0,24,0,24,0,0,24,0,24,0,0,24,0,24,0,24,0,0,24,0,24,0,0,24,0,24,0,24,0,0,24,0,24,0,0,24,0,24,0,24,0,0,24,0,24,0,0,24,0,24,0,24,0
'---Now its a GRAM card... MusicSprite 39*8 + bit11 (2048)
DATA 0,0,2360,0,2360,0,0,2360,0,2360,0,2360,0,0,2360,0,2360,0,0,2360,0,2360,0,2360,0,0,2360,0,2360,0,0,2360,0,2360,0,2360,0,0,2360,0,2360,0,0,2360,0,2360,0,2360,0,0,2360,0,2360,0,0,2360,0,2360,0,2360,0,0,0

'--- Ocatave according to note value, =(Octave*8)+(16*8) = GROM card # for 2,3,4,5,6,7-- FIRST DATA IS DUMMY
BadType_1Octave:
'DATA 0,144,144,144,144,144,144,144,144,144,144,144,144,152,152,152,152,152,152,152,152,152,152,152,152,160,160,160,160,160,160,160,160,160,160,160,160,168,168,168,168,168,168,168,168,168,168,168,168,176,176,176,176,176,176,176,176,176,176,176,176,184
'---Now its a GRAM card... Starting from MusicSprite 48*8 + bit11 (2048). FIRST VALUE IS DUMMY
DATA 0,2432,2432,2432,2432,2432,2432,2432,2432,2432,2432,2432,2432,2440,2440,2440,2440,2440,2440,2440,2440,2440,2440,2440,2440,2448,2448,2448,2448,2448,2448,2448,2448,2448,2448,2448,2448,2456,2456,2456,2456,2456,2456,2456,2456,2456,2456,2456,2456,2464,2464,2464,2464,2464,2464,2464,2464,2464,2464,2464,2464,2472,2472

'--GRAM Card to use------- Positioned horizontally -----
'I combined GRAM cards. 2 notes per card. I wont display adjacent notes, only 1 will be shown. FIRST VALUE IS DUMMY
BadType_1GRAM:
DATA 2056,2056,2072,2064,2080,2056,2064,2080,2056,2072,2064,2080,2056,2064,2080,2056,2072,2064,2056,2072,2064,2080,2056,2072,2064,2056,2072,2064,2080,2056,2064,2080,2056,2072,2064,2080,2056,2064,2080,2056,2072,2056,2056,2072,2064,2080,2056,2072,2064,2056,2072,2064,2080,2056,2064,2080,2056,2072,2064,2080,2056,2064

'-used to draw top of display, with vertical lines
BadType_1BlankLine:
DATA 0,0,0,2048,2048,2048,2048,2048,0,2048,2048,2048,2048,2048,0,0,0,0,0,0,0,0

'----Piano! GRAM+(MusicSprite24*8),GRAM+(MusicSprite25*8), etc-----
'There are 2 1/2 key per GRAM card for the piano, 4 different MusicSprites for hilite. 7 combinations 2 octaves...
'GRAM cards: CD,EF,GA,BC*,DE*,FG*,AB.  (*=same cards as EF,AB,CD). See source image to understand what all this means.
IntyPiano:
'2272= Char284 * 8
DATA 2272,2208,2192,2200,2192,2296,2208,2296,2208,2192,2200,2192,2296,2208,2296,2208,2192,2200,2192,2296,2208,2208,2208

'MusicSprite to show. 1st one is not dummy, but it wont be played. 
IntyPianoMusicSprite:
DATA 2264,2248,2240,2256,2240,2264,2248,2240,2256,2240,2256,2240,2264,2248,2240,2256,2240,2264,2248,2240,2256,2240,2256,2240,2264,2248,2240,2256,2240,2264,2248,2240,2256,2240,2256,2240,2264,2248,2240,2256,2240,2264,2248,2240,2256,2240,2256,2240,2264,2248,2240,2256,2240,2264,2248,2240,2256,2240,2256,2240,2264,2248,2240,2256,2240,2264,2264

'Key offstet position... on the source spreadsheet its a row of offsets (0-7) + card position (0,8,16,etc)
'In the source image, I drew all possibilities, and practically had to count pixels to get the correct offset.
IntyPianoMusicSpriteOffset:
DATA 4,0,2,4,6,8,12,14,16,18,20,22,24,28,30,32,34,36,40,42,44,46,48,50,52,56,58,60,62,64,68,70,72,74,76,78,80,84,86,88,90,92,96,98,100,102,104,106,108,112,114,116,118,120,124,126,128,130,132,134,136,140,142,144,146,148,152,154,156

'**********************************************************************
'============== IntyMusic graphics ==============================
'---- IntyMusic5.png --- Saturday, October 1, 2016

'===MusicSprite:0 == Chr:256===== [8,8]
MusicSprite0:
	BITMAP ".#......"	'$40
	BITMAP ".#......"	'$40
	BITMAP ".#......"	'$40
	BITMAP ".#......"	'$40
	BITMAP ".#......"	'$40
	BITMAP ".#......"	'$40
	BITMAP ".#......"	'$40
	BITMAP ".#......"	'$40

'===MusicSprite:1 == Chr:257===== [8,8]
'MusicSprite1:
	BITMAP ".#.#...."	'$50
	BITMAP ".#.#...."	'$50
	BITMAP ".#.#...."	'$50
	BITMAP ".#.#...."	'$50
	BITMAP ".###...."	'$70
	BITMAP "####...."	'$F0
	BITMAP "####...."	'$F0
	BITMAP ".##....."	'$60

'===MusicSprite:2 == Chr:258===== [8,8]
'MusicSprite2:
	BITMAP ".#....#."	'$42
	BITMAP ".#....#."	'$42
	BITMAP ".#....#."	'$42
	BITMAP ".#....#."	'$42
	BITMAP ".#..###."	'$4E
	BITMAP ".#.####."	'$5E
	BITMAP ".#.####."	'$5E
	BITMAP ".#..##.."	'$4C

'===MusicSprite:3 == Chr:259===== [8,8]
'MusicSprite3:
	BITMAP ".#.#...."	'$50
	BITMAP ".#.#..#."	'$52
	BITMAP ".#.#.#.#"	'$55
	BITMAP ".#.#..#."	'$52
	BITMAP ".###...."	'$70
	BITMAP "####...."	'$F0
	BITMAP "####...."	'$F0
	BITMAP ".##....."	'$60

'===MusicSprite:4 == Chr:260===== [8,8]
'MusicSprite4:
	BITMAP ".#....#."	'$42
	BITMAP ".#.#..#."	'$52
	BITMAP ".##.#.#."	'$6A
	BITMAP ".#.#..#."	'$52
	BITMAP ".#..###."	'$4E
	BITMAP ".#.####."	'$5E
	BITMAP ".#.####."	'$5E
	BITMAP ".#..##.."	'$4C

'===MusicSprite:5 == Chr:261===== [8,8]
'MusicSprite5:
	BITMAP "........"	'$00
	BITMAP "........"	'$00
	BITMAP "........"	'$00
	BITMAP "........"	'$00
	BITMAP ".###...."	'$70
	BITMAP "#####..."	'$F8
	BITMAP "#..###.."	'$9C
	BITMAP "....###."	'$0E

'===MusicSprite:6 == Chr:262===== [8,8]
'MusicSprite6:
	BITMAP "......##"	'$03
	BITMAP "......##"	'$03
	BITMAP "#...####"	'$8F
	BITMAP "#######."	'$FE
	BITMAP "######.."	'$FC
	BITMAP ".####..."	'$78
	BITMAP "........"	'$00
	BITMAP "........"	'$00

'===MusicSprite:7 == Chr:263===== [8,8]
'MusicSprite7:
	BITMAP "........"	'$00
	BITMAP ".####..."	'$78
	BITMAP "######.."	'$FC
	BITMAP "#######."	'$FE
	BITMAP "###.####"	'$EF
	BITMAP "##...###"	'$C7
	BITMAP "##....##"	'$C3
	BITMAP "#.....##"	'$83

'===MusicSprite:8 == Chr:264===== [8,8]
'MusicSprite8:
	BITMAP "........"	'$00
	BITMAP "........"	'$00
	BITMAP "........"	'$00
	BITMAP "#.#.#.#."
	BITMAP "........"	'$00
	BITMAP "........"	'$00
	BITMAP "........"	'$00
	BITMAP "........"	'$00

'===MusicSprite:9 == Chr:265===== [8,8]
'MusicSprite9:
	BITMAP "...#...."	'$10
	BITMAP "...#...."	'$10
	BITMAP "...#...."	'$10
	BITMAP "...#...."	'$10
	BITMAP ".###...."	'$70
	BITMAP "####...."	'$F0
	BITMAP "####...."	'$F0
	BITMAP ".##....."	'$60

'===MusicSprite:10 == Chr:266===== [8,8]
'MusicSprite10:
	BITMAP "......#."	'$02
	BITMAP "......#."	'$02
	BITMAP "......#."	'$02
	BITMAP "......#."	'$02
	BITMAP "....###."	'$0E
	BITMAP "...####."	'$1E
	BITMAP "...####."	'$1E
	BITMAP "....##.."	'$0C

'===MusicSprite:11 == Chr:267===== [8,8]
'MusicSprite11:
	BITMAP "...#...."	'$10
	BITMAP "...#..#."	'$12
	BITMAP "...#.#.#"	'$15
	BITMAP "...#..#."	'$12
	BITMAP ".###...."	'$70
	BITMAP "####...."	'$F0
	BITMAP "####...."	'$F0
	BITMAP ".##....."	'$60

'===MusicSprite:12 == Chr:268===== [8,8]
'MusicSprite12:
	BITMAP "......#."	'$02
	BITMAP "..#...#."	'$22
	BITMAP ".#.#..#."	'$52
	BITMAP "..#...#."	'$22
	BITMAP "....###."	'$0E
	BITMAP "...####."	'$1E
	BITMAP "...####."	'$1E
	BITMAP "....##.."	'$0C

'===MusicSprite:13 == Chr:269===== [8,8]
'MusicSprite13:
	BITMAP "...#####"	'$1F
	BITMAP ".#######"	'$7F
	BITMAP "####...."	'$F0
	BITMAP "#......."	'$80
	BITMAP "...##..."	'$18
	BITMAP "..####.."	'$3C
	BITMAP ".##.###."	'$6E
	BITMAP ".#..####"	'$4F

'===MusicSprite:14 == Chr:270===== [8,8]
'MusicSprite14:
	BITMAP "..######"	'$3F
	BITMAP "########"	'$FF
	BITMAP "###....#"	'$E1
	BITMAP "#.....##"	'$83
	BITMAP "##...###"	'$C7
	BITMAP "#######."	'$FE
	BITMAP ".#####.."	'$7C
	BITMAP "..###..."	'$38

'===MusicSprite:15 == Chr:271===== [8,8]
'MusicSprite15:
	BITMAP ".#......"	'$40
	BITMAP ".##....."	'$60
	BITMAP ".##....."	'$60
	BITMAP "..##...#"	'$31
	BITMAP "..##..##"	'$33
	BITMAP "..###.##"	'$3B
	BITMAP "...##.##"	'$1B
	BITMAP "...##..#"	'$19

'===MusicSprite:16 == Chr:272===== [8,8]
MusicSprite16:
	BITMAP "#......."	'$80
	BITMAP "###....."	'$E0
	BITMAP "####...."	'$F0
	BITMAP ".####..."	'$78
	BITMAP "..###..."	'$38
	BITMAP "...###.#"	'$1D
	BITMAP ".#######"	'$7F
	BITMAP "#######."	'$FE

'===MusicSprite:17 == Chr:273===== [8,8]
'MusicSprite17:
	BITMAP "...###.."	'$1C
	BITMAP "....###."	'$0E
	BITMAP ".....###"	'$07
	BITMAP "......##"	'$03
	BITMAP ".......#"	'$01
	BITMAP "........"	'$00
	BITMAP "........"	'$00
	BITMAP "........"	'$00

'===MusicSprite:18 == Chr:274===== [8,8]
'MusicSprite18:
	BITMAP "########"	'$FF
	BITMAP "#..#..##"	'$93
	BITMAP "#..#..##"	'$93
	BITMAP "#..#..##"	'$93
	BITMAP "#..#..##"	'$93
	BITMAP "...#...#"	'$11
	BITMAP "...#...#"	'$11
	BITMAP "########"	'$FF

'===MusicSprite:19 == Chr:275===== [8,8]
'MusicSprite19:
	BITMAP "########"	'$FF
	BITMAP "#.###.##"	'$BB
	BITMAP "#.###.##"	'$BB
	BITMAP "#.###.##"	'$BB
	BITMAP "#.###.##"	'$BB
	BITMAP "...#...#"	'$11
	BITMAP "...#...#"	'$11
	BITMAP "########"	'$FF

'===MusicSprite:20 == Chr:276===== [8,8]
'MusicSprite20:
	BITMAP "########"	'$FF
	BITMAP "..###.##"	'$3B
	BITMAP "..###.##"	'$3B
	BITMAP "..###.##"	'$3B
	BITMAP "..###.##"	'$3B
	BITMAP "...#...#"	'$11
	BITMAP "...#...#"	'$11
	BITMAP "########"	'$FF

'===MusicSprite:21 == Chr:277===== [8,8]
'MusicSprite21:
	BITMAP "........"	'$00
	BITMAP "........"	'$00
	BITMAP "........"	'$00
	BITMAP ".......#"	'$01
	BITMAP "..##..##"	'$33
	BITMAP ".####.##"	'$7B
	BITMAP "#####.#."	'$FA
	BITMAP "#####.#."	'$FA

'===MusicSprite:22 == Chr:278===== [8,8]
'MusicSprite22:
	BITMAP "#.##..#."	'$B2
	BITMAP "##...###"	'$C7
	BITMAP ".#######"	'$7F
	BITMAP "..######"	'$3F
	BITMAP ".......#"	'$01
	BITMAP "........"	'$00
	BITMAP "........"	'$00
	BITMAP "........"	'$00

'===MusicSprite:23 == Chr:279===== [8,8]
'MusicSprite23:
	BITMAP ".###.###"	'$77
	BITMAP ".###.###"	'$77
	BITMAP ".###.###"	'$77
	BITMAP "........"	'$00
	BITMAP "........"	'$00
	BITMAP "........"	'$00
	BITMAP "........"	'$00
	BITMAP "........"	'$00

'===MusicSprite:24 == Chr:280===== [8,8]
'MusicSprite24:
	BITMAP "........"	'$00
	BITMAP "###....."	'$E0
	BITMAP "###....."	'$E0
	BITMAP "###....."	'$E0
	BITMAP "###....."	'$E0
	BITMAP "........"	'$00
	BITMAP "........"	'$00
	BITMAP "........"	'$00

'===MusicSprite:25 == Chr:281===== [8,8]
'MusicSprite25:
	BITMAP "........"	'$00
	BITMAP "##......"	'$C0
	BITMAP "##......"	'$C0
	BITMAP "##......"	'$C0
	BITMAP "##......"	'$C0
	BITMAP "###....."	'$E0
	BITMAP "###....."	'$E0
	BITMAP "........"	'$00

'===MusicSprite:26 == Chr:282===== [8,8]
'MusicSprite26:
	BITMAP "........"	'$00
	BITMAP ".#......"	'$40
	BITMAP ".#......"	'$40
	BITMAP ".#......"	'$40
	BITMAP ".#......"	'$40
	BITMAP "###....."	'$E0
	BITMAP "###....."	'$E0
	BITMAP "........"	'$00

'===MusicSprite:27 == Chr:283===== [8,8]
'MusicSprite27:
	BITMAP "........"	'$00
	BITMAP ".##....."	'$60
	BITMAP ".##....."	'$60
	BITMAP ".##....."	'$60
	BITMAP ".##....."	'$60
	BITMAP "###....."	'$E0
	BITMAP "###....."	'$E0
	BITMAP "........"	'$00

'===MusicSprite:28 == Chr:284===== [8,8]
'MusicSprite28:
	BITMAP "########"	'$FF
	BITMAP "#.#.#.##"	'$AB
	BITMAP "#.##.#.#"	'$B5
	BITMAP "#.#.#.##"	'$AB
	BITMAP "#.##.#.#"	'$B5
	BITMAP "#.#.#.##"	'$AB
	BITMAP "#.##.#.#"	'$B5
	BITMAP "########"	'$FF

'===MusicSprite:29 == Chr:285===== [8,8]
'MusicSprite29:
	BITMAP ".....#.."	'$04
	BITMAP ".....##."	'$06
	BITMAP ".....###"	'$07
	BITMAP ".....#.#"	'$05
	BITMAP "...###.#"	'$1D
	BITMAP "..####.."	'$3C
	BITMAP "..####.."	'$3C
	BITMAP "...##..."	'$18

'===MusicSprite:30 == Chr:286===== [8,8]
'MusicSprite30:
	BITMAP "...#...."	'$10
	BITMAP "..##...."	'$30
	BITMAP ".###...."	'$70
	BITMAP ".#.#...."	'$50
	BITMAP ".#.###.."	'$5C
	BITMAP "...####."	'$1E
	BITMAP "...####."	'$1E
	BITMAP "....##.."	'$0C

'===MusicSprite:31 == Chr:287===== [8,8]
'MusicSprite31:
	BITMAP "########"	'$FF
	BITMAP "#.###..#"	'$B9
	BITMAP "#.###..#"	'$B9
	BITMAP "#.###..#"	'$B9
	BITMAP "#.###..#"	'$B9
	BITMAP "...#...#"	'$11
	BITMAP "...#...#"	'$11
	BITMAP "########"	'$FF

'===MusicSprite:32 == Chr:288===== [8,8]
MusicSprite32:
	BITMAP "........"	'$00
	BITMAP "....#..."	'$08
	BITMAP "...###.."	'$1C
	BITMAP "..##.##."	'$36
	BITMAP "..##.##."	'$36
	BITMAP ".##...##"	'$63
	BITMAP ".#######"	'$7F
	BITMAP ".##...##"	'$63

'===MusicSprite:33 == Chr:289===== [8,8]
'MusicSprite33:
	BITMAP "........"	'$00
	BITMAP ".######."	'$7E
	BITMAP "..##..##"	'$33
	BITMAP "..##..##"	'$33
	BITMAP "..#####."	'$3E
	BITMAP "..##..##"	'$33
	BITMAP "..##..##"	'$33
	BITMAP ".######."	'$7E

'===MusicSprite:34 == Chr:290===== [8,8]
'MusicSprite34:
	BITMAP "........"	'$00
	BITMAP "...####."	'$1E
	BITMAP "..##..##"	'$33
	BITMAP ".##....."	'$60
	BITMAP ".##....."	'$60
	BITMAP ".##....."	'$60
	BITMAP "..##..##"	'$33
	BITMAP "...####."	'$1E

'===MusicSprite:35 == Chr:291===== [8,8]
'MusicSprite35:
	BITMAP "........"	'$00
	BITMAP ".#####.."	'$7C
	BITMAP "..##.##."	'$36
	BITMAP "..##..##"	'$33
	BITMAP "..##...#"	'$31
	BITMAP "..##..##"	'$33
	BITMAP "..##.##."	'$36
	BITMAP ".#####.."	'$7C

'===MusicSprite:36 == Chr:292===== [8,8]
'MusicSprite36:
	BITMAP "........"	'$00
	BITMAP ".#######"	'$7F
	BITMAP "..##..##"	'$33
	BITMAP "..##.#.#"	'$35
	BITMAP "..####.."	'$3C
	BITMAP "..##.#.#"	'$35
	BITMAP "..##..##"	'$33
	BITMAP ".#######"	'$7F

'===MusicSprite:37 == Chr:293===== [8,8]
'MusicSprite37:
	BITMAP "........"	'$00
	BITMAP ".#######"	'$7F
	BITMAP "..##..##"	'$33
	BITMAP "..##.#.#"	'$35
	BITMAP "..####.."	'$3C
	BITMAP "..##.#.."	'$34
	BITMAP "..##...."	'$30
	BITMAP ".####..."	'$78

'===MusicSprite:38 == Chr:294===== [8,8]
'MusicSprite38:
	BITMAP "........"	'$00
	BITMAP "...####."	'$1E
	BITMAP "..##..##"	'$33
	BITMAP ".##....."	'$60
	BITMAP ".##.####"	'$6F
	BITMAP ".##...##"	'$63
	BITMAP "..##.###"	'$37
	BITMAP "...###.#"	'$1D

'===MusicSprite:39 == Chr:295===== [8,8]
'MusicSprite39:
	BITMAP "....#..."	'$08
	BITMAP "..#.##.."	'$2C
	BITMAP "..###..."	'$38
	BITMAP ".##.##.."	'$6C
	BITMAP "..###..."	'$38
	BITMAP ".##.#..."	'$68
	BITMAP "..#....."	'$20
	BITMAP "........"	'$00

'===MusicSprite:40 == Chr:296===== [8,8]
'MusicSprite40:
	BITMAP "########"	'$FF
	BITMAP "########"	'$FF
	BITMAP "########"	'$FF
	BITMAP "########"	'$FF
	BITMAP "########"	'$FF
	BITMAP "########"	'$FF
	BITMAP "########"	'$FF
	BITMAP "########"	'$FF

'===MusicSprite:41 == Chr:297===== [8,8]
'MusicSprite41:
	BITMAP ".#.#.#.#"	'$55
	BITMAP "#.#.#.#."	'$AA
	BITMAP ".#.#.#.#"	'$55
	BITMAP "#.#.#.#."	'$AA
	BITMAP ".#.#.#.#"	'$55
	BITMAP "#.#.#.#."	'$AA
	BITMAP ".#.#.#.#"	'$55
	BITMAP "#.#.#.#."	'$AA

'===MusicSprite:42 == Chr:298===== [8,8]
'MusicSprite42:
	BITMAP "#......#"	'$81
	BITMAP "#..##..#"	'$99
	BITMAP "#......#"	'$81
	BITMAP "#..##..#"	'$99
	BITMAP "#......#"	'$81
	BITMAP "#..##..#"	'$99
	BITMAP "#......#"	'$81
	BITMAP "#..##..#"	'$99

'===MusicSprite:43 == Chr:299===== [8,8]
'MusicSprite43:
	BITMAP "........"	'$00
	BITMAP ".#..#..#"	'$49
	BITMAP "........"	'$00
	BITMAP ".#..#..#"	'$49
	BITMAP "........"	'$00
	BITMAP ".#..#..#"	'$49
	BITMAP "........"	'$00
	BITMAP ".#..#..#"	'$49

'===MusicSprite:44 == Chr:300===== [8,8]
'MusicSprite44:
	BITMAP "........"	'$00
	BITMAP "##...#.."	'$C4
	BITMAP "#....#.."	'$84
	BITMAP "##.#.##."	'$D6
	BITMAP "#.#.##.."	'$AC
	BITMAP "###.#.#."	'$EA
	BITMAP "........"	'$00
	BITMAP "........"	'$00

'===MusicSprite:45 == Chr:301===== [8,8]
'MusicSprite45:
	BITMAP "........"	'$00
	BITMAP ".#.#...."	'$50
	BITMAP "#..#...."	'$90
	BITMAP "#..#.##."	'$96
	BITMAP "#..#.#.."	'$94
	BITMAP ".#.#.#.."	'$54
	BITMAP "........"	'$00
	BITMAP "........"	'$00

'===MusicSprite:46 == Chr:302===== [8,8]
'MusicSprite46:
	BITMAP "........"	'$00
	BITMAP ".###...."	'$70
	BITMAP "##.##..."	'$D8
	BITMAP "##.##..."	'$D8
	BITMAP "##.##..."	'$D8
	BITMAP ".###...."	'$70
	BITMAP "........"	'$00
	BITMAP "........"	'$00

'===MusicSprite:47 == Chr:303===== [8,8]
'MusicSprite47:
	BITMAP "........"	'$00
	BITMAP ".##....."	'$60
	BITMAP "###....."	'$E0
	BITMAP ".##....."	'$60
	BITMAP ".##....."	'$60
	BITMAP "####...."	'$F0
	BITMAP "........"	'$00
	BITMAP "........"	'$00

'===MusicSprite:48 == Chr:304===== [8,8]
MusicSprite48:
	BITMAP "........"	'$00
	BITMAP ".###...."	'$70
	BITMAP "#..##..."	'$98
	BITMAP "..##...."	'$30
	BITMAP ".##....."	'$60
	BITMAP "#####..."	'$F8
	BITMAP "........"	'$00
	BITMAP "........"	'$00

'===MusicSprite:49 == Chr:305===== [8,8]
'MusicSprite49:
	BITMAP "........"	'$00
	BITMAP ".###...."	'$70
	BITMAP "#..##..."	'$98
	BITMAP "..##...."	'$30
	BITMAP "#..##..."	'$98
	BITMAP ".###...."	'$70
	BITMAP "........"	'$00
	BITMAP "........"	'$00

'===MusicSprite:50 == Chr:306===== [8,8]
'MusicSprite50:
	BITMAP "........"	'$00
	BITMAP ".#.##..."	'$58
	BITMAP "##.##..."	'$D8
	BITMAP "#####..."	'$F8
	BITMAP "...##..."	'$18
	BITMAP "...##..."	'$18
	BITMAP "........"	'$00
	BITMAP "........"	'$00

'===MusicSprite:51 == Chr:307===== [8,8]
'MusicSprite51:
	BITMAP "........"	'$00
	BITMAP "#####..."	'$F8
	BITMAP "##......"	'$C0
	BITMAP ".###...."	'$70
	BITMAP "#..##..."	'$98
	BITMAP ".###...."	'$70
	BITMAP "........"	'$00
	BITMAP "........"	'$00

'===MusicSprite:52 == Chr:308===== [8,8]
'MusicSprite52:
	BITMAP "........"	'$00
	BITMAP ".###...."	'$70
	BITMAP "##..#..."	'$C8
	BITMAP "####...."	'$F0
	BITMAP "##.##..."	'$D8
	BITMAP ".###...."	'$70
	BITMAP "........"	'$00
	BITMAP "........"	'$00

'===MusicSprite:53 == Chr:309===== [8,8]
'MusicSprite53:
	BITMAP "........"	'$00
	BITMAP "#####..."	'$F8
	BITMAP "#..##..."	'$98
	BITMAP "..##...."	'$30
	BITMAP ".##....."	'$60
	BITMAP ".##....."	'$60
	BITMAP "........"	'$00
	BITMAP "........"	'$00

'===MusicSprite:54 == Chr:310===== [8,8]
'MusicSprite54:
	BITMAP "........"	'$00
	BITMAP ".###...."	'$70
	BITMAP "##.##..."	'$D8
	BITMAP ".###...."	'$70
	BITMAP "##.##..."	'$D8
	BITMAP ".###...."	'$70
	BITMAP "........"	'$00
	BITMAP "........"	'$00

'===MusicSprite:55 == Chr:311===== [8,8]
'MusicSprite55:
	BITMAP "........"	'$00
	BITMAP ".###...."	'$70
	BITMAP "##.##..."	'$D8
	BITMAP ".####..."	'$78
	BITMAP "#..##..."	'$98
	BITMAP ".###...."	'$70
	BITMAP "........"	'$00
	BITMAP "........"	'$00

'//Total of 56 characters.

'--- Music note color, by voice channel (drawn on top, scrolls down)----
iMusicNoteColor: DATA FG_DARKGREEN,FG_RED,FG_BLUE
'--- Piano key and Volume colors, by voice channel -- 2nd set flash effect. Use same colors on 2nd to disable hilite/blink
' SPR_BLACK,SPR_BLUE,SPR_RED,SPR_TAN,SPR_DARKGREEN,SPR_GREEN,SPR_YELLOW,SPR_WHITE,SPR_GREY,SPR_CYAN,SPR_ORANGE,SPR_BROWN,SPR_PINK,SPR_LIGHTBLUE,SPR_YELLOWGREEN,SPR_PURPLE			7
'--1st set--- for each voice channel---
iMusicPianoColorA: DATA SPR_DARKGREEN, SPR_RED, SPR_BLUE
'--2nd set, flash---
iMusicPianoColorB: DATA SPR_GREEN,SPR_ORANGE,SPR_LIGHTBLUE

