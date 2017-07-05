'---------------------------------------
' MSync v1.0 (c) 2016 Marco A. Marrero
'---------------------------------------
' Synchronize with Music player, 50Hz
'---------------------------------------
' Based on IntyMusic source
'---------------------------------------

'--This one has 3 timing/counter variables from IntyBasic_epilogue---
'DIM iMusicTime(3)			' _music_tc (time base), _music_t (note count), and _music_frame (1=skipped a frame on ntsc)
'CONST MT_music_t = 0
'CONST MT_music_tc = 1
'CONST MT_music_frame = 2

'--Init counters 
FrameSyncInit: PROCEDURE	
	FrameSkip=0:#FrameCount=0
END 
'DIM PALcount, Timer

'-- Synchronize at 50Hz along with music player----- This is called at every frame, I mark every 6th frame ---
FrameSync: PROCEDURE
	IF IntyMusic=0 THEN 
		CALL GETMUSICTIME(VARPTR FrameSkip)	
		IF FrameSkip<>1 THEN Palcount=Palcount+1:IF PalCount=50 THEN PalCount=0:Timer=Timer-1
		#FrameCount=#FrameCount+1		
		RETURN
	ELSE
	'------- IntyMusic ----
		IF MUSIC.PLAYING<>0 THEN
			'--Get music player data from IntyBasic_epilogue ASM variables ---
			CALL IMUSICGETINFOV2(VARPTR iMusicVol(0), VARPTR iMusicNote(0), VARPTR iMusicWaveForm(0),VARPTR iMusicTime(0))		
			'--Check values if frame was not skipped (every 6 frames on NTSC)
			IF iMusicTime(statusEtc_4)<>1 THEN			
				Frame8=Frame8+1			'--50Hz interval counter, 0 to 49. Might be handy for PAL games
				IF Frame8=49 THEN Frame8=0:#pcolor_3=#pcolor_3+1
				
				'--Force scrolling according to statusDie_6. 0=pause between notes (or wait 256 frames), 1=scroll at every frame, 2=skip one frame, etc.
				'--- On any note change screen will scroll, and this value gets reset.
				ypos_5=ypos_5+1
				IF ypos_5=statusDie_6 THEN ypos_5=0:BadType_6=1
							
				'--- check if new note played
				FOR #pcolor_7=0 TO 2
					'---check if waveform index zeroed (same note was hit again), will be 1 after VBLANK				
					IF iMusicWaveForm(#pcolor_7)=1 THEN
						iMusicDrawNote(#pcolor_7)=iMusicNoteColor(#pcolor_7)
						BadType_6=1:ypos_5=0	'--Yes, note restarted, scroll down
					END IF
				NEXT #pcolor_7	
			END IF 'iMusicTime
		END IF	
	'-------
	END IF 
END

'    ______________
'___/ GETMUSICTIME \_________________________________________________
'Get IntyBasic_epilogue music timing data onto IntyBasic.
'Call GETMUSICTIME(VARPTR Frame). [In] r0, destroys r3,r4
ASM GETMUSICTIME: PROC	
	asm movr	r0,r1				; r0 --> r1 	(r1=VARPTR Frame)
	asm mvi		_music_frame,r0		; _music_frame --> r0 (time, 0 to 5). In PAL, it should be always zero...
	asm add		_ntsc,r0			; if NTSC then r3++ (time is now 1 to 6, now I can test if it is 1 when skipped)
	asm mvo@ 	r0,r1				; r0 --> [r1]
	asm jr		r5					;return 
asm ENDP
