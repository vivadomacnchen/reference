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
    SW0,    // for start shifting
    SW1,    // for stop shifting
    led,
    button_r,   // mult_trigger
    button_l,   // add_trigger - tigger 0
//    button_c,   // reset  PS side BTN4 is used
    button_u,   // left_shift_trigger - trigger 0
    button_d);  // right_shift_trigger
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
  input button_r;
  input button_l;
 // input button_c;  PS side BTN4 is used
  input button_u;
  input button_d;
  input SW0; 
  input SW1; 
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
  wire FCLK_RESET0_N;
  wire [0:0] GPIO_O;
  wire ICAP_csib;
  wire [31:0]icap_i;
  wire [31:0]icap_o;
  wire ICAP_rdwrb;
  wire [2:0]vsm_rp_math_hw_triggers;
  wire [2:0]vsm_rp_shift_hw_triggers;
  wire led_rst; 
  wire led_shift_en;

system_wrapper system_wrapper_i
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
        .FCLK_CLK0(FCLK_CLK0),
        .FCLK_RESET0_N(FCLK_RESET0_N),
	.GPIO_O(GPIO_O),
        .icap_clk(FCLK_CLK0),
        .ICAP_csib(ICAP_csib),
        .icap_i(icap_i),
        .icap_o(icap_o),
        .ICAP_rdwrb(ICAP_rdwrb),
        .icap_reset(FCLK_RESET0_N),
        .vsm_rp_math_hw_triggers(vsm_rp_math_hw_triggers),
        .vsm_rp_shift_hw_triggers(vsm_rp_shift_hw_triggers)
        );

meta_harden meta_harden_math_hw_trigger_0 (
        .clk_dst(FCLK_CLK0),
        .rst_dst(~FCLK_RESET0_N),
        .signal_src(button_l),
        .signal_dst(vsm_rp_math_hw_triggers[0]));

meta_harden meta_harden_math_hw_trigger_1 (
        .clk_dst(FCLK_CLK0),
        .rst_dst(~FCLK_RESET0_N),
        .signal_src(button_r),
        .signal_dst(vsm_rp_math_hw_triggers[1]));

meta_harden meta_harden_math_hw_trigger_2 (
        .clk_dst(FCLK_CLK0),
        .rst_dst(~FCLK_RESET0_N),
        .signal_src(GPIO_O),
        .signal_dst(vsm_rp_math_hw_triggers[2]));
        
meta_harden meta_harden_shift_hw_trigger_0 (
        .clk_dst(FCLK_CLK0),
        .rst_dst(~FCLK_RESET0_N),
        .signal_src(button_u),
        .signal_dst(vsm_rp_shift_hw_triggers[0]));

meta_harden meta_harden_shift_hw_trigger_1 (
        .clk_dst(FCLK_CLK0),
        .rst_dst(~FCLK_RESET0_N),
        .signal_src(button_d),
        .signal_dst(vsm_rp_shift_hw_triggers[1]));

meta_harden meta_harden_shift_hw_trigger_2 (
        .clk_dst(FCLK_CLK0),
        .rst_dst(~FCLK_RESET0_N),
        .signal_src(GPIO_O),
        .signal_dst(vsm_rp_shift_hw_triggers[2]));

// Instantiate ICAP primitive
ICAPE2 
    # (
      .DEVICE_ID(32'h23727093), // Device ID code for 7z010 of Zybo
      .ICAP_WIDTH(32)   // Specifies the input and output data width to be used with the ICAPE2.
    )
    ICAPE2_inst (
      .O(icap_o), // 32-bit output: Configuration data output bus
      .CLK(FCLK_CLK0), // 1-bit input: Clock Input
      .CSIB(ICAP_csib), // 1-bit input: Active-Low ICAP Enable
      .I(icap_i),    // 32-bit input: Configuration data input bus
      .RDWRB(ICAP_rdwrb) // 1-bit input: Read/Write Select input
  );

led_control led_control_inst
    (
      .clk(FCLK_CLK0), 
      .reset(button_c), 
      .button_start(SW0), 
      .button_stop(SW1), 
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
