`timescale 1ps/1ps
module counter_vlg_tst();
	reg [7:0] data;
	wire [3:0] out_d;
	range_analyzer check(.data_in(data), .range_code(out_d));
	
	initial
	begin
		data = 0'd5;
	end
	
	$display("Running test");
	
	always
		#5 data = data + 1;


endmodule
