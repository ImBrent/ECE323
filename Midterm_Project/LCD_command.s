;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;LCD_command.s
;Executes either a command or data storage operation
;On the LCD display
;If bit 0 of R1 is 1, then a data operation will be performed.
;Otherwise, a command is performed
;Preconditions:
;	* R0: Contains payload to be sent to LCD
;	* R1: Contains 0 if payload is command, 1 if payload is data
;	* Pins are configured for sending data to LCD
;Postconditions:
;	* Necessary command or data has been sent to LCD, and LCD
;		should react accordingly
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 AREA PROGRAM, CODE, READONLY
 INCLUDE	LPC11xx.inc
 EXPORT LCD_command
 IMPORT BusyWait
	 
DELAY		EQU		500

payload		RN	6

LCD_command
	PUSH{R0-R6,LR}

	;Set correct reset bits for GPIO0DATA
	MOVS R5, #1
	LDR R3, =GPIO1DATA
	LDR R6, [R3]
	CMP R1, #1
	BEQ dataMode
commandMode
	BICS R6, R6, R5
	BL Load_UpperDB
dataMode
	ORRS R6, R6, R5
;	MOVS R2, #0x80
	
Load_UpperDB
	STR R6, [R3]
	LDR R1, =0xFFFFFF61	
	
	;== Split data into upper bit
	
	MOVS payload, R0, LSR #4
	MOVS R3, #0x0F
	ANDS payload,payload, R3

	;===Clear DB PINs====	
	LDR  R4, =(GPIO0DATA)
	MOVS R5, R1
	STR  R5, [R4]
	
	;== Send lower 4-bit
	LDR R4, =(GPIO0DATA)
	MOVS R5, payload, LSL #1
;	ORRS R5, R2, R5
	STR R5, [R4]
	
	;;===Delay
	LDR R3, =DELAY
	BL BusyWait
	
	;==Set E;;;
	LDR R4, =(GPIO1DATA)
	LDR R6, [R4]
	MOVS R5, #0x1
	MOVS R5, R5, LSL #8
	ORRS R6, R6, R5
	STR	R6, [R4]
	
	;===Delay
	LDR R3, =DELAY
	BL BusyWait
	
	
	;==Clear E
	
	LDR R4, =(GPIO1DATA)
	LDR R6, [R4]
	;R5 already has appropriate bit to clear
	BICS R6, R6, R5
	STR	R6, [R4]
	
Load_LowerDB

	;==split data into lower 4-bit
	
	MOVS payload, R0
	MOVS R3, #0x0F
	ANDS payload, R3
	
	;===Clear DB PINs====
	LDR  R4, =(GPIO0DATA)
	MOVS R5, R1
	STR  R5, [R4]
	
	;== Send lower 4-bit
	LDR R4, =(GPIO0DATA)
	MOVS R5, payload, LSL #1
;	ORRS R5, R2, R5
	STR R5, [R4]
	
	;;===Delay
	LDR R3, =DELAY
	BL BusyWait
	
	;==Set E;;;
	LDR R4, =(GPIO1DATA)
	LDR R6, [R4]
	MOVS R5, #0x1
	MOVS R5, R5, LSL #8
	ORRS R6, R6, R5
	STR	R6, [R4]
	
	;===Delay
	LDR R3, =DELAY
	BL BusyWait
	
	
	;==Clear E
	
	LDR R4, =(GPIO1DATA)
	LDR R6, [R4]
	;R5 already has appropriate bit to clear
	BICS R6, R6, R5
	STR	R6, [R4]
	
Post_processing
   ;;delay to allow LCD to process information
	
	LDR R3, =10000
	BL BusyWait

	
	POP {R0-R6,PC}
	ALIGN
	END