title  "lineFollow"
;
; A program which allows the robot to follow a black line 
; using two reflective sensors which detect black or white surfaces
;
;  Hardware Notes:
;   PIC16F684 running at 4 MHz
;	Motors:
;		-2 DC motors of 143:1 used, through a LM293D IC Driver
;   	-left motor is controlled by RC0 and RC1
;   	-right motor is controlled by RC2 and RC3
;	Sensors:
;		-both sensors are wired through a L293 dual comparator
;       -LEDs are tied to output of comparators:
;			-LED turns OFF when it senses the line
;			-LED turns ON when it doesn't sense the line
;		-Vref from a 10k pot is set about 2.5V 
;		-left sensor is let to RA5 
;		-right sensor is set to RA4
;		-LEDs turn on when 
; 
;   Directions:
;  	to go forward:		PORTC&lt;3:0&gt;=1010=10
;	to go backwards:	PORTC&lt;3:0&gt;=0101=5
;	to spin left:		PORTC&lt;3:0&gt;=1001=9
;	to spin right:		PORTC&lt;3:0&gt;=0110=6

; author
; date
;------------------------------------------------------------------------------------------------------
; Setup
	LIST R=DEC							
	INCLUDE "p16f684.inc" 
	INCLUDE "delay.inc"

__CONFIG _FCMEN_OFF & _IESO_OFF & _BOD_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTOSCIO ; put this all one ONE line
	
;  Variables
	CBLOCK 0x020 

	wHolder
		 
	ENDC 

;--------------------------------------------------------------------------
  PAGE
;  Configuring SFRs (Special Function Register)

	org    0
	
	movlw   7                   ; turn off Comparators
  	movwf   CMCON0

  	bsf     STATUS, RP0			; all PORTS are Digital
 	clrf    ANSEL ^ 0X080        	

	clrf	TRISC ^ 0X080		; teach all of PORT C to be outputs
;	movlw	b'000111'
;	movwf	TRISC^0x080

	movlw 	b'111000'			; teach RA4, RA5 to be digital inputs
	movwf	TRISA^0X080			; and the rest as outputs
	
	bcf	    STATUS, RP0	 		; (RA3 must always be an input)

;-----------------------------------------------------------------------------------------------------
 PAGE
; Code Body
 
loop:
;    movlw  10			;Move forward 
;	movwf PORTC			;until hits black line, move accordingly
;	Dlay 100000
;	nop
;		
;		clrf PORTC		;stop momentarily to get a
;		Dlay 30000		;more accurate reading from sensors
;		
;	btfss PORTA, 5		;if left sensor hits black line, 
;		call turn_left	;turn left
;
;	btfss PORTA, 4		;if right sensor hits black line,
;		call turn_right	;turn right
;	
    	call test_right_qti
	
	movwf wHolder
	btfss wHolder, 5
	    bsf PORTC, 5
	btfsc wHolder, 5
	    bcf PORTC, 5
	
	call test_left_qti
	
	movwf wHolder
	btfss wHolder, 4
	    bsf PORTC, 4
	btfsc wHolder, 4
	    bcf PORTC, 4
	
	call test_left_qti
		
 	goto loop

; -------------------------------------------------------------------------------------------------------------------------------
; subroutines


test_right_qti:
    bsf STATUS, RP0	; Switch to bank 1 and set A4 to output
    bcf TRISA, 5
    bcf STATUS, RP0
    
    bsf PORTA, 5	; Set A4 high
    Dlay 1000
    bcf PORTA, 5	; Set A4 low
    
    bsf STATUS, RP0	; Switch A4 back to input
    bsf TRISA, 5
    bcf STATUS, RP0
    
    Dlay 1000
    
    movf PORTA, 0
    return

test_left_qti:
    bsf STATUS, RP0	; Switch to bank 1 and set A4 to output
    bcf TRISA, 4
    bcf STATUS, RP0
    
    bsf PORTA, 4	; Set A4 high
    Dlay 1000
    bcf PORTA, 4	; Set A4 low
    
    bsf STATUS, RP0	; Switch A4 back to input
    bsf TRISA, 4
    bcf STATUS, RP0
    
    Dlay 1000
    
    movf PORTA, 0
    return

turn_left:		;turn robot left
	movlw 9
	movwf PORTC
	nop
	Dlay 60000
		clrf PORTC
		Dlay 30000
	return		;return back to main program loop

turn_right:	;turn robot right	
	movlw 6
	movwf PORTC
	nop
	Dlay 60000
		clrf PORTC
		Dlay 30000
	return		;return back to main program loop

  end                           


