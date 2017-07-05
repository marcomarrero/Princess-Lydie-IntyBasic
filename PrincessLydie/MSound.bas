'Sound system. Channels 0/3,1/4,2/5 are multiplexed
DIM #sound_address(6)	'--sound address
DIM sound_index(6)	'--sound index

Sound_Off: PROCEDURE
	SOUND 0,1,0
	SOUND 1,1,0
	SOUND 2,1,0
	SOUND 4,1,&00111000
END

CONST Sound_Decay = &0011

Sound_Bell: PROCEDURE
	'Envelope duration, shape. 
	'bits:[continue3][attack2][alt1][hold0] 1001=\_________
	SOUND 3, 4500, &0011
	SOUND 4, 53, &00011100	
	'SOUND 0,x,y
	'SOUND 1,x,y
END 

Sound_Engine_Reset: PROCEDURE
	FOR i=0 to 5:#sound_address(i)=0:sound_index(i)=0:NEXT i
END

DEF FN SOUNDV(voice) = SOUND voice,value12,volume

'--sound engine supports 2 sounds per channel, multiplexing 
Sound_Engine: PROCEDURE 
	i=FrameCount AND 1	'---multiplex
	#c=0:x=0:y=0	'--which #Channel (0=none,1=1st,2=2nd,3=OFF!). y=playing? x=playing? 
	FOR j=0 TO 2 	'--j=1st index, sound channel too 
		k=j+3		'---k=2nd index. #sound_address(0) and #sound_address(3) multiplex.. 
		IF #sound_address(j) AND #sound_address(k) THEN			
			IF i THEN #c=c+1 ELSE #c=2 	'--both playing, pick winner
			x=x+1:y=y+1 					'--both alive, must fetch even if it is off 
		ELSEIF #sound_address(j)
			#c=c+1:x=x+1 				'--only v0 is playing 
		ELSEIF #sound_address(k) THEN
			#c=2:y=y+1					'--only v1 is playing 
		END IF 	
		'--ruff fetchman
		if x THEN #a=PEEK(#sound_address(j) + sound_index(j)):IF #a=0 THEN #sound_address(j)=0:#c=3
		if y THEN #b=PEEK(#sound_address(k) + sound_index(k)):IF #b=0 THEN #sound_address(k)=0:#c=3
		
		'--pick and play
		if #c=1 THEN 		'--play 1st 
			PLAY_SOUND_FREQ(j,#a) 
		ELSEIF #c=2 THEN 	'--play 2nd 
			PLAY_SOUND_FREQ(j,#b) 
		ELSEIF #c=3 THEN 	'--shut off! 
			PLAY_SOUND_FREQ(j,1) '--vol0 freq1=off!
		END IF
	NEXT j	
END
			
'---Play sound. R0=channel, R1=VALUE is 16-bit,4-bit volume and 12-bit freq: $F $FFFFF ---
'---Sound chip register Address: $01F0 low 8-bit Voice 0.
ASM PLAY_SOUND_FREQ: PROC	
	asm mvi	#$1F0,r3		; r3=$01F0 (PSG R0, low 8-bit freq, channel 0)
	asm	addr r0,r3 			; use correct sound channel register (R0-R2)

	asm movr	r1,r2		; copy value. r1 --> r2 (r1=12 bit freq, r2 will be 4-bit volume)
	asm andr r1,#$0FFF		; r1:mask 12 bits
	
	asm mvo	r1,r3			; r1-->r3 	(store low-8 Freq -> PSG R0)
	
	asm swap	r1			; get upper 4-bit freq 
	
	asm	addi #4,r3			; move from PSG R0 to PSG R4 	
	asm	mvo	r1,r3			; r1-->r3  (store upper 4-bit Freq to PSG R4 register)
	
	'--cheap /4096 division... move $F000 to $000F (4-bit volume)
	asm swap r0,0			;-$Fxxx --> $xxFx
	asm	andi #$F0,r0			;-->$00F0 	(mask)
	asm	slr r0,2				;---$00F0 /4 --> $003C
	asm	slr r0,2				;-----$003C/4  --> $000F
	
	asm	addi #7,r3			; move from PSG R4 to PSG R11 (4-bit volume register)
	asm	mvo	r0,r3			;r0->r3 (volume -> PSG R11)
	
	asm jr	r5				;return 
asm ENDP

