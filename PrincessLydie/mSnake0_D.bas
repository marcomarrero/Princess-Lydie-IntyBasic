'=={ME}===={ME}===={ME}===={ME}===={ME}===={ME}===={ME}===={ME}===={ME}===={ME}===={ME}===
state_eye_erase_1=0
IF state_moved_1 THEN
	state_eye_erase_1=1							'--erase card next time here
	state_moved_1=0		
	#ta=EYECARDS(xpos_1):#tb=EYECARDS2(xpos_1)	'--eye coord,eyecard		
	#BACKTAB(backtabpos_1)=#ta + FG_WHITE
	IF #tb=0 THEN 
		state_2ndcard_1=0 						'--BIT_CARD2=0, clear 1 card
	ELSE
		state_2ndcard_1=1
		#BACKTAB(backtabpos_1+1)=#tb + FG_WHITE
	END IF
	backtabpre_1=backtabpos_1
END IF 

