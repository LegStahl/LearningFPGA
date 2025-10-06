module range_analyzer #(
	parameter WIDTH =8
)(
	input [WIDTH -1 :0] data_in,
	output reg[2:0] range_code

);

	always @(*) begin
		if(data_in < 10) begin
			range_code = ~(3'b001);
		end
		else if(data_in< 50)begin
			range_code = ~(3'b010);
		end
		else if(data_in < 200)begin
			range_code = ~(3'b100);
		end
		else begin 
			range_code = 3'b000;
		end
		
	end

endmodule