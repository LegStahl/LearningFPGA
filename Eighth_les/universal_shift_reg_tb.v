`timescale 1ns/10ps


module universal_shift_reg_tb #(parameter CLK_PERIOD = 5) ;

    reg         clk;           // Тактовый сигнал. Все синхронные операции выполняются по его положительному фронту.
    reg         rst_n;         // Асинхронный сброс, активный уровень - низкий ('0'). При сбросе выход обнуляется.
    reg   [1:0] select;        // Управляющий сигнал для выбора режима работы регистра.
    reg   [3:0] p_din;         // 4-битная шина для параллельной загрузки данных.
    reg         s_left_din;    // Входной бит для операции сдвига влево (загружается в LSB).
    reg         s_right_din;   // Входной бит для операции сдвига вправо (загружается в MSB).

    // ----------- Выходные порты ----------
    wire   [3:0] p_dout;   
	 
	 reg [3:0] etalon_out;
	 
	 universal_shift_reg test(.clk(clk), .rst_n(rst_n), .select(select), .p_din(p_din), .s_left_din(s_left_din), .s_right_din(s_right_din), .p_dout(p_dout));
	 
	 
	always begin
			clk = 1'b0;
			#(CLK_PERIOD/2);
			clk = 1'b1;
			#(CLK_PERIOD/2);
	end
	 
	 integer count_of_mistake = 0;
	 initial begin 
		$display("Test started\n");
		@(posedge clk);
		rst_n = 1'd0;
		p_din = 4'b1100;
		@(posedge clk);
		rst_n = 1'd1;
		select = 2'b11;
		$display("Load\n");
		p_din = 4'b1100;
		@(posedge clk);
		select = 2'b00;
		$display("Hold\n");
		etalon_out = 4'b1100;
		p_din = 4'b0100;
		@(posedge clk);
		select = 2'b00;
		etalon_out = 4'b0100;
		p_din = 4'b1001;
		@(posedge clk);
		etalon_out = 4'b1001;
		select = 2'b01;
		s_right_din = 1'b1;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		$display("Started counting\n");
		$stop;
	 end
	 
	 
		
		
	
endmodule