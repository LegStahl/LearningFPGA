module rom_player_8x4(
	input clk,
	input [2:0] addr,
	output reg [3:0] data_out
);

   reg [3:0] memory [7:0];

	always @ (posedge clk) 
	
	begin
     
    data_out <= memory[addr];
      
   end
	
	initial begin
	
		$readmemh("rom_init.hex", memory);
		
	end
	
	
endmodule