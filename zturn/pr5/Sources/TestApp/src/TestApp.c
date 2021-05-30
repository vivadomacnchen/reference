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
#include "xgpio.h"

// Parameters for Partial Reconfiguration
#define PARTIAL_LEFT_ADDR   0x200000
#define PARTIAL_RIGHT_ADDR   0x300000
#define PARTIAL_BLANK_SHIFT_ADDR   0x400000
#define PARTIAL_IDCODE_ADDR   0x500000
#define PARTIAL_CRC_ADDR   0x600000
#define PARTIAL_SYNC_ADDR   0x700000
#if ZED
#define PARTIAL_LEFT_BITFILE_LEN 31707  // in # of words with frame-based CRC
#define PARTIAL_RIGHT_BITFILE_LEN 31707 // in number of words
#define PARTIAL_BLANK_SHIFT_BITFILE_LEN 31707 // in number of words
#define PARTIAL_IDCODE_BITFILE_LEN 31707 // in number of words
#define PARTIAL_CRC_BITFILE_LEN 31707 // in number of words
#define PARTIAL_SYNC_BITFILE_LEN 31707 // in number of words
#endif

#if ZYBO
#define PARTIAL_LEFT_BITFILE_LEN 27679  // in # of words with frame-based CRC
#define PARTIAL_RIGHT_BITFILE_LEN 27679 // in number of words
#define PARTIAL_BLANK_SHIFT_BITFILE_LEN 27679 // in number of words
#define PARTIAL_IDCODE_BITFILE_LEN 27679 // in number of words
#define PARTIAL_CRC_BITFILE_LEN 27679 // in number of words
#define PARTIAL_SYNC_BITFILE_LEN 27679 // in number of words
#endif

// Read function for STDIN
extern char inbyte(void);

static FATFS fatfs;

// Driver Instantiations
static XDcfg_Config *XDcfg_0;
XDcfg DcfgInstance;
XDcfg *DcfgInstPtr;

XGpio gpio_icap_reconfig_done, gpio_icap_go_and_bitlength;
u32 BitstreamLength=0;

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

int mem2Icap(u32* address, u32 bitlength_words)
{
     int i;
     u32 word;
	 u32 baseaddr;

    /* Assign icap_buffer pointer */
	 baseaddr = XPAR_ICAP_INTERFACE_0_S00_AXI_BASEADDR;

	 XGpio_DiscreteWrite(&gpio_icap_go_and_bitlength,2,bitlength_words<<2);  // write bitstream length in words
	 XGpio_DiscreteWrite(&gpio_icap_go_and_bitlength,1,1);  // send icap_go pulse
	 XGpio_DiscreteWrite(&gpio_icap_go_and_bitlength,1,0);


	 for (i=0; i<bitlength_words; i++) {
		  	word = *address++;
		  	Xil_Out32(baseaddr+0, word);  // actual data which also generates a we to icap processor
	 }

	 while(!(XGpio_DiscreteRead(&gpio_icap_reconfig_done,1) & 0x00000001));  // wait for reconfig_done

	return 0;
}

void menu(void)
{
	 print("-- Xilinx Partial Reconfiguration Demo Using Custom ICAP Processor --\r\n");
	 print("      Press l or L for left shifting LED configuration\n\r");
	 print("      Press r or R for right shifting LED  configuration\n\r");
	 print("      Press b or B for blanking configuration\n\r");
	 print("      Press c or C for loading corrupted CRC word configuration\n\r");
	 print("      Press i or I for loading corrupted IDCODE word configuration\n\r");
	 print("      Press s or S for loading corrupted SYNC word configuration\n\r");
	 print("      Press q or Q to quit the demo\n\r");
}

