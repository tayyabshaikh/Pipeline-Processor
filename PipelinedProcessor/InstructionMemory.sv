module InstructionMemory(
	input logic [31:0] PC,
	output logic [31:0] instr
);

logic [7:0] mem [2047:0];

assign instr = {mem[PC+3], mem[PC+2], mem[PC+1], mem[PC]};

endmodule