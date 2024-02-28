module MUX21(
	input logic src,
	input logic [31:0] A, B,
	output logic [31:0] C
);

assign C = (src == 1'b1) ? B : A;

endmodule