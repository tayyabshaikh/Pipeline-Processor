module ExecutePipelineRegisters(
	input logic CLK, CLR,
	input logic [2:0] result_src_D, funct3_D,
	input logic [3:0] alu_control_D,
	input logic alu_src_D, reg_write_D, mem_write_D, reg_data1_and_pc_src_D, jump_D, branch_D,
	input logic [4:0] rs1_D, rs2_D, rd_D,
	input logic [31:0] reg_data1_D, reg_data2_D, ext_imm_D, curr_instr_addr_D, pc_plus4_D,
	
	output logic [2:0] result_src_E, funct3_E,
	output logic [3:0] alu_control_E,
	output logic alu_src_E, reg_write_E, mem_write_E, reg_data1_and_pc_src_E, jump_E, branch_E,
	output logic [4:0] rs1_E, rs2_E, rd_E,
	output logic [31:0] reg_data1_E, reg_data2_E, ext_imm_E, curr_instr_addr_E, pc_plus4_E
);

always @(posedge CLK)
begin
	
	if (CLR)
	begin
		funct3_E <= 3'b000;
		result_src_E <= 3'b000;
		alu_control_E <= 4'b0000;
		alu_src_E <= 1'b0;
		reg_write_E <= 1'b0;
		mem_write_E <= 1'b0;
		reg_data1_and_pc_src_E <= 1'b0;
		jump_E <= 1'b0;
		branch_E <= 1'b0;

		rs1_E <= 5'b00000;
		rs2_E <= 5'b00000;
		rd_E <= 5'b00000;
		
		reg_data1_E <= {32{1'b0}};
		reg_data2_E <= {32{1'b0}};
		ext_imm_E <= {32{1'b0}};
		curr_instr_addr_E <= {32{1'b0}};
		pc_plus4_E <= {32{1'b0}};
	end
	else
	begin
		funct3_E <= funct3_D;
		result_src_E <= result_src_D;
		alu_control_E <= alu_control_D;
		alu_src_E <= alu_src_D;
		reg_write_E <= reg_write_D;
		mem_write_E <= mem_write_D;
		reg_data1_and_pc_src_E <= reg_data1_and_pc_src_D;
		jump_E <= jump_D;
		branch_E <= branch_D;

		rs1_E <= rs1_D;
		rs2_E <= rs2_D;
		rd_E <= rd_D;
		
		reg_data1_E <= reg_data1_D;
		reg_data2_E <= reg_data2_D;
		ext_imm_E <= ext_imm_D;
		curr_instr_addr_E <= curr_instr_addr_D;
		pc_plus4_E <= pc_plus4_D;
	end

end

endmodule