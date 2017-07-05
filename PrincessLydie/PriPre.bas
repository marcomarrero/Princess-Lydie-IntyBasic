'--Princess Lydie, (c)2017 Marco A. Marrero
OPTION WARNINGS ON
OPTION EXPLICIT ON
PLAY SIMPLE

ON FRAME GOSUB FrameSync
INCLUDE "constants.bas"
CONST KEYWAIT=0
CONST EYECARDS = $2100:CONST EYECARDS2 = $21AC

'--- player stats
DIM Level, Difficulty				'-- difficulty 200=easy, 0=normal. PAL users won't have "normal" setting, just disables 1st wait.
DIM #Score, #HiScore, #OldScore		'-- scoring
DIM Lives


'-------
DIM #SoundAddress,SoundVolume,MusicOn	'--Sound data address, Volume, Music
DIM IntyMusic, FrameSkip, #FrameCount
CONST VOL = 12					'--Maximum volume 
MusicOn=1

'------difficulty adjust----------
CONST ENEMY_SLEEPWARN = 200
CONST ENEMY_SLEEPWAKE = 250		'-- Enemy sleep + wake
CONST SPEED1=1:CONST SPEED2=2	'--in slow mode, SPEED1=2:SPEED2=4
CONST ACCEL_DELAY = 2: CONST ACCEL_RUN = 3
CONST DIR_MAX=2
CONST FIREBALL1LEVEL = 5
CONST FIREBALL2LEVEL = 10
CONST MAXSECONDS = 60		'<--60 seconds per round
CONST HEADHIT= 1			'4 sometimes misses.. :P	2=ok, 1=testing

'---only donce once----
 #HiScore=1

GOTO Start
'-------------------------------------------------------------
INCLUDE "MToolsDef.bas"
INCLUDE "MTools.bas"
INCLUDE "MMenu.bas"
INCLUDE "PriPreTitle.bas"
INCLUDE "PriPreGraphics.bas"
INCLUDE "PriPreData.bas"
'INCLUDE "VptNum16.bas"

'================GLOBAL/ONCE===================
Start: 
GOSUB TitleScreen
Difficulty=0:IntyMusic=0
#Score=0

'---start 2, menu-----
Level=0	 'first level is 0
Lives=7

GOSUB MMenu_Demo:IF #tc=1 THEN GOTO Start

GOSUB GameInit
GOSUB FrameSyncInit
'---score penalty for difficulty 
'DIM bonus_timer, bonus_timer_set	'-- how much time multiplier
'IF Difficulty=200 OR NTSC=0 THEN bonus_timer_set=20 ELSE bonus_timer_set=10

'==============================================================LEVEL INIT============================
LevelInit:
'--------load level------
Level=Level+1
GOSUB DrawIntro				'<--level info screen, set hi-score, display game over

#tb=AllLevels(LEVEL AND 7)
GOSUB DrawLevelX			'<---stage 
GOSUB DrawBorders			'<--score, border

'----- seek where to land snakes -----
tx=8					'<---start seeking from 16th position from right
#ypos_0=SPRITEMAXY-7	'<---from below
include "mSnake0_A.bas.bas"

'---- set baddy type ----
GOSUB BadType

