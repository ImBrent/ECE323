;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;key_num_to_ascii.s
;This subroutine receives a key number as input.
;It returns the ASCII code corresponding to that key number
;Preconditions:
;	* Key number is in R6
;Postconditions:
;	* ASCII code of key number is in R5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 AREA PROGRAM, CODE, READONLY
 EXPORT Key_num_to_ascii
	 
Key_num_to_ascii
	PUSH{R0,LR}

	LDR R0, =Chars
	LDRB R5, [R0, R6]

	POP{R0, PC}
Chars DCB	"ABCD369#2580147*"
	END