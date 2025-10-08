module my_logic #(
    parameter S_IDLE  = 0,
    parameter STATE_1 = 1,
    parameter STATE_2 = 2,
    parameter STATE_3 = 3
)(
    output reg [2:0] led_check,
    output reg success2,
    input rst,
    input [2:0] buttons,
    input clk
);

    reg [1:0] current_state = S_IDLE;

    always @(posedge clk) begin
		  success2 <= 1'b0;
        if (rst) begin
            current_state <= S_IDLE;
            led_check <= 3'b111;
            success2 <= 1'b0;
        end else begin
            case (buttons)
                3'b001: begin
                    if (current_state == S_IDLE) begin
                        current_state <= STATE_1;
                        led_check[0] <= 0;
                    end else begin
                        current_state <= S_IDLE;
                        led_check[0] <= 1;
                        led_check[1] <= 1;
                    end
                end
                3'b010: begin
                    if (current_state == STATE_1) begin
                        current_state <= STATE_2;
                        led_check[1] <= 0;
                    end else begin
                        current_state <= S_IDLE;
                        led_check[0] <= 1;
                        led_check[1] <= 1;
                    end
                end
                3'b100: begin
                    if (current_state == STATE_2) begin
                        success2 <= 1'b1;
                        led_check[0] <= 1;
                        led_check[1] <= 1;
								current_state <= S_IDLE;
								
                    end else begin
                        current_state <= S_IDLE;
                        led_check[0] <= 1;
                        led_check[1] <= 1;
                    end
                end
            endcase
        end
    end
endmodule
