;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;memorySearch.s
;This subroutine will prompt the user for an input 0 - 9 corresponding to a memory entry
;If a memory entry exists corresponding to that input, then the memory entry will be
;	displayed on the LCD. T0 will be returned in R0, and T1 will be returned in R1.
;Preconditions:
;	* R2 - Memory pointer - Points to beginning of memory segment
;	* R4 - Memory offset  - Index of where least recent memory write is
;								(Or, if memory not full, then it is next empty slot)
;	* R5 - Print Mode	  - 0 if printing "Memory location?"
;						  - 1 if printing "Recall Memory:"
;	* R7 - Status vector  - Bit 28 should be set if memory is full.
;Postconditions:
;	* 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 AREA PROGRAM, CODE, READONLY
 EXPORT memorySearch
 INCLUDE Constants.inc
 IMPORT print_string
 IMPORT LCD_config_dir
 IMPORT Keypad_config_dir
 IMPORT LCD_command
 IMPORT get_next_key_input	
 IMPORT clear_new_key_flag
 IMPORT Print_Character
 IMPORT Key_num_to_ascii
 IMPORT print_decimal_to_LCD
	
keyEntered		RN	2
memory_offset	RN	4
memory_pointer	RN	2
	
memorySearch
	PUSH{R3,R5,R6,LR}
restart		
	PUSH{R2,R4}		;Will be restored earlier than other registers.
	
	MOVS keyEntered, #0	;No key entered. Set to 1 when a key is entered
	;Print prompt
	LDR R3, =memoryLocationPrompt	;Assumption is memory location prompt. Will be overwritten if Print Mode is 1
	CMP R5, #1
	BNE print_prompt
	LDR R3, =recallMemoryPrompt		;If print mode is 1, then overwrite assumption
print_prompt
	BL LCD_config_dir	;Set pins for LCD

	PUSH{R0,R1}
	MOVS R0, #CLEAR
	MOVS R1, #0		;command mode
	BL LCD_command	;Clear display

	BL print_string ;print prompt
reprint
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
	BLE quit	   ;If yes, then get out of subroutine.

	CMP R6, #KEY_ASTERISK
	BEQ quit			;If asterisk, leave subroutine w/o clearing flag
	
	CMP R6, #KEY_POUND
	BEQ pound_key		;If pound key, perform necessary logic
	
digit	;Otherwise, input is a digit
	CMP keyEntered, #1		;Check if a key was already entered
	BNE processDigit		;If not, skip over.
	MOVS keyEntered, #0	;If key was entered, then go through process again to overwrite previous key
	BL LCD_config_dir	;Set pins for LCD
	PUSH{R0,R1}
	MOVS R0, #HOME
	MOVS R1, #0
	BL LCD_command
	B reprint
	
processDigit
	PUSH{R5}
	BL Key_num_to_ascii	;Convert from Key num to ASCII. Ascii is in R5
	MOVS R3, R5			;Make copy of ASCII value into R3 for later use
	BL LCD_config_dir
	BL Print_Character ;Print character stored in R5
	BL Keypad_config_dir	
	POP{R5}
	BL clear_new_key_flag
	MOVS keyEntered, #1
	B getNextInput
	
pound_key
	BL clear_new_key_flag	;Always clear flag
	CMP keyEntered, #0		;If key is not entered yet, then do nothing
	BEQ getNextInput
	;Otherwise, verify input.
verify
	POP{R2,R4}
	;Extract bit 28 from R7
	MOVS R6, #1
	LSLS R6, R6, #28	;Set bit 28
	ANDS R6, R6, R7		;Get bit 28 from R7
	CMP R6, #0			;Check if bit is set
	BNE valid1			;If bit is set, then valid
	;Otherwise, to determine validity: Multiply entered number by 8, compare against memory offset
	SUBS R3, R3, #0x30		;Convert from ASCII to decimal
	MOVS R6, #8
	MULS R3, R6, R3
	CMP R3, memory_offset
	BLT valid2	;If input * 8 < memory_offset, then valid
	;Otherwise, invalid
invalid
	;Invalid input: restart.
	B restart
valid1
	SUBS R3, R3, #0x30		;Convert from ASCII to decimal
	MOVS R6, #8
	MULS R3, R6, R3
valid2
	;If valid input, find T0 and T1, assign to R0 and R1, display them
	;Find T0:
	LDR R0, [memory_pointer, R3] ;Store T0 in R0
	
	;Find T1:
	ADDS R3, R3, #4				;Move to next word
	LDR R1, [memory_pointer, R3] ;Store T1 in R1
	
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
	
quit	;Only accessed when ACBD* is pushed
	POP{R2,R4}	;Restore these values
	
done
	POP{R3,R5,R6,PC}
memoryLocationPrompt	DCB		"Memory location?",0
recallMemoryPrompt		DCB		"Recall memory:",0
T0Label					DCB		"T0:",0
T1Label					DCB		"T1:",0
	ALIGN
	END