;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 AREA PROGRAM, CODE, READONLY
 EXPORT capture_flag_handler
 INCLUDE Constants.inc
 INCLUDE LPC11xx.inc
 INCLUDE GlobalVariables.inc
 IMPORT LCD_command
 IMPORT LCD_config_dir
 IMPORT Keypad_config_dir
 IMPORT LCD_command
 IMPORT print_string
 IMPORT print_decimal_to_LCD
 IMPORT DisableP0Interrupt
 IMPORT EnableP0Interrupt
 
capture_flag_handler
	PUSH{R0-R6,LR}
	BL LCD_config_dir
	
	;Get global memory start from R7
	LDR R6, =0xFFFF0	;Get bits 4-19
	ANDS R6, R6, R7
	LSRS R6, R6, #4	;Shift back into bits 0-15
	LDR R4, =0x10000000
	ADDS R6, R6, R4		;Get correct initial memory location
	
	;Disabling interrupt to ensure that T0, T1 don't change while reading
	LDR R0, =ICPR
	MOVS R1, #1
	LSLS R1, #18
	STR R1, [R0]
	
	;Get T0, store in R2
	MOVS R5, #_T0
	SUBS R5, R6, R5
	LDR R2, [R5]
	
	;Get T1, store in R5
	MOVS R3, #_T1
	SUBS R3, R6, R3
	LDR R5, [R3]
	
	;Re-enable Interrupt
	LDR R0, =ISER
	MOVS R1, #1
	LSLS R1, #18
	STR R1, [R0]

	MOVS R0, #CLEAR
	MOVS R1, #0
	BL LCD_command
	
	LDR R3, =T0string
	BL print_string
	
	MOVS R3, R2	;Move T0 into R3 to write
	
	BL print_decimal_to_LCD
	
	MOVS R0, #NEXT_LINE
	MOVS R1, #0
	BL LCD_command
	
	LDR R3, =T1string
	BL print_string
	
	MOVS R3, R5	;Move T1 into R3 to write
	
	BL print_decimal_to_LCD
	
	BL Keypad_config_dir
	
	POP{R0-R6,PC}
T0string	DCB		"T0:",0
T1string	DCB		"T1:",0
	ALIGN
	END