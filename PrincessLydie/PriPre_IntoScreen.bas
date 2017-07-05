
'=====Display lives, etc.==========================================================================================
StopAudio: PROCEDURE
    PLAY OFF:SOUND 2,1,0
END 

DrawIntro: PROCEDURE
    CLS
    GOSUB StopAudio 
    MODE SCREEN_FB:WAIT
    GOSUB TitleCardsReset
    GOSUB TitleCard2 
    ResetSprites(0,7)
    CLSC(FGBG_BK_Color(STACK_TAN))

    '---draw borders ------------
    tx=0
    #ty=FGBG_BK_Color(STACK_TAN) + SCROLL_R1
    #ts=FGBG_BK_Color(STACK_TAN) + SCROLL_RINV2 
    DO
        #BACKTAB(tx)=#ts:tx=tx+19:#BACKTAB(tx)=#ty:tx=tx+1
    LOOP UNTIL tx>=BACKGROUND_COLUMNS*BACKGROUND_ROWS 

    '---draw lines---------------
    HLine(0, FGBG_BK_Color(STACK_BLUE) + STACK_BLACK + GradHi)   
    HLine(1, FGBG_BK_Color(STACK_LIGHTBLUE) + STACK_BLUE + GradHi)
    HLine(2,STACK_TAN + SCROLL_TOP1)

    '------
    '-----score, hi-score, and lives ----
    WAIT    
    '---tx,ti,#tm destroyed by Fillzeroes
    #tc=FGBG_BK_Color(STACK_TAN)
    PRINT COLOR STACK_BLUE + #tc
    PRINT AT 61+3,"\269\267\281\264\268:" '--score 
    PriNum(71+5,#score,2, #tc )
    FillZeroes(70)

    PRINT COLOR STACK_RED + #tc
    PRINT AT 81+3,"\306\299\285\268\269:" '--lives 
    IF Lives=255 THEN PRINT "\266\281\266\268" ELSE PriNum(91,Lives,0,#tc)
    FillZeroes(90)
      
    PRINT AT 104 COLOR STACK_DARKGREEN + #tc,"\264\281\295\266\291:" 'Round
    PriNum(111,Level,0, #tc)
    FillZeroes(110)

    PRINT COLOR STACK_BLUE + #tc
    IF #HiScore<#Score THEN 
        #HiScore=#Score
        PRINT AT 121, "\266\268\285\285" 'NEW
    END IF    
    PRINT AT 141,"\293\299\300\269\267\281\264\268:" '--hi-score     
    PriNum(151+5,#HiScore,2, #tc)
    FillZeroes(150)

    '---game over man, game over!!!
    if lives=255 then
        PRINT COLOR STACK_RED + #tc
        PRINT AT 181, "\270\272\284\272\283\266\272\268\272\272\272\281\272\285\272\268\272\264" '"G A M E   O V E R"
    end if 

    '---play music----
    WAIT
    IF Lives=255 THEN 
        GOSUB TitleCard3 '---get extra cards, or death animation    
        PLAY VOLUME 12:PLAY FULL:PLAY GameOverMusic 
    ELSEIF Lives>=4 THEN         
        PLAY VOLUME 12:PLAY FULL:PLAY RoundStart 
    ELSEIF Lives>=0 THEN 
        PLAY VOLUME 12:PLAY FULL:PLAY RoundStart2
    END IF 

    'DIM tx,ty,ti,tj,tk,tl ---  #ta,#tb,#tc,#ts,#tm
    ti=0    
    FOR tj=0 to 10
        IF Lives=255 then 
            #ta=DeathAnimA(ti)
            #ts=DeathAnimB(ti)
            tk=5
        ELSEIF Lives<4 THEN 
            #ta=NoAnimA(ti)
            #ts=DressAnim(ti)
            tk=6    '6=don't move dress..
        ELSE 
            #ta=HairAnimA(ti)
            #ts=DressAnim(ti)
            tk=5
        END IF 
        tl=0:#tb=SPR_WHITE:#tc=SPR_PINK
        ty=10
        tx=128:GOSUB DrawPrincess:#tb=0:#tc=0
        tx=127:GOSUB DrawPrincess
        tx=129:GOSUB DrawPrincess
        ti=ti+1:IF ti>7 THEN ti=tk  
        GOSUB MultiWait              
    NEXT tj   

    'PRINT AT 220,"\293\299\271\272\284\266\289\272\275\295\271\271\281\266" 'hit any button    
    #tc=FGBG_BK_Color(STACK_TAN) + STACK_GREEN
    PRINT AT 222 COLOR #tc,"\294\264\268\269\269\272\284\266\289\272\275\295\271\271\281\266" 'press any button
    GOSUB AnyKey
    GOSUB StopAudio
    GOSUB GameInit    
END 

'-----
DrawPrincess: PROCEDURE
    SPRITE tl,tx + VISIBLE + ZOOMX2,ty + ZOOMY4,#ta + #tb
    SPRITE tl+1,tx + VISIBLE  + ZOOMX2,ty-2 + ZOOMY4, #ts + #tc
    tl=tl+2
END
'-----

