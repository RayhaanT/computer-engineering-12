
    title "main.asm - ANDing variables"
    ;
    ; ANDs a few variables for testing
    ; Hardware Notes:
    ;	Not intended to be run on hardware
    ;
    ; Rayhaan Tanweer
    ; October 10, 2020
    ; ---------------------------------------------------------------------------------------------
    ; Setup
    LIST R=DEC			; the default numbering system is decimal
    INCLUDE "p16f684.inc"       ; include the header file for this PIC
				; header connects labels to specific memory addresses
	
     __CONFIG _FCMEN_OFF & _IESO_OFF & _BOD_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTOSCIO ; put this all one ONE line
	
    ; variables
    CBLOCK 0x20		    ; assigns variables to first available GPRs, beginning at 0x20
    
    i
    j
    k
    result
	
    ENDC
	
    ; ---------------------------------------------------------------------------------------------
    PAGE
    ; Main code
    
    org 0
    
    MOVLW 0xaf
    MOVWF i
    
    MOVLW 0x3b
    MOVWF j
    
    MOVLW 0xd4
    MOVWF k
    
    MOVF i,0
    ANDWF j,0
    MOVWF result
    MOVF result,0
    ANDWF k,0
    MOVWF result
    
    goto $
    
    ; ---------------------------------------------------------------------------------------------
    PAGE
    ; Subroutines/Methods
    
    end

