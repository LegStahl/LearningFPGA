module rom_player_top(
	input FPGA_CLK,
	input RESET_N,
	input PLAY_PAUSE_SW,
	output reg [6:0] SEG,
	output reg enable_s
);

	wire gz_1;
	wire [6:0] seg_wires;// провода
	wire [3:0] dig_wires;
	wire enable_s_wires;
	
	reg [2:0] address_counter;
	
	clock_divider clock(.out(gz_1), .reset(RESET_N), .clk(FPGA_CLK));
	
	
	always @(posedge gz_1 or negedge RESET_N)
		begin
			SEG = seg_wires;
			enable_s = enable_s_wires;
			if(~RESET_N)
				begin
					address_counter <= 3'd0;
				end
			
			else if(PLAY_PAUSE_SW)
				begin
					address_counter <= address_counter + 3'd1;
				end
			
		end
		
	
	rom_player_8x4 rom(.clk(gz_1), .addr(address_counter), .data_out(dig_wires));
	decoder dec(.binary_in(dig_wires), .segments(seg_wires), .enable(enable_s_wires));
	

endmodule