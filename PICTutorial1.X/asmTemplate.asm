    title "asmTemplate.asm - Assembly Language Coding Template"
    ;
    ; Explain the Operation of the Program
    ; Hardware Notes:
    ;	details about which PIC is being used, I/O ports used, clock speed, etc.
    ;
    ; Rayhaan Tanweer
    ; October 8, 2020
    ; ---------------------------------------------------------------------------------------------
    ; Setup
    LIST R=DEC			; the default numbering system is decimal
    INCLUDE "p16f684.inc"       ; include the header file for this PIC
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
    
    ; ---------------------------------------------------------------------------------------------
    PAGE
    ; Subroutines/Methods
    
    end