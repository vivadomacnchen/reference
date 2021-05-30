//Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2014.3 (win64) Build 1034051 Fri Oct  3 17:14:12 MDT 2014
//Date        : Tue Nov 04 12:40:18 2014
//Host        : XSJPARIMALP30 running 64-bit Service Pack 1  (build 7601)
//Command     : generate_target system_wrapper.bd
//Design      : system_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module top
   (DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
    led,
    button_u,   // stop button
    button_d);  // start button
  inout [14:0]DDR_addr;
  inout [2:0]DDR_ba;
  inout DDR_cas_n;
  inout DDR_ck_n;
  inout DDR_ck_p;
  inout DDR_cke;
  inout DDR_cs_n;
  inout [3:0]DDR_dm;
  inout [31:0]DDR_dq;
  inout [3:0]DDR_dqs_n;
  inout [3:0]DDR_dqs_p;
  inout DDR_odt;
  inout DDR_ras_n;
  inout DDR_reset_n;
  inout DDR_we_n;
  inout FIXED_IO_ddr_vrn;
  inout FIXED_IO_ddr_vrp;
  inout [53:0]FIXED_IO_mio;
  inout FIXED_IO_ps_clk;
  inout FIXED_IO_ps_porb;
  inout FIXED_IO_ps_srstb;
  input button_u;
  input button_d;
  output [3:0] led;

  wire [14:0]DDR_addr;
  wire [2:0]DDR_ba;
  wire DDR_cas_n;
  wire DDR_ck_n;
  wire DDR_ck_p;
  wire DDR_cke;
  wire DDR_cs_n;
  wire [3:0]DDR_dm;
  wire [31:0]DDR_dq;
  wire [3:0]DDR_dqs_n;
  wire [3:0]DDR_dqs_p;
  wire DDR_odt;
  wire DDR_ras_n;
  wire DDR_reset_n;
  wire DDR_we_n;
  wire FIXED_IO_ddr_vrn;
  wire FIXED_IO_ddr_vrp;
  wire [53:0]FIXED_IO_mio;
  wire FIXED_IO_ps_clk;
  wire FIXED_IO_ps_porb;
  wire FIXED_IO_ps_srstb;
  wire FCLK_CLK0;
  wire RP_reset;
  wire led_shift_en;
  wire led_rst;
  wire ICAP_CE_n;
  wire [31:0] Data2ICAP_processor; // output written into fifo
  wire [31:0] ICAP_dataout; // output of ICAP
  wire [31:0] bitreverseddata2ICAP; // input to ICAP
  wire [31:0] bitstreamlength; // number of words of partial bitstream
  wire empty; // fifo empty
  wire full; // fifo full
  wire icap_go; // start icap processor
  wire reconfig_done; // reconfiguration done
  wire we_en; // writing data to fifo
  wire rd_en; // reading fifo

system system_i
       (.DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .Data2ICAP_processor(Data2ICAP_processor),
        .FCLK_CLK0(FCLK_CLK0),
        .RP_enable(RP_enable),
        .RP_reset(RP_reset),
        .ICAP_CE_n(ICAP_CE_n),
        .ICAP_dataout(ICAP_dataout),
        .bitreverseddata2ICAP(bitreverseddata2ICAP),
        .bitstreamlength(bitstreamlength),
        .empty(empty),
        .full(full),
        .icap_go(icap_go),
        .reconfig_done(reconfig_done),
        .we_en(we_en),
        .rd_en(rd_en)
);        

ila_0 ila_inst (
	.clk(FCLK_CLK0), // input wire clk
	.probe0(Data2ICAP_processor), // input wire [31:0]  probe0  
	.probe1(ICAP_dataout), // input wire [31:0]  probe1 
	.probe2(bitreverseddata2ICAP), // input wire [31:0]  probe2 
	.probe3(bitstreamlength), // input wire [31:0]  probe3 
	.probe4(ICAP_CE_n), // input wire [0:0]  probe4 
	.probe5(RP_enable), // input wire [0:0]  probe5 
	.probe6(RP_reset), // input wire [0:0]  probe6 
	.probe7(empty), // input wire [0:0]  probe7 
	.probe8(full), // input wire [0:0]  probe8 
	.probe9(icap_go), // input wire [0:0]  probe9 
	.probe10(reconfig_done), // input wire [0:0]  probe10
	.probe11(we_en), // input wire [0:0]  probe11
	.probe12(rd_en) // input wire [0:0]  probe12
);     
led_control led_control_inst
    (
      .clk(FCLK_CLK0), 
      .reset(RP_reset), 
      .button_start(button_d), 
      .button_stop(button_u), 
      .rst(led_rst), 
      .en(led_shift_en)
      );

rModule_leds reconfig_leds
    (
      .clk(FCLK_CLK0), 
      .reset(led_rst),
      .en(led_shift_en),
      .led(led)
    );
        
endmodule
