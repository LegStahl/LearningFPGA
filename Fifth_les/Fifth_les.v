module Fifth_les(
	output reg [2:0] leds,
	input [3:0] buttons
);
	
	reg [7:0] data_in;
	wire [2:0] wire_leds;
	counter r(.data_in(data_in), .count(wire_leds));
	
	always @(*) begin
			leds = wire_leds;
			if(buttons == 4'd1) begin
			
				data_in = 8'd5;
			end
			else if (buttons == 4'd2) begin
			
				data_in = 8'd7;
			end
			else if (buttons == 4'd3) begin
			
				data_in = 8'd15;
			end
			else begin
				data_in = 8'd0;;
			end
	end


endmodule
