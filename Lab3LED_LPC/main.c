/*

Sample Code for LPC1114 driving a LCD, modified on 9/1/2020, and 9/10/2020

One focus of this project is to demonstrate functions and how to create and use correctly
Key topics include:
--- Creating function protoypes using a header file (calculations.h and initialization.h)
--- Implementing functions using .c files (calculations.c and intialization.c)
--- Making function calls from inside main function
--- referenced to LPC11xx.h supplied by Keil
    configure GPIO, Input or Output, and control the output to tuen an LED on and off
*/

// always include these two files
#include <LPC11xx.h>
#include <system_LPC11xx.h>

// functions for this porject
#include "calculations.h"
#include "initializations.h"

int main()
{
	
// The first section of code below simply demonstrates how to use user-defined function calls

	int num1, num2;
	int sum, difference;
	
	num1 = 5;
	num2 = 4;
	
	// the two function calls return integers so we must have
	//  the integers declared and set = to the function call
	sum = compute_sum(num1, num2);
	difference = compute_difference(num1, num2);
	
// the code below is responsible for the blinking of the LED connected to P0.11 (pin 4)
	initialize_P4P6();  // makes GPIO, sets as OUTPUT, and makes output HIGH
	
	char flag = 1; // set to 1 initially since the output was set to high in the initalize_P4 function call
	char pin1Output, pin17Status; //Output of pin1 is initially low in function call.
	
	int i; // used as index for a for loop delay 
	
	//Level 3: Let LED blink at a rate of N Hz
	int N = 1;		//Define N, the frequency that the LED will blink at

	const int HALF_PERIOD = 4000000/2;
	int numTicks = HALF_PERIOD / (N); //Set numTicks needed to make.

	// now enter infinite loop
	while(1)
	{
		
		// In order to achieve the blinking at a frequency with high accuarcy, use TIMERS
		// For now, can just use a simple delay function like the one below
		for(i = 0; i < numTicks ; i++)  // about 1 Hz blinking rate
		{   
		}
	
		toggle_pin(flag);
	
		if(flag) // if flag == 1
			flag = 0;
		else	
			flag = 1;
		
		//Level 2 function calls
		//Note: The output can only update as fast as the selected frequency.
		pin1Output = test_pin17();
		set_pin1(pin1Output);
	};
}
