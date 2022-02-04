; LPC11xx.inc
; defines for LPC11xx MMRs
IOCON_BASE_ADDR			EQU	 0x40044000
IOCON_PIO2_6 			EQU	(IOCON_BASE_ADDR + 0x000)
IOCON_PIO2_0 			EQU	(IOCON_BASE_ADDR + 0x008)
IOCON_RESET_PIO0_0 		EQU	(IOCON_BASE_ADDR + 0x00C)
IOCON_PIO0_1 			EQU	(IOCON_BASE_ADDR + 0x010)
IOCON_PIO1_8 			EQU	(IOCON_BASE_ADDR + 0x014)
IOCON_SSEL1_LOC			EQU	(IOCON_BASE_ADDR + 0x018)
IOCON_PIO0_2 			EQU	(IOCON_BASE_ADDR + 0x01C)
IOCON_PIO2_7			EQU	(IOCON_BASE_ADDR + 0x020)
IOCON_PIO2_8 			EQU	(IOCON_BASE_ADDR + 0x024)
IOCON_PIO2_1 			EQU	(IOCON_BASE_ADDR + 0x028)
IOCON_PIO0_3 			EQU	(IOCON_BASE_ADDR + 0x02C)
IOCON_PIO0_4 			EQU	(IOCON_BASE_ADDR + 0x030)
IOCON_PIO0_5 			EQU	(IOCON_BASE_ADDR + 0x034)
IOCON_PIO1_9 			EQU	(IOCON_BASE_ADDR + 0x038)	
IOCON_PIO3_4 			EQU	(IOCON_BASE_ADDR + 0x03C)
IOCON_PIO2_4 			EQU	(IOCON_BASE_ADDR + 0x040)	
IOCON_PIO2_5 			EQU	(IOCON_BASE_ADDR + 0x044)
IOCON_PIO3_5 			EQU	(IOCON_BASE_ADDR + 0x048)	
IOCON_PIO0_6 			EQU	(IOCON_BASE_ADDR + 0x04C)	
IOCON_PIO0_7 			EQU	(IOCON_BASE_ADDR + 0x050)
IOCON_PIO2_9 			EQU	(IOCON_BASE_ADDR + 0x054)
IOCON_PIO2_10 			EQU	(IOCON_BASE_ADDR + 0x058)
IOCON_PIO2_2 			EQU	(IOCON_BASE_ADDR + 0x05C)
IOCON_PIO0_8 			EQU	(IOCON_BASE_ADDR + 0x060)
IOCON_PIO0_9 			EQU	(IOCON_BASE_ADDR + 0x064)
IOCON_SWCLK_PIO0_10		EQU	(IOCON_BASE_ADDR + 0x068)
IOCON_PIO1_10 			EQU	(IOCON_BASE_ADDR + 0x06C)
IOCON_PIO2_11 			EQU	(IOCON_BASE_ADDR + 0x070)
IOCON_R_PIO0_11			EQU	(IOCON_BASE_ADDR + 0x074)
IOCON_R_PIO1_0			EQU	(IOCON_BASE_ADDR + 0x078)
IOCON_R_PIO1_1			EQU	(IOCON_BASE_ADDR + 0x07C)
IOCON_R_PIO1_2			EQU	(IOCON_BASE_ADDR + 0x080)
IOCON_PIO3_0			EQU	(IOCON_BASE_ADDR + 0x084)	
IOCON_PIO3_1			EQU	(IOCON_BASE_ADDR + 0x088)
IOCON_PIO2_3			EQU	(IOCON_BASE_ADDR + 0x08C)
IOCON_SWDIO_PIO1_3		EQU	(IOCON_BASE_ADDR + 0x090)
IOCON_PIO1_4			EQU	(IOCON_BASE_ADDR + 0x094)
IOCON_PIO1_11			EQU	(IOCON_BASE_ADDR + 0x098)
IOCON_PIO3_2			EQU	(IOCON_BASE_ADDR + 0x09C)	
IOCON_PIO1_5			EQU	(IOCON_BASE_ADDR + 0x0A0)
IOCON_PIO1_6 			EQU	(IOCON_BASE_ADDR + 0x0A4)	
IOCON_PIO1_7 			EQU	(IOCON_BASE_ADDR + 0x0A8) 
IOCON_PIO3_3 			EQU	(IOCON_BASE_ADDR + 0x0AC)
IOCON_SCK0_LOC			EQU	(IOCON_BASE_ADDR + 0x0B0)
IOCON_DSR_LOC			EQU	(IOCON_BASE_ADDR + 0x0B4)
IOCON_DCD_LOC			EQU	(IOCON_BASE_ADDR + 0x0B8)
IOCON_RI_LOC			EQU	(IOCON_BASE_ADDR + 0x0BC)
IOCON_CT16B0_CAP0_LOC	EQU	(IOCON_BASE_ADDR + 0x0C0)
IOCON_SCK1_LOC			EQU	(IOCON_BASE_ADDR + 0x0C4)
IOCON_MISO1_LOC			EQU	(IOCON_BASE_ADDR + 0x0C8)
IOCON_MOSI1_LOC			EQU	(IOCON_BASE_ADDR + 0x0CC)
IOCON_CT32B0_CAP0_LOC 	EQU	(IOCON_BASE_ADDR + 0x0D0)
IOCON_RXD_LOC		  	EQU	(IOCON_BASE_ADDR + 0x0D4)
	
	
GPIO0DIR		EQU	0x50008000
GPIO1DIR		EQU 0x50018000
GPIO2DIR		EQU 0x50028000
GPIO3DIR		EQU 0x50038000
	
GPIO0DATA 		EQU 0x50003FFC
GPIO1DATA 		EQU 0x50013FFC
GPIO2DATA 		EQU 0x50023FFC
GPIO3DATA 		EQU 0x50033FFC

SYSAHBCLKCTRL	EQU	0x40048080

 END 