module Sixth_les(
	input enable,
	input clk1,
	input rst,
	input up_down,
	output reg [7:0] seg,
	output reg[3:0] count_out
	
);
	wire out1;
	//reg [3:0] count_out;
	wire [3:0]wire_count;
	wire [7:0]wire_seg;
	clock_divider r(.out(out1), .reset(rst), .clk(clk1));
	decoder dec(.binary_in(count_out), .segments(wire_seg[6:0]), .enable(wire_seg[7]));
	integer check = 0;
	
	always @(posedge clk1)begin
		//seg[7] = 1;
		//count_out = wire_count;
		seg = wire_seg;
		
	   if(enable == 1) begin
			if(up_down == 1 && out1 == 1)begin 
				
				count_out = count_out + 1; 
			end
			if(up_down == 0 && out1 == 1)begin 
				
				count_out = count_out - 1; 
			end
			if(rst == 1'd0) begin
				count_out = 4'd0;
			end
		end
		else begin 
			seg[7] = 1;
		end
		
	end
	





endmodule
