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
#include "xhwicap.h"
#include "xil_io.h"
#include "xil_types.h"


// Parameters for Partial Reconfiguration
#ifdef ZED
#define PARTIAL_MULT_ADDR   0x200000
#define PARTIAL_ADDER_ADDR   0x300000
#define PARTIAL_BLANK_ADDR   0x400000
#define PARTIAL_MULT_BITFILE_LEN  0xC66F // in number of words
#define PARTIAL_ADDER_BITFILE_LEN  0xC66F // in number of words
#define PARTIAL_BLANK_BITFILE_LEN  0xC66F // in number of words
#endif

#ifdef ZYBO
#define PARTIAL_MULT_ADDR   0x200000
#define PARTIAL_ADDER_ADDR   0x300000
#define PARTIAL_BLANK_ADDR   0x400000
#define PARTIAL_MULT_BITFILE_LEN  0x9A3F // in number of words
#define PARTIAL_ADDER_BITFILE_LEN  0x9A3F // in number of words
#define PARTIAL_BLANK_BITFILE_LEN  0x9A3F // in number of words
#endif

// Turn on/off Debug messages
#ifdef DEBUG_PRINT
#define  debug_printf  xil_printf
#else
#define  debug_printf(msg, args...) do {  } while (0)
#endif


// Read function for STDIN
extern char inbyte(void);

static FATFS fatfs;

// Driver Instantiations
static XDcfg_Config *XDcfg_0;
XDcfg DcfgInstance;
XDcfg *DcfgInstPtr;
static XHwIcap HwIcap;	// The instance of the HWICAP device
XHwIcap *HwIcapInstPtr;

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

int XDcfg_TransferBitfile(XHwIcap *HwIcapInstPtr, u32 *PartialAddress, u32 bitfile_length_words)
{
	u32 Status = 0;

    Status = XHwIcap_DeviceWrite(HwIcapInstPtr, PartialAddress, bitfile_length_words);
    if (Status != XST_SUCCESS)
    {
			/* Error writing to ICAP */
		  xil_printf("error writing to ICAP (%d)\r\n", Status);
       return -1;
    }
    while(XHwIcap_IsDeviceBusy(HwIcapInstPtr));
	return XST_SUCCESS;
}

int main()
{
	u32 PartialAddress;
	int Status;

	XHwIcap_Config *ConfigPtr;

	// Flush and disable Data Cache
	Xil_DCacheDisable();

    // Initialize SD controller and transfer partials to DDR
	SD_Init();
	SD_TransferPartial("mult.bin", PARTIAL_MULT_ADDR, (PARTIAL_MULT_BITFILE_LEN << 2));
	SD_TransferPartial("add.bin", PARTIAL_ADDER_ADDR, (PARTIAL_ADDER_BITFILE_LEN << 2));
	SD_TransferPartial("blank.bin", PARTIAL_BLANK_ADDR, (PARTIAL_BLANK_BITFILE_LEN << 2));
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

	// Deselect PCAP as the configuration device as we are going to use the ICAP
	XDcfg_ClearControlRegister(DcfgInstPtr, XDCFG_CTRL_PCAP_PR_MASK);

	ConfigPtr = XHwIcap_LookupConfig(XPAR_AXI_HWICAP_0_DEVICE_ID);
	if (ConfigPtr == NULL) {
		return XST_FAILURE;
	}

	HwIcapInstPtr = &HwIcap;
	Status = XHwIcap_CfgInitialize(HwIcapInstPtr, ConfigPtr,
				ConfigPtr->BaseAddress);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	XHwIcap_Reset(HwIcapInstPtr);
//	while(!XHwIcap_IsDeviceBusy(HwIcapInstPtr));
	print("HWICAP Initialized\r\n");

	// Display Menu
    int Exit = 0;
    int OptionNext = 1; // start-up default
	while(Exit != 1) {
		do {
			print("    1: Multiplier\n\r");
			print("    2: Adder\n\r");
			print("    3: Blank\n\r");
			print("    4: Enter operands\n\r");
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
				PartialAddress = PARTIAL_MULT_ADDR;
				xil_printf("Starting Multiplication Reconfiguration\n\r");
				Status = XDcfg_TransferBitfile(HwIcapInstPtr, (u32 *)PartialAddress, PARTIAL_MULT_BITFILE_LEN);
			    if (Status != XST_SUCCESS)
			    {
						/* Error writing to ICAP */
					  xil_printf("error writing to ICAP (%d)\r\n", Status);
			       return -1;
			    }

				xil_printf("Multiplication Reconfiguration Completed!\n\r");
				break;
			case '2':
				PartialAddress = PARTIAL_ADDER_ADDR;
				xil_printf("Starting Addition Reconfiguration\n\r");
				Status = XDcfg_TransferBitfile(HwIcapInstPtr, (u32 *)PartialAddress, PARTIAL_ADDER_BITFILE_LEN);
				if (Status != XST_SUCCESS) {
					xil_printf("Error : FPGA configuration failed!\n\r");
					exit(EXIT_FAILURE);
				}
				xil_printf("Addition Reconfiguration Completed!\n\r");
				break;
			case '3':
				PartialAddress = PARTIAL_BLANK_ADDR;
				xil_printf("Starting Blanking Reconfiguration\n\r");
				Status = XDcfg_TransferBitfile(HwIcapInstPtr, (u32 *)PartialAddress, PARTIAL_BLANK_BITFILE_LEN);
				if (Status != XST_SUCCESS) {
					xil_printf("Error : FPGA configuration failed!\n\r");
					exit(EXIT_FAILURE);
				}
				xil_printf("Blanking Reconfiguration Completed!\n\r");
				break;
			case '4':
				get_operands();
				break;
			default:
				break;
		}
	}

    return 0;
}
