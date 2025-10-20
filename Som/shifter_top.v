



//
// Файл: shifter_top.v
// Описание: Модуль верхнего уровня для интеграции barrel_shifter
// 
// 
//

module shifter_top (
    // Входы от аппаратной платформы
    input        FPGA_CLK,
    input        RESET_N,
    input  [3:0] SW, // 4 DIP-переключателя для входных данных

    // Выходы на аппаратную платформу
    output [3:0] LED  // 4 светодиода для отображения результата
);
    // --- Параметры для теста ---
    // Меняйте эти значения для проверки разных режимов работы
    localparam SHIFT_DIR = 1'b0;  // Направление: 0 = влево, 1 = вправо
    localparam SHIFT_VAL = 2'b01; // Величина сдвига (от 0 до 3)

    // Промежуточные провода для наглядности соединений
    wire [3:0] data_from_sw;
    wire [3:0] data_to_led;

    // Прямое соединение физических портов с проводами
    assign data_from_sw = SW;
    assign LED = data_to_led;

    // Создание экземпляра (инстанцирование) модуля barrel_shifter
    barrel_shifter #(
        .DATA_WIDTH(4) // Явно указываем разрядность для этого экземпляра
        //.SHIFT_TYPE("ARITHMETIC") // Раскомментируйте для проверки арифм. сдвига
    ) shifter_inst (
        .data_in(data_from_sw),
        .shift_amount(SHIFT_VAL),   // Подключаем константу
        .direction(SHIFT_DIR),      // Подключаем константу
        .data_out(data_to_led)
    );

endmodule