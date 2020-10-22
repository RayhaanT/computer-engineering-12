    title "flash.asm - Flash an LED"
    ;
    ; Control a system of traffic lights, cycling between red green and yellow 
    ; Hardware Notes:
    ;	PIC16F684
    ;	Connect North-South direction LEDs to C0-C2
    ;	    C0: Green
    ;	    C1: Yellow
    ;	    C2: Red
    ;	Connect East-West direction LEDs to C3-C5
    ;	    C3: Green
    ;	    C4: Yellow
    ;	    C5: Red
    ;
    ; Rayhaan Tanweer
    ; October 22, 2020
    ; ---------------------------------------------------------------------------------------------
    ; Setup
    LIST R=DEC			; the default numbering system is decimal
    INCLUDE "p16f684.inc"       ; include the header file for this PIC
    INCLUDE "delay.inc"	; include header file with delay macro
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
    
    ; Set up SFRs to output correctly
    movlw   b'111'
    movwf   CMCON0	    ; turn off comparators
	
    bsf	    STATUS, RP0	    ; switch to bank 1 by setting the bank bit
    clrf    ANSEL ^ 0x080   ; set i/o to digital (defaults to analog)
	
    clrf    TRISC ^ 0x080   ; set C ports to output
    bcf	    STATUS, RP0	    ; switch back to bank 0
    
trafficLoop		    ; Traffic light control loop
	
	nop
	call goNorthSouth
	Dlay 10000000
	
	call stopTraffic
	
	call goEastWest
	Dlay 10000000
	
	call stopTraffic
	
	goto trafficLoop
    
    ; ---------------------------------------------------------------------------------------------
    PAGE
    ; Subroutines/Methods
    
stopTraffic:
	movlw 0
	btfsc PORTC, 0		; Check if east west green is on
	    movlw b'100010'	; If so, add code to turn east west yellow
	btfsc PORTC, 3		; Check if north south green is on
	    movlw b'010100'	; If so, add code to turn north south yellow
	movwf PORTC
	
	Dlay 5000000		; Delay 5 seconds
	movlw b'100100'		; Turn both directions red
	movwf PORTC
	
	Dlay 2000000		; Delay 2 seconds
	return

goNorthSouth:
	movlw b'001100'		; Turn north south green and east west red
	movwf PORTC
	return

goEastWest:
	movlw b'100001'		; Turn east west green and north south red
	movwf PORTC
	return
    
    end








