'==1====1====1====1====1====1====1====1====1====1====1===
Jumper_1:
#tc=0
IF ypos_1 >= DISABLED THEN 
	GoTo JumpOff_1	'---Dead? don't animate
END IF
'--------
IF statusFreeze_1 THEN		'======Freeze, player was killed===wait until player offscreen==
	if state_die0=0 THEN statusFreeze_1=0
	SPRITE 1,VISIBLE + xpos_1 + 2,ypos_1 + ZOOMY2 ,SPR43 + #pcolor_1	'--sprite:killed player 
	
ELSEIF statusOK_1 THEN 	'=========OK====Walk======================================
JumperOK_1:
	IF DIVBY8(xpos_1) THEN 	'(xpos_1 AND 8)=8 THEN
		IF #BACKTAB(backtabpos_1 + 20) = 0 THEN  '--fell?
			IF #tc THEN tl=3 ELSE tl=(RAND AND 3)	'--decide if fell, turn, or jump.
			IF tl=1 THEN 			
				#xdir_1=-#xdir_1 	'--don't fall, turn around!	
				statusTurn_1=$FF:statusOK_1=0
			ELSEIF tl=2 THEN 		'--jump
				statusEtc_1=1
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
	GOSUB PStatusHit_1

'======JUMP!===============================================================================
ELSEIF statusEtc_1 THEN 
	IF statusEtc_1=1 THEN 
		statusEtc_1=statusEtc_1+1	
		IF ypos_1>8 THEN IF #BACKTAB(backtabpos_1 - 20)<>0 THEN 
			statusEtc_1=4 '--if hits ceiling, stop jump NOW
		ELSE 
			ypos_1=ypos_1-2
		END IF 
	ELSEIF statusEtc_1=2 THEN
		ypos_1=ypos_1-2
		GOTO JumpW1
	ELSEIF statusEtc_1=3 THEN 		
JumpW1:
		IF DIVBY8(ypos_1) THEN
			statusEtc_1=statusEtc_1+1
			ycard_1=SPRITECARD(ypos_1)
			backtabpos_1=MUL20(ycard_1)+xcard_1	
			IF ypos_1>8 THEN IF #BACKTAB(backtabpos_1 - 20)<>0 THEN statusEtc_1=4 '--if hits ceiling, stop jump NOW
		END IF 
	END IF 

	'--------jump direction---	backtabpos_1=MUL20(ycard_1)+xcard_1	
	IF #xdir_1 > 0 THEN	#ta=2 ELSE #ta=-2		'---direction
	IF DIVBY8(xpos_1) THEN 	
		'IF #BACKTAB(backtabpos_1 + #ta) = 0 THEN	'--bounce back if hits anything
		'#xdir_1=-#xdir_1
		'END IF
		IF statusEtc_1=4 THEN 
			xcard_1=SPRITECARD(xpos_1)
			backtabpos_1=MUL20(ycard_1)+xcard_1			
			statusEtc_1=0:statusDown_1=0:statusOK_1=1
			GOTO JumperOK_1
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
	SPRITE 1,VISIBLE+ HIT  + xpos_1 + 2,ypos_1 + ZOOMY2 + FLIPX, MonkeyJump(statusEtc_1) + #pcolor_1

ELSEIF statusDie_1 THEN	'=========DIE (go offscreen)=================================	
	#ta=1:GOSUB PStatusDie_1:IF #ta=0 THEN GOTO LevelWon
	
ELSEIF statusTurn_1 THEN	'=========Turn==========================================
	statusTurn_1=statusTurn_1-1
	IF statusTurn_1=$FE THEN 			
		SPRITE 1,VISIBLE+ HIT  + xpos_1 + 2 ,ypos_1 + ZOOMY2,SPR38 + #pcolor_1	'--sprite:turn
	ELSEIF statusTurn_1=$FF - (1*4) THEN	'--delay, by sprite
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
	IF (statusDown_1 AND 1) THEN #ta=ZOOMY2  ELSE #ta=ZOOMY2+FLIPY
	SPRITE 1,VISIBLE+HIT + xpos_1 + 2,ypos_1 + #ta,SPR42 + Frame8 + #pcolor_1	
			
ELSEIF statusWait_1 THEN   		'======WAIT:coccoon, wait ============================================
	GOSUB PStatusWait_1
END IF		

JumpSkipCheck_1:
JumpOff_1:
ON BadType_2 GOTO Snake_2,Snake_2,Spinner_2,Jumper_2
'-----1------------END-------------------------------
'==2====2====2====2====2====2====2====2====2====2====2===
Jumper_2:
#tc=0
IF ypos_2 >= DISABLED THEN 
	GoTo JumpOff_2	'---Dead? don't animate
END IF
'--------
IF statusFreeze_2 THEN		'======Freeze, player was killed===wait until player offscreen==
	if state_die0=0 THEN statusFreeze_2=0
	SPRITE 2,VISIBLE + xpos_2 + 2,ypos_2 + ZOOMY2 ,SPR43 + #pcolor_2	'--sprite:killed player 
	