int main()
{
	int Status;
    char key;

	// Flush and disable Data Cache
	Xil_DCacheDisable();

    // Initialize SD controller and transfer partials to DDR
	SD_Init();
	SD_TransferPartial("b_led.bin", PARTIAL_BLANK_SHIFT_ADDR, (PARTIAL_BLANK_SHIFT_BITFILE_LEN << 2));
	SD_TransferPartial("left.bin", PARTIAL_LEFT_ADDR, (PARTIAL_LEFT_BITFILE_LEN << 2));
	SD_TransferPartial("right.bin", PARTIAL_RIGHT_ADDR, (PARTIAL_RIGHT_BITFILE_LEN << 2));
	SD_TransferPartial("sync.bin", PARTIAL_SYNC_ADDR, (PARTIAL_SYNC_BITFILE_LEN << 2));
	SD_TransferPartial("idcode.bin", PARTIAL_IDCODE_ADDR, (PARTIAL_IDCODE_BITFILE_LEN << 2));
	SD_TransferPartial("crc.bin", PARTIAL_CRC_ADDR, (PARTIAL_CRC_BITFILE_LEN << 2));
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

	XGpio_Initialize(&gpio_icap_reconfig_done,XPAR_AXI_GPIO_1_DEVICE_ID);
	XGpio_Initialize(&gpio_icap_go_and_bitlength,XPAR_AXI_GPIO_0_DEVICE_ID);
	XGpio_SetDataDirection(&gpio_icap_reconfig_done,1,1); // input
	XGpio_SetDataDirection(&gpio_icap_go_and_bitlength,1,0x0); // output
	XGpio_SetDataDirection(&gpio_icap_go_and_bitlength,2,0x0); // Output
	XGpio_DiscreteWrite(&gpio_icap_go_and_bitlength,1,0x0);  // set icap_go as 0
	XGpio_DiscreteWrite(&gpio_icap_go_and_bitlength,2,BitstreamLength);	 // set bitstreamlength as 0

	 menu();

   /* Wait for information from UART (keypress). */
   key = inbyte();;

   /* Keep performing user requested function until quit (6) is pressed. */
   while ((key != 'q') && (key != 'Q')) {
       switch (key) {
           case 'l': // Leftshift
           case 'L': // Leftshift
					xil_printf("\r\n      Performing reconfiguration for left shifting LEDs\n\r");
					mem2Icap((u32 *)PARTIAL_LEFT_ADDR,(u32)PARTIAL_LEFT_BITFILE_LEN);
					menu();
					break;
           case 'r': // Rightshift
           case 'R': // Rightshift
					xil_printf("\r\n      Performing reconfiguration for right shifting LEDs\n\r");
					mem2Icap((u32 *)PARTIAL_RIGHT_ADDR,(u32)PARTIAL_RIGHT_BITFILE_LEN);
					menu();
					break;
           case 'b': // Blanking
           case 'B': // Blanking
					xil_printf("\r\n      Performing reconfiguration for Blanking\n\r");
					mem2Icap((u32 *)PARTIAL_BLANK_SHIFT_ADDR,(u32)PARTIAL_BLANK_SHIFT_BITFILE_LEN);
					menu();
					break;
           case 'i': // IDECODE
           case 'I': // IDECODE
					xil_printf("\r\n      Performing reconfiguration with corrupted IDCODE \n\r");
					mem2Icap((u32 *)PARTIAL_IDCODE_ADDR,(u32)PARTIAL_IDCODE_BITFILE_LEN);
					menu();
					break;
           case 'c': // CRC
           case 'C': // CRC
					xil_printf("\r\n      Performing reconfiguration with corrupted CRC \n\r");
					mem2Icap((u32 *)PARTIAL_CRC_ADDR,(u32)PARTIAL_CRC_BITFILE_LEN);
					menu();
					break;
           case 's': // SYNC
           case 'S': // SYNC
					xil_printf("\r\n      Performing reconfiguration with corrupted SYNC\n\r");
					mem2Icap((u32 *)PARTIAL_SYNC_ADDR,(u32)PARTIAL_SYNC_BITFILE_LEN);
					menu();
					break;
           case 'q': // Quit
           case 'Q': // Quit
					break;
           default: // Quit or random data we ignore
					break;
       }
       /* Wait for another keystroke. */
       key = inbyte();
   }

   /* User is done with us... */
   xil_printf("Thank you. \n\r");

    return 0;
}
