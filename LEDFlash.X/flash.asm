    title "flash.asm - Flash an LED"
    ;
    ; Flash an LED on and off 
    ; Hardware Notes:
    ;	PIC16F684, connect pin C0 to an LED to see it flash
    ;
    ; Rayhaan Tanweer
    ; October 17, 2020
    ; ---------------------------------------------------------------------------------------------
    ; Setup
    LIST R=DEC			; the default numbering system is decimal
    INCLUDE "p16f684.inc"       ; include the header file for this PIC
    INCLUDE "asmDelay.inc"	; include header file with delay macro
				; header connects labels to specific memory addresses
	
     __CONFIG _FCMEN_OFF & _IESO_OFF & _BOD_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTOSCIO ; put this all one ONE line
	
    ; variables
    CBLOCK 0x20		    ; assigns variables to first available GPRs, beginning at 0x20
    ; put variable names here
	
    ENDC
	
    ; ---------------------------------------------------------------------------------------------
    PAGE
    ; Main code
    
    org	    0
    
    movlw   b'111'
    movwf   CMCON0	    ; turn off comparators
	
    bsf	    STATUS, RP0	    ; switch to bank 1 by setting the bank bit
    clrf    ANSEL ^ 0x080   ; set i/o to digital (defaults to analog)
	
    clrf    TRISC ^ 0x080   ; set C ports to output
    bcf	    STATUS, RP0	    ; switch back to bank 0
    
flashLoop
	
	nop
	bsf PORTC, 1
	    Dlay 1000000
	
	nop
	bcf PORTC, 1
	    Dlay 2000000
	
	goto flashLoop
    
    ; ---------------------------------------------------------------------------------------------
    PAGE
    ; Subroutines/Methods
    
    end