ELSEIF statusOK_2 THEN 	'=========OK====Walk======================================
JumperOK_2:
	IF DIVBY8(xpos_2) THEN 	'(xpos_2 AND 8)=8 THEN
		IF #BACKTAB(backtabpos_2 + 20) = 0 THEN  '--fell?
			IF #tc THEN tl=3 ELSE tl=(RAND AND 3)	'--decide if fell, turn, or jump.
			IF tl=1 THEN 			
				#xdir_2=-#xdir_2 	'--don't fall, turn around!	
				statusTurn_2=$FF:statusOK_2=0
			ELSEIF tl=2 THEN 		'--jump
				statusEtc_2=1
				statusOK_2=0:statusTurn_2=0
			ELSE '3
				statusDown_2=1
				statusOK_2=0:statusTurn_2=0
				SPRITE 2,VISIBLE+ HIT  + xpos_2,ypos_2 + ZOOMY2,SPR42 + #pcolor_2	'---sprite:fall
				GOTO JumpSkipCheck_2
			END IF 
		END IF
	END IF 
	IF #xdir_2 > 0 THEN		'---check right			
		#ta=2:#tb=0		
	ELSE					'--check left
		#ta=-2:#tb=FLIPX	
	END IF	

	xpos_2=xpos_2 + #xdir_2
	if (xpos_2<BAD_MINX) THEN 
		xpos_2=BAD_MINX
		#xdir_2=-#xdir_2
	ELSEIF (xpos_2>BAD_MAXX) THEN
		xpos_2=BAD_MAXX
		#xdir_2=-#xdir_2 
	END IF		 

	statusOK_2 = (#BACKTAB(backtabpos_2 + #ta) = 0)		
	statusTurn_2= statusOK_2 XOR $FF		
	xcard_2=SPRITECARD(xpos_2):backtabpos_2=MUL20(ycard_2)+xcard_2 'xpre_2=xpos_2
	state_moved_2=1
	SPRITE 2,VISIBLE+ HIT  + xpos_2 + 2 ,ypos_2 + ZOOMY2 + #tb,SPR36 + Frame8 + #pcolor_2	'--sprite: right	

ELSEIF statusHit_2 THEN	'======HIT:fall below============================================
	GOSUB PStatusHit_2

'======JUMP!===============================================================================
ELSEIF statusEtc_2 THEN 
	IF statusEtc_2=1 THEN 
		statusEtc_2=statusEtc_2+1	
		IF ypos_2>8 THEN IF #BACKTAB(backtabpos_2 - 20)<>0 THEN 
			statusEtc_2=4 '--if hits ceiling, stop jump NOW
		ELSE 
			ypos_2=ypos_2-2
		END IF 
	ELSEIF statusEtc_2=2 THEN
		ypos_2=ypos_2-2
		GOTO JumpW2
	ELSEIF statusEtc_2=3 THEN 		
JumpW2:
		IF DIVBY8(ypos_2) THEN
			statusEtc_2=statusEtc_2+1
			ycard_2=SPRITECARD(ypos_2)
			backtabpos_2=MUL20(ycard_2)+xcard_2	
			IF ypos_2>8 THEN IF #BACKTAB(backtabpos_2 - 20)<>0 THEN statusEtc_2=4 '--if hits ceiling, stop jump NOW
		END IF 
	END IF 

	'--------jump direction---	backtabpos_2=MUL20(ycard_2)+xcard_2	
	IF #xdir_2 > 0 THEN	#ta=2 ELSE #ta=-2		'---direction
	IF DIVBY8(xpos_2) THEN 	
		'IF #BACKTAB(backtabpos_2 + #ta) = 0 THEN	'--bounce back if hits anything
		'#xdir_2=-#xdir_2
		'END IF
		IF statusEtc_2=4 THEN 
			xcard_2=SPRITECARD(xpos_2)
			backtabpos_2=MUL20(ycard_2)+xcard_2			
			statusEtc_2=0:statusDown_2=0:statusOK_2=1
			GOTO JumperOK_2
		END IF 
	END IF	
	xpos_2=xpos_2 + #xdir_2
	if (xpos_2<BAD_MINX) THEN 
		xpos_2=BAD_MINX
		#xdir_2=-#xdir_2
	ELSEIF (xpos_2>BAD_MAXX) THEN
		xpos_2=BAD_MAXX
		#xdir_2=-#xdir_2 
	END IF
	SPRITE 2,VISIBLE+ HIT  + xpos_2 + 2,ypos_2 + ZOOMY2 + FLIPX, MonkeyJump(statusEtc_2) + #pcolor_2

ELSEIF statusDie_2 THEN	'=========DIE (go offscreen)=================================	
	#ta=2:GOSUB PStatusDie_2:IF #ta=0 THEN GOTO LevelWon
	
ELSEIF statusTurn_2 THEN	'=========Turn==========================================
	statusTurn_2=statusTurn_2-1
	IF statusTurn_2=$FE THEN 			
		SPRITE 2,VISIBLE+ HIT  + xpos_2 + 2 ,ypos_2 + ZOOMY2,SPR38 + #pcolor_2	'--sprite:turn
	ELSEIF statusTurn_2=$FF - (2*4) THEN	'--delay, by sprite
		#xdir_2=-#xdir_2	'--Animation frame 
		statusOK_2=1
	ELSE
		statusOK_2 = (#BACKTAB(backtabpos_2 + 20) = 0)
	END IF	
	state_moved_2=1		
					
ELSEIF statusDown_2 THEN '======DOWN:fall below======================================
	ypos_2=ypos_2+2										'---fall
	IF ypos_2>=SPRITEMAXY THEN ypos_2=8:statusDown_2=0	'---out? Respawn at top			
	statusDown_2 = statusDown_2 + 1				'---Must do 4 steps		
	
	IF statusDown_2 = 5 THEN             	'---At step 4 (2*4=8), check below	
		ycard_2=SPRITECARD(ypos_2)
		backtabpos_2=MUL20(ycard_2)+xcard_2 'ypre_2=ypos_2
		state_moved_2=1:statusDown_2=1
		IF #BACKTAB(backtabpos_2 + 20)<>0 THEN 	'---if floor, stop fall
			statusDown_2=0
			statusTurn_2=$FF			
			IF xpos_2 > xpos_0 THEN #xdir_2=1 ELSE #xdir_2=-1	'--towards player!
		END IF
	END IF  	
	IF (statusDown_2 AND 1) THEN #ta=ZOOMY2  ELSE #ta=ZOOMY2+FLIPY
	SPRITE 2,VISIBLE+HIT + xpos_2 + 2,ypos_2 + #ta,SPR42 + Frame8 + #pcolor_2	
			
ELSEIF statusWait_2 THEN   		'======WAIT:coccoon, wait ============================================
	GOSUB PStatusWait_2
END IF		

JumpSkipCheck_2:
JumpOff_2:
ON BadType_3 GOTO Snake_3,Snake_3,Spinner_3,Jumper_3
'-----2------------END-------------------------------
'==3====3====3====3====3====3====3====3====3====3====3===
Jumper_3:
#tc=0
IF ypos_3 >= DISABLED THEN 
	GoTo JumpOff_3	'---Dead? don't animate
END IF
'--------
IF statusFreeze_3 THEN		'======Freeze, player was killed===wait until player offscreen==
	if state_die0=0 THEN statusFreeze_3=0
	SPRITE 3,VISIBLE + xpos_3 + 2,ypos_3 + ZOOMY2 ,SPR43 + #pcolor_3	'--sprite:killed player 
	
ELSEIF statusOK_3 THEN 	'=========OK====Walk======================================
JumperOK_3:
	IF DIVBY8(xpos_3) THEN 	'(xpos_3 AND 8)=8 THEN
		IF #BACKTAB(backtabpos_3 + 20) = 0 THEN  '--fell?
			IF #tc THEN tl=3 ELSE tl=(RAND AND 3)	'--decide if fell, turn, or jump.
			IF tl=1 THEN 			
				#xdir_3=-#xdir_3 	'--don't fall, turn around!	
				statusTurn_3=$FF:statusOK_3=0
			ELSEIF tl=2 THEN 		'--jump
				statusEtc_3=1
				statusOK_3=0:statusTurn_3=0
			ELSE '3
				statusDown_3=1
				statusOK_3=0:statusTurn_3=0
				SPRITE 3,VISIBLE+ HIT  + xpos_3,ypos_3 + ZOOMY2,SPR42 + #pcolor_3	'---sprite:fall
				GOTO JumpSkipCheck_3
			END IF 
		END IF
	END IF 
	IF #xdir_3 > 0 THEN		'---check right			
		#ta=2:#tb=0		
	ELSE					'--check left
		#ta=-2:#tb=FLIPX	
	END IF	

	xpos_3=xpos_3 + #xdir_3
	if (xpos_3<BAD_MINX) THEN 
		xpos_3=BAD_MINX
		#xdir_3=-#xdir_3
	ELSEIF (xpos_3>BAD_MAXX) THEN
		xpos_3=BAD_MAXX
		#xdir_3=-#xdir_3 
	END IF		 

	statusOK_3 = (#BACKTAB(backtabpos_3 + #ta) = 0)		
	statusTurn_3= statusOK_3 XOR $FF		
	xcard_3=SPRITECARD(xpos_3):backtabpos_3=MUL20(ycard_3)+xcard_3 'xpre_3=xpos_3
	state_moved_3=1
	SPRITE 3,VISIBLE+ HIT  + xpos_3 + 2 ,ypos_3 + ZOOMY2 + #tb,SPR36 + Frame8 + #pcolor_3	'--sprite: right	

ELSEIF statusHit_3 THEN	'======HIT:fall below============================================
	GOSUB PStatusHit_3

'======JUMP!===============================================================================
ELSEIF statusEtc_3 THEN 
	IF statusEtc_3=1 THEN 
		statusEtc_3=statusEtc_3+1	
		IF ypos_3>8 THEN IF #BACKTAB(backtabpos_3 - 20)<>0 THEN 
			statusEtc_3=4 '--if hits ceiling, stop jump NOW
		ELSE 
			ypos_3=ypos_3-2
		END IF 
	ELSEIF statusEtc_3=2 THEN
		ypos_3=ypos_3-2
		GOTO JumpW3
	ELSEIF statusEtc_3=3 THEN 		
JumpW3:
		IF DIVBY8(ypos_3) THEN
			statusEtc_3=statusEtc_3+1
			ycard_3=SPRITECARD(ypos_3)
			backtabpos_3=MUL20(ycard_3)+xcard_3	
			IF ypos_3>8 THEN IF #BACKTAB(backtabpos_3 - 20)<>0 THEN statusEtc_3=4 '--if hits ceiling, stop jump NOW
		END IF 
	END IF 

	'--------jump direction---	backtabpos_3=MUL20(ycard_3)+xcard_3	
	IF #xdir_3 > 0 THEN	#ta=2 ELSE #ta=-2		'---direction
	IF DIVBY8(xpos_3) THEN 	
		'IF #BACKTAB(backtabpos_3 + #ta) = 0 THEN	'--bounce back if hits anything
		'#xdir_3=-#xdir_3
		'END IF
		IF statusEtc_3=4 THEN 
			xcard_3=SPRITECARD(xpos_3)
			backtabpos_3=MUL20(ycard_3)+xcard_3			
			statusEtc_3=0:statusDown_3=0:statusOK_3=1
			GOTO JumperOK_3
		END IF 
	END IF	
	xpos_3=xpos_3 + #xdir_3
	if (xpos_3<BAD_MINX) THEN 
		xpos_3=BAD_MINX
		#xdir_3=-#xdir_3
	ELSEIF (xpos_3>BAD_MAXX) THEN
		xpos_3=BAD_MAXX
		#xdir_3=-#xdir_3 
	END IF
	SPRITE 3,VISIBLE+ HIT  + xpos_3 + 2,ypos_3 + ZOOMY2 + FLIPX, MonkeyJump(statusEtc_3) + #pcolor_3

ELSEIF statusDie_3 THEN	'=========DIE (go offscreen)=================================	
	#ta=3:GOSUB PStatusDie_3:IF #ta=0 THEN GOTO LevelWon
	
ELSEIF statusTurn_3 THEN	'=========Turn==========================================
	statusTurn_3=statusTurn_3-1
	IF statusTurn_3=$FE THEN 			
		SPRITE 3,VISIBLE+ HIT  + xpos_3 + 2 ,ypos_3 + ZOOMY2,SPR38 + #pcolor_3	'--sprite:turn
	ELSEIF statusTurn_3=$FF - (3*4) THEN	'--delay, by sprite
		#xdir_3=-#xdir_3	'--Animation frame 
		statusOK_3=1
	ELSE
		statusOK_3 = (#BACKTAB(backtabpos_3 + 20) = 0)
	END IF	
	state_moved_3=1		
					
ELSEIF statusDown_3 THEN '======DOWN:fall below======================================
	ypos_3=ypos_3+2										'---fall
	IF ypos_3>=SPRITEMAXY THEN ypos_3=8:statusDown_3=0	'---out? Respawn at top			
	statusDown_3 = statusDown_3 + 1				'---Must do 4 steps		
	
	IF statusDown_3 = 5 THEN             	'---At step 4 (2*4=8), check below	
		ycard_3=SPRITECARD(ypos_3)
		backtabpos_3=MUL20(ycard_3)+xcard_3 'ypre_3=ypos_3
		state_moved_3=1:statusDown_3=1
		IF #BACKTAB(backtabpos_3 + 20)<>0 THEN 	'---if floor, stop fall
			statusDown_3=0
			statusTurn_3=$FF			
			IF xpos_3 > xpos_0 THEN #xdir_3=1 ELSE #xdir_3=-1	'--towards player!
		END IF
	END IF  	
	IF (statusDown_3 AND 1) THEN #ta=ZOOMY2  ELSE #ta=ZOOMY2+FLIPY
	SPRITE 3,VISIBLE+HIT + xpos_3 + 2,ypos_3 + #ta,SPR42 + Frame8 + #pcolor_3	
			
ELSEIF statusWait_3 THEN   		'======WAIT:coccoon, wait ============================================
	GOSUB PStatusWait_3
END IF		

JumpSkipCheck_3:
JumpOff_3:
ON BadType_4 GOTO Snake_4,Snake_4,Spinner_4,Jumper_4
'-----3------------END-------------------------------
'==4====4====4====4====4====4====4====4====4====4====4===
Jumper_4:
#tc=0
IF ypos_4 >= DISABLED THEN 
	GoTo JumpOff_4	'---Dead? don't animate
END IF
'--------
IF statusFreeze_4 THEN		'======Freeze, player was killed===wait until player offscreen==
	if state_die0=0 THEN statusFreeze_4=0
	SPRITE 4,VISIBLE + xpos_4 + 2,ypos_4 + ZOOMY2 ,SPR43 + #pcolor_4	'--sprite:killed player 
	
ELSEIF statusOK_4 THEN 	'=========OK====Walk======================================
JumperOK_4:
	IF DIVBY8(xpos_4) THEN 	'(xpos_4 AND 8)=8 THEN
		IF #BACKTAB(backtabpos_4 + 20) = 0 THEN  '--fell?
			IF #tc THEN tl=3 ELSE tl=(RAND AND 3)	'--decide if fell, turn, or jump.
			IF tl=1 THEN 			
				#xdir_4=-#xdir_4 	'--don't fall, turn around!	
				statusTurn_4=$FF:statusOK_4=0
			ELSEIF tl=2 THEN 		'--jump
				statusEtc_4=1
				statusOK_4=0:statusTurn_4=0
			ELSE '3
				statusDown_4=1
				statusOK_4=0:statusTurn_4=0
				SPRITE 4,VISIBLE+ HIT  + xpos_4,ypos_4 + ZOOMY2,SPR42 + #pcolor_4	'---sprite:fall
				GOTO JumpSkipCheck_4
			END IF 
		END IF
	END IF 
	IF #xdir_4 > 0 THEN		'---check right			
		#ta=2:#tb=0		
	ELSE					'--check left
		#ta=-2:#tb=FLIPX	
	END IF	

	xpos_4=xpos_4 + #xdir_4
	if (xpos_4<BAD_MINX) THEN 
		xpos_4=BAD_MINX
		#xdir_4=-#xdir_4
	ELSEIF (xpos_4>BAD_MAXX) THEN
		xpos_4=BAD_MAXX
		#xdir_4=-#xdir_4 
	END IF		 

	statusOK_4 = (#BACKTAB(backtabpos_4 + #ta) = 0)		
	statusTurn_4= statusOK_4 XOR $FF		
	xcard_4=SPRITECARD(xpos_4):backtabpos_4=MUL20(ycard_4)+xcard_4 'xpre_4=xpos_4
	state_moved_4=1
	SPRITE 4,VISIBLE+ HIT  + xpos_4 + 2 ,ypos_4 + ZOOMY2 + #tb,SPR36 + Frame8 + #pcolor_4	'--sprite: right	

ELSEIF statusHit_4 THEN	'======HIT:fall below============================================
	GOSUB PStatusHit_4

'======JUMP!===============================================================================
ELSEIF statusEtc_4 THEN 
	IF statusEtc_4=1 THEN 
		statusEtc_4=statusEtc_4+1	
		IF ypos_4>8 THEN IF #BACKTAB(backtabpos_4 - 20)<>0 THEN 
			statusEtc_4=4 '--if hits ceiling, stop jump NOW
		ELSE 
			ypos_4=ypos_4-2
		END IF 
	ELSEIF statusEtc_4=2 THEN
		ypos_4=ypos_4-2
		GOTO JumpW4
	ELSEIF statusEtc_4=3 THEN 		
JumpW4:
		IF DIVBY8(ypos_4) THEN
			statusEtc_4=statusEtc_4+1
			ycard_4=SPRITECARD(ypos_4)
			backtabpos_4=MUL20(ycard_4)+xcard_4	
			IF ypos_4>8 THEN IF #BACKTAB(backtabpos_4 - 20)<>0 THEN statusEtc_4=4 '--if hits ceiling, stop jump NOW
		END IF 
	END IF 

	'--------jump direction---	backtabpos_4=MUL20(ycard_4)+xcard_4	
	IF #xdir_4 > 0 THEN	#ta=2 ELSE #ta=-2		'---direction
	IF DIVBY8(xpos_4) THEN 	
		'IF #BACKTAB(backtabpos_4 + #ta) = 0 THEN	'--bounce back if hits anything
		'#xdir_4=-#xdir_4
		'END IF
		IF statusEtc_4=4 THEN 
			xcard_4=SPRITECARD(xpos_4)
			backtabpos_4=MUL20(ycard_4)+xcard_4			
			statusEtc_4=0:statusDown_4=0:statusOK_4=1
			GOTO JumperOK_4
		END IF 
	END IF	
	xpos_4=xpos_4 + #xdir_4
	if (xpos_4<BAD_MINX) THEN 
		xpos_4=BAD_MINX
		#xdir_4=-#xdir_4
	ELSEIF (xpos_4>BAD_MAXX) THEN
		xpos_4=BAD_MAXX
		#xdir_4=-#xdir_4 
	END IF
	SPRITE 4,VISIBLE+ HIT  + xpos_4 + 2,ypos_4 + ZOOMY2 + FLIPX, MonkeyJump(statusEtc_4) + #pcolor_4

ELSEIF statusDie_4 THEN	'=========DIE (go offscreen)=================================	
	#ta=4:GOSUB PStatusDie_4:IF #ta=0 THEN GOTO LevelWon
	
ELSEIF statusTurn_4 THEN	'=========Turn==========================================
	statusTurn_4=statusTurn_4-1
	IF statusTurn_4=$FE THEN 			
		SPRITE 4,VISIBLE+ HIT  + xpos_4 + 2 ,ypos_4 + ZOOMY2,SPR38 + #pcolor_4	'--sprite:turn
	ELSEIF statusTurn_4=$FF - (4*4) THEN	'--delay, by sprite
		#xdir_4=-#xdir_4	'--Animation frame 
		statusOK_4=1
	ELSE
		statusOK_4 = (#BACKTAB(backtabpos_4 + 20) = 0)
	END IF	
	state_moved_4=1		
					
ELSEIF statusDown_4 THEN '======DOWN:fall below======================================
	ypos_4=ypos_4+2										'---fall
	IF ypos_4>=SPRITEMAXY THEN ypos_4=8:statusDown_4=0	'---out? Respawn at top			
	statusDown_4 = statusDown_4 + 1				'---Must do 4 steps		
	
	IF statusDown_4 = 5 THEN             	'---At step 4 (2*4=8), check below	
		ycard_4=SPRITECARD(ypos_4)
		backtabpos_4=MUL20(ycard_4)+xcard_4 'ypre_4=ypos_4
		state_moved_4=1:statusDown_4=1
		IF #BACKTAB(backtabpos_4 + 20)<>0 THEN 	'---if floor, stop fall
			statusDown_4=0
			statusTurn_4=$FF			
			IF xpos_4 > xpos_0 THEN #xdir_4=1 ELSE #xdir_4=-1	'--towards player!
		END IF
	END IF  	
	IF (statusDown_4 AND 1) THEN #ta=ZOOMY2  ELSE #ta=ZOOMY2+FLIPY
	SPRITE 4,VISIBLE+HIT + xpos_4 + 2,ypos_4 + #ta,SPR42 + Frame8 + #pcolor_4	
			
ELSEIF statusWait_4 THEN   		'======WAIT:coccoon, wait ============================================
	GOSUB PStatusWait_4
END IF		

JumpSkipCheck_4:
JumpOff_4:
ON BadType_5 GOTO Snake_5,Snake_5,Spinner_5,Jumper_5
'-----4------------END-------------------------------
'==5====5====5====5====5====5====5====5====5====5====5===
Jumper_5:
#tc=0
IF ypos_5 >= DISABLED THEN 
	GoTo JumpOff_5	'---Dead? don't animate
END IF
'--------
IF statusFreeze_5 THEN		'======Freeze, player was killed===wait until player offscreen==
	if state_die0=0 THEN statusFreeze_5=0
	SPRITE 5,VISIBLE + xpos_5 + 2,ypos_5 + ZOOMY2 ,SPR43 + #pcolor_5	'--sprite:killed player 
	
ELSEIF statusOK_5 THEN 	'=========OK====Walk======================================
JumperOK_5:
	IF DIVBY8(xpos_5) THEN 	'(xpos_5 AND 8)=8 THEN
		IF #BACKTAB(backtabpos_5 + 20) = 0 THEN  '--fell?
			IF #tc THEN tl=3 ELSE tl=(RAND AND 3)	'--decide if fell, turn, or jump.
			IF tl=1 THEN 			
				#xdir_5=-#xdir_5 	'--don't fall, turn around!	
				statusTurn_5=$FF:statusOK_5=0
			ELSEIF tl=2 THEN 		'--jump
				statusEtc_5=1
				statusOK_5=0:statusTurn_5=0
			ELSE '3
				statusDown_5=1
				statusOK_5=0:statusTurn_5=0
				SPRITE 5,VISIBLE+ HIT  + xpos_5,ypos_5 + ZOOMY2,SPR42 + #pcolor_5	'---sprite:fall
				GOTO JumpSkipCheck_5
			END IF 
		END IF
	END IF 
	IF #xdir_5 > 0 THEN		'---check right			
		#ta=2:#tb=0		
	ELSE					'--check left
		#ta=-2:#tb=FLIPX	
	END IF	

	xpos_5=xpos_5 + #xdir_5
	if (xpos_5<BAD_MINX) THEN 
		xpos_5=BAD_MINX
		#xdir_5=-#xdir_5
	ELSEIF (xpos_5>BAD_MAXX) THEN
		xpos_5=BAD_MAXX
		#xdir_5=-#xdir_5 
	END IF		 

	statusOK_5 = (#BACKTAB(backtabpos_5 + #ta) = 0)		
	statusTurn_5= statusOK_5 XOR $FF		
	xcard_5=SPRITECARD(xpos_5):backtabpos_5=MUL20(ycard_5)+xcard_5 'xpre_5=xpos_5
	state_moved_5=1
	SPRITE 5,VISIBLE+ HIT  + xpos_5 + 2 ,ypos_5 + ZOOMY2 + #tb,SPR36 + Frame8 + #pcolor_5	'--sprite: right	

ELSEIF statusHit_5 THEN	'======HIT:fall below============================================
	GOSUB PStatusHit_5

'======JUMP!===============================================================================
ELSEIF statusEtc_5 THEN 
	IF statusEtc_5=1 THEN 
		statusEtc_5=statusEtc_5+1	
		IF ypos_5>8 THEN IF #BACKTAB(backtabpos_5 - 20)<>0 THEN 
			statusEtc_5=4 '--if hits ceiling, stop jump NOW
		ELSE 
			ypos_5=ypos_5-2
		END IF 
	ELSEIF statusEtc_5=2 THEN
		ypos_5=ypos_5-2
		GOTO JumpW5
	ELSEIF statusEtc_5=3 THEN 		
JumpW5:
		IF DIVBY8(ypos_5) THEN
			statusEtc_5=statusEtc_5+1
			ycard_5=SPRITECARD(ypos_5)
			backtabpos_5=MUL20(ycard_5)+xcard_5	
			IF ypos_5>8 THEN IF #BACKTAB(backtabpos_5 - 20)<>0 THEN statusEtc_5=4 '--if hits ceiling, stop jump NOW
		END IF 
	END IF 

	'--------jump direction---	backtabpos_5=MUL20(ycard_5)+xcard_5	
	IF #xdir_5 > 0 THEN	#ta=2 ELSE #ta=-2		'---direction
	IF DIVBY8(xpos_5) THEN 	
		'IF #BACKTAB(backtabpos_5 + #ta) = 0 THEN	'--bounce back if hits anything
		'#xdir_5=-#xdir_5
		'END IF
		IF statusEtc_5=4 THEN 
			xcard_5=SPRITECARD(xpos_5)
			backtabpos_5=MUL20(ycard_5)+xcard_5			
			statusEtc_5=0:statusDown_5=0:statusOK_5=1
			GOTO JumperOK_5
		END IF 
	END IF	
	xpos_5=xpos_5 + #xdir_5
	if (xpos_5<BAD_MINX) THEN 
		xpos_5=BAD_MINX
		#xdir_5=-#xdir_5
	ELSEIF (xpos_5>BAD_MAXX) THEN
		xpos_5=BAD_MAXX
		#xdir_5=-#xdir_5 
	END IF
	SPRITE 5,VISIBLE+ HIT  + xpos_5 + 2,ypos_5 + ZOOMY2 + FLIPX, MonkeyJump(statusEtc_5) + #pcolor_5

ELSEIF statusDie_5 THEN	'=========DIE (go offscreen)=================================	
	#ta=5:GOSUB PStatusDie_5:IF #ta=0 THEN GOTO LevelWon
	
ELSEIF statusTurn_5 THEN	'=========Turn==========================================
	statusTurn_5=statusTurn_5-1
	IF statusTurn_5=$FE THEN 			
		SPRITE 5,VISIBLE+ HIT  + xpos_5 + 2 ,ypos_5 + ZOOMY2,SPR38 + #pcolor_5	'--sprite:turn
	ELSEIF statusTurn_5=$FF - (5*4) THEN	'--delay, by sprite
		#xdir_5=-#xdir_5	'--Animation frame 
		statusOK_5=1
	ELSE
		statusOK_5 = (#BACKTAB(backtabpos_5 + 20) = 0)
	END IF	
	state_moved_5=1		
					
ELSEIF statusDown_5 THEN '======DOWN:fall below======================================
	ypos_5=ypos_5+2										'---fall
	IF ypos_5>=SPRITEMAXY THEN ypos_5=8:statusDown_5=0	'---out? Respawn at top			
	statusDown_5 = statusDown_5 + 1				'---Must do 4 steps		
	
	IF statusDown_5 = 5 THEN             	'---At step 4 (2*4=8), check below	
		ycard_5=SPRITECARD(ypos_5)
		backtabpos_5=MUL20(ycard_5)+xcard_5 'ypre_5=ypos_5
		state_moved_5=1:statusDown_5=1
		IF #BACKTAB(backtabpos_5 + 20)<>0 THEN 	'---if floor, stop fall
			statusDown_5=0
			statusTurn_5=$FF			
			IF xpos_5 > xpos_0 THEN #xdir_5=1 ELSE #xdir_5=-1	'--towards player!
		END IF
	END IF  	
	IF (statusDown_5 AND 1) THEN #ta=ZOOMY2  ELSE #ta=ZOOMY2+FLIPY
	SPRITE 5,VISIBLE+HIT + xpos_5 + 2,ypos_5 + #ta,SPR42 + Frame8 + #pcolor_5	
			
ELSEIF statusWait_5 THEN   		'======WAIT:coccoon, wait ============================================
	GOSUB PStatusWait_5
END IF		

JumpSkipCheck_5:
JumpOff_5:
ON BadType_6 GOTO Snake_6,Snake_6,Spinner_6,Jumper_6
'-----5------------END-------------------------------
'==6====6====6====6====6====6====6====6====6====6====6===
Jumper_6:
#tc=0
IF ypos_6 >= DISABLED THEN 
	GoTo JumpOff_6	'---Dead? don't animate
END IF
'--------
IF statusFreeze_6 THEN		'======Freeze, player was killed===wait until player offscreen==
	if state_die0=0 THEN statusFreeze_6=0
	SPRITE 6,VISIBLE + xpos_6 + 2,ypos_6 + ZOOMY2 ,SPR43 + #pcolor_6	'--sprite:killed player 
	
ELSEIF statusOK_6 THEN 	'=========OK====Walk======================================
JumperOK_6:
	IF DIVBY8(xpos_6) THEN 	'(xpos_6 AND 8)=8 THEN
		IF #BACKTAB(backtabpos_6 + 20) = 0 THEN  '--fell?
			IF #tc THEN tl=3 ELSE tl=(RAND AND 3)	'--decide if fell, turn, or jump.
			IF tl=1 THEN 			
				#xdir_6=-#xdir_6 	'--don't fall, turn around!	
				statusTurn_6=$FF:statusOK_6=0
			ELSEIF tl=2 THEN 		'--jump
				statusEtc_6=1
				statusOK_6=0:statusTurn_6=0
			ELSE '3
				statusDown_6=1
				statusOK_6=0:statusTurn_6=0
				SPRITE 6,VISIBLE+ HIT  + xpos_6,ypos_6 + ZOOMY2,SPR42 + #pcolor_6	'---sprite:fall
				GOTO JumpSkipCheck_6
			END IF 
		END IF
	END IF 
	IF #xdir_6 > 0 THEN		'---check right			
		#ta=2:#tb=0		
	ELSE					'--check left
		#ta=-2:#tb=FLIPX	
	END IF	

	xpos_6=xpos_6 + #xdir_6
	if (xpos_6<BAD_MINX) THEN 
		xpos_6=BAD_MINX
		#xdir_6=-#xdir_6
	ELSEIF (xpos_6>BAD_MAXX) THEN
		xpos_6=BAD_MAXX
		#xdir_6=-#xdir_6 
	END IF		 

	statusOK_6 = (#BACKTAB(backtabpos_6 + #ta) = 0)		
	statusTurn_6= statusOK_6 XOR $FF		
	xcard_6=SPRITECARD(xpos_6):backtabpos_6=MUL20(ycard_6)+xcard_6 'xpre_6=xpos_6
	state_moved_6=1
	SPRITE 6,VISIBLE+ HIT  + xpos_6 + 2 ,ypos_6 + ZOOMY2 + #tb,SPR36 + Frame8 + #pcolor_6	'--sprite: right	

ELSEIF statusHit_6 THEN	'======HIT:fall below============================================
	GOSUB PStatusHit_6

'======JUMP!===============================================================================
ELSEIF statusEtc_6 THEN 
	IF statusEtc_6=1 THEN 
		statusEtc_6=statusEtc_6+1	
		IF ypos_6>8 THEN IF #BACKTAB(backtabpos_6 - 20)<>0 THEN 
			statusEtc_6=4 '--if hits ceiling, stop jump NOW
		ELSE 
			ypos_6=ypos_6-2
		END IF 
	ELSEIF statusEtc_6=2 THEN
		ypos_6=ypos_6-2
		GOTO JumpW6
	ELSEIF statusEtc_6=3 THEN 		
JumpW6:
		IF DIVBY8(ypos_6) THEN
			statusEtc_6=statusEtc_6+1
			ycard_6=SPRITECARD(ypos_6)
			backtabpos_6=MUL20(ycard_6)+xcard_6	
			IF ypos_6>8 THEN IF #BACKTAB(backtabpos_6 - 20)<>0 THEN statusEtc_6=4 '--if hits ceiling, stop jump NOW
		END IF 
	END IF 

	'--------jump direction---	backtabpos_6=MUL20(ycard_6)+xcard_6	
	IF #xdir_6 > 0 THEN	#ta=2 ELSE #ta=-2		'---direction
	IF DIVBY8(xpos_6) THEN 	
		'IF #BACKTAB(backtabpos_6 + #ta) = 0 THEN	'--bounce back if hits anything
		'#xdir_6=-#xdir_6
		'END IF
		IF statusEtc_6=4 THEN 
			xcard_6=SPRITECARD(xpos_6)
			backtabpos_6=MUL20(ycard_6)+xcard_6			
			statusEtc_6=0:statusDown_6=0:statusOK_6=1
			GOTO JumperOK_6
		END IF 
	END IF	
	xpos_6=xpos_6 + #xdir_6
	if (xpos_6<BAD_MINX) THEN 
		xpos_6=BAD_MINX
		#xdir_6=-#xdir_6
	ELSEIF (xpos_6>BAD_MAXX) THEN
		xpos_6=BAD_MAXX
		#xdir_6=-#xdir_6 
	END IF
	SPRITE 6,VISIBLE+ HIT  + xpos_6 + 2,ypos_6 + ZOOMY2 + FLIPX, MonkeyJump(statusEtc_6) + #pcolor_6

ELSEIF statusDie_6 THEN	'=========DIE (go offscreen)=================================	
	#ta=6:GOSUB PStatusDie_6:IF #ta=0 THEN GOTO LevelWon
	
ELSEIF statusTurn_6 THEN	'=========Turn==========================================
	statusTurn_6=statusTurn_6-1
	IF statusTurn_6=$FE THEN 			
		SPRITE 6,VISIBLE+ HIT  + xpos_6 + 2 ,ypos_6 + ZOOMY2,SPR38 + #pcolor_6	'--sprite:turn
	ELSEIF statusTurn_6=$FF - (6*4) THEN	'--delay, by sprite
		#xdir_6=-#xdir_6	'--Animation frame 
		statusOK_6=1
	ELSE
		statusOK_6 = (#BACKTAB(backtabpos_6 + 20) = 0)
	END IF	
	state_moved_6=1		
					
ELSEIF statusDown_6 THEN '======DOWN:fall below======================================
	ypos_6=ypos_6+2										'---fall
	IF ypos_6>=SPRITEMAXY THEN ypos_6=8:statusDown_6=0	'---out? Respawn at top			
	statusDown_6 = statusDown_6 + 1				'---Must do 4 steps		
	
	IF statusDown_6 = 5 THEN             	'---At step 4 (2*4=8), check below	
		ycard_6=SPRITECARD(ypos_6)
		backtabpos_6=MUL20(ycard_6)+xcard_6 'ypre_6=ypos_6
		state_moved_6=1:statusDown_6=1
		IF #BACKTAB(backtabpos_6 + 20)<>0 THEN 	'---if floor, stop fall
			statusDown_6=0
			statusTurn_6=$FF			
			IF xpos_6 > xpos_0 THEN #xdir_6=1 ELSE #xdir_6=-1	'--towards player!
		END IF
	END IF  	
	IF (statusDown_6 AND 1) THEN #ta=ZOOMY2  ELSE #ta=ZOOMY2+FLIPY
	SPRITE 6,VISIBLE+HIT + xpos_6 + 2,ypos_6 + #ta,SPR42 + Frame8 + #pcolor_6	
			
ELSEIF statusWait_6 THEN   		'======WAIT:coccoon, wait ============================================
	GOSUB PStatusWait_6
END IF		

JumpSkipCheck_6:
JumpOff_6:
ON BadType_7 GOTO Snake_7,Snake_7,Spinner_7,Jumper_7
'-----6------------END-------------------------------
