asm ;; ======================================================================== ;;
asm ;;  PRNUM16.z     -- Print an unsigned 16-bit number with leading zeros.    ;;
asm ;;                                                                          ;;
asm ;;  AUTHOR                                                                  ;;
asm ;;      Joseph Zbiciak  <im14u2c AT globalcrossing DOT net>                 ;;
asm ;;      Hacked by Marco A. Marrero                                          ;;
asm ;;  REVISION HISTORY                                                        ;;
asm ;;      30-Mar-2003 Initial complete revision                               ;;
asm ;;                                                                          ;;
asm ;;  INPUTS for all variants                                                 ;;
asm ;;      R0  Number to print.                                                ;;
asm ;;      R2  Width of field.  Ignored by PRNUM16.l.                          ;;
asm ;;      R3  Format word, added to digits to set the color.                  ;;
asm ;;          Note:  Bit 15 MUST be cleared when building with PRNUM32.       ;;
asm ;;      R4  Pointer to location on screen to print number                   ;;
asm ;;                                                                          ;;
asm ;;  OUTPUTS                                                                 ;;
asm ;;      R0  Zeroed                                                          ;;
asm ;;      R1  Unmodified                                                      ;;
asm ;;      R2  Unmodified                                                      ;;
asm ;;      R3  Unmodified                                                      ;;
asm ;;      R4  Points to first character after field.                          ;;
asm ;;                                                                          ;;
asm ;;  DESCRIPTION                                                             ;;
asm ;;      These routines print unsigned 16-bit numbers in a field up to 5     ;;
asm ;;      positions wide.  The number is printed either in left-justified     ;;
asm ;;      or right-justified format.  Right-justified numbers are padded      ;;
asm ;;      with leading blanks or leading zeros.  Left-justified numbers       ;;
asm ;;      are not padded on the right.                                        ;;
asm ;;                                                                          ;;
asm ;;      This code handles fields wider than 5 characters, padding with      ;;
asm ;;      zeros or blanks as necessary.                                       ;;
asm ;;                                                                          ;;
asm ;;              Routine      Value(hex)     Field        Output             ;;
asm ;;              ----------   ----------   ----------   ----------           ;;
asm ;;              PRNUM16.l      $0045         n/a        "69"                ;;
asm ;;              PRNUM16.b      $0045          4         "  69"              ;;
asm ;;              PRNUM16.b      $0045          6         "    69"            ;;
asm ;;              PRNUM16.z      $0045          4         "0069"              ;;
asm ;;              PRNUM16.z      $0045          6         "000069"            ;;
asm ;; etc etc etc....

'CALL VPRNUM16(#x,Backtab,width,color)
asm VPRNUM16: PROC
asm         ;;  PRNUM16.z:  Print unsigned with leading zeros.                  ;;
asm         ;; ---------------------------------------------------------------- ;;
asm        PSHR    R5
asm         MOVR    r1,r4   ;--marco Intybasic cannot use 5th param!!!

asm         ;; ---------------------------------------------------------------- ;;
asm         ;;  Find the initial power of 10 to use for display.                ;;
asm         ;;  Note:  For fields wider than 5, fill the extra spots above 5    ;;
asm         ;;  with blanks or zeros as needed.                                 ;;
asm         ;; ---------------------------------------------------------------- ;;
asm         MVII    #_PW10X+5,R1     ; Point to end of power-of-10 table
asm         SUBR    R2,     R1      ; Subtract the field width to get right power
asm         MOVR    R3,R5 ;--marco 
asm         ADDI    #$80,  R5      ;--marco, char 0
asm         B       @@lblnk


asm @@llp:   MVO@    R5,     R4      ; print a blank/zero
asm         addi    #19, R4     ;--marco:go down!
'asm         SUBR    R5,     R4      ; rewind pointer if needed.

asm         INCR    R1              ; get next power of 10
asm @@lblnk: DECR    R2              ; decrement available digits
'asm         BEQ     @@ldone
asm         BEQ     @@digit      ;--marco 
asm         CMPI    #5,     R2      ; field too wide?
asm         BGE     @@llp           ; just force blanks/zeros 'till we're narrower.
asm         CMP@    R1,     R0      ; Is this power of 10 too big?
asm         BNC     @@llp           ; Yes:  Put a blank and go to next

'asm @@ldone PULR    R3              ; restore format word

asm         ;; ---------------------------------------------------------------- ;;
asm         ;;  The digit loop prints at least one digit.  It discovers digits  ;;
asm         ;;  by repeated subtraction.                                        ;;
asm         ;; ---------------------------------------------------------------- ;;
asm @@digit: TSTR    R0              ; If the number is zero, print zero and leave
asm         BNEQ    @@dig1          ; no: print the number
'marco:I already have a 0
'asm         MOVR    R3,     R5      ;\    
'asm         ADDI    #$80,   R5      ; |-- print a 0 there.

asm         MVO@    R5,     R4      ;/    
asm         B       @@done

asm @@dig1:

asm @@nxdig: MOVR    R3,     R5      ; save display format word
asm @@cont: ADDI    #$80-8, R5      ; start our digit as one just before '0'
asm @@spcl:

asm         ;; ---------------------------------------------------------------- ;;
asm         ;;  Divide by repeated subtraction.  This divide is constructed     ;;
asm         ;;  to go "one step too far" and then back up.                      ;;
asm         ;; ---------------------------------------------------------------- ;;
asm @@div:  ADDI    #8,     R5      ; increment our digit
asm         SUB@    R1,     R0      ; subtract power of 10
asm         BC      @@div           ; loop until we go too far
asm         ADD@    R1,     R0      ; add back the extra power of 10.

asm         MVO@    R5,     R4      ; display the digit.
asm         addi    #19,R4       ;--marco: go down!

asm         INCR    R1              ; point to next power of 10
asm         DECR    R2              ; any room left in field?
asm         BPL     @@nxdig         ; keep going until R2 < 0.

asm @@done: PULR    PC     ;---marco, let's trash all registers, just  return
asm _PW10X: DECLE   10000, 1000, 100, 10, 1, 0	;---Marco:
asm ENDP

