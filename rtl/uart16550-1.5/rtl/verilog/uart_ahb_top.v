//////////////////////////////////////////////////////////////////////
////                                                              ////
////  Trivial AHB wrapper for the "UART 16550 compatible" project ////
////  http://www.opencores.org/cores/uart16550/                   ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on

`include "uart_defines.v"

module uart_ahb_top(
	// AHB signals
	input         HCLK,
	input         HRESETn,
	input  [31:0] HADDR,
	input  [ 2:0] HBURST,
	input         HMASTLOCK,
	input  [ 3:0] HPROT,
	input         HSEL,
	input  [ 2:0] HSIZE,
	input  [ 1:0] HTRANS,
	input  [31:0] HWDATA,
	input         HWRITE,
	output [31:0] HRDATA,
	output        HREADY,
	output        HRESP,
	input         SI_Endian,

	output int_o, // interrupt request

	// UART signals
	// serial input/output
	output stx_pad_o,
	input srx_pad_i
	);

	parameter uart_addr_width = 5;

	wire [uart_addr_width - 1 : 0] wb_adr_int;
	assign wb_adr_int = HADDR[uart_addr_width-1:2];

	wire wb_clk_i;
	assign wb_clk_i = HCLK;
	wire wb_rst_i;
	assign wb_rst_i = ~HRESETn;

	assign HREADY = 1'b1;
	assign HRESP  = 1'b0;

	reg [ 1:0] HTRANS_dly;
	reg [31:0] HADDR_dly;
	reg [7:0] HWDATA_dly;
	reg HWRITE_dly;
	reg HSEL_dly;

	always @ (posedge HCLK)
	begin
		HTRANS_dly <= HTRANS;
		HADDR_dly  <= HADDR;
		HWRITE_dly <= HWRITE;
		HWDATA_dly <= HWDATA[7:0];
		HSEL_dly   <= HSEL;
	end

	// Write enable for registers
	wire we_o = HTRANS_dly != `HTRANS_IDLE && HSEL_dly && HWRITE_dly;
	// Read enable for registers
	wire re_o = HSEL && ~HWRITE;

	wire [7:0] wb_dat8_i; // 8-bit internal data input
	wire [7:0] wb_dat8_o; // 8-bit internal data output

	assign wb_dat8_i = HWDATA;
	assign HRDATA = wb_dat8_o;

	// Registers
	uart_regs	regs(
		.clk(wb_clk_i),
		.wb_rst_i(wb_rst_i),
		.wb_addr_i(wb_adr_int),
		.wb_dat_i(wb_dat8_i),
		.wb_dat_o(wb_dat8_o),
		.wb_we_i(we_o),
		.wb_re_i(re_o),
		.modem_inputs({cts_pad_i, dsr_pad_i, ri_pad_i, dcd_pad_i}),
		.stx_pad_o(stx_pad_o),
		.srx_pad_i(srx_pad_i)
	);

endmodule
