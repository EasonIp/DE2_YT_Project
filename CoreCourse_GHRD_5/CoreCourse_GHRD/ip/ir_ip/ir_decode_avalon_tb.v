`timescale 1ns/1ns

`define clk_period 20

module ir_decode_avalon_tb;
	
	reg cpu_clk;
	reg cpu_reset_n;

	reg cpu_cs;		//cpu片选信号
	reg cpu_read;	//cpu读请求信号
	reg [1:0]cpu_addr;	//cpu读地址信号
	wire[15:0]cpu_rddata;	//cpu读取数据端口
	reg cpu_write;
	reg [15:0]cpu_wrdata;	//cpu写数据
	wire cpu_irq;	//cpu中断请求
	
	reg iIR;
	
	integer i;

	ir_decode_avalon ir_decode_avalon(
		cpu_clk,
		cpu_reset_n,
		
		cpu_cs,		//cpu片选信号
		cpu_read,	//cpu读请求信号
		cpu_addr,	//cpu读地址信号
		cpu_rddata,	//cpu读取数据端口
		
		cpu_write,	//cpu写请求
		cpu_wrdata,	//cpu写数据
		
		cpu_irq,
		
		iIR
	);
		
	initial cpu_clk = 1'b1;
	always#(`clk_period/2)cpu_clk = ~cpu_clk;

	initial begin
		cpu_reset_n = 1'b0;
		iIR = 1'b1;
		#(`clk_period*10+1'b1);
		cpu_reset_n = 1'b1;
		#2000;
		iIR = 1'b1;
		send_data(1,8'h12);
		#60000000;
		send_data(3,8'heb);
		#60000000;
		$stop	;
	end

	initial begin
		cpu_cs = 0;		//cpu片选信号
		cpu_read = 0;	//cpu读请求信号
		cpu_addr = 0;	//cpu读地址信号
		
		cpu_write = 0;	//cpu写请求
		cpu_wrdata = 0;	//cpu写数据
		#200;
		wait(cpu_irq);
		
		#2000;	//模拟avalon总线写数据以清除中断
		cpu_cs = 1;
		cpu_write = 1;
		cpu_addr = 2;
		cpu_wrdata = 0;
		#20;
		cpu_cs = 0;
		cpu_write = 0;
		cpu_addr = 2;
		cpu_wrdata = 0;
		
		
		#200;	//模拟avalon总线读irdata寄存器
		cpu_cs = 1;
		cpu_read = 1;
		cpu_addr = 0;
		#40;
		cpu_cs = 0;
		cpu_read = 0;
		cpu_addr = 0;
		
		#40;//模拟avalon总线读iraddr寄存器
		cpu_cs = 1;
		cpu_read = 1;
		cpu_addr = 1;
		#40;
		cpu_cs = 0;
		cpu_read = 0;
		cpu_addr = 0;
		#2000;
		$stop;		
	end
	
	task send_data;
		input [15:0]addr;
		input [7:0]data;
		begin
			iIR = 0;#9000000;
			iIR = 1;#4500000;
			for(i=0;i<=15;i=i+1)begin
				bit_send(addr[i]);		
			end
			for(i=0;i<=7;i=i+1)begin
				bit_send(data[i]);		
			end
			for(i=0;i<=7;i=i+1)begin
				bit_send(~data[i]);		
			end
			iIR = 0;#560000;
			iIR = 1;		
		end
	endtask
	
	task bit_send;
		input one_bit;
		begin
			iIR = 0; #560000;
			iIR = 1;
			if(one_bit)
				#1690000;
			else
				#560000;
		end	
	endtask

endmodule
