;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Level2.s
;This subroutine will use LCD to display 4 different tuples
;of strings. Each tuple of 2 lines long, and will remain on
;the display for 5 seconds.
;After the last tuple has been displayed for 5 seonds,
;The first tuple will be displayed again and the cycle repeats.
;Preconditions:
;				None currenly
;Postconditions:
;				N/A. This procedure is an infinite loop.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 AREA PROGRAM, CODE, READONLY
 INCLUDE	LPC11xx.inc
 EXPORT Level2
 IMPORT LCD_command
 IMPORT Level2_print_string
 IMPORT BusyWait
	 
LOOPCOUNTER RN		5
STRCURSOR	RN		2					;Stores pointer in current string
NULL		EQU		'0'
NUMSTRINGS	EQU		4			
FREQ		EQU		12000000			;12 Mhz clock
CYCSPERLOOP EQU		4					;4 clock cycles per loop
LOOPFREQ	EQU		FREQ / CYCSPERLOOP	;Frequency of inner loop
WAITTIME	EQU		5					;5 second delay between changes
WAITTICKS	EQU		LOOPFREQ * WAITTIME

;LCD commands
CLEAR       EQU		0X01
HOME        EQU		0X02
LCD_ON      EQU		0X0C
BLINK       EQU		0X0F
CURSOR_ON   EQU		0X0E
LEFT        EQU		0X10
RIGHT       EQU		0X14
NEXT_LINE   EQU		0xC0
FOURBIT     EQU		0x28   ;0b00101000 = 0x28
LCD_OFF     EQU		0x0A

Level2
	PUSH {R0-R7, LR}

loop ;repeat forever
	
	MOVS LOOPCOUNTER, #0	;loopCounter used to track which string being displayed
	LDR STRCURSOR, =(COURSE1)	;Store pointer to first course

printCourse
	MOVS R1, #0		;Clearing R1 for all LCD commands

	MOVS R0, #CLEAR		;Clear display, reset cursor
	BL LCD_command
	
	MOVS R0, #HOME
	BL LCD_command
	
	MOVS R0, #0x08	;Everything off
	BL LCD_command	;Cleaner look during display update
	
	BL Level2_print_string ;Print course name
	ADDS STRCURSOR, #1		;Move from null byte to next string
	
	MOVS R0, #NEXT_LINE	;Move cursor to next line
	BL LCD_command
	
	BL Level2_print_string ;Print course time
	
	MOVS R0, #LCD_ON	;display on. Cursor/Blinking off
	BL LCD_command		;Turn display back on now that updated
	
	LDR R3, =(WAITTICKS) ;Put delay timer in R3
	BL BusyWait			;Wait 5 seconds
	
	ADDS STRCURSOR, #1		;Move from null byte to next string
	
	ADDS LOOPCOUNTER, #1	;Increment loop counter
	CMP LOOPCOUNTER, #NUMSTRINGS ;Check if all strings displayed
	BNE printCourse	;If not all displayed, repeat with next string

	BL loop

	POP {R0-R7, PC}
;Strings to be used
COURSE1		DCB		"ECE316 (M,W,F)",0,"10:00 - 10:50",0
COURSE2		DCB		"ECE301 (M,T,W,F)",0,"1:00-1:50",0
COURSE3		DCB		"ECE323 (T,Th)",0,"2:00-3:15",0
COURSE4		DCB		"CSCI413 (T,Th)",0,"11:00-12:15",0
	ALIGN
	END