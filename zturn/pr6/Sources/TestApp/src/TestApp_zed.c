/**************************************************************************
*
*     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"
*     SOLELY FOR USE IN DEVELOPING PROGRAMS AND SOLUTIONS FOR
*     XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION
*     AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE, APPLICATION
*     OR STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS
*     IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,
*     AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE
*     FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY
*     WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE
*     IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
*     REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF
*     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
*     FOR A PARTICULAR PURPOSE.
*
*     (c) Copyright 2010 Xilinx, Inc.
*     All rights reserved.
*
**************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "xparameters.h"
#include "xil_printf.h"
#include "xil_cache.h"
#include "ff.h"
#include "xdevcfg.h"
#include "xil_io.h"
#include "xil_types.h"

// Parameters for Partial Reconfiguration
#define PARTIAL_MULT_ADDR   0x300000
#define PARTIAL_ADDER_ADDR   0x200000
#define PARTIAL_LEFT_ADDR   0x400000
#define PARTIAL_RIGHT_ADDR   0x500000
#define PARTIAL_BLANK_MATH_ADDR   0x600000
#define PARTIAL_BLANK_SHIFT_ADDR   0x700000
#define PARTIAL_MULT_BITFILE_LEN  27746 // in number of words
#define PARTIAL_ADDER_BITFILE_LEN  27746 // in number of words
#define PARTIAL_BLANK_MATH_BITFILE_LEN  13901 // in number of words
#define PARTIAL_LEFT_BITFILE_LEN 37871 // in number of words
#define PARTIAL_RIGHT_BITFILE_LEN 37871 // in number of words
#define PARTIAL_BLANK_SHIFT_BITFILE_LEN 30490 // in number of words

// address space for the prc_0 instance
//| Virtual Socket Manager | Register     | Address |
//+------------------------+--------------+---------+
//| rp_math                | STATUS       | 0X00000 |
//| rp_math                | CONTROL      | 0X00000 |
//| rp_math                | SW_TRIGGER   | 0X00004 |
//| rp_math                | TRIGGER0     | 0X00040 |
//| rp_math                | TRIGGER1     | 0X00044 |
//| rp_math                | TRIGGER2     | 0X00048 |
//| rp_math                | TRIGGER3     | 0X0004C |
//| rp_math                | RM_BS_INDEX0 | 0X00080 |
//| rp_math                | RM_CONTROL0  | 0X00084 |
//| rp_math                | RM_BS_INDEX1 | 0X00088 |
//| rp_math                | RM_CONTROL1  | 0X0008C |
//| rp_math                | RM_BS_INDEX2 | 0X00090 |
//| rp_math                | RM_CONTROL2  | 0X00094 |
//| rp_math                | RM_BS_INDEX3 | 0X00098 |
//| rp_math                | RM_CONTROL3  | 0X0009C |
//| rp_math                | BS_ID0       | 0X000C0 |
//| rp_math                | BS_ADDRESS0  | 0X000C4 |
//| rp_math                | BS_SIZE0     | 0X000C8 |
//| rp_math                | BS_ID1       | 0X000D0 |
//| rp_math                | BS_ADDRESS1  | 0X000D4 |
//| rp_math                | BS_SIZE1     | 0X000D8 |
//| rp_math                | BS_ID2       | 0X000E0 |
//| rp_math                | BS_ADDRESS2  | 0X000E4 |
//| rp_math                | BS_SIZE2     | 0X000E8 |
//| rp_math                | BS_ID3       | 0X000F0 |
//| rp_math                | BS_ADDRESS3  | 0X000F4 |
//| rp_math                | BS_SIZE3     | 0X000F8 |
//| rp_shift               | STATUS       | 0X00100 |
//| rp_shift               | CONTROL      | 0X00100 |
//| rp_shift               | SW_TRIGGER   | 0X00104 |
//| rp_shift               | TRIGGER0     | 0X00140 |
//| rp_shift               | TRIGGER1     | 0X00144 |
//| rp_shift               | TRIGGER2     | 0X00148 |
//| rp_shift               | TRIGGER3     | 0X0014C |
//| rp_shift               | RM_BS_INDEX0 | 0X00180 |
//| rp_shift               | RM_CONTROL0  | 0X00184 |
//| rp_shift               | RM_BS_INDEX1 | 0X00188 |
//| rp_shift               | RM_CONTROL1  | 0X0018C |
//| rp_shift               | RM_BS_INDEX2 | 0X00190 |
//| rp_shift               | RM_CONTROL2  | 0X00194 |
//| rp_shift               | RM_BS_INDEX3 | 0X00198 |
//| rp_shift               | RM_CONTROL3  | 0X0019C |
//| rp_shift               | BS_ID0       | 0X001C0 |
//| rp_shift               | BS_ADDRESS0  | 0X001C4 |
//| rp_shift               | BS_SIZE0     | 0X001C8 |
//| rp_shift               | BS_ID1       | 0X001D0 |
//| rp_shift               | BS_ADDRESS1  | 0X001D4 |
//| rp_shift               | BS_SIZE1     | 0X001D8 |
//| rp_shift               | BS_ID2       | 0X001E0 |
//| rp_shift               | BS_ADDRESS2  | 0X001E4 |
//| rp_shift               | BS_SIZE2     | 0X001E8 |
//| rp_shift               | BS_ID3       | 0X001F0 |
//| rp_shift               | BS_ADDRESS3  | 0X001F4 |
//| rp_shift               | BS_SIZE3     | 0X001F8 |

#define rp_math_STATUS      XPAR_PRC_0_BASEADDR+0X00000
#define rp_math_CONTROL     XPAR_PRC_0_BASEADDR+0X00000
#define rp_math_SW_TRIGGER  XPAR_PRC_0_BASEADDR+0X00004
#define rp_math_TRIGGER0    XPAR_PRC_0_BASEADDR+0X00040
#define rp_math_TRIGGER1    XPAR_PRC_0_BASEADDR+0X00044
#define rp_math_TRIGGER2    XPAR_PRC_0_BASEADDR+0X00048
#define rp_math_TRIGGER3    XPAR_PRC_0_BASEADDR+0X0004C

//| rp_math                | BS_ID0       | 0X000C0 |
//| rp_math                | BS_ID1       | 0X000D0 |
//| rp_math                | BS_ID2       | 0X000E0 |
//| rp_math                | BS_ID3       | 0X000F0 |

#define rp_math_RM_ADDRESS0 XPAR_PRC_0_BASEADDR+0X00080
#define rp_math_RM_CONTROL0 XPAR_PRC_0_BASEADDR+0X00084
#define rp_math_RM_ADDRESS1 XPAR_PRC_0_BASEADDR+0X00088
#define rp_math_RM_CONTROL1 XPAR_PRC_0_BASEADDR+0X0008C
#define rp_math_RM_ADDRESS2 XPAR_PRC_0_BASEADDR+0X00090
#define rp_math_RM_CONTROL2 XPAR_PRC_0_BASEADDR+0X00094
#define rp_math_RM_ADDRESS3 XPAR_PRC_0_BASEADDR+0X00098
#define rp_math_RM_CONTROL3 XPAR_PRC_0_BASEADDR+0X0009C
#define rp_math_BS_ADDRESS0 XPAR_PRC_0_BASEADDR+0X000C4
#define rp_math_BS_SIZE0    XPAR_PRC_0_BASEADDR+0X000C8
#define rp_math_BS_ADDRESS1 XPAR_PRC_0_BASEADDR+0X000D4
#define rp_math_BS_SIZE1    XPAR_PRC_0_BASEADDR+0X000D8
#define rp_math_BS_ADDRESS2 XPAR_PRC_0_BASEADDR+0X000E4
#define rp_math_BS_SIZE2    XPAR_PRC_0_BASEADDR+0X000E8
#define rp_math_BS_ADDRESS3 XPAR_PRC_0_BASEADDR+0X000F4
#define rp_math_BS_SIZE3    XPAR_PRC_0_BASEADDR+0X000F8

#define rp_shift_STATUS      XPAR_PRC_0_BASEADDR+0X00100
#define rp_shift_CONTROL     XPAR_PRC_0_BASEADDR+0X00100
#define rp_shift_SW_TRIGGER  XPAR_PRC_0_BASEADDR+0X00104
#define rp_shift_TRIGGER0    XPAR_PRC_0_BASEADDR+0X00140
#define rp_shift_TRIGGER1    XPAR_PRC_0_BASEADDR+0X00144
#define rp_shift_TRIGGER2    XPAR_PRC_0_BASEADDR+0X00148
#define rp_shift_TRIGGER3    XPAR_PRC_0_BASEADDR+0X0014C

#define rp_shift_RM_ADDRESS0 XPAR_PRC_0_BASEADDR+0X00180
#define rp_shift_RM_CONTROL0 XPAR_PRC_0_BASEADDR+0X00184
#define rp_shift_RM_ADDRESS1 XPAR_PRC_0_BASEADDR+0X00188
#define rp_shift_RM_CONTROL1 XPAR_PRC_0_BASEADDR+0X0018C
#define rp_shift_RM_ADDRESS2 XPAR_PRC_0_BASEADDR+0X00190
#define rp_shift_RM_CONTROL2 XPAR_PRC_0_BASEADDR+0X00194
#define rp_shift_RM_ADDRESS3 XPAR_PRC_0_BASEADDR+0X00198
#define rp_shift_RM_CONTROL3 XPAR_PRC_0_BASEADDR+0X0019C

//| rp_shift               | BS_ID1       | 0X001D0 |
//| rp_shift               | BS_ID2       | 0X001E0 |
//| rp_shift               | BS_ID2       | 0X001E0 |
//| rp_shift               | BS_ID3       | 0X001F0 |

#define rp_shift_BS_ADDRESS0 XPAR_PRC_0_BASEADDR+0X001C4
#define rp_shift_BS_SIZE0    XPAR_PRC_0_BASEADDR+0X001C8
#define rp_shift_BS_ADDRESS1 XPAR_PRC_0_BASEADDR+0X001D4
#define rp_shift_BS_SIZE1    XPAR_PRC_0_BASEADDR+0X001D8
#define rp_shift_BS_ADDRESS2 XPAR_PRC_0_BASEADDR+0X001E4
#define rp_shift_BS_SIZE2    XPAR_PRC_0_BASEADDR+0X001E8
#define rp_shift_BS_ADDRESS3 XPAR_PRC_0_BASEADDR+0X001F4
#define rp_shift_BS_SIZE3    XPAR_PRC_0_BASEADDR+0X001F8
// Read function for STDIN
extern char inbyte(void);

static FATFS fatfs;

// Driver Instantiations
static XDcfg_Config *XDcfg_0;
XDcfg DcfgInstance;
XDcfg *DcfgInstPtr;

int SD_Init()
{
	FRESULT rc;

	rc = f_mount(&fatfs, "", 0);
	if (rc) {
		xil_printf(" ERROR : f_mount returned %d\r\n", rc);
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}

int SD_TransferPartial(char *FileName, u32 DestinationAddress, u32 ByteLength)
{
	FIL fil;
	FRESULT rc;
	UINT br;

	rc = f_open(&fil, FileName, FA_READ);
	if (rc) {
		xil_printf(" ERROR : f_open returned %d\r\n", rc);
		return XST_FAILURE;
	}

	rc = f_lseek(&fil, 0);
	if (rc) {
		xil_printf(" ERROR : f_lseek returned %d\r\n", rc);
		return XST_FAILURE;
	}

	rc = f_read(&fil, (void*) DestinationAddress, ByteLength, &br);
	if (rc) {
		xil_printf(" ERROR : f_read returned %d\r\n", rc);
		return XST_FAILURE;
	}

	rc = f_close(&fil);
	if (rc) {
		xil_printf(" ERROR : f_close returned %d\r\n", rc);
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}

int getNumber (){

	unsigned char byte;
	unsigned char uartBuffer[16];
	unsigned char validNumber;
	int digitIndex;
	int digit, number, sign;
	int c;

	while(1){
		byte = 0x00;
		digit = 0;
		digitIndex = 0;
		number = 0;
		validNumber = TRUE;

		//get bytes from uart until RETURN is entered

		while(byte != 0x0d){
			byte = inbyte();
			uartBuffer[digitIndex] = byte;
			xil_printf("%c", byte);
			digitIndex++;
		}

		//calculate number from string of digits

		for(c = 0; c < (digitIndex - 1); c++){
			if(c == 0){
				//check if first byte is a "-"
				if(uartBuffer[c] == 0x2D){
					sign = -1;
					digit = 0;
				}
				//check if first byte is a digit
				else if((uartBuffer[c] >> 4) == 0x03){
					sign = 1;
					digit = (uartBuffer[c] & 0x0F);
				}
				else
					validNumber = FALSE;
			}
			else{
				//check byte is a digit
				if((uartBuffer[c] >> 4) == 0x03){
					digit = (uartBuffer[c] & 0x0F);
				}
				else
					validNumber = FALSE;
			}
			number = (number * 10) + digit;
		}
		number *= sign;
		if(validNumber == TRUE){
			return number;
		}
		print("This is not a valid number.\n\r");
	}
}

void get_operands(void)
{
	int first, second, result;

	print("First operand: ");
	first = getNumber();
	print("\r\n");
	print("Second operand: ");
	second = getNumber();
	print("\r\n");
	Xil_Out32(XPAR_MATH_0_S_AXI_BASEADDR,first);
	Xil_Out32(XPAR_MATH_0_S_AXI_BASEADDR+4,second);
	result=Xil_In32(XPAR_MATH_0_S_AXI_BASEADDR+8);
	xil_printf("Result: %d\n\r",result);
}

int main()
{
	int Status;
	int loading_done=0;

	// Flush and disable Data Cache
	Xil_DCacheDisable();

    // Initialize SD controller and transfer partials to DDR
	SD_Init();
	SD_TransferPartial("mult.bin", PARTIAL_MULT_ADDR, (PARTIAL_MULT_BITFILE_LEN << 2));
	SD_TransferPartial("add.bin", PARTIAL_ADDER_ADDR, (PARTIAL_ADDER_BITFILE_LEN << 2));
	SD_TransferPartial("b_math.bin", PARTIAL_BLANK_MATH_ADDR, (PARTIAL_BLANK_MATH_BITFILE_LEN << 2));
	SD_TransferPartial("b_led.bin", PARTIAL_BLANK_SHIFT_ADDR, (PARTIAL_BLANK_SHIFT_BITFILE_LEN << 2));
	SD_TransferPartial("left.bin", PARTIAL_LEFT_ADDR, (PARTIAL_LEFT_BITFILE_LEN << 2));
	SD_TransferPartial("right.bin", PARTIAL_RIGHT_ADDR, (PARTIAL_RIGHT_BITFILE_LEN << 2));
	xil_printf("Partial Binaries transferred successfully!\r\n");

	// Invalidate and enable Data Cache
	Xil_DCacheEnable();

	// Initialize Device Configuration Interface
	DcfgInstPtr = &DcfgInstance;
	XDcfg_0 = XDcfg_LookupConfig(XPAR_XDCFG_0_DEVICE_ID) ;
	Status =  XDcfg_CfgInitialize(DcfgInstPtr, XDcfg_0, XDcfg_0->BaseAddr);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	// De-select PCAP as the configuration device as we are going to use the ICAP
	XDcfg_ClearControlRegister(DcfgInstPtr, XDCFG_CTRL_PCAP_PR_MASK | XDCFG_CTRL_PCAP_MODE_MASK);

	// Display PRC status
	print("Putting the PRC core's Math RP in Shutdown mode\n\r");
	Xil_Out32(rp_math_CONTROL,0);
	print("Waiting for the shutdown to occur\r\n");
	while(!(Xil_In32(rp_math_STATUS)&0x80));
	print("Math RP is shutdown\r\n");
	print("Putting the PRC core's SHIFT RP in Shutdown mode\n\r");
	Xil_Out32(rp_shift_CONTROL,0);
	print("Waiting for the shutdown to occur\r\n");
	while(!(Xil_In32(rp_shift_STATUS)&0x80));
	print("Shift RP is shutdown\r\n");
	print("Initializing RM bitstream address and size registers for Math and Shift RMs\r\n");
	Xil_Out32(rp_math_BS_ADDRESS0,PARTIAL_ADDER_ADDR);
	Xil_Out32(rp_math_BS_ADDRESS1,PARTIAL_MULT_ADDR);
	Xil_Out32(rp_math_BS_ADDRESS2,PARTIAL_BLANK_MATH_ADDR);
	Xil_Out32(rp_math_BS_SIZE0,PARTIAL_ADDER_BITFILE_LEN<<2);
	Xil_Out32(rp_math_BS_SIZE1,PARTIAL_MULT_BITFILE_LEN<<2);
	Xil_Out32(rp_math_BS_SIZE2,PARTIAL_BLANK_MATH_BITFILE_LEN<<2);

	Xil_Out32(rp_shift_BS_ADDRESS0,PARTIAL_LEFT_ADDR);
	Xil_Out32(rp_shift_BS_ADDRESS1,PARTIAL_RIGHT_ADDR);
	Xil_Out32(rp_shift_BS_ADDRESS2,PARTIAL_BLANK_SHIFT_ADDR);
	Xil_Out32(rp_shift_BS_SIZE0,PARTIAL_LEFT_BITFILE_LEN<<2);
	Xil_Out32(rp_shift_BS_SIZE1,PARTIAL_RIGHT_BITFILE_LEN<<2);
	Xil_Out32(rp_shift_BS_SIZE2,PARTIAL_BLANK_SHIFT_BITFILE_LEN<<2);

	print("Initializing RM trigger ID registers for Math and Shift RMs\r\n");
	Xil_Out32(rp_math_TRIGGER0,0);
	Xil_Out32(rp_math_TRIGGER1,1);
	Xil_Out32(rp_math_TRIGGER2,2);
	Xil_Out32(rp_shift_TRIGGER0,0);
	Xil_Out32(rp_shift_TRIGGER1,1);
	Xil_Out32(rp_shift_TRIGGER2,2);

	print("Initializing RM address and control registers for Math and Shift RMs\r\n");
	Xil_Out32(rp_math_RM_ADDRESS0,0);
	Xil_Out32(rp_math_RM_ADDRESS1,1);
	Xil_Out32(rp_math_RM_ADDRESS2,2);
	Xil_Out32(rp_math_RM_CONTROL0,0);
	Xil_Out32(rp_math_RM_CONTROL1,0);
	Xil_Out32(rp_math_RM_CONTROL2,0);

	Xil_Out32(rp_shift_RM_ADDRESS0,0);
	Xil_Out32(rp_shift_RM_ADDRESS1,1);
	Xil_Out32(rp_shift_RM_ADDRESS2,2);
	Xil_Out32(rp_shift_RM_CONTROL0,0);
	Xil_Out32(rp_shift_RM_CONTROL1,0);
	Xil_Out32(rp_shift_RM_CONTROL2,0);

	print("Reading RM bitstreams address and size registers for Math and Shift RMs\r\n");
	xil_printf("Adder RM address = %x\r\n",Xil_In32(rp_math_BS_ADDRESS0));
	xil_printf("Mult RM address = %x\r\n",Xil_In32(rp_math_BS_ADDRESS1));
	xil_printf("Math Blank RM address = %x\r\n",Xil_In32(rp_math_BS_ADDRESS2));
	xil_printf("Adder RM size = %x\r\n",Xil_In32(rp_math_BS_SIZE0));
	xil_printf("Mult RM size = %x\r\n",Xil_In32(rp_math_BS_SIZE1));
	xil_printf("Math Blank RM size = %x\r\n",Xil_In32(rp_math_BS_SIZE2));

	xil_printf("Left Shift RM address = %x\r\n",Xil_In32(rp_shift_BS_ADDRESS0));
	xil_printf("Right Shift RM address = %x\r\n",Xil_In32(rp_shift_BS_ADDRESS1));
	xil_printf("Shift Blank RM address = %x\r\n",Xil_In32(rp_shift_BS_ADDRESS2));
	xil_printf("Left Shift RM size = %x\r\n",Xil_In32(rp_shift_BS_SIZE0));
	xil_printf("Right Shift RM size = %x\r\n",Xil_In32(rp_shift_BS_SIZE1));
	xil_printf("Shift Blank RM size = %x\r\n",Xil_In32(rp_shift_BS_SIZE2));

	print("Reading RM Trigger and address registers for Math and Shift RMs\r\n");
	xil_printf("Adder RM Trigger0 = %x\r\n",Xil_In32(rp_math_TRIGGER0));
	xil_printf("Mult RM Trigger1 = %x\r\n",Xil_In32(rp_math_TRIGGER1));
	xil_printf("Math Blank RM Trigger2 = %x\r\n",Xil_In32(rp_math_TRIGGER2));
	xil_printf("Adder RM Address0 = %x\r\n",Xil_In32(rp_math_RM_ADDRESS0));
	xil_printf("Mult RM Address1 = %x\r\n",Xil_In32(rp_math_RM_ADDRESS1));
	xil_printf("Math Blank RM Address2 = %x\r\n",Xil_In32(rp_math_RM_ADDRESS2));

	xil_printf("Left RM Trigger0 = %x\r\n",Xil_In32(rp_shift_TRIGGER0));
	xil_printf("RIght RM Trigger1 = %x\r\n",Xil_In32(rp_shift_TRIGGER1));
	xil_printf("Shift Blank RM Trigger2 = %x\r\n",Xil_In32(rp_shift_TRIGGER2));
	xil_printf("Left RM Address0 = %x\r\n",Xil_In32(rp_shift_RM_ADDRESS0));
	xil_printf("Right RM Address1 = %x\r\n",Xil_In32(rp_shift_RM_ADDRESS1));
	xil_printf("Shift Blank RM Address2 = %x\r\n",Xil_In32(rp_shift_RM_ADDRESS2));
	print("Putting the PRC core's Math RP in Restart with Status mode\n\r");
	Xil_Out32(rp_math_CONTROL,2);
	print("Putting the PRC core's SHIFT RP in Restart with Status mode\n\r");
	Xil_Out32(rp_shift_CONTROL,2);
	xil_printf("Reading the Math RP status=%x\n\r",Xil_In32(rp_math_STATUS));
	xil_printf("Reading the SHIFT RP status=%x\n\r",Xil_In32(rp_shift_STATUS));

	// Display Menu
    int Exit = 0;
    int OptionNext = 1; // start-up default
	while(Exit != 1) {
		do {
			print("    1: Multiplier\n\r");
			print("    2: Adder\n\r");
			print("    3: Blank Math\n\r");
			print("    4: Blank LED\n\r");
			print("    5: Left Shift\n\r");
			print("    6: Right Shift\n\r");
			print("    7: Enter operands\n\r");
			print("    0: Exit\n\r");
			print("> ");

			OptionNext = inbyte();
			if (isalpha(OptionNext)) {
				OptionNext = toupper(OptionNext);
			}

			xil_printf("%c\n\r", OptionNext);
		} while (!isdigit(OptionNext));

		switch (OptionNext) {
			case '0':
				Exit = 1;
				break;
			case '1':
				xil_printf("Generating software trigger for Multiplication reconfiguration\r\n");
				Status=Xil_In32(rp_math_SW_TRIGGER);
				if(!(Status&0x8000)) {
					xil_printf("Starting Multiplication Reconfiguration\n\r");
					Xil_Out32(rp_math_SW_TRIGGER,1);
				}
				loading_done = 0;
				while(!loading_done) {
					Status=Xil_In32(rp_math_STATUS)&0x07;
					switch(Status) {
						case 7 : print("RM loaded\r\n"); loading_done=1; break;
						case 6 : print("RM is being reset\r\n"); break;
						case 5 : print("Software start-up step\r\n"); break;
						case 4 : print("Loading new RM\r\n"); break;
						case 2 : print("Software shutdown\r\n"); break;
						case 1 : print("Hardware shutdown\r\n"); break;
					}
				}
				xil_printf("Multiplication Reconfiguration Completed!\n\r");
				break;
			case '2':
				xil_printf("Generating software trigger for Addition reconfiguration\r\n");
				Status=Xil_In32(rp_math_SW_TRIGGER);
				if(!(Status&0x8000)) {
					xil_printf("Starting Addition Reconfiguration\n\r");
					Xil_Out32(rp_math_SW_TRIGGER,0);
				}
				loading_done = 0;
				while(!loading_done) {
					Status=Xil_In32(rp_math_STATUS)&0x07;
					switch(Status) {
						case 7 : print("RM loaded\r\n"); loading_done=1; break;
						case 6 : print("RM is being reset\r\n"); break;
						case 5 : print("Software start-up step\r\n"); break;
						case 4 : print("Loading new RM\r\n"); break;
						case 2 : print("Software shutdown\r\n"); break;
						case 1 : print("Hardware shutdown\r\n"); break;
					}
				}
				xil_printf("Addition Reconfiguration Completed!\n\r");
				break;
			case '3':
				xil_printf("Generating software trigger for Math Blanking reconfiguration\r\n");
				Status=Xil_In32(rp_math_SW_TRIGGER);
				if(!(Status&0x8000)) {
					xil_printf("Starting Math Blanking Reconfiguration\n\r");
					Xil_Out32(rp_math_SW_TRIGGER,2);
				}
				loading_done = 0;
				while(!loading_done) {
					Status=Xil_In32(rp_math_STATUS)&0x07;
					switch(Status) {
						case 7 : print("RM loaded\r\n"); loading_done=1; break;
						case 6 : print("RM is being reset\r\n"); break;
						case 5 : print("Software start-up step\r\n"); break;
						case 4 : print("Loading new RM\r\n"); break;
						case 2 : print("Software shutdown\r\n"); break;
						case 1 : print("Hardware shutdown\r\n"); break;
					}
				}
				xil_printf("Blanking Math module Reconfiguration Completed!\n\r");
				break;
			case '4':
				xil_printf("Generating software trigger for LED Blanking reconfiguration\r\n");
				Status=Xil_In32(rp_shift_SW_TRIGGER);
				if(!(Status&0x8000)) {
					xil_printf("Starting LED Blanking Reconfiguration\n\r");
					Xil_Out32(rp_shift_SW_TRIGGER,2);
				}
				loading_done=0;
				while(!loading_done) {
					Status=Xil_In32(rp_shift_STATUS);
					xil_printf("Status=%x\r\n",Status);
					switch(Status&0x07) {
						case 7 : print("RM loaded\r\n"); loading_done=1; break;
						case 6 : print("RM is being reset\r\n"); break;
						case 5 : print("Software start-up step\r\n"); break;
						case 4 : print("Loading new RM\r\n"); break;
						case 2 : print("Software shutdown\r\n"); break;
						case 1 : print("Hardware shutdown\r\n"); break;
					}
				}
				xil_printf("Blanking LED module Reconfiguration Completed!\n\r");
				break;
			case '5':
				xil_printf("Generating software trigger for LED shift left reconfiguration\r\n");
				Status=Xil_In32(rp_shift_SW_TRIGGER);
				if(!(Status&0x8000)) {
					xil_printf("Starting LED shift left Reconfiguration\n\r");
					Xil_Out32(rp_shift_SW_TRIGGER,0);
				}
				loading_done=0;
				while(!loading_done) {
					Status=Xil_In32(rp_shift_STATUS);
					xil_printf("Status=%x\r\n",Status);
					switch(Status&0x07) {
						case 7 : print("RM loaded\r\n"); loading_done=1; break;
						case 6 : print("RM is being reset\r\n"); break;
						case 5 : print("Software start-up step\r\n"); break;
						case 4 : print("Loading new RM\r\n"); break;
						case 2 : print("Software shutdown\r\n"); break;
						case 1 : print("Hardware shutdown\r\n"); break;
					}
				}
				xil_printf("Shift left Reconfiguration Completed!\n\r");
				break;
			case '6':
				xil_printf("Generating software trigger for LED shift right reconfiguration\r\n");
				Status=Xil_In32(rp_shift_SW_TRIGGER);
				if(!(Status&0x8000)) {
					xil_printf("Starting LED shift right Reconfiguration\n\r");
					Xil_Out32(rp_shift_SW_TRIGGER,1);
				}
				loading_done=0;
				while(!loading_done) {
					Status=Xil_In32(rp_shift_STATUS);
					xil_printf("Status=%x\r\n",Status);
					switch(Status&0x07) {
						case 7 : print("RM loaded\r\n"); loading_done=1; break;
						case 6 : print("RM is being reset\r\n"); break;
						case 5 : print("Software start-up step\r\n"); break;
						case 4 : print("Loading new RM\r\n"); break;
						case 2 : print("Software shutdown\r\n"); break;
						case 1 : print("Hardware shutdown\r\n"); break;
					}
				}
				xil_printf("Right shifting LED module Reconfiguration Completed!\n\r");
				break;
			case '7':
				get_operands();
				break;
			default:
				break;
		}
	}

    return 0;
}
