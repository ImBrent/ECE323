 AREA program, CODE, READONLY
 EXPORT convertKeyNum
 INCLUDE LPC11xx.inc
	 
convertKeyNum
	PUSH {R1-R7, LR}

	LDR R1, =Chars
	LDRB R0, [R1, R7]

	POP {R1-R7, PC}
	ALIGN
		
Chars DCB	"ABCD369#2580147*",0
ALIGN
 END