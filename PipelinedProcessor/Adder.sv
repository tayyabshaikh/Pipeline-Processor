module Adder(
	input logic signed [31:0] A, B,
	output logic signed [31:0] C
);

assign C = A + B;

endmodule