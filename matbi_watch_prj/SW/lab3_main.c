//////////////////////////////////////////////////////////////////////////////////
// Company: Personal
// Engineer: Matbi / Austin
//
// Create Date:
// Design Name:
// Project Name:
// Target Devices:
// Tool Versions:
// Description: test Matbi Watch using AXI4-lite
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
 
#include <stdio.h>
#include "xparameters.h"
#include "xil_io.h"

#define AXI_DATA_BYTE 4
 
int main() {
    unsigned int data;
	int sec, min, hour;
    while (1) {
    	printf("======= Hello Project Matbi Watch ======\n");
    	printf("plz input freq (1 <= input <= 1GHz)\n");
    	scanf("%d",&data);
    	Xil_Out32((XPAR_LAB4_MATBI_0_BASEADDR) + (0*AXI_DATA_BYTE), (u32)(data));
    	printf("MATBI_WATCH (hour : min : sec)\n");
		while(1) {
    		data = Xil_In32((XPAR_LAB4_MATBI_0_BASEADDR) + (1*AXI_DATA_BYTE));
			sec = data & 0x3F;
			min = (data>>6) & 0x3F;
			hour = (data>>12) & 0x1F;
    		printf("\r(%2d:%2d:%2d) ", hour, min, sec); // https://stackoverflow.com/questions/15192441/update-printf-value-on-same-line-instead-of-new-one
			fflush(stdout);
	        // wait (for example, 10000 us or 0.01 sec), To prevent over send to PC through uart.
	        usleep(10000);
		}
    }
    return 0;
}

