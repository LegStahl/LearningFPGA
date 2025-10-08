// debounce.v
// Модуль для подавления дребезга контактов кнопки

module debounce (
    input wire clk,         // Тактовый сигнал 50 МГц
    input wire reset,       // Сигнал сброса
    input wire btn_in,      // Вход от физической кнопки (active-low)
    output wire btn_out     // Выход: чистый одиночный импульс (active-high)
);

    // Параметры для задержки ~20 мс на частоте 50 МГц
    localparam COUNTER_MAX = 1_000_000;
    localparam COUNTER_WIDTH = 20;

    reg [COUNTER_WIDTH-1:0] counter;
    reg btn_q1, btn_q2, btn_q3;
    
    // Синхронизируем асинхронный сигнал от кнопки с нашей тактовой частотой
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            btn_q1 <= 1'b1;
            btn_q2 <= 1'b1;
        end else begin
            btn_q1 <= btn_in;
            btn_q2 <= btn_q1;
        end
    end

    // Логика дебаунсера
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            btn_q3 <= 1'b1;
        end else begin
            if (btn_q2 == btn_q3) begin // Если состояние стабильно (нет изменений)
                counter <= 0; // Сбрасываем счетчик
            end else begin
                if (counter < COUNTER_MAX) begin
                    counter <= counter + 1;
                end else begin
                    // Счетчик достиг максимума, значит состояние стабильно уже 20мс
                    btn_q3 <= btn_q2;
                end
            end
        end
    end
    
    // Генерируем одиночный импульс на выходе, когда кнопка была отпущена, а теперь нажата
    // btn_q3 - это отфильтрованное, стабильное состояние кнопки
    // '1' - отпущена, '0' - нажата
    reg prev_btn_state;
    always @(posedge clk or posedge reset) begin
        if(reset)
            prev_btn_state <= 1'b1;
        else
            prev_btn_state <= btn_q3;
    end
    
    assign btn_out = prev_btn_state & ~btn_q3; // Импульс возникает при переходе 1 -> 0

endmodule