'CALL VPRNUM16(#x,BACKTAB_ADDR,5,CS_RED)
'======================================================================== ;;
'  VPRNUM16     -- Print an unsigned 16-bit number with leading zeros.     ;;
'                                                                          ;;
'  AUTHOR                                                                  ;;
'      Joseph Zbiciak  <im14u2c AT globalcrossing DOT net>                 ;;
'      Marco A. Marrero (ugly hack to print vertical text)
'                                                                          ;;
'  REVISION HISTORY                                                        ;;
'      30-Mar-2003 Initial complete revision                               ;;
'                                                                          ;;
'  INPUTS for all variants                                                 ;;
'      R0  Number to print.                                                ;;
'	   R1  Screen Address
'      R2  Width of field.  Ignored by PRNUM16.l.                          ;;
'      R3  Format word, added to digits to set the color.                  ;;
'          Note:  Bit 15 MUST be cleared when building with PRNUM32.       ;;
'                                                                          ;;
'--- See intybasic_epilogue.asm for original function

asm VPRNUM16: PROC
asm		    PSHR    R5			;---save return 
asm			movr	R1,R4		;---added: Screen address in R4

'         ;; ---------------------------------------------------------------- ;;
'         ;;  Find the initial power of 10 to use for display.                ;;
'         ;;  Note:  For fields wider than 5, fill the extra spots above 5    ;;
'         ;;  with blanks or zeros as needed.                                 ;;
'         ;; ---------------------------------------------------------------- ;;
asm         MVII    #_PW10X + 5,R1     ; Point to end of power-of-10 table
asm         SUBR    R2,     R1          ; Subtract the field width to get right power
'         ;; ---------------------------------------------------------------- ;;
'         ;;  The digit loop prints at least one digit.  It discovers digits  ;;
'         ;;  by repeated subtraction.                                        ;;
'         ;; ---------------------------------------------------------------- ;;
asm @@digit: TSTR    R0              ; If the number is zero, print zero and leave
asm         BNEQ    @@dig1          ; no: print the number

asm         MOVR    R3,     R5      ;\    
asm         ADDI    #$80,   R5      ; |-- print a 0 there.
asm         MVO@    R5,     R4      ;/    
'asm			subI	#21, R4			;---added: move up!
asm         B       @@done

asm @@dig1:
asm     
asm @@nxdig: MOVR    R3,     R5      ; save display format word
asm @@cont: ADDI    #$80-8, R5      ; start our digit as one just before '0'
asm @@spcl:

'         ;; ---------------------------------------------------------------- ;;
'         ;;  Divide by repeated subtraction.  This divide is constructed     ;;
'         ;;  to go "one step too far" and then back up.                      ;;
'         ;; ---------------------------------------------------------------- ;;
asm @@div:  ADDI    #8,     R5      ; increment our digit
asm         SUB@    R1,     R0      ; subtract power of 10
asm         BC      @@div           ; loop until we go too far
asm         ADD@    R1,     R0      ; add back the extra power of 10.

asm         MVO@    R5,     R4      ; display the digit.
asm			subI	#21,    R4			;---added: move up!

asm         INCR    R1              ; point to next power of 10
asm         DECR    R2              ; any room left in field?
asm         BPL     @@nxdig         ; keep going until R2 < 0.

asm @@done: PULR    PC              ; return
asm _PW10X: DECLE   10000, 1000, 100, 10, 1, 0
asm         ENDP
