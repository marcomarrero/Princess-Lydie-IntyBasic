''=={ME}===={ME}===={ME}===={ME}===={ME}===={ME}===={ME}===={ME}===={ME}===={ME}===={ME}===
PStatusDie_{ME}: PROCEDURE	'--Procedures also Called by spinner and jumper to reduce code size
	#tb=VISIBLE + 2
	IF (#xdir_1<>6) AND (#xdir_1<>-6) THEN 
		IF #xdir_0>0 THEN #xdir_1 = 6 ELSE #xdir_1= -6	'--kick in player's direction
	END IF
	xpos_1=xpos_1 + #xdir_1:ypos_1=ypos_1+2
	IF (xpos_1>=SPRITEMAXX-8) OR (xpos_1 <=8) OR (ypos_1 >= SPRITEMAXY) THEN 
		statusDie_1=0:StatusHit_1=0	'--- Kill baddy
		#ta={ME}
		GOSUB NextLevel
		#tb=0 'remove Visible flag
		ypos_1=DISABLED
	END IF 
	SPRITE 1,#tb + xpos_1,ypos_1 + ZOOMY2,SPR35 + #pcolor_1
END
'------
PStatusWait_{ME}: PROCEDURE	
	#ta=SPR34 + #pcolor_1 + Frame8
	statusWait_1 = statusWait_1 + 1
	IF statusWait_1 = ENEMY_SLEEPWAKE THEN
		statusWait_1 = 0:statusTurn_1=$FF ':statusOK_1 = 1
		IF BadType_{ME} < 3 THEN BadType_{ME}=BadType_{ME}+1	'--- Upgrade baddy!
		IF #SoundAddress<VARPTR Sound_Explode(0) THEN 	'--hahaha!!
			#SoundAddress=VARPTR Sound_Laugh(0):SoundVolume=VOL
		END IF		
	ELSEIF statusWait_1 >ENEMY_SLEEPWARN THEN		'---waking up
		IF Frame8 THEN 	#ta=SPR48 + CS_WHITE
	END IF
	SPRITE 1,VISIBLE+ HIT  + xpos_1 + 4,ypos_1 + ZOOMY2,#ta	
END 
'------
PStatusHit_{ME}: PROCEDURE
	ypos_1=ypos_1+2							'---fall 
	IF ypos_1>=SPRITEMAXY THEN ypos_1=4		'---out? Respawn at top		
	statusHit_1 = statusHit_1 + 1			'---Must do 4 steps	
	
	#ta=SPR35 + #pcolor_1
	#tb=VISIBLE + 2 
	IF DIVBY8(ypos_1) THEN 
		ycard_1=SPRITECARD(ypos_1):backtabpos_1=MUL20(ycard_1)+xcard_1
		IF #BACKTAB(backtabpos_1 + 20)<>0 THEN 	'---if floor, stop fall
			IF #BACKTAB(backtabpos_1)=0 THEN 	'--make sure I'm not embedded in floor!
				statusHit_1=0:statusWait_1=1
			END IF 
		END IF		
		#tb=#tb+HIT
	ELSEIF statusHit_1=$99 THEN 	'--can't land? die!
		statusOK_1=0:statusHit_1=0:statusWait_1=0:statusDie_1=$FF:xpos_1=SPRITEMAXX+10
	ELSEIF Frame8 THEN 		
		#ta=#ta-8	'SPR34
		#tb=#tb+1	'+3
	END IF
	SPRITE 1,#tb + xpos_1 ,ypos_1 + ZOOMY2,#ta	'-can't be hit yet
END 

'---------------------
Snake_{ME}:	'---type 0 and 1.. tx,ty,ti,tj,tk,tl
IF ypos_1 >= DISABLED THEN 
	GoTo SnakeOff_{ME}	'---Dead? don't animate
END IF

IF BadType_{ME}=0 THEN	'--type 0: Snake_
	#tm=SPR49 + Frame8 + #pcolor_1
	#ts= SPR51 + #pcolor_1
	ti=0:tj=4:tk=0		'--sprite offset, tk=random mask
Else	'type 1:Walker
	#tm=SPR54 + Frame8 + #pcolor_1
	#ts=SPR56 + #pcolor_1
	ti=1:tj=2:tk=1		'--sprite offsets, tk=random mask
END IF 
'--------
IF statusFreeze_1 THEN		'======Freeze, player was killed===wait until player offscreen==
	if state_die0=0 THEN statusFreeze_1=0
	SPRITE 1,VISIBLE + xpos_1 + tj,ypos_1 + ZOOMY2 ,SPR52 + #pcolor_1
	
ELSEIF statusOK_1 THEN 	'=========OK====Walk======================================
	IF DIVBY8(xpos_1) THEN 	'(xpos_1 AND 8)=8 THEN
		IF #BACKTAB(backtabpos_1 + 20) = 0 THEN  '--fell?
			tx=(RAND AND tk)
			IF tx THEN	'--tx<>0: turn around
				#xdir_1=-#xdir_1 
				statusOK_1=0:statusTurn_1=$FF
			Else		'--tx=0:fall
				statusOK_1=0:statusTurn_1=0:statusDown_1=1
				SPRITE 1,VISIBLE+ HIT+xpos_1,ypos_1 + ZOOMY2,SPR53 + #pcolor_1
				GOTO SkipCheck_{ME}
			END IF
		END IF
	END IF
	IF #xdir_1 > 0 THEN  	'---check right			
		#ta=2:tl=ti:#tc=0	'--#ta=left/right card, tl=sprite offset, #tc=FLIPX
	ELSE
		#ta=-2:tl=tj:#tc=FLIPX
	END IF	
	xpos_1=xpos_1 + #xdir_1
	
	statusOK_1 = (#BACKTAB(backtabpos_1 + #ta) = 0)
	statusTurn_1= statusOK_1 XOR $FF		
	xcard_1=SPRITECARD(xpos_1):backtabpos_1=MUL20(ycard_1)+xcard_1 'xpre_1=xpos_1
	state_moved_1=1
	SPRITE 1,VISIBLE+ HIT  + xpos_1 + tl, ypos_1 + ZOOMY2 + #tc, #tm
	
ELSEIF statusHit_1 THEN	'======HIT:fall below============================================
	GOSUB PStatusHit_{ME}

ELSEIF statusDie_1 THEN	'=========DIE (go offscreen)=================================
	#ta={ME}:GOSUB PStatusDie_{ME}:IF #ta=0 THEN GOTO LevelWon

ELSEIF statusTurn_1 THEN	'=========Turn==========================================
	statusTurn_1=statusTurn_1-1
	IF statusTurn_1=$FE THEN 			
		SPRITE 1,VISIBLE+ HIT  + xpos_1 + 2 ,ypos_1 + ZOOMY2,#ts
	ELSEIF statusTurn_1=$FF - ({ME}*6) THEN	'--delay, by sprite
		#xdir_1=-#xdir_1	'--Animation frame 
		statusOK_1=1
	ELSE
		statusOK_1 = (#BACKTAB(backtabpos_1 + 20) = 0)
	END IF	
	state_moved_1=1			
				
ELSEIF statusDown_1 THEN '======DOWN:fall below======================================
	ypos_1=ypos_1+2										'---fall
	IF ypos_1>=SPRITEMAXY THEN ypos_1=8:statusDown_1=0	'---out? Respawn at top			
	statusDown_1 = statusDown_1 + 1				'---Must do 4 steps		
	
	IF statusDown_1 = 5 THEN             	'---At step 4 (2*4=8), check below	
		ycard_1=SPRITECARD(ypos_1)
		backtabpos_1=MUL20(ycard_1)+xcard_1 'ypre_1=ypos_1
		state_moved_1=1:statusDown_1=1
		IF #BACKTAB(backtabpos_1 + 20)<>0 THEN 	'---if floor, stop fall
			statusDown_1=0:	statusTurn_1=$FF
			IF BadType_{ME} THEN 
				IF xpos_1 > xpos_0 THEN #xdir_1=2 ELSE #xdir_1=-2	'--Walker:towards player!
			ELSE
				IF (RAND AND 1) THEN #xdir_1=-#xdir_1				'--Snake: Random direction 
			END IF			
		END IF
		#tb=0	
	ELSE		
		#ts=SPR52+ #pcolor_1:#tb=FLIPY + 1
	END IF
	SPRITE 1,VISIBLE+ HIT + xpos_1 + 2,ypos_1 + ZOOMY2 + #tb, #ts 
			
ELSEIF statusWait_1 THEN   		'======WAIT:coccoon, wait ============================================
	GOSUB PStatusWait_{ME}
END IF		

SkipCheck_1:
SnakeOff_{ME}:
ON BadType_{ME1} GOTO Snake_{ME1},Snake_{ME1},Spinner_{ME1},Jumper_{ME1}
'-----{ME}------------END-------------------------------