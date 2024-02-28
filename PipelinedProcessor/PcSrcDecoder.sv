module PcSrcDecoder(
	input logic [2:0] funct3,
	input logic eq, lt, ltu, gte, gteu, jump, branch,
	output logic PC_src
);

always_comb
begin

	if ((jump == 1'b1) && (branch == 1'b0)) PC_src = 1'b1;
	else if ((jump == 1'b0) && (branch == 1'b1))
	begin
		if (
			((funct3 == 3'b000) && eq) ||
			((funct3 == 3'b001) && (!eq)) ||
			((funct3 == 3'b100) && lt) ||
			((funct3 == 3'b101) && gte) ||
			((funct3 == 3'b110) && ltu) ||
			((funct3 == 3'b111) && gteu)
		) PC_src = 1'b1;
		else PC_src = 1'b0;
	end
	else PC_src = 1'b0;

end

endmodule