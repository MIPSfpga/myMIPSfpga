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

module mipsfpga_de0_nano(
	input  CLOCK_50,
	input  [3:0]  SW,
	input  [1:0]  KEY,
	output [7:0]  LED,
	inout  [33:0] GPIO_0,
	inout  [33:0] GPIO_1);

	reg reset = 0;
	wire clk10m;
	wire pll_locked;

	altpll0 pll10MHz(
		.inclk0(CLOCK_50),
		.c0(clk10m)
	);
	

	wire [35:0] cout;
	counter counter(.out(cout), .clk(clk10m), .reset(0));

	//wire led_oe = ((cout[0] & cout[1]) & ~my_reset);
	wire led_oe = (cout[0] & cout[1]);

	wire slow_clock = cout[8];
	assign LED[7] = slow_clock;
	assign LED[6] = slow_clock;

	wire my_reset;
	assign LED[1] = my_reset;
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

		.UART_RX(GPIO_0[32]),
		.UART_TX(GPIO_0[33])
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
