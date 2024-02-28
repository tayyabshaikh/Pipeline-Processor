module ALU(
	input logic [3:0] alu_control,
	input logic signed [31:0] A, B,
	output logic eq, lt, ltu, gte, gteu,
	output logic signed [31:0] alu_result
);

always_comb
begin

	eq = (A == B) ? 1'b1 : 1'b0;
	lt = (A < B) ? 1'b1 : 1'b0;
	ltu = (unsigned'(A) < unsigned'(B)) ? 1'b1 : 1'b0;
	gte = (A >= B) ? 1'b1 : 1'b0;
	gteu = (unsigned'(A) >= unsigned'(B)) ? 1'b1 : 1'b0;
	
	if (alu_control == 4'b0000) alu_result = A + B;
	else if (alu_control == 4'b0001) alu_result = A - B;
	else if (alu_control == 4'b0010) alu_result = A & B;
	else if (alu_control == 4'b0011) alu_result = A | B;
	else if (alu_control == 4'b0100) alu_result = A ^ B;
	else if (alu_control == 4'b0101) alu_result = A << B[4:0];
	else if (alu_control == 4'b0110) alu_result = A >> B[4:0];
	else if (alu_control == 4'b0111) alu_result = A >>> B[4:0];
	else if (alu_control == 4'b1000) alu_result = (A < B) ? {{31{1'b0}}, 1'b1} : {32{1'b0}};
	else if (alu_control == 4'b1001) alu_result = (unsigned'(A) < unsigned'(B)) ? {{31{1'b0}}, 1'b1} : {32{1'b0}};
	else alu_result = {32{1'b0}};
	
end

endmodule