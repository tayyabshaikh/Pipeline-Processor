module ProgramCounter(
	input logic CLK, EN,
	input logic [31:0] next_instr_addr,
	output logic [31:0] curr_instr_addr
);

initial begin
	curr_instr_addr = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
end

always @(posedge CLK)
begin
	if (!EN) curr_instr_addr <= next_instr_addr;
end

endmodule