
module my_uart_tx(
				input clk, input  rst_n,
				input [7:0] rx_data, input rx_int, output rs232_tx,
				input clk_bps, output bps_start
			);

//input clk;			// 50MHz��ʱ��
//input rst_n;		//�͵�ƽ��λ�ź�
//input clk_bps;		// clk_bps_r�ߵ�ƽΪ��������λ���м�������,ͬʱҲ��Ϊ�������ݵ����ݸı���
//input[7:0] rx_data;	//�������ݼĴ���
//input rx_int;		//���������ж��ź�,���յ������ڼ�ʼ��Ϊ�ߵ�ƽ,�ڸ�ģ�������������½������������ڷ�������
//output rs232_tx;	// RS232���������ź�
//output bps_start;	//���ջ���Ҫ�������ݣ�������ʱ�������ź���λ

//---------------------------------------------------------
reg rx_int0,rx_int1,rx_int2;	//rx_int�źżĴ�������׽�½����˲���
wire neg_rx_int;	// rx_int�½��ر�־λ

always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
			rx_int0 <= 1'b0;
			rx_int1 <= 1'b0;
			rx_int2 <= 1'b0;
		end
	else begin
			rx_int0 <= rx_int;
			rx_int1 <= rx_int0;
			rx_int2 <= rx_int1;
		end
end

assign neg_rx_int = rx_int0 & ~rx_int1 & rx_int2;	//��׽���½��غ���neg_rx_int���߱���һ����ʱ������

//---------------------------------------------------------
reg[7:0] tx_data;	//���������ݵļĴ���
//---------------------------------------------------------
reg bps_start_r;
reg tx_en;	//��������ʹ���źţ�����Ч
reg[3:0] num;

always @ (posedge clk or negedge rst_n) begin
	
	if(!rst_n) begin
			bps_start_r <= 1'bz;
			tx_en <= 1'b0;
			tx_data <= 8'd0;
		end
	else if(neg_rx_int) begin	//�����������ϣ�׼���ѽ��յ������ݷ���ȥ
			bps_start_r <= 1'b1;
			tx_data <= rx_data;	//�ѽ��յ������ݴ��뷢�����ݼĴ���
			tx_en <= 1'b1;		//���뷢������״̬��
		end
	else if(num==4'd11) begin	//���ݷ������ɣ���λ
			bps_start_r <= 1'b0;
			tx_en <= 1'b0;
		end
end

assign bps_start = bps_start_r;

//---------------------------------------------------------
reg rs232_tx_r;

always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
			num <= 4'd0;
			rs232_tx_r <= 1'b1;
		end
	else if(tx_en) begin
			if(clk_bps)	begin
					num <= num + 1'b1;
					case (num)
						4'd0: rs232_tx_r <= 1'b0; 	//������ʼλ
						4'd1: rs232_tx_r <= tx_data[0];	//����bit0
						4'd2: rs232_tx_r <= tx_data[1];	//����bit1
						4'd3: rs232_tx_r <= tx_data[2];	//����bit2
						4'd4: rs232_tx_r <= tx_data[3];	//����bit3
						4'd5: rs232_tx_r <= tx_data[4];	//����bit4
						4'd6: rs232_tx_r <= tx_data[5];	//����bit5
						4'd7: rs232_tx_r <= tx_data[6];	//����bit6
						4'd8: rs232_tx_r <= tx_data[7];	//����bit7
						4'd9: rs232_tx_r <= 1'b1;	//���ͽ���λ
					 	default: rs232_tx_r <= 1'b1;
						endcase
				end
			else if(num==4'd11) num <= 4'd0;	//��λ
		end
end

assign rs232_tx = rs232_tx_r;

endmodule


