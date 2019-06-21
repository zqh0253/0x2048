`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:06:53 06/06/2016 
// Design Name: 
// Module Name:    VGA 
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
module VGA_ctrl(
	input clk,
	input rst,
	input SW,
	input [31:0] color,
	output hs,
	output vs,
	output  [3:0] red,
	output  [3:0] green,
	output [3:0] blue,
	output [9:0] x_ptr,
	output [9:0] y_ptr,
	output reg [10:0] addrb,
	output [31:0] score,
	output valid,
	output reg isin
);
	wire [11:0] rgbw2;
	wire [11:0] rgbw4;
	wire [11:0] rgbw8;
	wire [11:0] rgbw16;
	wire [11:0] rgbw32;
	wire [11:0] rgbw64;
	wire [11:0] rgbw128;
	wire [11:0] rgbw256;
	wire [11:0] rgbw512;
	wire [11:0] rgbw1024;
	wire [11:0] rgbw2048;
	wire [11:0] bgrgb;
	reg [9:0] cnt_x;
	reg [9:0] cnt_y;
	reg [31:0] block_cnt[15:0];
	reg [4:0] i;
   initial begin
		cnt_x = 10'd0;
		cnt_y = 10'd0;
		isin = 1'd0;
		block_cnt[0] = 31'b0;
		block_cnt[1] = 31'b0;
		block_cnt[2] = 31'b0;
		block_cnt[3] = 31'b0;
		block_cnt[4] = 31'b0;
		block_cnt[5] = 31'b0;
		block_cnt[6] = 31'b0;
		block_cnt[7] = 31'b0;
		block_cnt[8] = 31'b0;
		block_cnt[9] = 31'b0;
		block_cnt[10] = 31'b0;
		block_cnt[11] = 31'b0;
		block_cnt[12] = 31'b0;
		block_cnt[13] = 31'b0;
		block_cnt[14] = 31'b0;
		block_cnt[15] = 31'b0;
	end
	
	always @(posedge clk) begin
		if (rst) cnt_x <= 10'd0;
		else if (cnt_x == 10'd799) cnt_x <= 10'd0;
		else cnt_x <= cnt_x + 10'd1;
	end
	
	always @(posedge clk) begin
		if (rst) cnt_y <= 10'd0;
		else if(cnt_x == 10'd799) begin
			if (cnt_y == 10'd524) cnt_y <= 10'd0;
			else cnt_y <= cnt_y + 10'd1;
		end
	end
	
	assign x_ptr = cnt_x - (96+40+8);
	assign y_ptr = cnt_y - (2+25+8);
	assign score = block_cnt[0] + block_cnt[1] + block_cnt[2] + block_cnt[3] + block_cnt[4] + block_cnt[5] + block_cnt[6] + block_cnt[7] + 
						block_cnt[8] + block_cnt[9] + block_cnt[10] + block_cnt[11] + block_cnt[12] + block_cnt[13] + block_cnt[14] + block_cnt[15];
		
	wire [12:0]addr_item= ((x_ptr-40) - ((x_ptr-40) / 8'd110) * 8'd110)+90*((y_ptr-30)-((y_ptr-30)/8'd110)*8'd110);
	wire [18:0]bgaddr = x_ptr + y_ptr * 640;
	reg isdead = 0;
	
	assign hs = !((cnt_x >= 0) && (cnt_x < 96));
	assign vs = !((cnt_y >= 0) && (cnt_y < 2));
	assign valid = x_ptr>=0 && x_ptr < 640 && y_ptr >= 0 && y_ptr < 480;

	item2 m2(clk, 1'b0, addr_item, 12'b0, rgbw2);
	item4 m4(clk, 1'b0, addr_item, 12'b0, rgbw4);
	item8(clk, 1'b0, addr_item, 12'b0, rgbw8);
	item16(clk, 1'b0, addr_item, 12'b0, rgbw16);
	item32(clk, 1'b0, addr_item, 12'b0, rgbw32);
	item64(clk, 1'b0, addr_item, 12'b0, rgbw64);
	item128(clk, 1'b0, addr_item, 12'b0, rgbw128);
	item256(clk, 1'b0, addr_item, 12'b0, rgbw256);
	item512(clk, 1'b0, addr_item, 12'b0, rgbw512);
	item1024(clk, 1'b0, addr_item, 12'b0, rgbw1024);
	item2048(clk, 1'b0, addr_item, 12'b0, rgbw2048);
	bg mbg(clk, 1'b0, bgaddr, 12'b0, bgrgb);
	
	always @ (posedge clk) begin
		isin = 1;
		if (x_ptr>=40 && x_ptr<=130 && y_ptr>=30 && y_ptr<=120) begin addrb = 11'd256; block_cnt[0] = color; end
		else if (x_ptr>=150 && x_ptr<=240 && y_ptr>=30 && y_ptr<=120)  begin	addrb = 11'd257; block_cnt[1] = color; end
		else if (x_ptr>=260 && x_ptr<=350 && y_ptr>=30 && y_ptr<=120)	begin addrb = 11'd258; block_cnt[2] = color; end
		else if (x_ptr>=370 && x_ptr<=460 && y_ptr>=30 && y_ptr<=120)  begin addrb = 11'd259; block_cnt[3] = color; end
		else if (x_ptr>=40 && x_ptr<=130 && y_ptr>=140 && y_ptr<=230)	begin addrb = 11'd260; block_cnt[4] = color; end
		else if (x_ptr>=150 && x_ptr<=240 && y_ptr>=140 && y_ptr<=230)	begin addrb = 11'd261; block_cnt[5] = color; end
		else if (x_ptr>=260 && x_ptr<=350 && y_ptr>=140 && y_ptr<=230)	begin addrb = 11'd262; block_cnt[6] = color; end
		else if (x_ptr>=370 && x_ptr<=460 && y_ptr>=140 && y_ptr<=230)	begin addrb = 11'd263; block_cnt[7] = color; end
		else if (x_ptr>=40 && x_ptr<=130 && y_ptr>=250 && y_ptr<=340)	begin addrb = 11'd264; block_cnt[8] = color; end
		else if (x_ptr>=150 && x_ptr<=240 && y_ptr>=250 && y_ptr<=340)	begin addrb = 11'd266; block_cnt[9] = color; end
		else if (x_ptr>=260 && x_ptr<=350 && y_ptr>=250 && y_ptr<=340)	begin addrb = 11'd267; block_cnt[10] = color; end
		else if (x_ptr>=370 && x_ptr<=460 && y_ptr>=250 && y_ptr<=340)	begin addrb = 11'd267; block_cnt[11] = color; end
		else if (x_ptr>=40 && x_ptr<=130 && y_ptr>=360 && y_ptr<=450)	begin addrb = 11'd268; block_cnt[12] = color; end
		else if (x_ptr>=150 && x_ptr<=240 && y_ptr>=360 && y_ptr<=450)	begin addrb = 11'd269; block_cnt[13] = color; end
		else if (x_ptr>=260 && x_ptr<=350 && y_ptr>=360 && y_ptr<=450)	begin addrb = 11'd270; block_cnt[14] = color; end
		else if (x_ptr>=370 && x_ptr<=460 && y_ptr>=360 && y_ptr<=450)	begin addrb = 11'd271; block_cnt[15] = color; end
		else isin = 0; 
	end
	
	assign red =  ~valid ? 4'b0000 : (~isin ? bgrgb[11:8] : ( 
							color==32'd0 ? 4'b1111 : (
							color==32'd1 ? rgbw2[11:8] : (
							color==32'd2 ? rgbw4[11:8] : (
							color==32'd3 ? rgbw8[11:8] : (
							color==32'd4 ? rgbw16[11:8] : (
							color==32'd5 ? rgbw32[11:8] : (
							color==32'd6 ? rgbw64[11:8] : (
							color==32'd7 ? rgbw128[11:8] : (
							color==32'd8 ? rgbw256[11:8] : (
							color==32'd9 ? rgbw512[11:8] : (
							color==32'd10 ? rgbw1024[11:8] : rgbw2048[11:8]))))))))))));
		assign green = ~valid ? 4'b0000 : (~isin ? bgrgb[7:4] : ( 
							color==32'd0 ? 4'b1111 : (
							color==32'd1 ? rgbw2[7:4] : (
							color==32'd2 ? rgbw4[7:4] : (
							color==32'd3 ? rgbw8[7:4] : (
							color==32'd4 ? rgbw16[7:4] : (
							color==32'd5 ? rgbw32[7:4] : (
							color==32'd6 ? rgbw64[7:4] : (
							color==32'd7 ? rgbw128[7:4] : (
							color==32'd8 ? rgbw256[7:4] : (
							color==32'd9 ? rgbw512[7:4] : (
							color==32'd10 ? rgbw1024[7:4] : rgbw2048[7:4]))))))))))));
		assign blue = ~valid ? 4'b0000 : (~isin ? bgrgb[3:0] : ( 
							color==32'd0 ? 4'b1111 : (
							color==32'd1 ? rgbw2[3:0] : (
							color==32'd2 ? rgbw4[3:0] : (
							color==32'd3 ? rgbw8[3:0] : (
							color==32'd4 ? rgbw16[3:0] : (
							color==32'd5 ? rgbw32[3:0] : (
							color==32'd6 ? rgbw64[3:0] : (
							color==32'd7 ? rgbw128[3:0] : (
							color==32'd8 ? rgbw256[3:0] : (
							color==32'd9 ? rgbw512[3:0] : (
							color==32'd10 ? rgbw1024[3:0] : rgbw2048[3:0]))))))))))));
	
endmodule

	
	/*assign isin = (x_ptr>=150 && x_ptr<=240 && y_ptr>=30 && y_ptr<=120) ||
						(x_ptr>=260 && x_ptr<=350 && y_ptr>=30 && y_ptr<=120) ||
						(x_ptr>=370 && x_ptr<=460 && y_ptr>=30 && y_ptr<=120) ||
						(x_ptr>=40 && x_ptr<=130 && y_ptr>=30 && y_ptr<=120) ||
						(x_ptr>=40 && x_ptr<=130 && y_ptr>=140 && y_ptr<=230) ||
						(x_ptr>=150 && x_ptr<=240 && y_ptr>=140 && y_ptr<=230) ||
						(x_ptr>=260 && x_ptr<=350 && y_ptr>=140 && y_ptr<=230) ||
						(x_ptr>=370 && x_ptr<=460 && y_ptr>=140 && y_ptr<=230) ||
						(x_ptr>=40 && x_ptr<=130 && y_ptr>=250 && y_ptr<=340) ||
						(x_ptr>=150 && x_ptr<=240 && y_ptr>=250 && y_ptr<=340)||
						 (x_ptr>=260 && x_ptr<=350 && y_ptr>=250 && y_ptr<=340) ||
						 (x_ptr>=370 && x_ptr<=460 && y_ptr>=250 && y_ptr<=340) ||
						 (x_ptr>=40 && x_ptr<=130 && y_ptr>=360 && y_ptr<=450) ||
						 (x_ptr>=150 && x_ptr<=240 && y_ptr>=360 && y_ptr<=450) ||
						 (x_ptr>=260 && x_ptr<=350 && y_ptr>=360 && y_ptr<=450) ||
						 (x_ptr>=370 && x_ptr<=460 && y_ptr>=360 && y_ptr<=450);
	*/