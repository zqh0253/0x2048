`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:44:45 05/10/2016 
// Design Name: 
// Module Name:    Top_lab9 
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
module Top(
	input RSTN,
	input [3:0] BTN_y,
	input PS2_clk,
	input PS2_data,
	output [4:0] BTN_x,
	input [15:0] SW,
	input clk_100mhz,
	output CR,
	output RDY,
	output readn,
	output seg_clk,
	output seg_sout,
	output SEG_PEN,
	output seg_clrn,
	output led_clk,
	output led_sout,
	output LED_PEN,
	output led_clrn,
	output Buzzer,
	output HSYNC,
	output VSYNC,
	output [3:0] Red,
	output [3:0] Green,
	output [3:0] Blue
);
	
	//	SAnti_jitter
	wire rst;
	wire [4:0] Key_out;
	wire [3:0] BTN_OK;
	wire [15:0] SW_OK;
	wire [3:0] Pulse;
	//	clk_div
	wire [31:0] Div;
	wire Clk_CPU, IO_clk;
	//	SEnter_2_32
	wire [31:0] Ai;
	wire [31:0] Bi;
	wire [7:0] blink;
	//	SSeg7_Dev
	wire [31:0] Disp_num;
	wire [7:0] point_out;
	wire [7:0] LE_out;
	//	MCPU
	wire mem_w;
	wire [31:0] Addr_out;
	wire [31:0] Data_in;
	wire [31:0] Data_out;
	wire [31:0] inst;
	wire [31:0] PC;
	wire [4:0] State;
	//	MIO_BUS
	wire [31:0] CPU2IO;
	wire GPIOE0, GPIOF0;
	wire [15:0] LED_out;
	//	RAM_B
	wire [8:0] addra;
	wire wea;
	wire [31:0] dina;
	wire [31:0] douta;
	wire [8:0] addrb;
	wire web;
	wire [31:0] doutb;
	//	Counter_x
	wire [1:0] counter_ch;
	wire [31:0] Counter_out;
	wire counter2_out, counter1_out, counter0_out, counter_we;
	// buzzer
	assign Buzzer = 1;
	// VGA
	wire clk_VGA;
	wire [8:0] findpos;
	wire [1:0] findrun;
	wire [31:0] score;
	wire [9:0] PS2_key;
	assign clk_VGA = Div[1];
	
	assign IO_clk = ~Clk_CPU;
	
	SAnti_jitter	U9(
		.RSTN(RSTN), .clk(clk_100mhz), .Key_y(BTN_y), .Key_x(BTN_x), .SW(SW), .readn(readn), 
		.CR(CR), .Key_out(Key_out), .Key_ready(RDY), .pulse_out(Pulse), .BTN_OK(BTN_OK), .SW_OK(SW_OK), .rst(rst)
	);
	
	clk_div	U8(
		.clk(clk_100mhz), .rst(rst), .SW2(SW_OK[2]), 
		.clkdiv(Div), .Clk_CPU(Clk_CPU)
	);
	
	SEnter_2_32	M4(
		.clk(clk_100mhz), .Din(Key_out), .D_ready(RDY), .BTN(BTN_OK[2:0]), .Ctrl({SW_OK[7:5], SW_OK[15], SW_OK[0]}), 
		.readn(readn), .Ai(Ai), .Bi(Bi), .blink(blink)
	);

	SSeg7_Dev	U6(
		.clk(clk_100mhz), .rst(rst), .Start(Div[20]), .SW0(SW_OK[0]), .flash(Div[25]), 
		.Hexs(Disp_num), .point(point_out), .LES(LE_out), 
		.seg_clk(seg_clk), .seg_sout(seg_sout), .SEG_PEN(SEG_PEN), .seg_clrn(seg_clrn)
	);
	
	MCPU U1(
		.clk(Clk_CPU), .reset(rst), .inst_out(inst), .INT(counter0_out), .PC_out(PC), 
		.mem_w(mem_w), .Addr_out(Addr_out), .Data_in(Data_in), .Data_out(Data_out), .state(State), .MIO_ready(1'b1)
	);

	MIO_BUS	U4(
		.clk(clk_100mhz), .rst(rst), .BTN(BTN_OK), .SW(SW_OK), 
		.mem_w(mem_w), .addr_bus(Addr_out), .Cpu_data4bus(Data_in), .Cpu_data2bus(Data_out), 
		.ram_data_in(dina), .data_ram_we(wea), .ram_addr(addra), .ram_data_out(douta), 
		.Peripheral_in(CPU2IO), .GPIOe0000000_we(GPIOE0), .GPIOf0000000_we(GPIOF0), .led_out(LED_out), 
		.counter_out(Counter_out), .counter2_out(counter2_out), .counter1_out(counter1_out), 
		.counter0_out(counter0_out), .counter_we(counter_we), .ps2kb_key(PS2_key)
	);
	
	PS2 ps2(.clk(clk_100mhz), .rst(rst), .ps2_clk(PS2_clk), .ps2_data(PS2_data), 
						.data_out(PS2_key), .ready());
	
	RAM_B	U3(
		.addra(addra), .wea(wea), .dina(dina), .clka(clk_100mhz), .douta(douta),
		.addrb(addrb), .web(1'b0), .clkb(clk_100mhz), .doutb(doutb)
	);
	
	Counter_x	U10(
		.clk(IO_clk), .rst(rst), .clk0(Div[8]), .clk1(Div[9]), .clk2(Div[11]), 
		.counter_we(counter_we), .counter_val(CPU2IO), .counter_ch(counter_ch), 
		.counter0_OUT(counter0_out), .counter1_OUT(counter1_out), .counter2_OUT(counter2_out), .counter_out(Counter_out)
	);
	
	Multi_8CH32	U5(
		.clk(IO_clk), .rst(rst), .EN(GPIOE0), .Test(SW_OK[7:5]),
		.point_in({Div[31:0], Div[31:13], State[4:0], 8'b0}), .LES(64'b0),
		.Data0(CPU2IO), .data1({2'd0, findrun, 14'd0, addrb}), .data2(inst), .data3({23'd0, findpos}), 
		.data4(score), .data5(doutb), .data6(Data_in), .data7(PC), 
		.Disp_num(Disp_num), .point_out(point_out), .LE_out(LE_out)
	);
	
	SPIO	U7(
		.clk(IO_clk), .rst(rst), .EN(GPIOF0), .Start(Div[20]), .P_Data(CPU2IO), 
		.counter_set(counter_ch), .LED_out(LED_out), 
		.led_clk(led_clk), .led_sout(led_sout), .LED_PEN(LED_PEN), .led_clrn(led_clrn)
	);
	
	VGA_ctrl	U11(
		.clk(clk_VGA), .rst(rst), .hs(HSYNC), .vs(VSYNC), .addrb(addrb), .score(score), .SW(SW_OK[8]),
		.color(doutb), .red(Red), .green(Green), .blue(Blue), .pos(findpos), .run(findrun)
	);

endmodule
