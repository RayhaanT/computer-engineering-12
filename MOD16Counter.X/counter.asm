    title "counter.asm - Count from 0 to 15 then loop"
    ;
    ; Sets outputs to count in binary from 0 to 15, then resets and starts again
    ; Hardware Notes:
    ;	PIC16F684, plug LEDs in the first 4 C outputs
    ;
    ; Rayhaan Tanweer
    ; October 17, 2020
    ; ---------------------------------------------------------------------------------------------
    ; Setup
    LIST R=DEC			; the default numbering system is decimal
    INCLUDE "p16f684.inc"       ; include the header file for this PIC
    INCLUDE "delay.inc"		; include header file with delay macro
				; header connects labels to specific memory addresses
	
     __CONFIG _FCMEN_OFF & _IESO_OFF & _BOD_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTOSCIO ; put this all one ONE line
	
    ; variables
    CBLOCK 0x20		    ; assigns variables to first available GPRs, beginning at 0x20
    ; put variable names here
	
    ENDC
	
    ; ---------------------------------------------------------------------------------------------
    PAGE
    ; Main code
    
    org 0
    
    movlw   b'111'
    movwf   CMCON0	    ; turn off comparators
	
    bsf	    STATUS, RP0	    ; switch to bank 1 by setting the bank bit
    clrf    ANSEL ^ 0x080   ; set i/o to digital (defaults to analog)
	
    clrf    TRISC ^ 0x080   ; set C ports to output
    bcf	    STATUS, RP0	    ; switch back to bank 0

start:
	clrf PORTC	    ; reset all outputs to off

count:
	nop
	Dlay 250000
	movlw 1
	addwf PORTC, f	    ; increment outputs by 1
	btfss STATUS, DC    ; check if the 4th bit has been carried (counter has exceeded 15 limit)
	    goto count	    ; if limit is not exceeded, go to count label, otherwise this instruction is skipped
	goto start	    ; go back to start label, where outputs are reset
			    ; only triggers if the 4th bit is carreid, meaning counter overflow
    
    ; ---------------------------------------------------------------------------------------------
    PAGE
    ; Subroutines/Methods
    
    end


