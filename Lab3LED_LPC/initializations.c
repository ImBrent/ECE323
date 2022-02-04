#include <LPC11xx.h>
#include "initializations.h"

// this function will set pin #4 (P0_11) to GPIO and as an OUTPUT
void initialize_P4P6(void)
{
	// Pin 4 is PIO0_11, Pin 6 is PIO0_6
	LPC_IOCON-> R_PIO0_11|= 0x1; // line 214 of the LPC11xx.h file 
	//user manual pages 174 and 94, bits 2:0 should be 1, use bitwise OR to set a bit to 1
	LPC_IOCON->PIO0_6 = 0x0;  // Page 88, Table 75,

	LPC_IOCON->PIO0_8 = 0x0; //Pin 1
	
	LPC_IOCON->PIO1_6 = 0x0; //Pin 17
	
	// pin P0.11, 11th bit in the GPIO0->DIR register to be 1, output
	LPC_GPIO0->DIR |=  0x900;  // 1000 0100 0000, page 193 of user manual and line 317 of LPC11xx.h
	
	// finally, make the output HIGH
	LPC_GPIO0->DATA |= 0x940;  // page 192 of user manual, line 313 in LPC11xx.h
}


// could put this function implementaion in a sperate .c file if wanted
void toggle_pin(char flag)
{
	if(flag) // if high, make low
		LPC_GPIO0->DATA &= ~0x840;  // by doing a bitwise NOT, then bitwise AND to set zero
	else // make high
		LPC_GPIO0->DATA |= 0x840;   // bitwise OR to set 6th and 11th bit to be one.
	
}

/*******************************
set_pin1
This function sets the output of pin1 to HIGH if input is high,
and to LOW if input is low
*******************************/
void set_pin1(char flag){
	if(flag) //If flag set, make pin high
		LPC_GPIO0->DATA |= 0x100;
	else //make pin low
		LPC_GPIO0->DATA &= ~0x100;
}//end set_pin1

/******************
test_pin6
This function returns a integer 1 if pin17 is logic 1,
and a integer 0 if pin17 is logic 0
******************/
char test_pin17(void){
	char test;
	//test = (LPC_GPIO0->DATA & 0x040);
	test = (LPC_GPIO1->DATA & 0x40);
	return (test > 0);
}//end test_pin17
