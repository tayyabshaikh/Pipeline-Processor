module MUX51(
	input logic [2:0] src,
	input logic [31:0] A, B, C, D, E,
	output logic [31:0] result
);

always_comb
begin

	if (src == 3'b000) result = A;
	else if (src == 3'b001) result = B;
	else if (src == 3'b010) result = C;
	else if (src == 3'b011) result = D;
	else if (src == 3'b100) result = E;
	else result = {32{1'b0}};
	
end

endmodule