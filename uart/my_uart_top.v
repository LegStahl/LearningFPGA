




module my_uart_top(
				input clk, 
				input rst_n,
				input rs232_rx,
				output rs232_tx,
				output reg [3:0]leds,
				output [9:0] segments
				);


	//integer state;
	wire bps_start1,bps_start2;//	
	wire clk_bps1,clk_bps2;//		
	wire[7:0] rx_data;//	
	wire rx_int;//		
	wire rx_int_2;
	reg [7:0] first_deg;
	reg [7:0] second_deg;
	reg [7:0] third_deg;
	reg [9:0] first_operand;
	reg [9:0] second_operand;
	reg [9:0] summ;
	reg [3:0] summ_to_show [0:2];
	reg rx_reg_int;
	speed_select		speed_rx(	
								.clk(clk),	//������ѡ��ģ��
								.rst_n(rst_n),
								.bps_start(bps_start1),
								.clk_bps(clk_bps1)
							);

	my_uart_rx			my_uart_rx(		
								.clk(clk),	//��������ģ��
								.rst_n(rst_n),
								.rs232_rx(rs232_rx),
								.rx_data(rx_data),
								.rx_int(rx_int),
								.clk_bps(clk_bps1),
								.bps_start(bps_start1)
							);

	///////////////////////////////////////////						
	speed_select		speed_tx(	
								.clk(clk),	//������ѡ��ģ��
								.rst_n(rst_n),
								.bps_start(bps_start2),
								.clk_bps(clk_bps2)
							);

	my_uart_tx			my_uart_tx(		
								.clk(clk),	//��������ģ��
								.rst_n(rst_n),
								.rx_data(rx_data),
								.rx_int(rx_int),
								.rs232_tx(rs232_tx),
								.clk_bps(clk_bps2),
								.bps_start(bps_start2)
							);
							
	decoder dec(.binary_in(summ_to_show[0]), .segments(segments[6:0]), .enable(segments[7]));
							
	//assign leds = rx_data[3:0];

reg [31:0] state;
reg rx_int_d;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 0;
        first_operand <= 0;
        second_operand <= 0;
        summ <= 0;
        leds <= 0;
        rx_int_d <= 0;
    end else begin
        rx_int_d <= rx_int;
        // Детект положительного фронта rx_int
        if (rx_int & ~rx_int_d) begin
            leds <= state[3:0];  // визуализация состояния
            case (state)
                0: begin first_deg <= rx_data - 8'd48; state <= 1; end
                1: begin second_deg <= rx_data - 8'd48; state <= 2; end
                2: begin third_deg <= rx_data - 8'd48; state <= 3; end
                3: begin
                    if (rx_data == 8'd101) begin
                        first_operand <= first_deg*100 + second_deg*10 + third_deg;
                        state <= 4;
                    end else state <= 0;
                end
                4: begin first_deg <= rx_data - 8'd48; state <= 5; end
                5: begin second_deg <= rx_data - 8'd48; state <= 6; end
                6: begin third_deg <= rx_data - 8'd48; state <= 7; end
                7: begin
                    if (rx_data == 8'd101) begin
                        second_operand <= first_deg*100 + second_deg*10 + third_deg;
                        summ <= first_operand + second_operand;
                        summ_to_show[0] <= (first_operand + second_operand) % 10;
                        summ_to_show[1] <= ((first_operand + second_operand)/10) % 10;
                        summ_to_show[2] <= ((first_operand + second_operand)/100) % 10;
                        state <= 0;
                    end else state <= 0;
                end
            endcase
        end
    end
end



endmodule
