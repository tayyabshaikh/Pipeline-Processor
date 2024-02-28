module HazardUnit(
	input logic [2:0] result_src_M, result_src_E,
	input logic reg_write_M, reg_write_W, pc_src_E,
	input logic [4:0] rs1_D, rs2_D, rs1_E, rs2_E, rd_E, rd_M, rd_W,
	
	output logic [2:0] forwardA_E, forwardB_E,
	output logic stall_F, stall_D, flush_D, flush_E
);

always_comb
begin

	// FORWARDING FROM MEMORY AND WRITEBACK STAGE TO EXECUTE STAGE

	if ((rs1_E == rd_M) && (reg_write_M) && (rs1_E != {5{1'b0}}))
	begin
		if (result_src_M == 3'b100) forwardA_E = 3'b011;			// LUI in M Stage
		else if (result_src_M == 3'b011) forwardA_E = 3'b100;		// AUIPC in M Stage
		else forwardA_E = 3'b010;											// Others
	end
	else if ((rs1_E == rd_W) && (reg_write_W) && (rs1_E != {5{1'b0}})) forwardA_E = 3'b001;
	else forwardA_E = 3'b000;
	
	if ((rs2_E == rd_M) && (reg_write_M) && (rs2_E != {5{1'b0}}))
	begin
		if (result_src_M == 3'b100) forwardB_E = 3'b011;			// LUI in M Stage
		else if (result_src_M == 3'b011) forwardB_E = 3'b100;		// AUIPC in M Stage
		else forwardB_E = 3'b010;											// Others
	end
	else if ((rs2_E == rd_W) && (reg_write_W) && (rs2_E != {5{1'b0}})) forwardB_E = 3'b001;
	else forwardB_E = 3'b000;
	
	// STALLING F AND D STAGES IN NEXT CYCLE WHEN L-TYPE INSTRUCTION IN E STAGE IN CURRENT CYCLE
	
	if ((result_src_E == 3'b001) && ((rs1_D == rd_E) || (rs2_D == rd_E)))
	begin
		stall_F = 1'b1;
		stall_D = 1'b1;
	end
	else
	begin
		stall_F = 1'b0;
		stall_D = 1'b0;
	end
	
	// FLUSHING E STAGE ON NEXT CYCLE WHEN L-TYPE INSTRUCTION IN E STAGE CURRENT CYCLE
	// OR ALSO WHEN BRANCH OR JUMP IS BEING TAKEN
	
	if (((result_src_E == 3'b001) && ((rs1_D == rd_E) || (rs2_D == rd_E))) || (pc_src_E)) flush_E = 1'b1;
	else flush_E = 1'b0;
	
	// FLUSHING D STAGE ON WHEN BRANCH ON JUMP IS BEING TAKEN
	
	flush_D = pc_src_E;

end

endmodule