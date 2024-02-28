module DecodePipelineRegisters(
	input logic CLK, EN, CLR,
	input logic [31:0] instr_F, curr_instr_addr_F, pc_plus4_F,
	output logic [31:0] instr_D, curr_instr_addr_D, pc_plus4_D
);

always @(posedge CLK)
begin
	
	if (!EN)
	begin
		if (CLR)
		begin
			instr_D <= {32{1'b0}};
			curr_instr_addr_D <= {32{1'b0}};
			pc_plus4_D <= {32{1'b0}};
		end
		else
		begin
			instr_D <= instr_F;
			curr_instr_addr_D <= curr_instr_addr_F;
			pc_plus4_D <= pc_plus4_F;
		end
	end

end

endmodule