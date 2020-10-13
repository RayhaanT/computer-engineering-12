    title "asmTemplate.asm - Assembly Language Coding Template"
    ;
    ; Add numbers in an infinite loop. Only for testing, watch the variables with variable watches.
    ; Hardware Notes:
    ;	None, not meant to be executed on hardware.
    ;
    ; Rayhaan Tanweer
    ; October 9, 2020
    ; ---------------------------------------------------------------------------------------------
    ; Setup
    LIST R=DEC			; the default numbering system is decimal
    INCLUDE "p16f684.inc"       ; include the header file for this PIC
				; header connects labels to specific memory addresses
	
     __CONFIG _FCMEN_OFF & _IESO_OFF & _BOD_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTOSCIO ; put this all one ONE line
	
    ; variables
    CBLOCK 0x20		; assigns variables to first available GPRs, beginning at 0x20
    
    i			; assign first GPR to variable i
	
    ENDC
	
    ; ---------------------------------------------------------------------------------------------
    PAGE
    ; Main code
    
    org 0
    
    movlw 6		; Move the literal 6 into the working register
    movwf i		; Move 6 to i
    
    movlw 15		; Move 1 into the working register
    
    addwf i,f		; Add the contents of the working register to a file (i) and save it
    
    goto 2		; Loop to add again
    
    
    ; ---------------------------------------------------------------------------------------------
    PAGE
    ; Subroutines/Methods
    
    end