module counter #(
	parameter WIDTH = 8
)(
	input [WIDTH-1:0] data_in,
	output reg [3:0] count
);
	integer i = 0;
	always @(*) begin
		
		count = 4'd0;
		for(i =0; i < WIDTH -1; i = i + 1) begin
			if(data_in[i] == 1'b1) begin 
				count = count + 1;
			end
		end
		
	
	
	end
	



endmodule