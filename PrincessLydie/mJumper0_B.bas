'=={ME}===={ME}===={ME}===={ME}===={ME}===={ME}===={ME}===={ME}===={ME}===={ME}===={ME}===
Jumper_{ME}:
#tc=0
IF ypos_1 >= DISABLED THEN 
	GoTo JumpOff_{ME}	'---Dead? don't animate
END IF
'--------
IF statusFreeze_1 THEN		'======Freeze, player was killed===wait until player offscreen==
	if state_die0=0 THEN statusFreeze_1=0
	SPRITE 1,VISIBLE + xpos_1 + 2,ypos_1 + ZOOMY2 ,SPR43 + #pcolor_1	'--sprite:killed player 
	
ELSEIF statusOK_1 THEN 	'=========OK====Walk======================================
JumperOK_{ME}:
	IF DIVBY8(xpos_1) THEN 	'(xpos_1 AND 8)=8 THEN
		IF #BACKTAB(backtabpos_1 + 20) = 0 THEN  '--fell?
			IF #tc THEN tl=3 ELSE tl=(RAND AND 3)	'--decide if fell, turn, or jump.
			IF tl=1 THEN 			
				#xdir_1=-#xdir_1 	'--don't fall, turn around!	
				statusTurn_1=$FF:statusOK_1=0
			ELSEIF tl=2 THEN 		'--jump
				statusEtc_{ME}=1
				statusOK_1=0:statusTurn_1=0
			ELSE '3
				statusDown_1=1
				statusOK_1=0:statusTurn_1=0
				SPRITE 1,VISIBLE+ HIT  + xpos_1,ypos_1 + ZOOMY2,SPR42 + #pcolor_1	'---sprite:fall
				GOTO JumpSkipCheck_1
			END IF 
		END IF
	END IF 
	IF #xdir_1 > 0 THEN		'---check right			
		#ta=2:#tb=0		
	ELSE					'--check left
		#ta=-2:#tb=FLIPX	
	END IF	

	xpos_1=xpos_1 + #xdir_1
	if (xpos_1<BAD_MINX) THEN 
		xpos_1=BAD_MINX
		#xdir_1=-#xdir_1
	ELSEIF (xpos_1>BAD_MAXX) THEN
		xpos_1=BAD_MAXX
		#xdir_1=-#xdir_1 
	END IF		 

	statusOK_1 = (#BACKTAB(backtabpos_1 + #ta) = 0)		
	statusTurn_1= statusOK_1 XOR $FF		
	xcard_1=SPRITECARD(xpos_1):backtabpos_1=MUL20(ycard_1)+xcard_1 'xpre_1=xpos_1
	state_moved_1=1
	SPRITE 1,VISIBLE+ HIT  + xpos_1 + 2 ,ypos_1 + ZOOMY2 + #tb,SPR36 + Frame8 + #pcolor_1	'--sprite: right	

ELSEIF statusHit_1 THEN	'======HIT:fall below============================================
	GOSUB PStatusHit_{ME}

'======JUMP!===============================================================================
ELSEIF statusEtc_{ME} THEN 
	IF statusEtc_{ME}=1 THEN 
		statusEtc_{ME}=statusEtc_{ME}+1	
		IF ypos_1>8 THEN IF #BACKTAB(backtabpos_1 - 20)<>0 THEN 
			statusEtc_{ME}=4 '--if hits ceiling, stop jump NOW
		ELSE 
			ypos_1=ypos_1-2
		END IF 
	ELSEIF statusEtc_{ME}=2 THEN
		ypos_1=ypos_1-2
		GOTO JumpW{Me}
	ELSEIF statusEtc_{ME}=3 THEN 		
JumpW{ME}:
		IF DIVBY8(ypos_1) THEN
			statusEtc_{ME}=statusEtc_{ME}+1
			ycard_1=SPRITECARD(ypos_1)
			backtabpos_1=MUL20(ycard_1)+xcard_1	
			IF ypos_1>8 THEN IF #BACKTAB(backtabpos_1 - 20)<>0 THEN statusEtc_{ME}=4 '--if hits ceiling, stop jump NOW
		END IF 
	END IF 

	'--------jump direction---	backtabpos_1=MUL20(ycard_1)+xcard_1	
	IF #xdir_1 > 0 THEN	#ta=2 ELSE #ta=-2		'---direction
	IF DIVBY8(xpos_1) THEN 	
		'IF #BACKTAB(backtabpos_1 + #ta) = 0 THEN	'--bounce back if hits anything
		'#xdir_1=-#xdir_1
		'END IF
		IF statusEtc_{ME}=4 THEN 
			xcard_1=SPRITECARD(xpos_1)
			backtabpos_1=MUL20(ycard_1)+xcard_1			
			statusEtc_{ME}=0:statusDown_1=0:statusOK_1=1
			GOTO JumperOK_{ME}
		END IF 
	END IF	
	xpos_1=xpos_1 + #xdir_1
	if (xpos_1<BAD_MINX) THEN 
		xpos_1=BAD_MINX
		#xdir_1=-#xdir_1
	ELSEIF (xpos_1>BAD_MAXX) THEN
		xpos_1=BAD_MAXX
		#xdir_1=-#xdir_1 
	END IF
	SPRITE 1,VISIBLE+ HIT  + xpos_1 + 2,ypos_1 + ZOOMY2 + FLIPX, MonkeyJump(statusEtc_{ME}) + #pcolor_1

ELSEIF statusDie_1 THEN	'=========DIE (go offscreen)=================================	
	#ta={ME}:GOSUB PStatusDie_{ME}:IF #ta=0 THEN GOTO LevelWon
	
ELSEIF statusTurn_1 THEN	'=========Turn==========================================
	statusTurn_1=statusTurn_1-1
	IF statusTurn_1=$FE THEN 			
		SPRITE 1,VISIBLE+ HIT  + xpos_1 + 2 ,ypos_1 + ZOOMY2,SPR38 + #pcolor_1	'--sprite:turn
	ELSEIF statusTurn_1=$FF - ({ME}*4) THEN	'--delay, by sprite
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
			statusDown_1=0
			statusTurn_1=$FF			
			IF xpos_1 > xpos_0 THEN #xdir_1=1 ELSE #xdir_1=-1	'--towards player!
		END IF
	END IF  	
	IF (StatusDown_1 AND 1) THEN #ta=ZOOMY2  ELSE #ta=ZOOMY2+FLIPY
	SPRITE 1,VISIBLE+HIT + xpos_1 + 2,ypos_1 + #ta,SPR42 + Frame8 + #pcolor_1	
			
ELSEIF statusWait_1 THEN   		'======WAIT:coccoon, wait ============================================
	GOSUB PStatusWait_{ME}
END IF		

JumpSkipCheck_1:
JumpOff_{ME}:
ON BadType_{ME1} GOTO Snake_{ME1},Snake_{ME1},Spinner_{ME1},Jumper_{ME1}
'-----{ME}------------END-------------------------------
