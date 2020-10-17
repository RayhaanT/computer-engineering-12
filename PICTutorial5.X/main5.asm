    title "main5.asm - Testing the STATUS register"
    ;
    ; Perform a series of operation to see their impact on the status register
    ; Hardware Notes:
    ;	Not intended to run on hardware
    ;
    ; Rayhaan Tanweer
    ; October 15, 2020
    ; ---------------------------------------------------------------------------------------------
    ; Setup
    LIST R=DEC			; the default numbering system is decimal
    INCLUDE "p16f684.inc"       ; include the header file for this PIC
				; header connects labels to specific memory addresses
	
     __CONFIG _FCMEN_OFF & _IESO_OFF & _BOD_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTOSCIO ; put this all one ONE line
	
    ; variables
    CBLOCK 0x20		    ; assigns variables to first available GPRs, beginning at 0x20
    ; put variable names here
    j
    i
    
    ENDC
	
    ; ---------------------------------------------------------------------------------------------
    PAGE
    ; Main code
    
    org 0
;    movlw 0x80
;    addlw 0x80
;    
;    movlw 0xb8
;    addlw 0x47
;    
;    movlw 0x4
;    addlw 0x8C
    
    movlw 0x5
    sublw 0x5
    
    goto $
    
    ; ---------------------------------------------------------------------------------------------
    PAGE
    ; Subroutines/Methods
    
    end


