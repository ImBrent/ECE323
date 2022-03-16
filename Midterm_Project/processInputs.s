;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;processInputs.s
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 AREA PROGRAM, CODE, READONLY
 EXPORT processInputs
 INCLUDE LPC11xx.inc
 INCLUDE Constants.inc
 IMPORT LCD_config_dir
 IMPORT Keypad_config_dir
 IMPORT EnterTx
 IMPORT LCD_command
 IMPORT get_next_key_input
 IMPORT clear_new_key_flag
 IMPORT memorySearch
 IMPORT enterChannel
 IMPORT memory_update
 IMPORT capture_flag_handler
 IMPORT print_string
	 
processInputs
	PUSH{LR}
	SUB sp, sp, #memory_size	;Set up stack pointer to accomodate locals
	MOV memory_pointer, sp ;Initialize memory pointer
	
	MOVS R0, #0		;T0 initially 0
	MOVS R1, #0		;T1 initially 0

getNextInput
	BL LCD_config_dir

	PUSH{R0,R1}

	MOVS R0, #CLEAR
	MOVS R1, #0
	BL LCD_command
	;Print name
	LDR R3, =myName
	BL print_string

	POP{R0,R1}
	BL Keypad_config_dir
skipName
	;Waiting for keypad input
	BL get_next_key_input	;New key will be stored in R6
	
	;New keypad input received. Clear new key flag.
	BL clear_new_key_flag
		
	;Branch to appropriate subroutine based upon what key was input
	CMP R6, #KEY_A
		BEQ KEY_A_LOGIC
	CMP R6, #KEY_B
		BEQ KEY_B_LOGIC
	CMP R6, #KEY_C
		BEQ KEY_C_LOGIC
	CMP R6, #KEY_D
		BEQ KEY_D_LOGIC
	CMP R6, #KEY_ASTERISK
		BEQ KEY_ASTERISK_LOGIC
	CMP R6, #KEY_POUND
		BEQ KEY_POUND_LOGIC
	B getNextInput		;Default case. Do nothing, wait for another input.
	
KEY_A_LOGIC
	MOVS R5, #0
	BL EnterTx
	B getNextInput
	
KEY_B_LOGIC
	MOVS R5, #1
	BL EnterTx
	B getNextInput
	
KEY_C_LOGIC
	MOVS R5, #0		;Indicate prompt for subroutine to display
	BL memory_update
	B skipName
	
KEY_D_LOGIC
	MOVS R5, #1		;Indicate prompt for subroutine to display
	BL memorySearch
	B skipName

KEY_ASTERISK_LOGIC
	BL enterChannel
	B getNextInput
	
KEY_POUND_LOGIC
	;Check if capture flag is set (Bit 27 of R7)
	LDR R3, =0x08000000
	ANDS R3, R3, R7
	CMP R3, #0
	BEQ getNextInput	;If flag is not set, then don't do display logic
	BL capture_flag_handler
	B skipName	;Don't print name over output
	
	ADD sp, sp, #memory_size ;Recover space used by locals	
	POP{PC}
myName	DCB	 "Brent!",0		
	ALIGN
	END