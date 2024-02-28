module ExtendImmediate(
	input logic [2:0] ext_imm_control,
	input logic [31:7] imm,
	output logic [31:0] ext_imm
);

always_comb
begin
	// I-Type
	if (ext_imm_control == 3'b000) ext_imm = {{20{imm[31]}}, imm[31:20]};
	// S-Type
	else if (ext_imm_control == 3'b001) ext_imm = {{20{imm[31]}}, imm[31:25], imm[11:7]};
	// B-Type
	else if (ext_imm_control == 3'b010) ext_imm = {{20{imm[31]}}, imm[7], imm[30:25], imm[11:8], 1'b0};
	// J-Type
	else if (ext_imm_control == 3'b011) ext_imm = {{12{imm[31]}}, imm[19:12], imm[20], imm[30:21], 1'b0};
	// U-Type
	else if (ext_imm_control == 3'b100) ext_imm = {imm[31:12], {12{1'b0}}};
	else ext_imm = {32{1'b0}};
end

endmodule