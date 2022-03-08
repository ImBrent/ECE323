;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;ConfigInit.s
;Performs the following initializations:
;	* IOCON
;		- Configures pins 0.1, 0.2, 0.3, 0.4, 0.7 and 1.8 as IOCON
;		- Configures SYSAHBCLKCTRL for IOCON and GPIO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 AREA program, CODE, READONLY
 EXPORT CONFIG_INIT
 INCLUDE LPC11xx.inc
	 
CONFIG_INIT
	PUSH {R0-R7, LR}

;Configure SYSAHBCLKCTRL for IOCON and GPIO
	LDR R0, =(SYSAHBCLKCTRL) ;Load address of SYSAHBCLKCTRL
	LDR R1, [R0]			 ;Load contents of SYSAHBCLKCTRL into R1
	;Bit 6 enables clock for GPIO, Bit 16 for IOCON.
	LDR R2, =(0x0001040)	 ;Load pattern into R2
	ORRS R1, R2				 ;Set needed bits in R1
	STR R1, [R0]			 ;Store updated configuration bits back

;CONFIGURE PIO0_1 as IOCON
	LDR R0, =(IOCON_PIO0_1)	;Load address of IOCON_PIO0_1
	LDR R1, [R0]			;Get value from address
	LDR R2, =(0x8)			;Set function to PIO0_1, mode to pd resistor
	ORRS R1, R2				;Set needed bits in R1
	STR R1, [R0]			;Store updated configuration bits
	
	
;CONFIGURE PIO0_2 as IOCON
	LDR R0, =(IOCON_PIO0_2)	;Load address of IOCON_PIO0_2
	LDR R1, [R0]			;Get value from address
	LDR R2, =(0x8)			;Set function to PIO0_2, mode to pd resistor
	ORRS R1, R2				;Set needed bits in R1
	STR R1, [R0]			;Store updated configuration bits
	
;CONFIGURE PIO0_3 as IOCON
	LDR R0, =(IOCON_PIO0_3)	;Load address of IOCON_PIO0_3
	LDR R1, [R0]			;Get value from address
	LDR R2, =(0x8)			;Set function to PIO0_3, mode to pd resistor
	ORRS R1, R2				;Set needed bits in R1
	STR R1, [R0]			;Store updated configuration bits
	
;CONFIGURE PIO0_4 as IOCON
	LDR R0, =(IOCON_PIO0_1)	;Load address of IOCON_PIO0_4
	LDR R1, [R0]			;Get value from address
	LDR R2, =(0x0)			;Set function to PIO0_4. pd resistor mode unavailable.
	ORRS R1, R2				;Set needed bits in R1
	STR R1, [R0]			;Store updated configuration bits
	
;CONFIGURE PIO0_7 as IOCON
	LDR R0, =(IOCON_PIO0_1)	;Load address of IOCON_PIO0_7
	LDR R1, [R0]			;Get value from address
	LDR R2, =(0x8)			;Set function to PIO0_7, mode to pd resistor
	ORRS R1, R2				;Set needed bits in R1
	STR R1, [R0]			;Store updated configuration bits
	
;CONFIGURE PIO1_8 as IOCON
	LDR R0, =(IOCON_PIO1_8)	;Load address of IOCON_PIO1_8
	LDR R1, [R0]			;Get value from address
	LDR R2, =(0x8)			;Set function to PIO0_1, mode to pd resistor
	ORRS R1, R2				;Set needed bits in R1
	STR R1, [R0]			;Store updated configuration bits
	
	POP {R0-R7, PC}
	ALIGN
 END