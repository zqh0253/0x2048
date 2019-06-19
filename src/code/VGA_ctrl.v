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
	output  [3:0] red,
	output  [3:0] green,
	output  [3:0] blue,
	input [31:0] color,
	output [9:0] x_ptr,
	output [9:0] y_ptr,
	output reg [12:0] addrb,
	output reg [8:0] pos,
	output reg [1:0] run,
	output reg [31:0] score,
	output valid
);
	wire isin;
	wire [11:0] rgbw2;
	wire [11:0] rgbw4;
	wire [11:0] rgbw8;
	wire [11:0] rgbw16;
	wire [11:0] rgbw32;
	wire [11:0] rgbw64;
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
	
		
	wire [13:0]addr_item;
	reg isdead = 0;
	
	assign addr_item = ((x_ptr-40) - ((x_ptr-40) / 8'd110) * 8'd110)+90*((y_ptr-30)-((y_ptr-30)/8'd110)*8'd110);
	
	
	assign hs = !((cnt_x >= 0) && (cnt_x < 96));
	assign vs = !((cnt_y >= 0) && (cnt_y < 2));
	assign valid = x_ptr && x_ptr < 640 && y_ptr >= 0 && y_ptr < 480;

	assign red = 0;
	assign green = 15;
	assign red = 0;
	
endmodule
/*always @ (posedge clk) begin
		if (x_ptr>=40 && x_ptr<=130 && y_ptr>=30 && y_ptr<=120)	addrb <= 12'h800;
		if (x_ptr>=150 && x_ptr<=240 && y_ptr>=30 && y_ptr<=120)	addrb <= 12'h804;
		if (x_ptr>=260 && x_ptr<=350 && y_ptr>=30 && y_ptr<=120)	addrb <= 12'h808;
		if (x_ptr>=370 && x_ptr<=460 && y_ptr>=30 && y_ptr<=120)	addrb <= 12'h80C;
		
		if (x_ptr>=40 && x_ptr<=130 && y_ptr>=140 && y_ptr<=230)	addrb <= 12'h810;
		if (x_ptr>=150 && x_ptr<=240 && y_ptr>=140 && y_ptr<=230)	addrb <= 12'h814;
		if (x_ptr>=260 && x_ptr<=350 && y_ptr>=140 && y_ptr<=230)	addrb <= 12'h818;
		if (x_ptr>=370 && x_ptr<=460 && y_ptr>=140 && y_ptr<=230)	addrb <= 12'h81C;
		
		if (x_ptr>=40 && x_ptr<=130 && y_ptr>=250 && y_ptr<=340)	addrb <= 12'h820;
		if (x_ptr>=150 && x_ptr<=240 && y_ptr>=250 && y_ptr<=340)	addrb <= 12'h824;
		if (x_ptr>=260 && x_ptr<=350 && y_ptr>=250 && y_ptr<=340)	addrb <= 12'h828;
		if (x_ptr>=370 && x_ptr<=460 && y_ptr>=250 && y_ptr<=340)	addrb <= 12'h82C;
		
		if (x_ptr>=40 && x_ptr<=130 && y_ptr>=360 && y_ptr<=470)	addrb <= 12'h830;
		if (x_ptr>=150 && x_ptr<=240 && y_ptr>=360 && y_ptr<=470)	addrb <= 12'h834;
		if (x_ptr>=260 && x_ptr<=350 && y_ptr>=360 && y_ptr<=470)	addrb <= 12'h838;
		if (x_ptr>=370 && x_ptr<=460 && y_ptr>=360 && y_ptr<=470)	addrb <= 12'h83C;
		
		if (color == 16'hFFFF) begin isdead <= 1; end
		if (isdead==1) 	begin red <= 4'b1111; green <= 4'b1111; blue <= 4'b1111; end
		else if (color == 0)		begin red <= 4'b1111; green <= 4'b0000; blue <= 4'b1111; end
		else if (color == 1) 	begin red <= rgbw2[11:8]; green <= rgbw2[7:4]; blue <= rgbw2[3:0]; end
		else if (color == 2) 	begin red <= rgbw4[11:8]; green <= rgbw4[7:4]; blue <= rgbw4[3:0]; end
		else if (color == 3) 	begin red <= rgbw8[11:8]; green <= rgbw8[7:4]; blue <= rgbw8[3:0]; end
		else if (color == 4) 	begin red <= rgbw16[11:8]; green <= rgbw16[7:4]; blue <= rgbw16[3:0]; end
		else if (color == 5) 	begin red <= rgbw32[11:8]; green <= rgbw32[7:4]; blue <= rgbw32[3:0]; end
		else begin red <= rgbw32[11:8]; green <= rgbw32[7:4]; blue <= rgbw32[3:0]; end
		
		
	item2(clk, 0, addr_item, 0, rgbw2);
	item4(clk, 0, addr_item, 0, rgbw4);
	item8(clk, 0, addr_item, 0, rgbw8);
	item16(clk, 0, addr_item, 0, rgbw16);
	item32(clk, 0, addr_item, 0, rgbw32);
	item64(clk, 0, addr_item, 0, rgbw64);
	
	
	
		*/
		//red <= 15;
		//green <= 15;
		//blue <= 15;
	//end