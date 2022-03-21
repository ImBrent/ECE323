;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;enterChannel.s
;This subroutine will prompt the user for a channel number 1-4
;When the user enters a value and presses the # key, the channel corresponding
;to the entered value will have the value T0 (stored in R0) applied to its
;total period, and T1 (stored in R1) applied to its high period
;Preconditions:
;	* R0: Contains value of T0
;	* R1: Contains value of T1
;	* T0 > T1
;Postconditions:
;	* User entered channel will be configured such that T0 is its total period
;			and T1 is its high period.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 AREA PROGRAM, CODE, READONLY
 EXPORT enterChannel
 INCLUDE Constants.inc
 IMPORT LCD_command
 IMPORT LCD_config_dir
 IMPORT Keypad_config_dir
 IMPORT print_string
 IMPORT Key_num_to_ascii
 IMPORT Print_Character
 IMPORT clear_new_key_flag
 IMPORT get_next_key_input	
 IMPORT configureChannel
	
channelNum		rn			2
isEntered		rn			4
 
enterChannel
	PUSH{R2-R6,LR}

	MOVS isEntered, #0	;Flag initialized to 0

	;Display prompt
	BL LCD_config_dir
	PUSH{R0,R1}
	;Clear display
	MOVS R0, #CLEAR
	MOVS R1, #0
	BL LCD_command
	
	;Print prompt
	LDR R3, =prompt
	BL print_string
	
	;Move to next line
	MOVS R0, #NEXT_LINE
	;R1 already 0
	BL LCD_command
	
	POP{R0,R1}
	BL Keypad_config_dir

getNextInput
	BL get_next_key_input	;Next key is in R6
	
	CMP R6, #KEY_D	;If ABCD, then quit w/o clearing flag
		BLE quit
	CMP R6, #KEY_ASTERISK	;If *, then quit w/o clearing
		BEQ quit
	CMP R6, #KEY_POUND	;If pound key, go to that logic
		BEQ pound_key
	;Otherwise, default: digit 0-9

digit
	BL clear_new_key_flag ;Clear new key flag
	;Determine ascii value
	BL Key_num_to_ascii	;Ascii in R5
	;Convert to decimal
	MOVS R6, R5
	SUBS R6, R6, #0x30 ;decimal key number in R6
	;Check if in range 1-4. If not, then wait for next input.
	CMP R6, #1
		BLT getNextInput
	CMP R6, #4
		BGT getNextInput
	;Otherwise, valid input given. Print ASCII key number
	BL LCD_config_dir
	PUSH{R0,R1}
	;Reset cursor at beginning of line 2
	MOVS R0, #HOME
	MOVS R1, #0	;command mode
	BL LCD_command
	MOVS R0, #NEXT_LINE
	BL LCD_command
	
	BL Print_Character ;Ascii key num in R5 already. Print character.
	
	POP{R0,R1}
	BL Keypad_config_dir	
	
	;Convert to Decimal, store in channelNum
	SUBS R5, R5, #0x30
	MOVS channelNum, R5	
	
	MOVS isEntered, #1 ;set flag indicating that a digit has been entered
	B getNextInput	;Wait for next keypad input
	
pound_key
	BL clear_new_key_flag ;Clear new key flag.
	;Check if a digit has been entered.
	CMP isEntered, #1
		BNE getNextInput	;Only proceed if a digit has been entered.
	
	;Check if both T0 and T1 assigned (Bit 29 and 30 of R7)
	MOVS R4, R7
	LSRS R4, R4, #29 ;Shift out all bits except 29-31
	MOVS R5, #0x3	;Set bits 0 and 1
	ANDS R4, R4, R5	;Isolate bits 0 and 1
	CMP R4, #0x3	;Check if set
	BNE error		;If either is not set, then don't change channel.
	
	CMP R0, R1	;Check if R0 >= R1
	BLT error	;Do not change channel if not.
	
	;Call subroutine to apply T0,T1 to chosen channel
	BL configureChannel
	B quit

error
	BL LCD_config_dir
	PUSH{R0,R1}
	
	MOVS R0, #CLEAR
	MOVS R1, #0
	BL LCD_command
	
	LDR R3, =errMessage
	BL print_string
	
	POP{R0,R1}
	BL Keypad_config_dir
	
	;Wait for next input here. Allows message to remain displayed
	BL get_next_key_input
		
quit 

	POP{R2-R6,PC}
prompt		DCB		"Channel?",0
errMessage	DCB		"T0 or T1 Invalid",0
	ALIGN
	END