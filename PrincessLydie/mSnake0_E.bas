'=={ME}===={ME}===={ME}===={ME}===={ME}===={ME}===={ME}===={ME}===={ME}===={ME}===={ME}===	
'#ta=collision... tk=0:ti=0:tj=0	'-tk=dead, ti=killed baddy, tj=stomped baddy.  
	IF (#ta AND COLLIDE_ENEMY_1) THEN							'--collision!
		IF ypos_1>=DISABLED THEN				'--fireball hit!
			tk=1
		ELSEIF statusWait_1 THEN								'--if waiting, kick it out!
			ti=1:statusOK_1=0:statusWait_1=0:statusDie_1=$FF
		ELSEIF (StatusHit_1 + StatusDie_1) =0 Then				'--can't be hit
			IF ypos_1-#ypos_0 >= HEADHIT THEN 					'--Hit! Push baddy below
				tj=1:statusHit_1=1:statusOK_1=0:statusDown_1=0:statusTurn_1=0:statusEtc_{ME}=0
				state_eye_erase_1=2
				state_moved_1=0						
			ELSE 	'--not proper hit = death
				tk=1:statusFreeze_1=1	
			END IF
		END IF		
	END IF			
'=={ME}====END======
