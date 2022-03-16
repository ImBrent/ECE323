;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;memory_update
;Preconditions:
;	*
;Postconditions:
;	*
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 AREA PROGRAM, CODE, READONLY
 INCLUDE Constants.inc
 INCLUDE GlobalVariables.inc
 EXPORT memory_update
 IMPORT LCD_command
 IMPORT print_string
 IMPORT LCD_config_dir
 IMPORT Keypad_config_dir
 IMPORT clear_new_key_flag	
 IMPORT Print_Character
 IMPORT Key_num_to_ascii
 IMPORT get_next_key_input
 IMPORT print_decimal_to_LCD
	
keyEntered	RN	3
keyNum		RN	4
	 
	 
memory_update
	PUSH{R2-R6,LR}
	
	MOVS keyEntered, #0 ;flag initially 0
	
promptForInput
	;Prompt user to enter memory location
	PUSH {R0,R1}
	BL LCD_config_dir
	MOVS R0, #CLEAR	;Clear the display
	MOVS R1, #0		;Command mode
	BL LCD_command

	LDR R3, =memoryLocationPrompt	
	BL print_string ;Print prompt
	
	MOVS R0, #NEXT_LINE
	BL LCD_command
	BL Keypad_config_dir
	POP {R0,R1}
	
	;Get next input from user and determine how to handle it	
getNextInput
	BL get_next_key_input ;New key will be stored in R6
	
	;Determine what to do with key input
	CMP R6, #KEY_D ;Checking whether in row with A,B,C,D
		BLE exit	   ;If yes, then get out of subroutine.
	CMP R6, #KEY_ASTERISK
		BEQ exit			;If asterisk, leave subroutine w/o clearing flag
	CMP R6, #KEY_POUND
		BEQ pound_key		;If pound key, perform necessary logic	
digit	;Otherwise, input is a digit
	BL clear_new_key_flag;input handled here
	BL Key_num_to_ascii ;Ascii in R5
	
	;Print key number
	BL LCD_config_dir	;Set pins for LCD
	PUSH{R0,R1}
	;Reset cursor at beginning of line 2
	MOVS R0, #HOME
	MOVS R1, #0	;command mode
	BL LCD_command
	MOVS R0, #NEXT_LINE
	BL LCD_command
	
	BL Print_Character ;Ascii key num in R5 already. Print character.
	
	BL Keypad_config_dir
	
	POP{R0,R1}
	;Convert to Decimal, store in keyNum
	SUBS R5, R5, #0x30
	MOVS keyNum, R5	

	MOVS keyEntered, #1
	B getNextInput
	
pound_key
	BL clear_new_key_flag
	;If key not entered, do not proceed. Re-print
	CMP keyEntered, #1
	BNE promptForInput
	
	;If: 
	;	* Flags for R0 and R1 update are set (bits 29 and 30 in R7)
	;	* T0 >= T1
	;Then: proceed to write to memory location entered
	LDR R5, =0x60000000 ;Bits 29 and 30 set
	MOVS R6, R5			;Apply same value to R6
	ANDS R5, R5, R7		;Check if both are set in R7, store result in R5
	CMP R6, R5
	BEQ checkT1	;If both are set, check next condition.
	LDR R3, =undefinedPrompt;Otherwise, don't update memory. Load prompt.
	B noUpdate

checkT1
	CMP R0, R1	;Check if T0 >= T1
	BGE updateMemory	;Do not update memory if T1 >= T0
	LDR R3, =T1LargerPrompt;Otherwise, don't update memory. Load prompt.
	B noUpdate

updateMemory
	;Updating memory
	MOVS R3, keyNum
	MOVS R5, #0x8
	MULS R3, R5, R3
	ADDS memory_pointer, memory_pointer, R3
	STR R0, [memory_pointer]		;Store R0 to memory, decrement pointer
	ADDS memory_pointer, #element_size
	STR R1, [memory_pointer]		;Store R1 to memory
	
	;Set bit indicating that memory location is assigned
	LDR R3, =0xFFFF0 ;Getting memory head from R7
	ANDS R3, R7, R3
	LSRS R3, R3, #4
	LDR R5, =0x10000000
	ADDS R3, R3, R5	;Memory head now in R3
	;Get correct memory location
	SUBS R3, R3, #_memory_flags
	LDR R6, [R3]	;R6 now has flags
	
	;Set correct flag
	MOVS R2, #1
	LSLS R2, R2, keyNum	
	ORRS R6, R6, R2		;Set corresponding bit in R6
	STR R6, [R3]		;Store back to memory
	
	;Display message showing values written to memory. 
	;Save R0 to R5, R1 to R6. Avoids excessive pushing/popping
	MOVS R5, R0
	MOVS R6, R1
	
	BL LCD_config_dir;Configure pins for LCD
	;Clear LCD
	MOVS R0, #CLEAR
	MOVS R1, #0	;command
	BL LCD_command
	
	MOVS R0, #HOME
	BL LCD_command
	;Write T0
	LDR R3, =T0Label
	BL print_string
	
	MOVS R3, R5
	BL print_decimal_to_LCD
	
	;Move to next line
	MOVS R0, #NEXT_LINE
	BL LCD_command
	
	;Print T1
	LDR R3, =T1Label
	BL print_string
	
	MOVS R3, R6
	BL print_decimal_to_LCD
	
	BL Keypad_config_dir;Configure pins for keypad
	;Restore values of R0, R1
	MOVS R0, R5
	MOVS R1, R6
	B exit
	
noUpdate	
	;Display message indicating no update
	BL LCD_config_dir
	;Clear display
	PUSH{R0,R1}
	MOVS R0, #CLEAR
	MOVS R1, #0	;command
	BL LCD_command
	
	MOVS R0, #HOME
	BL LCD_command
	POP{R0,R1}
	
	;Prompt in R3 already
	BL print_string
	
	BL Keypad_config_dir
exit
	POP{R2-R6,PC}
memoryLocationPrompt	DCB		"Memory location?",0
undefinedPrompt			DCB		"T0/T1 undefined.",0
T1LargerPrompt			DCB		"T1>T0. Aborted.",0
	ALIGN
	END