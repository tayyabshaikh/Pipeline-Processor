module MemoryPipelineRegisters(
	input logic CLK,
	input logic [2:0] result_src_E, funct3_E,
	input logic reg_write_E, mem_write_E,
	input logic [31:0] alu_result_E, alu2_mux_result_E, pc_plus4_E, ext_imm_E, pc_plus_ext_imm_E,
	input logic [4:0] rd_E,

	output logic [2:0] result_src_M, funct3_M,
	output logic reg_write_M, mem_write_M,
	output logic [31:0] alu_result_M, alu2_mux_result_M, pc_plus4_M, ext_imm_M, pc_plus_ext_imm_M,
	output logic [4:0] rd_M
);

always @(posedge CLK)
begin

	result_src_M <= result_src_E;
	funct3_M <= funct3_E;
	reg_write_M <= reg_write_E;
	mem_write_M <= mem_write_E;
	alu_result_M <= alu_result_E;
	alu2_mux_result_M <= alu2_mux_result_E;
	pc_plus4_M <= pc_plus4_E;
	ext_imm_M <= ext_imm_E;
	pc_plus_ext_imm_M <= pc_plus_ext_imm_E;
	rd_M <= rd_E;

end

endmodule