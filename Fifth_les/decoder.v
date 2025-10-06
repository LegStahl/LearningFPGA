module decoder(
	input [3:0] binary_in,
	output reg [6:0] segments,
	output reg enable
);
	
	
	
	always @(*)begin
		enable = 1;
		case(binary_in)
			(4'd1):begin
				
				segments = 7'b1111101 & 7'b1111011;
				enable = 0;
			end
			(4'd2):begin
				segments = 7'b1111110 & 7'b1111101 & 7'b0111111 & 7'b1101111 & 7'b1110111;
				enable = 0;
			end
			(4'd3):begin	
				segments = 7'b1111110 & 7'b1111101 & 7'b0111111 & 7'b1111011 & 7'b1110111 ;
				enable = 0;
			end
			(4'd4):begin
				segments = 7'b1011111 & 7'b0111111 & 7'b1111101 &  7'b1111011;
				enable = 0;
			end
			(4'd5):begin
				segments = 7'b1111110 & 7'b1011111 & 7'b0111111 & 7'b1111011 & 7'b1110111;
				enable = 0;
			end
			(4'd6):begin
				segments =  7'b1111110 & 7'b1011111 & 7'b0111111 & 7'b1101111 & 7'b1111011 & 7'b1110111;
				enable = 0;
			end
			(4'd7):begin
				segments = 7'b1111110 & 7'b1111101 & 7'b1111011;
				enable = 0;
			end
			(4'd8):begin
				segments =  7'b1111110 & 7'b1011111 & 7'b0111111 & 7'b1101111 & 7'b1111011 & 7'b1110111 & 7'b1111101;
				enable = 0;
			end
			(4'd9):begin
				segments =  7'b1111110 & 7'b1011111 & 7'b0111111  & 7'b1111011 & 7'b1110111 & 7'b1111101;
				enable = 0;
			end
			(4'd0):begin
				//segments = 7'd0;
			end
			default:begin
			
			end
		endcase
	
	end


endmodule