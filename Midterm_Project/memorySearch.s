;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;memorySearch.s
;This subroutine will prompt the user for an input 0 - 9 corresponding to a memory entry
;If a memory entry exists corresponding to that input, then the memory entry will be
;	displayed on the LCD. T0 will be returned in R0, and T1 will be returned in R1.
;Otherwise, if the entry does not exist, then a message will be displayed stating such,
;	and no changes will be made to registers
; If a key ACBD* is entered, then the subroutine will return with no changes to R0 or R1.
;	The key entered will be in R7 and new key flag is set.
;Preconditions:
;	* R2 - Memory pointer - Points to beginning of memory segment
;Postconditions:
;	* If ACBD* entered: 
;		- Key entered is in R7 with new key flag set
;	* If valid memory location entered:
;		- R0,R1 loaded with values of T0 and T1 stored at that location.
;		- T0 and T1 displayed to LCD
;	* Otherwise, if undefined memory location entered:
;		- Message displayed indicating as such.
;		- R0,R1 unchanged.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 AREA PROGRAM, CODE, READONLY
 EXPORT memorySearch
 INCLUDE Constants.inc
 INCLUDE GlobalVariables.inc
 IMPORT print_string
 IMPORT LCD_config_dir
 IMPORT Keypad_config_dir
 IMPORT LCD_command
 IMPORT get_next_key_input	
 IMPORT clear_new_key_flag
 IMPORT Print_Character
 IMPORT Key_num_to_ascii
 IMPORT print_decimal_to_LCD
	
keyEntered		RN	4
memory_pointer	RN	2
	
memorySearch
	PUSH{R2-R6,LR}
	
	MOVS keyEntered, #0	;No key entered. Set to 1 when a key is entered
	;Print prompt
	LDR R3, =recallMemoryPrompt		;Load address of string to print
print_prompt
	BL LCD_config_dir	;Set pins for LCD

	PUSH{R0,R1}
	MOVS R0, #CLEAR
	MOVS R1, #0		;command mode
	BL LCD_command	;Clear display

	BL print_string ;print prompt
	;Move cursor to next line
	MOVS R0, #NEXT_LINE
	MOVS R1, #0
	BL LCD_command
	POP{R0,R1}
	BL Keypad_config_dir	;Set pins for keypad

getNextInput
	BL get_next_key_input ;New key will be stored in R6
	
	;Determine what to do with key input
	CMP R6, #KEY_D ;Checking whether in row with A,B,C,D
		BLE done	   ;If yes, then get out of subroutine
	CMP R6, #KEY_ASTERISK
		BEQ done			;If asterisk, leave subroutine w/o clearing flag
	CMP R6, #KEY_POUND
		BEQ pound_key		;If pound key, perform necessary logic
digit	;Otherwise, input is a digit
	BL clear_new_key_flag

	BL LCD_config_dir	;Set pins for LCD
	PUSH{R0,R1}
	;Reset cursor to beginning of line 2.
	MOVS R0, #HOME
	MOVS R1, #0
	BL LCD_command
	MOVS R0, #NEXT_LINE
	BL LCD_command
	POP{R0,R1}
	;Get entered character
	BL Key_num_to_ascii	;Convert from Key num to ASCII. Ascii is in R5
	MOVS R3, R5			;Make copy of ASCII value into R3 for later use
	;Print entered character
	BL LCD_config_dir
	BL Print_Character ;Print character stored in R5
	BL Keypad_config_dir	
	MOVS keyEntered, #1
	
	;Convert to decimal, store in R3
	SUBS R3, R3, #0x30
	B getNextInput ;Get next key input
	
pound_key
	BL clear_new_key_flag	;Always clear flag
	CMP keyEntered, #0		;If key is not entered yet, then do nothing
	BEQ getNextInput
	;Otherwise, verify input.
	
checkIfAssigned	
	;Extract memory head from R7
	LDR R4, =0xFFFF0
	ANDS R4, R7, R4
	LSRS R4, R4, #4
	LDR R5, =0x10000000
	ADDS R4, R4, R5	;Memory head now in R4
	;Get correct memory location
	SUBS R4, R4, #_memory_flags
	LDR R6, [R4]	;R6 now has flags
	
	;Check if flag corresponding to entered input is set
	MOVS R5, #1
	LSLS R5, R5, R3	;Set bit corresponding to entered input
	ANDS R5, R5, R6	;Check if bit is set
	CMP R5, #0
	BEQ undefinedInput
valid

	MOVS R5, #0x8
	MULS R3, R5, R3
	ADDS memory_pointer, memory_pointer, R3
	LDR R0, [memory_pointer]		;Store R0 to memory, decrement pointer
	ADDS memory_pointer, #element_size
	LDR R1, [memory_pointer]		;Store R1 to memory	
	
	;Display:
	BL LCD_config_dir	;Configure pins for LCD
	
	;Clear display:
	PUSH{R0,R1}
	MOVS R0, #CLEAR
	MOVS R1, #0		;0 to indicate command
	BL LCD_command
	POP{R0,R1}
	
	;Display T0:
	LDR R3, =T0Label
	BL print_string	;Print T0Label to LCD
	MOVS R3, R0
	BL print_decimal_to_LCD	;Print the decimal number from T0 to LCD
	
	;Move to next line:
	PUSH{R0,R1}
	MOVS R0, #NEXT_LINE
	MOVS R1, #0
	BL LCD_command
	POP{R0,R1}
	
	;Display T1:
	LDR R3, =T1Label
	BL print_string	;Print T1Label to LCD
	MOVS R3, R1
	BL print_decimal_to_LCD	;Print the decimal number from T1 to LCD
	BL Keypad_config_dir	;Configure pins for Keypad
	
	B done	
	
undefinedInput
;This code is accessed if user enters a location that is not yet
;defined in memory
	PUSH{R0,R1}
	BL LCD_config_dir
	;Clear LCD, reset cursor
	MOVS R0, #CLEAR
	MOVS R1, #0
	BL LCD_command
	MOVS R0, #HOME
	BL LCD_command
	;Print message
	LDR R3, =memoryUndefinedMessage
	BL print_string
	
	BL Keypad_config_dir
	POP{R0,R1}
done
	POP{R2-R6,PC}
recallMemoryPrompt		DCB		"Recall memory:",0
memoryUndefinedMessage	DCB		"Mem Undefined",0
	ALIGN
	END