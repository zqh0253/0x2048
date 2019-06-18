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
	output hs,
	output vs,
	output [3:0] red,
	output [3:0] green,
	output [3:0] blue,
	input [31:0] color,
	output [9:0] x_ptr,
	output [9:0] y_ptr,
	output [8:0] addrb,
	output reg [8:0] pos,
	output reg [1:0] run,
	output reg [31:0] score,
	output valid
);
	wire isin;
	wire [11:0] rgbw2;
	wire [11:0] rgbw4;
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
	
	/*always @(posedge rst) begin
		nowrst = nowrst + 10'd3;
	end*/
	
	always @(posedge clk) begin
		if (rst) begin 
			pos   =  9'd256;
			run   =  2'd3;
			cur   =  4'd7;
			score = 32'd0;
			//lastrst = lastrst + 1;
		end
		else if (color[11:0] && addrb == pos) begin
			cur = color[23:20];
			if (run == 2'd3) run = {1'b0, color[24]};
			else if (run[0] ^ color[24])
				begin
					run = 2'd3;
					score = score + 32'd1;
					if (pos == 9'd511) pos = 9'd0;
					else pos = pos + 9'd1;
				end
		end
	end
	
	assign x_ptr = cnt_x - (96+40+8);
	assign y_ptr = cnt_y - (2+25+8);
	
	
	wire addr_item2 = y_ptr * 90 + x_ptr;
	wire addr_item4 = (y_ptr - 100) * 90 + x_ptr - 100;
	item2(clk, 0, addr_item2, 0, rgbw2);
	reditem(clk, 0, addr_item4, 0, rgbw4);
	
	
	assign isin2 = (x_ptr <=90) && (y_ptr<=90);
	assign isin4 = (x_ptr <= 190 && x_ptr >=100 && y_ptr<=190 && y_ptr>=100);
	
	assign hs = !((cnt_x >= 0) && (cnt_x < 96));
	assign vs = !((cnt_y >= 0) && (cnt_y < 2));
	assign valid = x_ptr && x_ptr < 640 && y_ptr >= 0 && y_ptr < 480;

	//assign addrb = 32'h30800 + y_ptr* 320 + (x_ptr>>2);
							//  base + 640*2*y + £¨x//2£©*4
	assign red =   ((isin2 == 1'b1) ? rgbw2[11:8]:isin4?rgbw4[11:8]:4'b0000);
	assign green = ((isin2 == 1'b1) ? rgbw2[7:4]:isin4?rgbw4[7:4]:4'b0000);
	assign blue =  ((isin2 == 1'b1) ? rgbw2[3:0]:isin4?rgbw4[3:0]:4'b0000);
	
endmodule
