module PipelinedProcessor(input logic CLK);

// Fetch Stage Variables
logic [31:0] instr_F, curr_instr_addr_F, next_instr_addr_F, pc_plus4_F;

// Decode Stage Variables
logic [31:0] instr_D, curr_instr_addr_D, pc_plus4_D, reg_data1_D, reg_data2_D, ext_imm_D;

logic [2:0] ext_imm_control_D, result_src_D;
logic [3:0] alu_control_D;
logic alu_src_D, reg_write_D, mem_write_D, reg_data1_and_pc_src_D, jump_D, branch_D;

// Execute Stage Variables
logic [4:0] rs1_E, rs2_E, rd_E;
logic [31:0] reg_data1_E, reg_data2_E, ext_imm_E, curr_instr_addr_E, pc_plus4_E, alu1_mux_result_E, alu2_mux_result_E, alu3_mux_result_E, alu_result_E, pc_plus_ext_imm_adder_mux_result_E, pc_plus_ext_imm_E;

logic pc_src_E;
logic [2:0] result_src_E, funct3_E;
logic [3:0] alu_control_E;
logic alu_src_E, reg_write_E, mem_write_E, reg_data1_and_pc_src_E, jump_E, branch_E;

// Memory Stage Variables
logic [31:0] alu_result_M, alu2_mux_result_M, pc_plus4_M, ext_imm_M, pc_plus_ext_imm_M, data_mem_output_M;
logic [4:0] rd_M;

logic [2:0] result_src_M, funct3_M;
logic reg_write_M, mem_write_M;

// Writeback Stage Variables
logic [31:0] alu_result_W, data_mem_output_W, pc_plus4_W, ext_imm_W, pc_plus_ext_imm_W, result_W;
logic [4:0] rd_W;

logic [2:0] result_src_W;
logic reg_write_W;

// Hazard Variables
logic [2:0] forwardA_E, forwardB_E;
logic stall_F, stall_D, flush_D, flush_E;

// Flags
logic eq, lt, ltu, gte, gteu;

// FETCH STAGE

ProgramCounter pc(
	CLK, stall_F,
	next_instr_addr_F,
	curr_instr_addr_F
);

Adder pc_plus4_adder(
	curr_instr_addr_F, 32'b0000_0000_0000_0000_0000_0000_0000_0100,
	pc_plus4_F
);

MUX21 pc_mux(
	pc_src_E,
	pc_plus4_F, pc_plus_ext_imm_E,
	next_instr_addr_F
);

InstructionMemory instr_mem(
	curr_instr_addr_F,
	instr_F
);

// DECODE STAGE

DecodePipelineRegisters decode_pr(
	CLK, stall_D, flush_D,
	instr_F, curr_instr_addr_F, pc_plus4_F,
	instr_D, curr_instr_addr_D, pc_plus4_D
);

ControlUnit cu(
	instr_D[30],
	instr_D[14:12],
	instr_D[6:0],
	alu_src_D, reg_write_D, mem_write_D, reg_data1_and_pc_src_D, jump_D, branch_D,
	ext_imm_control_D, result_src_D,
	alu_control_D
);

RegisterFile reg_file(
	CLK, reg_write_W,
	instr_D[19:15], instr_D[24:20], rd_W,
	result_W,
	reg_data1_D, reg_data2_D
);

ExtendImmediate ext_imm_block(
	ext_imm_control_D,
	instr_D[31:7],
	ext_imm_D
);

// EXECUTE STAGE

ExecutePipelineRegisters execute_pr(
	CLK, flush_E,
	result_src_D, instr_D[14:12],
	alu_control_D,
	alu_src_D, reg_write_D, mem_write_D, reg_data1_and_pc_src_D, jump_D, branch_D,
	instr_D[19:15], instr_D[24:20], instr_D[11:7],
	reg_data1_D, reg_data2_D, ext_imm_D, curr_instr_addr_D, pc_plus4_D,
	
	result_src_E, funct3_E,
	alu_control_E,
	alu_src_E, reg_write_E, mem_write_E, reg_data1_and_pc_src_E, jump_E, branch_E,
	rs1_E, rs2_E, rd_E,
	reg_data1_E, reg_data2_E, ext_imm_E, curr_instr_addr_E, pc_plus4_E
);

PcSrcDecoder pc_src_decoder(
	funct3_E,
	eq, lt, ltu, gte, gteu, jump_E, branch_E,
	pc_src_E
);

MUX51 alu1_mux(
	forwardA_E,
	reg_data1_E, result_W, alu_result_M, ext_imm_M, pc_plus_ext_imm_M,
	alu1_mux_result_E
);

MUX51 alu2_mux(
	forwardB_E,
	reg_data2_E, result_W, alu_result_M, ext_imm_M, pc_plus_ext_imm_M,
	alu2_mux_result_E
);

MUX21 alu3_mux(
	alu_src_E,
	alu2_mux_result_E, ext_imm_E,
	alu3_mux_result_E
);

ALU alu(
	alu_control_E,
	alu1_mux_result_E, alu3_mux_result_E,
	eq, lt, ltu, gte, gteu,
	alu_result_E
);

MUX21 pc_plus_ext_imm_adder_mux(
	reg_data1_and_pc_src_E,
	alu1_mux_result_E, curr_instr_addr_E,
	pc_plus_ext_imm_adder_mux_result_E
);

Adder pc_plus_ext_imm_adder(
	pc_plus_ext_imm_adder_mux_result_E, ext_imm_E,
	pc_plus_ext_imm_E
);

// MEMORY STAGE

MemoryPipelineRegisters memory_pr(
	CLK,
	result_src_E, funct3_E,
	reg_write_E, mem_write_E,
	alu_result_E, alu2_mux_result_E, pc_plus4_E, ext_imm_E, pc_plus_ext_imm_E,
	rd_E,
	
	result_src_M, funct3_M,
	reg_write_M, mem_write_M,
	alu_result_M, alu2_mux_result_M, pc_plus4_M, ext_imm_M, pc_plus_ext_imm_M,
	rd_M
);

DataMemory data_mem(
	CLK, mem_write_M,
	funct3_M,
	alu_result_M, alu2_mux_result_M,
	data_mem_output_M
);

// WRITEBACK STAGE

WritebackPipelineRegisters writeback_pr(
	CLK,
	result_src_M,
	reg_write_M,
	alu_result_M, data_mem_output_M, pc_plus4_M, ext_imm_M, pc_plus_ext_imm_M,
	rd_M,
	
	result_src_W,
	reg_write_W,
	alu_result_W, data_mem_output_W, pc_plus4_W, ext_imm_W, pc_plus_ext_imm_W,
	rd_W
);

MUX51 result_mux(
	result_src_W,
	alu_result_W, data_mem_output_W, pc_plus4_W, pc_plus_ext_imm_W, ext_imm_W,
	result_W
);

// HAZARD UNIT

HazardUnit hu(
	result_src_M, result_src_E,
	reg_write_M, reg_write_W, pc_src_E,
	instr_D[19:15], instr_D[24:20], rs1_E, rs2_E, rd_E, rd_M, rd_W,
	
	forwardA_E, forwardB_E,
	stall_F, stall_D, flush_D, flush_E
);

endmodule