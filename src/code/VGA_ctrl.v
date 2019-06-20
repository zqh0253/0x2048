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
	output reg [8:0] pos,
	output reg [1:0] run,
	output reg [31:0] score,
	output valid,
	output isin
);
	wire [11:0] rgbw2;
	wire [11:0] rgbw4;
	wire [11:0] rgbw8;
	wire [11:0] rgbw16;
	wire [11:0] rgbw32;
	wire [11:0] rgbw64;
	wire [11:0] rgbw128;
	wire [11:0] bgrgb;
	reg [9:0] cnt_x;
	reg [9:0] cnt_y;
	
	reg [3:0] cur;
	wire [1:0] mod;
	wire in, bird;
	
	
   initial begin
		cnt_x = 10'd0;
		cnt_y = 10'd0;
		pos   =  9'd256;
		run   =  2'd3;
		cur   =  4'd7;
		score = 32'd0;
		//nowrst = 10'd0;
		//lastrst = 10'd0;
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
	
		
	wire [12:0]addr_item= ((x_ptr-40) - ((x_ptr-40) / 8'd110) * 8'd110)+90*((y_ptr-30)-((y_ptr-30)/8'd110)*8'd110);
	
	reg isdead = 0;
	
	assign hs = !((cnt_x >= 0) && (cnt_x < 96));
	assign vs = !((cnt_y >= 0) && (cnt_y < 2));
	assign valid = x_ptr && x_ptr < 640 && y_ptr >= 0 && y_ptr < 480;

	item2 m2(clk, 1'b0, addr_item, 12'b0, rgbw2);
	item4 m4(clk, 1'b0, addr_item, 12'b0, rgbw4);
	//item8(clk, 1'b0, addr_item, 16'b0, rgbw8);
	//item16(clk, 1'b0, addr_item, 16'b0, rgbw16);
	//item32(clk, 1'b0, addr_item, 16'b0, rgbw32);
//	item64(clk, 1'b0, addr_item, 16'b0, rgbw64);
	//item128(clk, 1'b0, addr_item, 16'b0, rgbw128);
	bg mbg(clk, 1'b0, 8'b0, 12'b0, bgrgb);
	
	assign isin = (x_ptr>=150 && x_ptr<=240 && y_ptr>=30 && y_ptr<=120) ||
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
						 (x_ptr>=40 && x_ptr<=130 && y_ptr>=360 && y_ptr<=470) ||
						 (x_ptr>=150 && x_ptr<=240 && y_ptr>=360 && y_ptr<=470) ||
						 (x_ptr>=260 && x_ptr<=350 && y_ptr>=360 && y_ptr<=470) ||
						 (x_ptr>=370 && x_ptr<=460 && y_ptr>=360 && y_ptr<=470);
	
	always @ (posedge clk) begin
		if (x_ptr>=40 && x_ptr<=130 && y_ptr>=30 && y_ptr<=120)	addrb = 11'h256;
		else if (x_ptr>=150 && x_ptr<=240 && y_ptr>=30 && y_ptr<=120)	addrb = 11'h257;
		else if (x_ptr>=260 && x_ptr<=350 && y_ptr>=30 && y_ptr<=120)	addrb = 11'h258;
		else if (x_ptr>=370 && x_ptr<=460 && y_ptr>=30 && y_ptr<=120)	addrb = 11'h259;
		else if (x_ptr>=40 && x_ptr<=130 && y_ptr>=140 && y_ptr<=230)	addrb = 11'h260;
		else if (x_ptr>=150 && x_ptr<=240 && y_ptr>=140 && y_ptr<=230)	addrb = 11'h261;
		else if (x_ptr>=260 && x_ptr<=350 && y_ptr>=140 && y_ptr<=230)	addrb = 11'h262;
		else if (x_ptr>=370 && x_ptr<=460 && y_ptr>=140 && y_ptr<=230)	addrb = 11'h263;
		else if (x_ptr>=40 && x_ptr<=130 && y_ptr>=250 && y_ptr<=340)	addrb = 11'h264;
		else if (x_ptr>=150 && x_ptr<=240 && y_ptr>=250 && y_ptr<=340)	addrb = 11'h265;
		else if (x_ptr>=260 && x_ptr<=350 && y_ptr>=250 && y_ptr<=340)	addrb = 11'h266;
		else if (x_ptr>=370 && x_ptr<=460 && y_ptr>=250 && y_ptr<=340)	addrb = 11'h267;
		else if (x_ptr>=40 && x_ptr<=130 && y_ptr>=360 && y_ptr<=470)	addrb = 11'h268;
		else if (x_ptr>=150 && x_ptr<=240 && y_ptr>=360 && y_ptr<=470)	addrb = 11'h269;
		else if (x_ptr>=260 && x_ptr<=350 && y_ptr>=360 && y_ptr<=470)	addrb = 11'h270;
		else if (x_ptr>=370 && x_ptr<=460 && y_ptr>=360 && y_ptr<=470)	addrb = 11'h271;
	end
	
	assign red =  (~isin ? 4'b0000 : ( 
							color==32'd0 ? rgbw2[11:8] : (
							color==32'd1 ? rgbw2[11:8] : (
							color==32'd2 ? rgbw4[11:8] : (
							color==32'd3 ? rgbw4[11:8] : (
							color==32'd4 ? rgbw4[11:8] : (
							color==32'd5 ? rgbw4[11:8] : rgbw2[11:8])))))));
		assign green =   ( ~isin ? 4'b0000 : (
							color==32'd0 ? rgbw4[7:4] : (
							color==32'd1 ? rgbw2[7:4] : (
							color==32'd2 ? rgbw4[7:4] : (
							color==32'd3 ? rgbw4[7:4] : (
							color==32'd4 ? rgbw4[7:4] : (
							color==32'd5 ? rgbw4[7:4] : rgbw4[7:4])))))));
		assign blue =  (~isin ? 4'b0000: (
							color==32'd0 ? rgbw4[3:0] : (
							color==32'd1 ? rgbw2[3:0] : (
							color==32'd2 ? rgbw4[3:0] : (
							color==32'd3 ? rgbw4[3:0] : (
							color==32'd4 ? rgbw4[3:0] : (
							color==32'd5 ? rgbw4[3:0] : rgbw4[3:0])))))));
	
endmodule

	/*
	assign red = ((isin == 0 )? bgrgb[11:8] : (isdead? bgrgb[11:8] : (
							color==32'd0 ? bgrgb[11:8] : (
							color==32'd1 ? rgbw2[11:8] : (
							color==32'd2 ? rgbw4[11:8] : (
							color==32'd3 ? bgrgb[11:8] : (
							color==32'd4 ? bgrgb[11:8] : (
							color==32'd5 ? bgrgb[11:8] : bgrgb[11:8]))))))));
		assign green = (isin == 0 )? bgrgb[7:4] : (isdead? bgrgb[11:8] : (
							color==32'd0 ? bgrgb[7:4] : (
							color==32'd1 ? rgbw2[7:4] : (
							color==32'd2 ? rgbw4[7:4] : (
							color==32'd3 ? bgrgb[7:4] : (
							color==32'd4 ? bgrgb[7:4] : (
							color==32'd5 ? bgrgb[7:4] : bgrgb[7:4])))))));
		assign blue = (isin == 0) ? bgrgb[3:0] :( isdead? bgrgb[11:8] : (
							color==32'd0 ? bgrgb[3:0] : (
							color==32'd1 ? rgbw2[3:0] : (
							color==32'd2 ? rgbw4[3:0] : (
							color==32'd3 ? bgrgb[3:0] : (
							color==32'd4 ? bgrgb[3:0] : (
							color==32'd5 ? bgrgb[3:0] : bgrgb[3:0])))))));
							
							
		assign red = isdead? 4'b1111 : (
							color==32'd0 ? rgbw128[11:8] : (
							color==32'd1 ? rgbw2[11:8] : (
							color==32'd2 ? rgbw4[11:8] : (
							color==32'd3 ? rgbw8[11:8] : (
							color==32'd4 ? rgbw16[11:8] : (
							color==32'd5 ? rgbw32[11:8] : rgbw64[11:8]))))));
		assign green =  isdead? 4'b1111 : (
							color==32'd0 ? rgbw128[7:4] : (
							color==32'd1 ? rgbw2[7:4] : (
							color==32'd2 ? rgbw4[7:4] : (
							color==32'd3 ? rgbw8[7:4] : (
							color==32'd4 ? rgbw16[7:4] : (
							color==32'd5 ? rgbw32[7:4] : rgbw64[7:4]))))));
		assign blue = isdead? 4'b1111 : (
							color==32'd0 ? rgbw128[3:0] : (
							color==32'd1 ? rgbw2[3:0] : (
							color==32'd2 ? rgbw4[3:0] : (
							color==32'd3 ? rgbw8[3:0] : (
							color==32'd4 ? rgbw16[3:0] : (
							color==32'd5 ? rgbw32[3:0] : rgbw64[3:0]))))));
							
	
							*/