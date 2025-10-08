module Seventh_les 
(
	output reg [3:0] led_check,
	input rst,
	input [2:0] buttons,
	input  clk
);


	
   reg [3:0] out_imp;
	wire [3:0] out_wires;
	wire [3:0] out_wires_leds;
	wire [3:0] out_wires_logic;
	wire  success;
	wire  success_long;
	my_logic lo(.led_check(out_wires_leds[2:0]), .success2(success), .rst(~rst), .buttons(out_wires[2:0]), .clk(clk) );
	debounce first(.clk(clk), .reset(~rst), .btn_in(buttons[0]), .btn_out(out_wires[0]));
	debounce second(.clk(clk), .reset(~rst), .btn_in(buttons[1]), .btn_out(out_wires[1]));
	debounce third(.clk(clk), .reset(~rst), .btn_in(buttons[2]), .btn_out(out_wires[2]));

	
	pulse_extender ext1(.clk(clk), .reset(~rst), .pulse_in(success), .pulse_out(success_long));
	
	
	always @(*) begin 
				led_check[3] <= success_long; 
				led_check[2:0] <= out_wires_leds[2:0];
	end




endmodule