
module Blink( 
input wire clk, 
output reg led
);

	reg[15:0] counter = 0;

	always @(posedge clk) begin
		counter <= counter + 1;
		if(counter == 15'd0)
			led = ~led;
	end
endmodule