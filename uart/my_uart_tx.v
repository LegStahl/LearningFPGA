
module my_uart_tx(
    input clk, input  rst_n,
    input [7:0] rx_data, input rx_int, output rs232_tx,
    input clk_bps, output bps_start
);

//---------------------------------------------------------
reg rx_int0, rx_int1, rx_int2;
wire neg_rx_int;

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        rx_int0 <= 1'b0;
        rx_int1 <= 1'b0;
        rx_int2 <= 1'b0;
    end else begin
        rx_int0 <= rx_int;
        rx_int1 <= rx_int0;
        rx_int2 <= rx_int1;
    end
end

// детект спадающего фронта rx_int (prev == 1 && curr == 0)
assign neg_rx_int = rx_int1 & ~rx_int0;

//---------------------------------------------------------
reg [7:0] tx_data;
reg bps_start_r;
reg tx_en;
reg [3:0] num;
reg rs232_tx_r;

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        bps_start_r <= 1'b0;
        tx_en       <= 1'b0;
        tx_data     <= 8'd0;
    end else begin
        // старт передачи — на обнаружении neg_rx_int
        if (neg_rx_int) begin
            bps_start_r <= 1'b1;    // сигнал старт генератору бит-переключений
            tx_data     <= rx_data;
            tx_en       <= 1'b1;
        end
        // завершение передачи: делаем это только когда достигнут стоп-бит и пришёл такт clk_bps
        else if (tx_en && (num == 4'd9) && clk_bps) begin
            bps_start_r <= 1'b0;
            tx_en       <= 1'b0;
            // num будет сброшен в блоке ниже (или можно сбросить здесь тоже)
        end
        // иначе — сохраняем текущие значения
    end
end

assign bps_start = bps_start_r;

//---------------------------------------------------------
// управление линией rs232 и счётчиком num
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        num         <= 4'd0;
        rs232_tx_r  <= 1'b1; // idle = 1
    end else begin
        if (tx_en) begin
            if (clk_bps) begin
                // на каждом импульсе clk_bps выполняем текущую фазу (case по текущему num)
                // и увеличиваем счетчик для следующей фазы
                case (num)
                    4'd0: rs232_tx_r <= 1'b0;        // start bit
                    4'd1: rs232_tx_r <= tx_data[0];
                    4'd2: rs232_tx_r <= tx_data[1];
                    4'd3: rs232_tx_r <= tx_data[2];
                    4'd4: rs232_tx_r <= tx_data[3];
                    4'd5: rs232_tx_r <= tx_data[4];
                    4'd6: rs232_tx_r <= tx_data[5];
                    4'd7: rs232_tx_r <= tx_data[6];
                    4'd8: rs232_tx_r <= tx_data[7];
                    4'd9: rs232_tx_r <= 1'b1;        // stop bit
                    default: rs232_tx_r <= 1'b1;
                endcase

                // инкрементируем (на следующем clk используем обновлённое значение)
                // Если дошли до 9 — следующий инкремент оставим 0 (или можно тут же сбросить)
                if (num == 4'd9)
                    num <= 4'd0;
                else
                    num <= num + 1'b1;
            end
            // если tx_en, но нет clk_bps — ничего не делаем (ждём тактов bps)
        end else begin
            // при отсутствии tx_en — гарантированно сбрасываем num и держим линию в idle
            num <= 4'd0;
            rs232_tx_r <= 1'b1;
        end
    end
end

assign rs232_tx = rs232_tx_r;

endmodule