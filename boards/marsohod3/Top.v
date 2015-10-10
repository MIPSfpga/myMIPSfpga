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

//	input FTDI_BD0,		/* SK_i, TCK_i, TXD_i */
//	output FTDI_BD1,	/* DO_o, TDI_o, RXD_o */
//	input FTDI_BD2,		/* DI_i, TDO_i, RTS#_i */
//	input FTDI_BD3,		/* CS_i, TMS_i, CTS#_i */

module Top(
	input  CLK100MHZ,
	output [7:0] LED,
	inout [7:0] IO,
	input KEY1
	);

//assign IO[5] = IO[7];

wire clk10m, clk24m, clk1m;

altpll0 pll(
	.inclk0(CLK100MHZ),
	.c0(clk10m),
	.c1(clk24m),
	.c2(clk1m)
	);

	wire [35:0] cout;
	counter counter(.out(cout), .clk(clk10m), .reset(0));
	wire slow_clock = cout[8];

	wire my_reset;
	assign LED[0] = my_reset;
	reset mreset(slow_clock, my_reset);

wire [31:0] c;
counter #(.WIDTH(32)) cn(c[31:0], clk24m, 1'b0);

reg [7:0] L;
assign LED[7:4] = L[3:0];

always @(*)
begin
	case (c[27:25])
	4'b0000: L[7:0] = 8'b0001;
	4'b0001: L[7:0] = 8'b0011;
	4'b0010: L[7:0] = 8'b1110;
	4'b0011: L[7:0] = 8'b1100;
	4'b0100: L[7:0] = 8'b1000;
	4'b0101: L[7:0] = 8'b1100;
	4'b0110: L[7:0] = 8'b0111;
	4'b0111: L[7:0] = 8'b0011;
	endcase
end
	
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
		.EJ_TDO(IO[4]),
		.EJ_TMS(0),
		.EJ_TCK(0),
		.EJ_DINT(0),

		.IO_Switches(),
		.IO_Buttons(),
		.IO_RedLEDs(),
		.IO_GreenLEDs(),

		.UART_RX(IO[7]),
		.UART_TX(IO[5])
	);

endmodule

module counter(out, clk, reset);

	parameter WIDTH = 27;

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
