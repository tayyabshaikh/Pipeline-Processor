module ControlUnit(
	input logic funct7_5,
	input logic [2:0] funct3,
	input logic [6:0] op,
	output logic alu_src, reg_write, mem_write, reg_data1_and_pc_src, jump, branch,
	output logic [2:0] ext_imm_control, result_src,
	output logic [3:0] alu_control
);

always_comb
begin

	if (op == 7'b0110011)				// R-Type
	begin
		reg_write = 1'b1;
		mem_write = 1'b0;
		alu_src = 1'b0;
		ext_imm_control = 3'b111;
		reg_data1_and_pc_src = 1'b1;
		alu_control = {
			(~funct7_5) & (~funct3[2]) & funct3[1],
			((~funct7_5) & funct3[2] & (~funct3[1])) | ((~funct7_5) & (~funct3[1]) & funct3[0]) | (funct3[2] & (~funct3[1]) & funct3[0]),
			(funct3[2] & (~funct3[1]) & funct3[0]) | ((~funct7_5) & funct3[2] & funct3[1]),
			((~funct7_5) & (~funct3[2]) & funct3[0]) | (funct7_5 & (~funct3[2]) & (~funct3[1]) & (~funct3[0])) | (funct7_5 & funct3[2] & (~funct3[1]) & funct3[0]) | ((~funct7_5) & funct3[2] & funct3[1] & (~funct3[0]))
		};
		result_src = 3'b000;
		jump = 1'b0;
		branch = 1'b0;
	end
	else if (op == 7'b0010011)			// I-Type
	begin
		reg_write = 1'b1;
		mem_write = 1'b0;
		alu_src = 1'b1;
		ext_imm_control = 3'b000;
		reg_data1_and_pc_src = 1'b1;
		alu_control = {
			(~funct3[2]) & funct3[1],
			(funct3[2] & (~funct3[1])) | ((~funct7_5) & (~funct3[1]) & funct3[0]),
			funct3[2] & (funct3[1] | funct3[0]),
			(funct7_5 & funct3[2] & (~funct3[1]) & funct3[0]) | ((~funct7_5) & (~funct3[2]) & funct3[0]) | ((~funct3[2]) & funct3[1] & funct3[0]) | (funct3[2] & funct3[1] & (~funct3[0]))
		};
		result_src = 3'b000;
		jump = 1'b0;
		branch = 1'b0;
	end
	else if (op == 7'b0100011)			// S-Type
	begin
		reg_write = 1'b0;
		mem_write = 1'b1;
		alu_src = 1'b1;
		ext_imm_control = 3'b001;
		reg_data1_and_pc_src = 1'b1;
		alu_control = 4'b0000;
		result_src = 3'b111;
		jump = 1'b0;
		branch = 1'b0;
	end
	else if (op == 7'b0000011)			// L-Type
	begin
		reg_write = 1'b1;
		mem_write = 1'b0;
		alu_src = 1'b1;
		ext_imm_control = 3'b000;
		reg_data1_and_pc_src = 1'b1;
		alu_control = 4'b0000;
		result_src = 3'b001;
		jump = 1'b0;
		branch = 1'b0;
	end
	else if (op == 7'b1100011)			// B-Type
	begin
		reg_write = 1'b0;
		mem_write = 1'b0;
		alu_src = 1'b0;
		ext_imm_control = 3'b010;
		reg_data1_and_pc_src = 1'b1;
		alu_control = 4'b1111;
		result_src = 3'b111;
		jump = 1'b0;
		branch = 1'b1;
	end
	else if (op == 7'b1101111)			// JAL
	begin
		reg_write = 1'b1;
		mem_write = 1'b0;
		alu_src = 1'b1;
		ext_imm_control = 3'b011;
		reg_data1_and_pc_src = 1'b1;
		alu_control = 4'b1111;
		result_src = 3'b010;
		jump = 1'b1;
		branch = 1'b0;
	end
	else if (op == 7'b1100111)			// JALR
	begin
		reg_write = 1'b1;
		mem_write = 1'b0;
		alu_src = 1'b1;
		ext_imm_control = 3'b000;
		reg_data1_and_pc_src = 1'b0;
		alu_control = 4'b1111;
		result_src = 3'b010;
		jump = 1'b1;
		branch = 1'b0;
	end
	else if (op == 7'b0010111)			// AUIPC
	begin
		reg_write = 1'b1;
		mem_write = 1'b0;
		alu_src = 1'b1;
		ext_imm_control = 3'b100;
		reg_data1_and_pc_src = 1'b1;
		alu_control = 4'b1111;
		result_src = 3'b011;
		jump = 1'b0;
		branch = 1'b0;
	end
	else if (op == 7'b0110111)			// LUI
	begin
		reg_write = 1'b1;
		mem_write = 1'b0;
		alu_src = 1'b1;
		ext_imm_control = 3'b100;
		reg_data1_and_pc_src = 1'b1;
		alu_control = 4'b1111;
		result_src = 3'b100;
		jump = 1'b0;
		branch = 1'b0;
	end
	else
	begin
		reg_write = 1'b0;
		mem_write = 1'b0;
		alu_src = 1'b1;
		ext_imm_control = 3'b111;
		reg_data1_and_pc_src = 1'b1;
		alu_control = 4'b1111;
		result_src = 3'b111;
		jump = 1'b0;
		branch = 1'b0;
	end

end

endmodule