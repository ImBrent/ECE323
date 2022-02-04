 AREA PROGRAM, CODE, READONLY
 INCLUDE	LPC11xx.inc
 EXPORT Level3
	 
	 
Level3
	
	PUSH {R0-R7,LR}
;Constantly check condition of GPIO1_8
	LDR R0, =(GPIO0DATA)
	LDR R2, =(GPIO1DATA)
CHECK
	LDR R3, [R2]			;First, get value of GPIO1_8
	LDR R1, =(0x100)		;Bit 8 set for comparison
	
	ANDS R1, R1, R3		;Get value of bit 8 from data register
	
	LDR R4, [R0]		;Get contents of GPIO0 prior to setting
	
	CMP R1, #0			;Check if bit 8 set
	BNE SET				
	
	;Bit 8 is not set. Clear bit 6 of GPIO0
	LDR R1, =(0xFFFFFFBF)	;All bits set except bit 6
	ANDS R1, R1, R4			
	STR R1, [R0]			;Store updated data
	
	B CHECK	;Repeat check
SET
	;Bit 8 is set. Set bit 6 in GPIO1
	LDR R1, =(0x40)		;Bit 6 set
	ORRS R1, R1, R4		;Set bit 6 in data if not set already
	STR R1, [R0]		;Store updated data
	
	B CHECK
 
	POP {R0-R7,PC}
 
	END