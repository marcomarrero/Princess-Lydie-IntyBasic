

TitleScreen: PROCEDURE 	
	MODE SCREEN_COLOR_STACK, STACK_BLACK, STACK_TAN, STACK_BLACK, STACK_TAN
	WAIT
	CLS
	BORDER CS_RED
	GOSUB TitleCardsReset	
	'--paper---
	PRINT AT 0 COLOR CS_TAN,"\261"
	FOR tx=1 TO 9
		PRINT "\278\279"
	NEXT tx	
	PRINT "\278"
	
	'-------
	ty=20
	PRINT AT ty 
	FOR tx=1 TO 11
		PRINT COLOR CS_GREY,"\262"	'277
		PRINT COLOR CS_ADVANCE,"\277"	'262
		ty=ty+19
		PRINT AT ty COLOR CS_TAN+CS_ADVANCE,"\95"
		ty=ty+1
	NEXT tx	
		
	'----colors
	PRINT AT 23
	FOR tx=0 TO 7
		PRINT COLOR tx, "\315"
	NEXT tx
	FOR tx=0 TO 7
		PRINT COLOR CS_GREY+tx,"\315"
	NEXT tx
	'--marco marrero
	PRINT AT 63 COLOR CS_RED, "\283\266\284\264\267\281 \283\266\284\264\264\268\264\281"
	'--presents
	PRINT AT 87 COLOR CS_WHITE, "\294\264\268\269\268\266\271\269"

	PRINT COLOR CS_BLUE
	'GOSUB AnyKey
	
	'PRINT AT 123, "\257\258\264\265\266\267\268\269\269\272\257\258\265\294\264\284" 'pipra
	'PRINT AT 143, "\273\274\201\201\201\201\201\201\201\272\273\274\201\201\201\201"

	'---------------P    P   r   i   n   c  e    s   s       L  L   y  d   i    e    
	'PRINT AT 123, "\257\258\264\265\266\267\268\269\269\272\257\272\289\291\265\268" 
	'PRINT AT 143, "\273\274\201\201\201\201\201\201\201\272\273\276\201\201\201\201"
		
	ty=1:#tb=48+8 	'Pen/sprite 
	tl=1:#tc=123	'1-check button and draw sprite, #tc=offset
	statusDie_1=0	'--exit flag
	GOSUB PRINCESSLYDIE:IF tx=0 then RETURN 
	for tx=0 to 3
		GOSUB TITLESCREEN2	'--- sprites-----		
		IF statusDie_1<>0 THEN RETURN
	next tx

	
	'V1.7.04.02
	PRINT AT 183 COLOR SPR_PINK,"\285\265\296\283\296\281\289\296\281\280"
	PRINT "\272\284\306\294\293\284"	' alpha
	
	'copyright(c)2016
	PRINT AT 223 COLOR CS_BLUE	       
	PRINT "\267\281\294\289\264\265\270\293\271\272"	'"copyright "
	PRINT "\304\272\280\281\265\283"					'"c 2017"
		
	tx=60:ty=44:GOSUB PENSPRITE			'i as in princess
	IF statusDie_1<>0 THEN RETURN
	PRINT AT 106 COLOR CS_BLACK,"\296" 
		
	tx=76:ty=84:GOSUB PENSPRITE			'i as in copyright
	IF statusDie_1<>0 THEN RETURN
	PRINT AT 208 COLOR CS_BLUE,"\296"

	tx=148:ty=44:GOSUB PENSPRITE		'i as in Lydie
	IF statusDie_1<>0 THEN RETURN
	PRINT AT 117 COLOR CS_BLACK,"\296"
	ResetSprite(2)
	GOSUB AnyKey
END

PRINCESSLYDIE: PROCEDURE
	for tx=0 to 15
		PRINT AT tx+#tc, ((PriPreText(tx)/256)+201 )*8 
		PRINT AT tx+#tc+20,  ((PriPreText(tx) AND 255)+201)*8
		if tl then 		
			GOSUB TITLESCREEN2	'--- sprites-----				
			IF statusDie_1<>0 THEN RETURN
		end if
	NEXT tx
END 

PENSPRITE: PROCEDURE 
	SPRITE 2,tx + VISIBLE + 1, ty + DOUBLEY + 2,CS_BLACK + SPR30
	FOR ti=16 to 0 STEP -1
		SPRITE 0,tx + VISIBLE, ty + DOUBLEY - ti,CS_WHITE + SPR30
		SPRITE 1,tx + VISIBLE + 1, ty + DOUBLEY - ti + 1,CS_GREY + SPR30
		WAIT
		IF CONT.BUTTON THEN statusDie_1=$FF:RETURN
	NEXT ti 	
END 

TITLESCREEN2: PROCEDURE 
	for ti=1 to 7
		'CONST SHOWTRICK = 3 + BEHIND
		CONST SHOWTRICK = 0
		if (FRAME AND 1) THEN #ta=DOUBLEY+FLIPY ELSE #ta=DOUBLEY
		'SPRITE 5,40 + VISIBLE + DOUBLEX + ty,56 + ZOOMY4,CS_TAN + SPR58
		SPRITE 2,24 + VISIBLE + ty,56 + #ta,CS_TAN + SPR56 + SHOWTRICK
		SPRITE 3,24 + VISIBLE + ty,64 + #ta,CS_TAN + SPR56 + SHOWTRICK
		SPRITE 4,32 + VISIBLE + ZOOMX2 + ty,56 + ZOOMY4,CS_TAN + SPR58 + SHOWTRICK
		SPRITE 6,48 + VISIBLE + ZOOMX2 + ty,56 + ZOOMY4,CS_TAN + SPR58 + SHOWTRICK
		
		'---pen goes randomly
		#ta=RAND(4)
		IF #ta>=2 THEN #tb=#tb+1 ELSE #tb=#tb-1
		IF #tb<48 THEN #tb=#tb+4 ELSE IF #tb>(48+16) THEN #tb=#tb-4
		
		SPRITE 0,28 + VISIBLE + ty, #tb + DOUBLEY,CS_WHITE + SPR30
		SPRITE 1,29 + VISIBLE + ty + 1, #tb + DOUBLEY,CS_GREY + SPR30
		
		ty=ty+1
		WAIT
		IF CONT.BUTTON THEN statusDie_1=$FF:RETURN	
	next ti
END

