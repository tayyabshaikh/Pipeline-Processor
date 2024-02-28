module WritebackPipelineRegisters(
	input logic CLK,
	input logic [2:0] result_src_M,
	input logic reg_write_M,
	input logic [31:0] alu_result_M, data_mem_output_M, pc_plus4_M, ext_imm_M, pc_plus_ext_imm_M,
	input logic [4:0] rd_M,
	
	output logic [2:0] result_src_W,
	output logic reg_write_W,
	output logic [31:0] alu_result_W, data_mem_output_W, pc_plus4_W, ext_imm_W, pc_plus_ext_imm_W,
	output logic [4:0] rd_W
);

always @(posedge CLK)
begin

	result_src_W <= result_src_M;
	reg_write_W <= reg_write_M;
	alu_result_W <= alu_result_M;
	data_mem_output_W <= data_mem_output_M;
	pc_plus4_W <= pc_plus4_M;
	ext_imm_W <= ext_imm_M;
	pc_plus_ext_imm_W <= pc_plus_ext_imm_M;
	rd_W <= rd_M;

end

endmodule