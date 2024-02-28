module DataMemory(
	input logic CLK, WE,
	input logic [2:0] funct3,
	input logic [31:0] A, WD,
	output logic [31:0] RD
);

logic [7:0] mem [2047:0];

always_comb
begin
	
	if (!WE)
	begin
		if (funct3[1:0] == 2'b00)				// LB
		begin
			if (funct3[2] == 1'b0) RD = {{24{mem[A][7]}}, mem[A]};
			else RD = {{24{1'b0}}, mem[A]};
		end
		else if (funct3[1:0] == 2'b01)		// LH
		begin
			if (funct3[2] == 1'b0) RD = {{16{mem[A+1][7]}}, mem[A+1], mem[A]};
			else RD = {{16{1'b0}}, mem[A+1], mem[A]};
		end
		else if (funct3[1:0] == 2'b10)		// LW
			RD = {mem[A+3], mem[A+2], mem[A+1], mem[A]};
		else
			RD = {32{1'b0}};
	end
	else RD = {32{1'b0}};
	
end

always @(posedge CLK)
begin

	if (WE) 
	begin
		// SB
		if (funct3[1:0] == 2'b00) mem[A] <= WD[7:0];
		// SH
		else if (funct3[1:0] == 2'b01) {mem[A+1], mem[A]} <= WD[15:0];
		// SW
		else if (funct3[1:0] == 2'b10) {mem[A+3], mem[A+2], mem[A+1], mem[A]} <= WD;
	end
	
end

endmodule