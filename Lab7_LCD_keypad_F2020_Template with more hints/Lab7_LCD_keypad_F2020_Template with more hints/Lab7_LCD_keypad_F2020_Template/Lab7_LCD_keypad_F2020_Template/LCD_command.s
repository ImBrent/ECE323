;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;LCD_command.s
;Executes either a command or data storage operation
;On the LCD display
;If bit 0 of R1 is 1, then a data operation will be performed.
;Otherwise, a command is performed
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 AREA PROGRAM, CODE, READONLY
 INCLUDE	LPC11xx.inc
 EXPORT LCD_command
 IMPORT BusyWait
	 
DELAY		EQU		500

payload		RN	6

LCD_command
	PUSH{R0-R7,LR}

	;Set correct reset bits for GPIO0DATA
	CMP R1, #1
	BEQ dataMode
commandMode
	LDR R1, =0xFFFFFF61
	MOVS R2, #0
	BL Load_UpperDB
dataMode
	LDR R1, =0xFFFFFFE1
	MOVS R2, #0x80
	
Load_UpperDB
	
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
	ORRS R5, R2, R5
	STR R5, [R4]
	
	;;===Delay
	LDR R3, =DELAY
	BL BusyWait
	
	;==Set E;;;
	LDR R4, =(GPIO1DATA)
	MOVS R5, #0x1
	MOVS R5, R5, LSL #8
	STR	R5, [R4]
	
	;===Delay
	LDR R3, =DELAY
	BL BusyWait
	
	
	;==Clear E
	
	LDR R4, =(GPIO1DATA)
	MOVS R5, #0x0
	MOVS R5, R5, LSL #8
	STR	R5, [R4]
	
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
	ORRS R5, R2, R5
	STR R5, [R4]
	
	;;===Delay
	LDR R3, =DELAY
	BL BusyWait
	
	;==Set E;;;
	LDR R4, =(GPIO1DATA)
	MOVS R5, #0x1
	MOVS R5, R5, LSL #8
	STR	R5, [R4]
	
	;===Delay
	LDR R3, =DELAY
	BL BusyWait
	
	
	;==Clear E
	
	LDR R4, =(GPIO1DATA)
	MOVS R5, #0x0
	MOVS R5, R5, LSL #8
	STR	R5, [R4]
	
Post_processing
   ;;delay to allow LCD to process information
	
	LDR R3, =10000
	BL BusyWait

	
	POP {R0-R7,PC}
	END