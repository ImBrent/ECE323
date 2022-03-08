;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;EnterTx.s
;This subroutine allows the user to enter a new value for Tx, where 'x' is 0 or 1.
;The new value will be saved into Rx. If a key is pressed to switch to another
;function, then the subroutine will break and Rx will remain unchanged
;Preconditions:
;	* x is stored in R5
;Postconditions:
;	* Rx contains user entered value if user doesn't go to another function.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 AREA PROGRAM, CODE, READONLY
 INCLUDE LPC11xx.inc
 INCLUDE Constants.inc
 EXPORT EnterTx
 IMPORT print_string
 IMPORT LCD_config_dir
 IMPORT Keypad_config_dir
 IMPORT LCD_command
 IMPORT get_next_key_input
 IMPORT clear_new_key_flag
 IMPORT Print_Character
 IMPORT Key_num_to_ascii
 
Entered_Value	RN	2
POUND_FLAG		RN	3
Num_Chars		RN	4
x				RN	5
 
EnterTx
	PUSH{R2-R6,LR}
	
restart
	BL LCD_config_dir 	;Configure pins for LCD use
	
print_prompt
	PUSH{R0,R1}
	
	MOVS R0, #CLEAR
	MOVS R1, #0
	BL LCD_command ;Clear LCD
	
	LDR R3, =prompt	;Print prompt
	BL print_string

	;Print x to the display
	PUSH{R5}
	ADDS x, x, #0x30	;Convert to ASCII digit
	MOVS R5, x			;Place in R5 for subroutine call
	BL Print_Character
	
	;Print ':' to the display
	MOVS R5, #0x3A
	BL Print_Character
	POP{R5}

	MOVS R0, #NEXT_LINE ;Move to next line for input
	BL LCD_command
	
	POP{R0,R1}

	MOVS Entered_Value, #0	;Initialize Entered Value to 0 
	MOVS Num_Chars, #0		;Initialize number of entered characters to 0
	MOVS POUND_FLAG, #0

	BL Keypad_config_dir 	;Configure pins for keypad use
getNextInput
	BL get_next_key_input ;New key will be stored in R6
	
	;Determine what to do with key input
	CMP R6, #KEY_D ;Checking whether in row with A,B,C,D
	BLE exit	   ;If yes, then get out of subroutine.

	CMP R6, #KEY_ASTERISK
	BEQ exit			;If asterisk, leave subroutine w/o clearing flag
	
	CMP R6, #KEY_POUND
	BEQ pound_key		;If pound key, perform necessary logic
	
digit
	;Otherwise, key is a digit 0-9. 
	;In this case, print the key and add the key to sum.
	
	BL clear_new_key_flag ;Clear flag
	
	;If key is 0 and number of keys entered is 0, then don't do anything
	CMP R6, #KEY_0
	BNE printNum
	CMP Num_Chars, #0
	BEQ getNextInput
	
printNum
	PUSH{R5}
	BL Key_num_to_ascii	;Convert from Key num to ASCII. Ascii is in R5
	BL LCD_config_dir
	BL Print_Character ;Print character stored in R5
	BL Keypad_config_dir
	
	;Add key to sum
	SUBS R5, R5, #0x30						;Convert key from ascii to decimal
	MOVS R6, #10
	MULS Entered_Value, R6, Entered_Value	;Move current value to the left by 1 place
	ADDS Entered_Value, Entered_Value, R5
	POP{R5}
	
	BLT restart		;Restart if overflow.

	;Increment number of entered characters
	ADDS Num_Chars, Num_Chars, #1

	B getNextInput

pound_key
	BL clear_new_key_flag
	
	CMP Num_Chars, #0		;Check if pound is first char entered
	BNE Store_Value			;If not zero, then go to code that handles storing entered value
	
	;Otherwise, print # on screen and set pound flag
	PUSH{R5}
	MOVS R5, #0x23	;Code for '#' in ASCII
	BL LCD_config_dir
	BL Print_Character ;Print character stored in R5
	BL Keypad_config_dir
	POP{R5}
	
	MOVS POUND_FLAG, #1 ;Set # flag
	
	B getNextInput

Store_Value
	;Apply Pound flag
	CMP POUND_FLAG, #1	;If Pound flag is set, then multiply by Entered value by 1000
	BNE checkLower
	
	LDR R6, =1000
	MULS Entered_Value, R6, Entered_Value
	
checkLower	;Check lower bound. Must be >=1000. 
	;Note that if overflow occured during multiplication, value will still be <=1000. No need for explicit check.
	LDR R3, =1000
	CMP Entered_Value, R3
	BLT restart					;Restart if lower bound not satisfied
	
checkUpper	;Check upper bound. Must be <=48,000,000
	LDR R3, =48000000
	CMP Entered_Value, R3
	BGT restart

	;Both bounds satisfied. Assign value.
	CMP x, #0	;If x is 0, then place Entered value into R0
	BNE assignT1
assignT0
	CMP Entered_Value, R1 ;Make sure that entered value => T1 before assigning
	BLT restart	;Restart if  < T1
	
	MOVS R0, Entered_Value ;Assign entered T0 to R0
	B exit
	
assignT1
	CMP Entered_Value, R0	;Make sure that entered value <= T0 before assigning
	BGT restart	;Restart if > T0
	MOVS R1, Entered_Value	;Assign entered T1 to R1
	
exit
	;Set flag indicating that Tx has been updated
	;Bit 29 corresponds to T0, Bit 30 corresponds to T1
	MOVS R2, #29	
	ADDS R2, x		;Set R2 to 29 if T0, 30 if T1
	MOVS R3, #1
	LSLS R3, R3, R2	;Set appropriate bit in R3
	ORRS R7, R7, R3	;Set that bit in R7. Flag now set.
	
	POP{R2-R6, PC}
prompt	DCB		"Enter T",0	;Remainder of string will be manually entered.
	ALIGN
	END