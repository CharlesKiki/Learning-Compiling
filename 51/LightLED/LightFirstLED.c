/**************************************************************************************
*                 Light LED						*
Step£ºDownloader load the code into ROM of MCU ,and then the LED light.	  
***************************************************************************************/


#include "reg52.h"
//This file define the memory address with the stitch.

sbit led=P2^0;
//Define P2.0 port as LED

/*******************************************************************************
* Function name       : main
* Purpose		 	  : The entrance of program
* Input       		  : None
* Output 			  : None
*******************************************************************************/
void main()
{
	while(1)
	{
		led=0;	//P2.0 port Set to low level
	}		
}
