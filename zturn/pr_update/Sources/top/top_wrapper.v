`timescale 1 ps / 1 ps

module top_wrapper
(
    button_start, 
    button_stop, 
    led_reset, 
    led, 
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb
 ); 
  inout [53:0]FIXED_IO_mio;
  inout FIXED_IO_ps_clk;
  inout FIXED_IO_ps_porb;
  inout FIXED_IO_ps_srstb;
  input button_start;
  input button_stop;
  input led_reset;
  output [3:0] led;

  wire FCLK_CLK0;
  wire FCLK_RESET0_N;
  wire [53:0]FIXED_IO_mio;
  wire FIXED_IO_ps_clk;
  wire FIXED_IO_ps_porb;
  wire FIXED_IO_ps_srstb;
  wire rx;
  wire tx;
  wire gpio_0_tri_o_0;
  wire gpio_0_tri_t_1;
  wire gpio_0_tri_t_0;

ps7mysystem system_i
       (.FCLK_CLK0(FCLK_CLK0),
        .FCLK_RESET0_N(FCLK_RESET0_N),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
	   .GPIO_0_tri_i({1'b0,tx}),
        .GPIO_0_tri_o({rx,gpio_0_tri_o_0}),
        .GPIO_0_tri_t({gpio_0_tri_t_1,gpio_0_tri_t_0}));

top top_i
        (.clk(FCLK_CLK0), // 100 MHz clock
         .reset(~FCLK_RESET0_N), // Reset when HIGH
         .rx(rx), // to RX module input
         .tx(tx), // from TX module output
         .button_start(button_start),
         .button_stop(button_stop),
         .led_reset(led_reset),
         .led(led)); 
        
endmodule
