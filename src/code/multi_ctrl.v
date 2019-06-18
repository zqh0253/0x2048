`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:16:06 08/03/2009 
// Design Name: 
// Module Name:    ctrl 
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
module ctrl(input  clk,
				input  reset,
				input  [31:0] Inst_in,
				input  zero,
				input  overflow,
				input  MIO_ready,
				output reg MemRead,
				output reg MemWrite,
				output [2:0]ALU_operation,
				output [4:0]state_out,
				
				output reg CPU_MIO,
				output reg IorD,
				output reg IRWrite,
				output reg [1:0]RegDst,
				output reg RegWrite,
				output reg [1:0]MemtoReg,
				output reg ALUSrcA,
				output reg [1:0]ALUSrcB,
				output reg [1:0]PCSource,
				output reg PCWrite,
				output reg PCWriteCond,
				output reg Branch
				);
reg [3:0] state;
reg [1:0] ALUop;

ALU_Decoder ALU_D(.ALUop(ALUop), .Fun(Inst_in[5:0]), .ALU_Control(ALU_operation));

parameter IF =      4'b0000,     ID = 4'b0001, Mem_Ex = 4'b0010, Mem_RD = 4'b0011,
			 LW_WB =   4'b0100,  Mem_W = 4'b0101,  R_Exc = 4'b0110,   R_WB = 4'b0111,
			 Beq_Exc = 4'b1000,      J = 4'b1001,  Error = 4'b1111;
			 
`define Datapath_signals {PCWrite, PCWriteCond,IorD, MemRead, MemWrite,IRWrite, MemtoReg, PCSource, ALUSrcA, ALUSrcB, RegWrite, RegDst, Branch, ALUop, CPU_MIO}

parameter value0 = 20'b10010100000010000000,	value1 = 20'b00000000000110000000,
	       value2 = 20'b00000000001100000000,	value3 = 20'b00110000000000000001,
	       value4 = 20'b00000001000001000000,	value5 = 20'b00101000000000000001,
	       value6 = 20'b00000000001000000100,	value7 = 20'b00000000000001010000,
	       value8 = 20'b01000000011000001010,	value9 = 20'b10000000100000000000;
			 
always @ * begin
	   case (state)				//state
			IF: 	   `Datapath_signals = value0;
			ID:	   `Datapath_signals = value1;
			Mem_Ex:  `Datapath_signals = value2;
			Mem_RD:  `Datapath_signals = value3;
			LW_WB:	`Datapath_signals = value4;
			Mem_W:	`Datapath_signals = value5;
			R_Exc:	`Datapath_signals = value6;
			R_WB:	   `Datapath_signals = value7;
			Beq_Exc: `Datapath_signals = value8;
			J:	      `Datapath_signals = value9;
			default: `Datapath_signals = value0;
	  endcase
end

always @ (posedge clk or posedge reset)
   if (reset==1) state <= IF; 
   else
		case (state)
			IF:      if (MIO_ready) state <= ID; else state <= IF;
			ID:      case (Inst_in[31:26])
							 6'b000000: state <= R_Exc;	 //R-type OP
							 6'b100011: state <= Mem_Ex; 	 //Lw
							 6'b101011: state <= Mem_Ex;   //Sw
							 6'b000100: state <= Beq_Exc;  //Beq
							 6'b000010: state <= J;        //J
							 default:   state <= Error;	
					   endcase
			Mem_Ex:  if (Inst_in[31:26] == 6'b100011) state <= Mem_RD; else state <= Mem_W;
			Mem_RD:  state <= LW_WB;
			LW_WB:   state <= IF;
			Mem_W:   state <= IF;
			R_Exc:   state <= R_WB;
			R_WB:    state <= IF;
			Beq_Exc: state <= IF;
			J:       state <= IF;
			Error:   state <= Error;
			default: state <= Error; 
      endcase 
endmodule