'----player 1 initial values-----
#ypos_0=-4:xpos_0=84
state_fall0=0:state_jump0=0:state_die0=0:total_enemies=6
state_stomp=0:BadType_7=0:state_kick=0:#anim_2=0:state_scrollx=0:state_scrolly=0
xcard_0=SPRITECARD(xpos_0):ycard_0=SPRITECARD(#ypos_0)	
fire1_y=DISABLED:fire2_y=DISABLED

#SoundAddress=0:SoundVolume=VOL
Frame4=FRAME AND 4:Frame8=FRAME AND 8
IF MusicOn Then 
	PLAY VOLUME 10
	PLAY SIMPLE
	IF Lives=0 THEN 
		PLAY MyMusic02
	ELSE 
		PLAY MyMusic
	END IF
ELSE
	PLAY NONE
END IF
Timer=MAXSECONDS
#OldScore=#Score
PRINT COLOR CS_TAN
GOTO MainLoop

'====pick bad distribution by level 
BADTYPE: PROCEDURE
	#ta=LEVEL-1:IF #ta>3 THEN #ta=3
	'BadType_1=#ta:BadType_2=#ta:BadType_3=#ta:BadType_4=#ta:BadType_5=#ta:BadType_6=#ta	
	'RETURN
	'---------
	IF Level<4 THEN
		BadType_1=0:BadType_2=0:BadType_3=0:BadType_4=0:BadType_5=0:BadType_6=0
	ELSEIF Level<8 THEN 
		BadType_1=1:BadType_2=0:BadType_3=1:BadType_4=0:BadType_5=0:BadType_6=1
	ELSEIF Level<12 THEN 
		BadType_1=2:BadType_2=1:BadType_3=0:BadType_4=0:BadType_5=1:BadType_6=2
	ELSEIF Level<16 THEN 
		BadType_1=2:BadType_2=1:BadType_3=2:BadType_4=0:BadType_5=2:BadType_6=2		
	ELSEIF Level<20 THEN 
		BadType_1=3:BadType_2=2:BadType_3=1:BadType_4=0:BadType_5=2:BadType_6=3
	Else
		BadType_1=3:BadType_2=3:BadType_3=2:BadType_4=1:BadType_5=3:BadType_6=3
	END IF
END

'=======================================
'#ta=Sprite number
'---Decrease baddies, spawn fireballs, check next level
NextLevel: PROCEDURE
	SPRITE #ta,0,0,0
	total_enemies=total_enemies-1
	IF total_enemies=0 THEN 
		#ta=0	'--returns 0 to indicate level is over
	ELSEIF total_enemies=5 THEN 	'--fireball! get 1st sprite 
		fire1_sprA=#ta
	ELSEIF total_enemies=4 THEN 	'--fireball! Get 2nd, spawn away from player
		fire1_sprB=#ta
		IF Level>=FIREBALL1LEVEL THEN
			IF #ypos_0 > SPRITEMAXY/2 THEN Fire1_y=0:#fire1_yd=1 ELSE Fire1_y=SPRITEMAXY-2:#fire1_yd=-1
			IF xpos_0 > SPRITEMAXX/2 THEN Fire1_x=8:#fire1_xd=1 ELSE Fire1_x=SPRITEMAXX-8:#fire1_xd=-1
		END IF 
	ELSEIF total_enemies=3 THEN		'--fireball2! Get 1st sprite
		fire2_sprA=#ta
	ELSEIF total_enemies=2 THEN
		fire2_sprB=#ta
		IF Level>=FIREBALL2LEVEL THEN
			IF #ypos_0 > SPRITEMAXY/2 THEN Fire2_y=0:#fire2_yd=1 ELSE Fire2_y=SPRITEMAXY:#fire2_yd=-1
			IF xpos_0 > SPRITEMAXX/2 THEN Fire2_x=8:#fire2_xd=1 ELSE Fire2_x=SPRITEMAXX-8:#fire2_xd=-1
		END IF
	END IF 
END

'---
FindLandingSpot: PROCEDURE 
	'--parse from left or right
	IF (ti AND 1) THEN #xdir_0=1 ELSE #xdir_0=-1		'--forward
KeepLooking:
	tx=tx+16:IF tx>(160/2) THEN tx=16:#ypos_0=#ypos_0-8	'--up if cross middle		
	IF (ti AND 1) THEN xpos_0=tx else xpos_0=160-tx
	xcard_0=SPRITECARD(xpos_0):ycard_0=SPRITECARD(#ypos_0):backtabpos_0=MUL20(ycard_0)+xcard_0	
	'--can't have anything around
	IF #BACKTAB(backtabpos_0)=0 AND #BACKTAB(backtabpos_0 - 1)=0 AND #BACKTAB(backtabpos_0 + 1)=0 AND #BACKTAB(backtabpos_0 + 20)<>0 THEN RETURN 	
	GOTO KeepLooking 
END

include "PriPreLevels.bas"	'<---- levels

'---draw borders=====
DrawBorders: PROCEDURE 
    tx=0
    '#ts=FGBG_BK_Color(CS_BLUE) + VWall
    #ts=STACK_BLUE + FGBG_BK_Color(STACK_LIGHTBLUE) + VWall
    DO
        #BACKTAB(tx)=#ts
        tx=tx+19:#BACKTAB(tx)=#ts
        tx=tx+1
    LOOP UNTIL tx>=BACKGROUND_COLUMNS*BACKGROUND_ROWS 

    '#ts=FGBG_BK_Color(CS_BLUE) + CS_WHITE
    '#backtab(20)=#ts + "L"*8:#backtab(100)=#ts + "S"*8
    #OldScore=-1   
        '---update score-----
    PRINT AT 0 COLOR CS_BLUE,"S"
    PRINT COLOR CS_GREEN,<5>#Score,"00 "
    PRINT COLOR CS_BLUE,"T99 R"
    PRINT COLOR CS_GREEN,<2>Level
    PRINT COLOR CS_BLUE," L"
    PRINT COLOR CS_RED,<2>Lives
    WAIT   
END

EndProgram50: DATA "M"

'------------------------tx,ty,ti,tj,tk,tl-------------------------
ASM ORG $C040

'==================================================================


FireballsAndSound: PROCEDURE
	IF Fire1_y<>DISABLED THEN
		ti=Frame0 AND 7  '0-3
		#ta=FireBall(ti)+ ZOOMY2 :#tb=FireBall1BColor(ti)+SPR12+BEHIND

		IF Frame1 THEN 
			fire1_x=fire1_x+#fire1_xd:fire1_y=fire1_y+#fire1_yd
			IF (fire1_x>=SPRITEMAXX-8) OR (fire1_x <=8) THEN #fire1_xd=-#fire1_xd   '--bounce
			IF (fire1_y >= SPRITEMAXY) THEN #fire1_yd=-#fire1_yd
		END IF		
		'IF LEVEL>=VERYDIFFICULT THEN 
		'	SPRITE fire1_sprA,VISIBLE + HIT + fire1_x, fire1_y + #ta, #tb
		'	SPRITE fire1_sprB,VISIBLE + HIT + (SPRITEMAXX-fire1_x), (SPRITEMAXY-fire1_y) + #ta, #tb
		'ELSE 
			SPRITE fire1_sprA,VISIBLE + HIT + fire1_x, fire1_y + #ta , SPR11 + FireBall1AColor(ti)
			SPRITE fire1_sprB,VISIBLE + HIT + fire1_x, fire1_y + #ta, #tb 
		'END IF 
	END IF

	IF Fire2_y<>DISABLED THEN
		#tb=FireBall2BColor(ti)+SPR12
		IF Frame1=0 THEN 
			fire2_x=fire2_x+#fire2_xd:fire2_y=fire2_y+#fire2_yd
			IF (fire2_x>=SPRITEMAXX-8) OR (fire2_x <=8) THEN #fire2_xd=-#fire2_xd   '--bounce
			IF (fire2_y >= SPRITEMAXY) THEN #fire2_yd=-#fire2_yd	
		END IF 
		'IF LEVEL>=VERYDIFFICULT THEN 
		'	SPRITE fire2_sprA,VISIBLE + HIT + fire2_x, fire2_y + #ta,  #tb
		'	SPRITE fire2_sprB,VISIBLE + HIT + (SPRITEMAXX-fire2_x), (SPRITEMAXY-fire2_y) + #ta, #tb
		'ELSE
			SPRITE fire2_sprA,VISIBLE + HIT + fire2_x, fire2_y + #ta , SPR11 + FireBall2AColor(ti)
			SPRITE fire2_sprB,VISIBLE + HIT + fire2_x, fire2_y + #ta, #tb
		'END IF
	END IF
'==========SOUND PLAYER=====================
'SOUNDPLAY: IF FRAME1=0 THEN GOTO MainLoop
	IF #SoundAddress<>0 THEN
		#ta=PEEK(#SoundAddress)			'--Get data
		#SoundAddress=#SoundAddress+2	'--next address.
		IF #ta=0 THEN 					'-- 0 = end
			#SoundAddress=0				'--clear data address. 0=don't play
			RETURN 
		END IF			
		IF #ta AND 1 THEN SoundVolume=SoundVolume-1		'-Volume down, if it's an odd value	
		SOUND 2,#ta,SoundVolume
	Else
		SOUND 2,1,0
	END IF 
END

INCLUDE "PriPre_IntoScreen.bas"
'==========================================================================================================

'---------------------------------------------------MAIN---------------------------------------------------

'==========================================================================================================
MainLoop:
	IF OldTimer<>Timer THEN 
		IF Timer=0 OR Timer=255 THEN 
			GOTO OuttaTime
		ELSEIF Timer=15 THEN
			CALL MUSIC_TEMPO(4)
		ELSEIF Timer=10 THEN
			CALL MUSIC_TEMPO(3)
		ELSEIF Timer<8 THEN 
			PRINT COLOR Timer
		END IF 
		PRINT AT 10,<2>Timer:OldTimer=Timer		
	END IF 

'<-------------------- 1stWAIT -----------------------------------------------------------------------------
	POKE $30,state_scrollx: POKE $31,state_scrolly	'--set shake
	WAIT
	IF Difficulty + FrameSkip=201 THEN 
		POKE $30,state_scrollx: POKE $31,state_scrolly	'--set shake
		WAIT		'FrameSkip, PAL sync (easy mode)
	END IF 

	ON BadType_1 GOTO Snake_1,Snake_1,Spinner_1,Jumper_1
	include "mSnake0_B.bas.bas"		'<--- Sprites and behavior: Snake	
	include "mJumper0_B.bas.bas"	'<--- Sprites and behavior: Jumper
	
	ON BadType_1 GOTO Snake_1,Snake_1,Spinner_1,Jumper_1 
	include "mSpinner0_B.bas.bas"	'<--- Sprites and behavior: Spinner
	GOTO Snake_7

EndProgramC0: DATA "A"
	
'-----------------------
asm org $A000	
'----------------------
Snake_7:
Spinner_7:
Jumper_7:
 	IF #xpad_0=0 THEN 		'----<>stop
 		IF #xdir_0<0 Then 	'<<<descelerate
 			#tx=FLIPX:pri_anim=0
 			xaccel_0=xaccel_0+1:IF xaccel_0>ACCEL_DELAY THEN 
				xaccel_0=0:#xdir_0=#xdir_0+1:IF #SoundAddress=0 THEN #SoundAddress=VARPTR Sound_Slip(0)+NTSC:SoundVolume=VOL
			END IF
 			IF state_jump0=0 THEN #anim_0=PRI_SLIDE:#anim_1=PRI_DRESS2			
 		ELSEIF #xdir_0>0 then 	'<<<<descelerate
 			#tx=0:pri_anim=0:xaccel_0=xaccel_0+1
			IF xaccel_0>ACCEL_DELAY THEN 
				xaccel_0=0:#xdir_0=#xdir_0-1:IF #SoundAddress=0 THEN #SoundAddress=VARPTR Sound_Slip(0)+NTSC:SoundVolume=VOL
			END IF
 			IF state_jump0=0 THEN #anim_0=PRI_SLIDE:#anim_1=PRI_DRESS2			
 		ELSE 
 			IF state_jump0=0 THEN #anim_0=PRI_STAND:#anim_1=PRI_DRESS1
 		END IF 		
 	ELSEIF #xpad_0=1 THEN 	'------>>>acelerate right
 		IF #xdir_0<DIR_MAX THEN
 			#tx=0:xaccel_0=xaccel_0 + 1:IF xaccel_0 > ACCEL_RUN THEN xaccel_0=0:#xdir_0=#xdir_0 + 1
 		END IF 
 		IF state_jump0=0 THEN pri_anim=(pri_anim+2) AND 15:#anim_0=PRI_Walk(pri_anim):#anim_1=PRI_Walk(pri_anim+1)
 	ELSEIF #xpad_0=-1 THEN 	'--<<<<acelerate left
 		IF #xdir_0>-DIR_MAX THEN
 			#tx=FLIPX:xaccel_0=xaccel_0+1:IF xaccel_0>ACCEL_RUN THEN xaccel_0=0:#xdir_0=#xdir_0-1
 		END IF 		
 		IF state_jump0=0 THEN pri_anim=(pri_anim+2) AND 15:#anim_0=PRI_Walk(pri_anim):#anim_1=PRI_Walk(pri_anim+1)
 	END IF	
 '---------move-----
 	xpos_0=xpos_0 + #xdir_0
	IF xpos_0>(SPRITEMAXX-16) THEN
		xpos_0=SPRITEMAXX-18
		#xdir_0=-#xdir_0:#xpad_0=-#xpad_0
	ELSEIF xpos_0<=14 THEN
		xpos_0=16
		#xdir_0=-#xdir_0:#xpad_0=-#xpad_0
	END IF
 '---------fall-----
 	IF state_fall0 THEN	 	
 		state_fall0=state_fall0 - 1
 		IF state_fall0=$FE THEN 
 			#xdir_0=#xpad_0
 		ELSEIF state_fall0<$F8 THEN '--after falling for a while, let user toggle direction
 			#xdir_0=CONTX(CONT1 AND 15)
 		END IF
 		pri_anim=0:IF #SoundAddress< VARPTR Sound_Explode(0) THEN #SoundAddress=0 '--don't make sound slip if playing other sound...
 		
 		#ypos_0 = #ypos_0 + 2
 		IF #ypos_0>=SPRITEMAXY THEN #ypos_0=-4
 		xcard_0=SPRITECARD(xpos_0)		
 		#anim_0=PRI_FALL
 		IF FRAME4 THEN #anim_1=PRI_DRESS1 ELSE #anim_1=PRI_DRESS2
 		
 		IF #ypos_0>=4 THEN	'--don't check if she's top offscreen, just fall
 			IF DIVBY8(#ypos_0) THEN			
 				ycard_0=SPRITECARD(#ypos_0)
 				backtabpos_0=MUL20(ycard_0)+xcard_0		
 				IF #BACKTAB(backtabpos_0 + 20)<>0 THEN state_fall0=0:GOTO Fall_Stop	'--if floor, stop falling
 			END IF
 		END IF 
		'---check and initialize kick mode!
		IF CONT1.BUTTON Then 
			state_kick=1:state_fall0=0:#xdir_0=0:#xpad_0=0:#SoundAddress=VARPTR Sound_Kick(0)+NTSC:SoundVolume=VOL
		END IF 
'--------flying down kick!---------
	ELSEIF state_kick THEN
		#anim_0=PRI_KICK
		IF state_kick=2 THEN			
			#ypos_0 = #ypos_0 + 4
		ELSE 
			IF #ypos_0>0 THEN '--don't do look_up on negative values!
				IF DIVBY8(#ypos_0) THEN 
					state_kick=state_kick+1
					GOTO StateKick0			
				END IF 				
			END IF
			#ypos_0 = #ypos_0 + 2	'--add 2 until div by 8, then 4 by 4
		END IF	
StateKick0:
		IF #ypos_0 >= SPRITEMAXY THEN #ypos_0=0
	 	IF #ypos_0>7 THEN	'--don't check if she's top offscreen, just fall
 			IF DIVBY8(#ypos_0) THEN	
 				ycard_0=SPRITECARD(#ypos_0)
 				backtabpos_0=MUL20(ycard_0)+xcard_0
 				IF #BACKTAB(backtabpos_0 + 20)<>0 THEN state_kick=0:GOTO Fall_Stop	'--if floor, stop falling
 			END IF
 		END IF 			
		IF FRAME1 THEN #anim_1=PRI_DRESS1 ELSE #anim_1=PRI_DRESS2		

 '---------jump-----
 	ELSEIF state_jump0 THEN	 
 		state_jump0=state_jump0+1		'--starts at 2
 		IF state_jump0 > 14 THEN 
 			state_jump0=0:state_fall0=$FF
 		ELSE 		
 			#ypos_0 = #ypos_0 - 2
 			IF #ypos_0>16 THEN	'--don't check floor above if she's at top...
 				IF DIVBY8(#ypos_0) THEN
 					IF #BACKTAB(backtabpos_0 - 20)<>0 THEN state_jump0=0:state_fall0=$FF 'stop jump if hit top floor
 				END IF
 				xcard_0=SPRITECARD(xpos_0):	ycard_0=SPRITECARD(#ypos_0)
 				backtabpos_0=MUL20(ycard_0)+xcard_0
 			END IF
 		END IF 
'----die!---------------- 	
 	ELSEIF state_die0 THEN
		state_die0=state_die0+1
		if state_die0=2 Then						
			#SoundAddress=VARPTR Sound_Die(0)+NTSC:SoundVolume=VOL			
		elseif state_die0 <6 Then	'stay dead for a while 
			'
		elseif state_die0 < 14 then 	'fall up 
			#ypos_0 = #ypos_0 - 3			
		else 	'fall down
			#ypos_0 = #ypos_0 + 3			
		end if
		IF #ypos_0<SPRITEMAXY THEN 
			SPRITE 0,VISIBLE + xpos_0, #ypos_0 + ZOOMY2 + FLIPY + 1, PRI_HI
			SPRITE 7,VISIBLE + xpos_0, #ypos_0 + ZOOMY2 + FLIPY + 2, PRI_DRESS2
		ElseIF #ypos_0<SPRITEMAXY+10 THEN
			ResetSprite(0):ResetSprite(7)
		ELSE 
			#ypos_0=-4:xpos_0=80:state_die0=0:state_fall0=$FF
			Lives=Lives-1:PRINT AT 18 COLOR CS_RED,<2>Lives 
			PRINT COLOR CS_TAN			
			IF Lives=255 THEN 
				GOTO GameOver
			ELSEIF Lives=0 THEN
				IF MusicOn Then PLAY MyMusic02
			END IF
		End if 
'---------run-----
 	ELSE '--Check if jump
 		#xpad_0 = CONTX(CONT1 AND 15)	'-- values: -1 to 1 
 		IF CONT1.BUTTON Then '------start jumping-----
 			state_jump0=1
 			IF #xpad_0=0 THEN 	'--jump up
 				#anim_0=PRI_HI 
 				#anim_1=PRI_DRESS1
 			ELSE 				'--jump towards
 				#anim_0=PRI_JUMP
 				#anim_1=PRI_DRESS2
 			END IF			
 			#SoundAddress=VARPTR Sound_Jump(0)+NTSC:SoundVolume=VOL
 		ELSE 	'---run				
 			IF DIVBY8(#ypos_0) THEN 
 				xcard_0=SPRITECARD(xpos_0)	
 				backtabpos_0=MUL20(ycard_0)+xcard_0
 				IF #BACKTAB(backtabpos_0 + 20)=0 THEN state_fall0=$FF  '--if no floor, fall 
 			END IF 		
 		END IF
 	END IF
 '---------	
Fall_Stop:
	IF state_die0=0 THEN
		IF #anim_2<>0 THEN #anim_0=#anim_2:#anim_2=0
		SPRITE 0,VISIBLE + HIT + xpos_0, #ypos_0 + ZOOMY2 + #tx + 1, #anim_0				'--skin
		SPRITE 7,VISIBLE + xpos_0, #ypos_0 - 1 + ZOOMY2 + #tx + 1 + state_stomp, #anim_1	'--dress 
	END IF 

'---------------------- Fire, difficulty--------------
	'IF Level>VERYDIFFICULT Then
	'	IF Fire1_y<>DISABLED THEN			
	'		ti=Frame0 AND 7  '0-3
	'		#ta=FireBall(ti)+ZOOMY2: #tb=SPR11 + FireBall1AColor(ti)
    '		SPRITE fire1_sprA,VISIBLE + HIT + fire1_x, fire1_y + #ta , #tb
	'		SPRITE fire1_sprB,VISIBLE + HIT + (SPRITEMAXX-fire1_x), (SPRITEMAXY-fire1_y) + #ta , #tb
	'	END IF		
	'	IF Fire2_y<>DISABLED Then
	'	    SPRITE fire2_sprA,VISIBLE + HIT + fire2_x, fire2_y + #ta, #tb
	'		SPRITE fire2_sprB,VISIBLE + HIT + (SPRITEMAXX-fire2_x), (SPRITEMAXY-fire2_y) + #ta , #tb
    '	END IF 
	'END IF

'<=============================================2ndWAIT=============================================================
	POKE $30,state_scrollx: POKE $31,state_scrolly	'--set shake
	state_scrollx=0:state_scrolly=0	 				'--de-shake...
	WAIT
	IF FrameSkip=1 THEN 
		POKE $30,0: POKE $31,0	'--set shake
		WAIT
	END IF 	
	FRAME0=FRAME0+1:Frame1=FRAME0 AND 1:Frame4=FRAME0 AND 4:Frame8=FRAME0 AND 8	'--toggle
	'-------------------------------------------------------collision----------------------	
	state_stomp=0

	IF NOT state_die0 THEN 
		#ta=(COL0 AND $7E) 		
		IF #ta THEN
			tk=0:ti=0:tj=0	'-tk=dead, ti=killed baddy, tj=stomped baddy		
			'---collision----
			include "mSnake0_E.bas.bas" 
			IF tk then 'died?
				#xpad_0=0:#xdir_0=0:state_die0=1:state_jump0=0:state_fall0=0
				'---force fire to travel down, to avoid hitting character
				IF #fire1_yd<0 THEN #fire1_yd=-#fire1_yd
				IF #fire2_yd<0 THEN #fire2_yd=-#fire2_yd
				
			elseif ti THEN '--kicked baddy!				
				#SoundAddress=VARPTR Sound_Explode(0)+NTSC:SoundVolume=VOL
				#anim_2=PRI_BUTTKICK
				SPRITE 7,VISIBLE + xpos_0, #ypos_0 - 1 + ZOOMY2 + #tx + 1 + state_stomp, #anim_2
				state_scrollx=1
			elseif tj THEN '--stomped baddy				
				#SoundAddress=VARPTR Sound_Stomp(0)+NTSC:SoundVolume=VOL	
				state_stomp=DOUBLEY				
				SPRITE 7,VISIBLE + xpos_0, #ypos_0 - 1 + ZOOMY2 + #tx + 1 + state_stomp, #anim_1
				state_scrolly=1
			end if			
		END IF
	END IF
	
'-------collision end-----------
	include "mSnake0_C.bas.bas"
	include "mSnake0_D.bas.bas"


	'------fireball--------
	'FIREBALL1 and 2
	GOSUB FireBallsAndSound
'=========================================
GOTO MainLoop

OuttaTime:
	GOSUB StopAudio
	#ts= FGBG_BK_Color(STACK_RED)+CS_BLUE 	
	FOR ti=0 TO 4
		'---------==------------01234567890123456789"
		PRINT AT 220 COLOR #ts," T I M E    O V E R "
		Sleep(20)
		#ts= FGBG_BK_Color(ti+3)+CS_RED
	NEXT ti 
	Lives=Lives-1:IF Lives=255 THEN GOTO GameOver
	GOTO LevelInit
'=========================================
LevelWon:
	GOSUB StopAudio	
	GOTO LevelInit
'----------------------------------------
GameOver:	
	GOSUB DrawIntro	'<--Game over screen
	GOTO Start
'--------------------
INCLUDE "IntyMusicX.bas"
INCLUDE "MSync.bas"

'==================================================================

Info: PROCEDURE
	'-------------0123456789012345678	
	PRINT COLOR CS_BLACK
	PRINT AT  82,"   Programmed by  "
	PRINT AT 102," Marco A. Marrero "
	PRINT COLOR CS_BLUE
	PRINT AT 122,"mmarrero\309yahoo.com"
	PRINT COLOR CS_DARKGREEN
	PRINT AT 142,"Thanks everyone in"
	PRINT AT 162,"AtariAge Inty Pgrm"
	GOSUB AnyKey
END 

EndProgramA0: DATA $A000 '- to $BFFF

ASM ORG $2100
'===================================================================
MyMusic:
INCLUDE "PriPreMusic1.bas"
MyMusicTitle01: DATA "*",$FF
'=================================================================================
MyMusic02:
INCLUDE "PriPreMusic2.bas"
MyMusicTitle02: DATA "*",$FF
'=================================================================================
MyMusic03:
GameOverMusic:
INCLUDE "PriPreMusic_GameOver.bas"
DATA 8:MUSIC STOP
MyMusicTitle03: DATA "*",$FF
'=================================================================================
MyMusic04:
RoundClearMusic:
INCLUDE "PriPreMusic_RoundClear.bas"
DATA 8:MUSIC STOP
MyMusicTitle04: DATA "*",$FF
'===============================================================================
MyMusic05:
RoundStart:
INCLUDE "PriPreMusic_RoundStart1.bas"
DATA 8:MUSIC STOP
MyMusicTitle05: DATA "*",$FF
'===============================================================================
MyMusic06:
RoundStart2:
INCLUDE "PriPreMusic_RoundStart2.bas"
DATA 8:MUSIC STOP			
MyMusicTitle06: DATA "*",$FF	
'===============================================================================
MyMusic07:
'INCLUDE ".bas"
DATA 8:MUSIC STOP
MyMusicTitle07: DATA "*",$FF	
'===============================================================================
MyMusic08:
'INCLUDE ".bas"
DATA 8:MUSIC STOP
MyMusicTitle08: DATA "*",$FF	
'===============================================================================
MyMusic09:
'INCLUDE ".bas"
DATA 8:MUSIC STOP
MyMusicTitle09: DATA "*",$FF	
'===============================================================================
MyMusic10:
'INCLUDE ".bas"
DATA 8:MUSIC STOP
MyMusicTitle10: DATA "*",$FF	
'===============================================================================
MyMusic11:
'INCLUDE ".bas"
DATA 8:MUSIC STOP
MyMusicTitle11: DATA "*",$FF	
'===============================================================================
MyMusic12:
'INCLUDE ".bas"
DATA 8:MUSIC STOP
MyMusicTitle12: DATA "*",$FF	
'===============================================================================
MyMusic13:
'INCLUDE ".bas"
DATA 8:MUSIC STOP
MyMusicTitle13: DATA "*",$FF	
'===============================================================================
MyMusic14:
'INCLUDE ".bas"
DATA 8:MUSIC STOP
MyMusicTitle14: DATA "*",$FF	
'===============================================================================
MyMusic15:
'INCLUDE ".bas"
DATA 8:MUSIC STOP
MyMusicTitle15: DATA "*",$FF
'===============================================================================
MyMusic16:
'INCLUDE ".bas"
DATA 8:MUSIC STOP			
MyMusicTitle16: DATA "*",$FF	
'===============================================================================
MyMusic17:
'INCLUDE ".bas"
DATA 8:MUSIC STOP
MyMusicTitle17: DATA "*",$FF	
'===============================================================================
MyMusic18:
'INCLUDE ".bas"
DATA 8:MUSIC STOP
MyMusicTitle18: DATA "*",$FF	
'===============================================================================
MyMusic19:
'INCLUDE ".bas"
DATA 8:MUSIC STOP
MyMusicTitle19: DATA "*",$FF	
'===============================================================================
MyMusic20:
'INCLUDE ".bas"
DATA 8:MUSIC STOP
MyMusicTitle20: DATA "*",$FF	

EndProgram21: DATA $2100 '- to $2FFF
'---unused----

EndProgram71: DATA $7100 '- to $7FFF
EndProgram48: DATA $4810 '--to $4FFF 
