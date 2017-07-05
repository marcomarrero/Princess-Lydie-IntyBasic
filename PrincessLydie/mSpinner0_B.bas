'=={ME}===={ME}===={ME}===={ME}===={ME}===={ME}===={ME}===={ME}===={ME}===={ME}===={ME}===
Spinner_{ME}:
#tm=SPR57 + Frame8 + #pcolor_1
#ts=SPR59 + #pcolor_1
ti=3:tj=9			'--sprite offsets

IF ypos_1 >= DISABLED THEN 
	GoTo SpinOff_{ME}	'---Dead? don't animate
END IF
'--------
IF statusFreeze_1 THEN		'======Freeze, player was killed===wait until player offscreen==
	if state_die0=0 THEN statusFreeze_1=0
	SPRITE 1,VISIBLE + xpos_1 + ti - 4,ypos_1 + ZOOMY2 ,SPR60 + #pcolor_1
	
ELSEIF statusOK_1 THEN 	'=========OK====Walk======================================
	IF DIVBY8(xpos_1) THEN 	'(xpos_1 AND 8)=8 THEN 	
		IF #BACKTAB(backtabpos_1 + 20) = 0 THEN  '--fell?
			tx=(RAND AND 3)	'0,1,2,3
			IF tx THEN	'--tx<>0: turn around
				#xdir_1=-#xdir_1 
				statusOK_1=0:statusTurn_1=$FF
			Else		'--tx=0:fall
				statusOK_1=0:statusTurn_1=0:statusDown_1=1
				SPRITE 1,VISIBLE+ HIT+xpos_1,ypos_1 + ZOOMY2,SPR61 + #pcolor_1
				GOTO SpinSkipCheck_{ME}
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
	SPRITE 1,VISIBLE+ HIT  + xpos_1 + tl - 4, ypos_1 + ZOOMY2 + #tc, #tm
	
ELSEIF statusHit_1 THEN	'======HIT:fall below============================================
	GOSUB PStatusHit_{ME}

ELSEIF statusDie_1 THEN	'=========DIE (go offscreen)=================================
StatusDieSpin_{ME}:
	#ta={ME}:GOSUB PStatusDie_{ME}:IF #ta=0 THEN GOTO LevelWon

ELSEIF statusTurn_1 THEN	'=========Turn==========================================
	statusTurn_1=statusTurn_1-1
	IF statusTurn_1=$FE THEN 			
		SPRITE 1,VISIBLE+ HIT  + xpos_1 - 1 ,ypos_1 + ZOOMY2,#ts
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
		backtabpos_1=MUL20(ycard_1)+xcard_1
		statusDown_1=1
		'state_moved_1=1
		IF #BACKTAB(backtabpos_1 + 20)<>0 THEN 	'---if floor, stop fall
			statusDown_1=0:	statusTurn_1=$FF
			IF BadType_1 THEN 
				IF xpos_1 > xpos_0 THEN #xdir_1=2 ELSE #xdir_1=-2	'--Walker:towards player!
			ELSE
				IF (RAND AND 1) THEN #xdir_1=-#xdir_1				'--Snake: Random direction 
			END IF			
		END IF
		#tb=0	
	ELSE		
		#ts=SPR60+ #pcolor_1:#tb=FLIPY + 1
	END IF
	SPRITE 1,VISIBLE+ HIT + xpos_1 + 2,ypos_1 + ZOOMY2 + #tb, #ts 
			
ELSEIF statusWait_1 THEN   		'======WAIT:coccoon, wait ============================================
	GOSUB PStatusWait_{ME}
END IF		

SpinSkipCheck_1:
SpinOff_1:
ON BadType_{ME1} GOTO Snake_{ME1},Snake_{ME1},Spinner_{ME1},Jumper_{ME1}	
'-----{ME}------------END-------------------------------