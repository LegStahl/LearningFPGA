// Файл: barrel_shifter.v
// Описание: Параметризуемый N-разрядный бочковой сдвиговый регистр (Barrel Shifter).
// Язык: Verilog-2001
//

module barrel_shifter #(
    // Параметр для задания ширины обрабатываемых данных
    parameter DATA_WIDTH = 4,
    // Параметр для выбора типа сдвига вправо
    parameter SHIFT_TYPE = "LOGICAL" // "LOGICAL" или "ARITHMETIC"
) (
    // Входные порты
    input [DATA_WIDTH-1:0] data_in,
    input [clog2(DATA_WIDTH)-1:0] shift_amount,
    input direction, // 0 - сдвиг влево, 1 - сдвиг вправо

    // Выходной порт
    output [DATA_WIDTH-1:0] data_out
);

    // Константная функция для вычисления логарифма по основанию 2.
    // Выполняется на этапе компиляции для определения разрядности шины shift_amount.
    function integer clog2;
        input integer value;
        begin
            value = value - 1;
            for (clog2 = 0; value > 0; clog2 = clog2 + 1)
                value = value >> 1;
        end
    endfunction

    // Локальная константа для разрядности управляющей шины
    localparam SA_WIDTH = clog2(DATA_WIDTH);

    // Внутренняя шина для хранения промежуточных результатов между каскадами
    wire [DATA_WIDTH-1:0] stage_data [SA_WIDTH:0];

    // Входные данные поступают на первый каскад
    assign stage_data[0] = data_in;

    // Генерация каскадов мультиплексоров для выполнения сдвига
    genvar i;
    generate
        for (i = 0; i < SA_WIDTH; i = i + 1) begin : shifter_stages
            
            // Промежуточные сигналы для результатов левого и правого сдвига
            wire [DATA_WIDTH-1:0] left_shifted_val;
            wire [DATA_WIDTH-1:0] right_shifted_val;

            // Логика сдвига влево
            assign left_shifted_val = stage_data[i] << (1 << i);

            // УСЛОВНАЯ ГЕНЕРАЦИЯ (дополнительное задание)
            // Компилятор создаст одну из двух схем в зависимости от параметра SHIFT_TYPE
            if (SHIFT_TYPE == "ARITHMETIC") begin
                // Арифметический сдвиг вправо (сохранение знакового бита)
                assign right_shifted_val = $signed(stage_data[i]) >> (1 << i);
            end else begin // LOGICAL
                // Логический сдвиг вправо (заполнение нулями)
                assign right_shifted_val = stage_data[i] >> (1 << i);
            end

            // Мультиплексор каскада:
            // 1. С помощью 'direction' выбирается результат (левый или правый сдвиг).
            // 2. С помощью 'shift_amount[i]' выбирается, применять сдвиг или нет.
            assign stage_data[i+1] = shift_amount[i]
                                     ? (direction ? right_shifted_val : left_shifted_val)
                                     : stage_data[i];
        end
    endgenerate

    // Вывод результата после прохождения всех каскадов
    assign data_out = stage_data[SA_WIDTH];

endmodule
