// pulse_extender.v
// Модуль для расширения короткого импульса до заметной длительности

module pulse_extender (
    input wire clk,         // Тактовый сигнал
    input wire reset,       // Сброс
    input wire pulse_in,    // Входной короткий импульс
    output reg pulse_out    // Выходной расширенный импульс
);

    // Параметры для задержки 250 мс на частоте 50 МГц
    localparam COUNTER_MAX = 12_500_000;
    localparam COUNTER_WIDTH = 24;

    reg [COUNTER_WIDTH-1:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            pulse_out <= 1'b0;
        end else begin
            // Если пришел короткий импульс, запускаем счетчик
            if (pulse_in) begin
                counter <= COUNTER_MAX;
            end
            // Пока счетчик не дошел до нуля, уменьшаем его
            else if (counter > 0) begin
                counter <= counter - 1;
            end

            // Выходной сигнал активен, пока счетчик не равен нулю
            if (counter > 0 || pulse_in) begin
                pulse_out <= 1'b1;
            end else begin
                pulse_out <= 1'b0;
            end
        end
    end

endmodule