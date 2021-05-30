`timescale 1ns / 1ps
module led_control(clk, reset, button_start, button_stop, rst, en );


input clk;
input reset;
input button_start;
input button_stop;
output rst;
output en;

/*
*******************************************
* Signals
*******************************************
*/

reg start;
reg stop;
reg clk_en;
reg [24:0] div_counter;
reg button_en;
wire rst;
wire en;



/*
*******************************************
* Main
*******************************************
*/


assign rst = reset;
assign en = button_en & clk_en;

/* Register the button inputs */
always @(posedge clk)
begin
    if (rst) begin
        start <= 0;
        stop <= 0;
    end else begin
        start <= button_start;
        stop <= button_stop;
    end

end

/* Led Counter enable */
always @(posedge clk)
begin
    if (rst)
        button_en <= 1;
    else
        if (start)
            button_en <= 1;
        else if (stop)
            button_en <= 0;
end

/* Divide the clock to get a slow clock */
always @(posedge clk)
begin
    if (rst) begin
        clk_en <= 0;
        div_counter <= 0;
    end else begin
        div_counter <= div_counter + 1;
        if (div_counter == 0) 
            clk_en <= 1;
        else
            clk_en <= 0;
	end
end

endmodule
