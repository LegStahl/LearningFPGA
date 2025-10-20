
module clock_divider #(parameter MAX_1 = 50000000)
(
	output  out,
	input reset,
	input clk
	

);
	
	 
	integer i = 0;
	assign out = (i == MAX_1 - 1);
	always @(posedge clk) begin
		i = i + 1;
		if(reset == 1'd0 || i == MAX_1) begin 
			i <= 0;
		end
		
	end


endmodule