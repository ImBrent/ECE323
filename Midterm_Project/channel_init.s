;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;channel_init
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 AREA PROGRAM, CODE, READONLY
 EXPORT channel_init
 IMPORT Init_TMR32B0
 IMPORT Init_TMR32B1
 IMPORT Init_TMR16B0
 IMPORT Init_TMR16B1
 
channel_init
	PUSH{LR}
	
	BL Init_TMR32B0
	
	BL Init_TMR32B1
	
	BL Init_TMR16B0
	
	BL Init_TMR16B1
	
	POP{PC}
	ALIGN
	END