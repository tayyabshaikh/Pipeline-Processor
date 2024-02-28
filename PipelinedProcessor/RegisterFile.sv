module RegisterFile(
	input logic CLK, WE3,
	input logic [4:0] A1, A2, A3,
	input logic [31:0] WD3,
	output logic [31:0] RD1, RD2
);

logic [31:0] R [31:0];

initial begin
	R[0] = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
end

assign RD1 = R[A1];
assign RD2 = R[A2];

always @(negedge CLK)
begin

	if (WE3 && (A3 != 5'b00000)) R[A3] <= WD3;

end

endmodule