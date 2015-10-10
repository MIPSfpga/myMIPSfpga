module hexLEDDriver(input [7:0] value, output [6:0] out, input oe);

	reg [6:0] segments;

	always @(value)
		begin
			if (oe == 1)
			begin
			case (value)
				8'h0:   segments = 7'h3F;
				8'h1:   segments = 7'h06;
				8'h2:   segments = 7'h5B;
				8'h3:   segments = 7'h4F;
				8'h4:   segments = 7'h66;
				8'h5:   segments = 7'h6D;
				8'h6:   segments = 7'h7D;
				8'h7:   segments = 7'h07;
				8'h8:   segments = 7'h7F;
				8'h9:   segments = 7'h67;
				8'hA:   segments = 7'h77;
				8'hB:   segments = 7'h7C;
				8'hC:   segments = 7'h39;
				8'hD:   segments = 7'h5E;
				8'hE:   segments = 7'h79;
				8'hF:   segments = 7'h71;
				default: segments = 7'h7f;
			endcase
			end
			else
			begin
				segments = 7'h00;
			end
	   end

	assign out = ~segments;

endmodule
