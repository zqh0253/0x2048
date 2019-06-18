`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:52:27 05/07/2019 
// Design Name: 
// Module Name:    Multi_CPU 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module   MCPU ( 
			input wire clk,
			input wire reset,
			input wire MIO_ready,	// be used：=1
			input wire  INT,		//中断
			output wire[31:0]PC_out,	//Test
			output[31:0] inst_out,	//TEST
			output wire mem_w,	//存储器读写控制
			output wire[31:0]Addr_out,//数据空间访问地址
			output wire[31:0]Data_out,//数据输出总线
			input wire [31:0]Data_in,	//数据输入总线
			output wire CPU_MIO,	// Be used 				
			output[4:0]state		//Test
			);

	wire zero, overflow, MemRead, MemWrite;
	wire IorD, IRWrite, RegWrite, ALUSrcA, PCWrite, PCWriteCond, Branch;
	wire [1:0] RegDst, MemtoReg, ALUSrcB, PCSource;
	wire [2:0] ALU_operation;
	wire [4:0] status_out;
	assign mem_w = (~MemRead) && MemWrite;
	ctrl       m0 (.clk(clk), .reset(reset), .zero(zero), .overflow(overflow), .MIO_ready(MIO_ready),
					  .Inst_in(inst_out), .MemRead(MemRead), .MemWrite(MemWrite), .CPU_MIO(CPU_MIO), .IorD(IorD),
					  .IRWrite(IRWrite), .RegWrite(RegWrite), .ALUSrcA(ALUSrcA), .PCWrite(PCWrite),
					  .PCWriteCond(PCWriteCond), .Branch(Branch), .RegDst(RegDst), .MemtoReg(MemtoReg),
					  .ALUSrcB(ALUSrcB), .PCSource(PCSource), .ALU_operation(ALU_operation), .state_out(state));

	M_datapath m1(.clk(clk), .reset(reset), .MIO_ready(MIO_ready), .IorD(IorD), .IRWrite(IRWrite),
					  .RegWrite(RegWrite), .ALUSrcA(ALUSrcA), .PCWrite(PCWrite), .PCWriteCond(PCWriteCond), 
					  .Branch(Branch), .RegDst(RegDst), .MemtoReg(MemtoReg), .ALUSrcB(ALUSrcB),
					  .PCSource(PCSource), .ALU_operation(ALU_operation), .data2CPU(Data_in),
					  .zero(zero), .overflow(overflow), .PC_Current(PC_out), .Inst(inst_out),
					  .data_out(Data_out), .M_addr(Addr_out));

endmodule
