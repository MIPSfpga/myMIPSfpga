module reset(clk, reset);
	parameter WIDTH = 8;

	input clk;
	output reg reset = 1;

	reg [WIDTH - 1 : 0]   out = 0;
	wire clk;

	always @(posedge clk)
		if (reset == 1)
			out <= out + 1;

	always @(posedge clk)
		if (out[4:0] == 5'b11111)
			reset <= 0;
endmodule /* reset */

module mipsfpga_de1_soc(
	input  CLOCK_50,
	output [6:0]  HEX0,
	output [6:0]  HEX1,
	output [6:0]  HEX2,
	output [6:0]  HEX3,
	output [6:0]  HEX4,
	output [6:0]  HEX5,
	input  [9:0]  SW,
	input  [3:0]  KEY,
	output [9:0]  LEDR,
	inout  [35:0] GPIO_0,
	inout  [35:0] GPIO_1);

	reg reset = 0;
	wire clk10m;
	wire pll_locked;

	pll10MHz pll_10(
		.refclk(CLOCK_50),
		.rst(reset),
		.outclk_0(clk10m),
		.locked(pll_locked));

	wire [35:0] cout;
	counter counter(.out(cout), .clk(clk10m), .reset(0));

	//wire led_oe = ((cout[0] & cout[1]) & ~my_reset);
	wire led_oe = (cout[0] & cout[1]);

	// hexLEDDriver segment0(.value(cout[15:12]), .out(HEX0), .oe(led_oe));
	// hexLEDDriver segment1(.value(cout[19:16]), .out(HEX1), .oe(led_oe));
	// hexLEDDriver segment2(.value(cout[23:20]), .out(HEX2), .oe(led_oe));
	// hexLEDDriver segment3(.value(cout[27:24]), .out(HEX3), .oe(led_oe));
	// hexLEDDriver segment4(.value(cout[31:28]), .out(HEX4), .oe(led_oe));
	// hexLEDDriver segment5(.value(cout[35:32]), .out(HEX5), .oe(led_oe));

	hexLEDDriver segment0(.value(HADDR[3:0]), .out(HEX0), .oe(led_oe));
	hexLEDDriver segment1(.value(HADDR[7:4]), .out(HEX1), .oe(led_oe));
	hexLEDDriver segment2(.value(HADDR[11:8]), .out(HEX2), .oe(led_oe));
	hexLEDDriver segment3(.value(HADDR[15:12]), .out(HEX3), .oe(led_oe));
	hexLEDDriver segment4(.value(HADDR[19:16]), .out(HEX4), .oe(led_oe));
	hexLEDDriver segment5(.value(HADDR[23:20]), .out(HEX5), .oe(led_oe));

	wire slow_clock = cout[8];
	assign LEDR[9] = slow_clock;
	assign LEDR[6] = slow_clock;


	wire my_reset;
	assign LEDR[1] = my_reset;
	reset mreset(slow_clock, my_reset);


	wire [31:0] HADDR, HRDATA, HWDATA;
	wire HWRITE;

	mfp_system mfp_system(
		.SI_ClkIn         (clk10m),
		//.SI_Reset         (KEY[0]),
		.SI_Reset         (my_reset),
		//.SI_ColdReset(KEY[1]),
		.SI_ColdReset(my_reset),

		.HADDR(HADDR),
		.HRDATA(HRDATA),
		.HWDATA(HWDATA),
		.HWRITE(HWRITE),

		.EJ_TRST_N_probe(1),
		.EJ_TDI(0),
		.EJ_TDO(GPIO_0[4]),
		.EJ_TMS(0),
		.EJ_TCK(0),
		.EJ_DINT(0),

		.IO_Switches(),
		.IO_Buttons(),
		.IO_RedLEDs(),
		.IO_GreenLEDs(),

		.UART_RX(GPIO_0[3]),
		.UART_TX(GPIO_0[1])
	);

endmodule

module counter(out, clk, reset);

	parameter WIDTH = 36;

	output [WIDTH - 1 : 0] out;
	input clk, reset;

	reg [WIDTH - 1 : 0] out;
	wire clk, reset;

	always @(posedge clk)
		if (reset)
			out <= 0;
		else
			out <= out + 1;

endmodule /* counter */
