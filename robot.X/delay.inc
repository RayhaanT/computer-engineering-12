 title  "delay.inc"
;
; allows the user to specify a delay based on microseconds
; for example "Dlay 250000" is a 250,000microseconds = 1/4 sec.
;
;
; Predko
; 2002
;--------------------------------------------------------------------------
; Setup

	LIST R=DEC							
	;INCLUDE "p16f684.inc" 

 ;__CONFIG _FCMEN_OFF & _IESO_OFF & _BOD_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTOSCIO

;  Variables
	CBLOCK 0x07A 
 DlayValue:2  					 ;Requires 24 Bit Counter (w/ WREG)				 
	ENDC 
;--------------------------------------------------------------------- 
 PAGE
 ; The Delay Macro 
 	
Dlay Macro Cycles
 variable CyclesLeft            ;  Keep Track of Remaining Cycles
 variable LargeNum
CyclesLeft = Cycles
 local LongLoop
 if Cycles > 0x04FFFF00         ;  Can't Handle the Anything > 83 Seconds (@ 4 MHz)
 error "Required Delay is longer than 'Dlay' Macro can support"
 endif
 if Cycles > 327681             ;  Need Large Loop?  
LargeNum = CyclesLeft / 327681
  movlw   LargeNum
  movwf   DlayValue + 2         ;  Calculate Number of Loops
LongLoop:                       ;  Repeat for Each Loop
  clrf    DlayValue + 1         ;  Do Maximum Possible Loop Count
  clrf    DlayValue
  decf    DlayValue, f
  btfsc   STATUS, Z
   decfsz DlayValue + 1, f
    goto  $ - 3
  decfsz  DlayValue + 2, f      ;  Repeat Loop
   goto   LongLoop
CyclesLeft = CyclesLeft - ((LargeNum * 327681) + 1 + (LargeNum * 3))
 endif  ;  Need Large Loop
 if Cycles > 14                 ;  Will a Loop be required?  
  movlw   high (((CyclesLeft - 3) / 5) + 256)
  movwf   DlayValue + 1
  movlw   low (((CyclesLeft - 3)/ 5) + 256)
  movwf   DlayValue
  decf    DlayValue, f          ;  5 Cycle Constant Delay Loop
  btfsc   STATUS, Z
   decfsz DlayValue + 1, f
    goto  $ - 3
CyclesLeft = CyclesLeft - (3 + (5 * ((CyclesLeft - 3)/ 5)))
 endif                          ;  Finished with Loop Code
 while CyclesLeft >= 2          ;  Put in 2 Instruction Cycle Delays
  goto    $ + 1
CyclesLeft = CyclesLeft - 2
 endw
 if CyclesLeft == 1             ;  Put in the Last Required Cycle
  nop
 endif
 endm

 





