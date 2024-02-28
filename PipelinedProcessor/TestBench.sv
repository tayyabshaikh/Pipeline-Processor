`timescale 1s/1fs

module TestBench();

int j = 0;
int i, failed;
logic CLK;
real CLK_FREQ = 64'd2_000_000_000;
real delay;
logic [31:0] instructions [0:55] =
'{
	'{32'b1010_1011_1100_1101_1110_01000_0110111},		// LUI x8, 0xABCDE
	'{32'b0000000_01000_00000_000_01001_0110011},		// ADD x9, zero, x8
	'{32'b000000001010_00000_000_10010_0010011},			// ADDI x18, zero, 10
	'{32'b000000000010_00000_000_10011_0010011},			// ADDI x19, zero, 2
	'{32'b0100000_10011_10010_000_10100_0110011},		// SUB x20, x18, x19
	'{32'b0000000_10011_10010_001_10100_0110011},		// SLL x20, x18, x19
	'{32'b0000000_10011_10010_101_10100_0110011},		// SRL x20, x18, x19
	'{32'b0100000_10011_10010_101_10100_0110011},		// SRA x20, x18, x19
	'{32'b0000000_10011_10010_010_10100_0110011},		// SLT x20, x18, x19
	'{32'b0000000_10010_10011_010_10100_0110011},		// SLT x20, x19, x18
	'{32'b0000000_10011_10010_100_10100_0110011},		// XOR x20, x18, x19
	'{32'b0000000_10011_10010_110_10100_0110011},		// OR x20, x18, x19
	'{32'b0000000_10011_10010_111_10100_0110011},		// AND x20, x18, x19
	'{32'b000000000101_10010_010_10100_0010011},			// SLTI x20, x18, 5
	'{32'b000000001011_10010_010_10100_0010011},			// SLTI x20, x18, 11
	'{32'b000000000010_10010_100_10100_0010011},			// XORI x20, x18, 2
	'{32'b000000000010_10010_110_10100_0010011},			// ORI x20, x18, 2
	'{32'b000000000010_10010_111_10100_0010011},			// ANDI x20, x18, 2
	'{32'b0000000_00001_10010_001_10100_0010011},		// SLLI x20, x18, 1
	'{32'b0000000_00001_10010_101_10100_0010011},		// SRLI x20, x18, 1
	'{32'b0100000_00001_10010_101_10100_0010011},		// SRAI x20, x18, 1
	'{32'b0001_0010_0011_01000_000_01000_0010011},		// ADDI x8, x8, 0x123
	'{32'b0000000_01000_00000_010_00000_0100011},		// SW x8, 0(zero)
	'{32'b0000000_01000_00000_001_00100_0100011},		// SH x8, 4(zero)
	'{32'b0000000_01000_00000_000_01000_0100011},		// SB x8, 8(zero)
	'{32'b000000000000_00000_010_10100_0000011},			// LW x20, 0(zero)
	'{32'b000000000000_00000_001_10100_0000011},			// LH x20, 0(zero)
	'{32'b000000000000_00000_101_10100_0000011},			// LHU x20, 0(zero)
	'{32'b000000000000_00000_000_10100_0000011},			// LB x20, 0(zero)
	'{32'b000000000000_00000_100_10100_0000011},			// LBU x20, 0(zero)
	'{32'b0000000_01000_01000_000_01000_1100011},		// BEQ x8, x8, 8
	'{32'b000000000001_10010_000_10100_0010011},			// ADDI x20, x18, 1
	'{32'b000000000101_10010_000_10100_0010011},			// ADDI x20, x18, 5
	'{32'b0000000_10011_10010_001_01000_1100011},		// BNE x18, x19, 8
	'{32'b000000000001_10100_000_10100_0010011},			// ADDI x20, x20, 1
	'{32'b000000000101_10100_000_10100_0010011},			// ADDI x20, x20, 5
	'{32'b0000000_10010_10011_100_01000_1100011},		// BLT x19, x18, 8
	'{32'b000000000001_10100_000_10100_0010011},			// ADDI x20, x20, 1
	'{32'b000000000101_10100_000_10100_0010011},			// ADDI x20, x20, 5
	'{32'b0000000_10011_10010_101_01000_1100011},		// BGTE x18, x19, 8
	'{32'b000000000001_10100_000_10100_0010011},			// ADDI x20, x20, 1
	'{32'b000000000101_10100_000_10100_0010011},			// ADDI x20, x20, 5
	'{32'b00000000100000000000_10101_1101111},			// JAL x21, 8
	'{32'b000000000001_10100_000_10100_0010011},			// ADDI x20, x20, 1
	'{32'b000000000101_10100_000_10100_0010011},			// ADDI x20, x20, 5
	'{32'b00000000000000000000_10101_0010111},			// AUIPC x21, 0x00000
	'{32'b000000001100_10101_000_00001_1100111},			// JALR zero, x21, 12
	'{32'b000000000001_10100_000_10100_0010011},			// ADDI x20, x20, 1
	'{32'b000000000101_10100_000_10100_0010011},			// ADDI x20, x20, 5
	// Checking Forwarding in Hazard Unit
	'{32'b0000000_10100_10100_111_10101_0110011},		// AND x21, x20, x20
	'{32'b0000000_10100_10100_100_10101_0110011},		// XOR x21, x20, x20
	'{32'b0000000_10100_10100_110_10101_0110011},		// OR x21, x20, x20
	// Checking Stall in Hazrad Unit
	'{32'b000000000000_00000_010_10101_0000011},			// LW x21, 0(zero)
	'{32'b0000000_10101_10101_111_10110_0110011},		// AND x22, x21, x21
	'{32'b0000000_10101_10101_100_10110_0110011},		// XOR x22, x21, x21
	'{32'b0000000_10101_10101_110_10110_0110011}			// OR x22, x21, x21
};

PipelinedProcessor dut(CLK);

initial
begin
	
	for (i = 0; i < $size(instructions); i = i + 1)
	begin
		{dut.instr_mem.mem[j+3], dut.instr_mem.mem[j+2], dut.instr_mem.mem[j+1], dut.instr_mem.mem[j]} = instructions[i];
		j = j + 4;
	end

	delay = 1/(CLK_FREQ * 2);
	$display("\n\n");
	
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	
	#delay
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	
	#delay
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	
	#delay
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("LUI x8, 0xABCDE");
	if (dut.reg_file.R[8] === 32'habcde000)
		$display("TEST PASSED!		s0 = x8 = %h\n", dut.reg_file.R[8]);
	else begin
		$display("TEST FAILED!		s0 = x8 = %h, but should be abcde000\n", dut.reg_file.R[8]);
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("ADD x9, zero, x8");
	if (dut.reg_file.R[9] === 32'habcde000)
		$display("TEST PASSED!		s1 = x9 = %h\n", dut.reg_file.R[9]);
	else begin
		$display("TEST FAILED!		s1 = x9 = %h, but should be abcde000\n", dut.reg_file.R[9]);
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("ADDI x18, zero, 10");
	if (dut.reg_file.R[18] === 10)
		$display("TEST PASSED!		s2 = x18 = %d\n", dut.reg_file.R[18]);
	else begin
		$display("TEST FAILED!		s2 = x18 = %d, but should be abcde000\n", dut.reg_file.R[18]);
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("ADDI x19, zero, 2");
	if (dut.reg_file.R[19] === 2)
		$display("TEST PASSED!		s3 = x19 = %d\n", dut.reg_file.R[19]);
	else begin
		$display("TEST FAILED!		s3 = x19 = %d, but should be 2\n", dut.reg_file.R[19]);
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("SUB x20, x18, x19");
	if (dut.reg_file.R[20] === 8)
		$display("TEST PASSED!		s4 = x20 = %d\n", dut.reg_file.R[20]);
	else begin
		$display("TEST FAILED!		s4 = x20 = %d, but should be 2\n", dut.reg_file.R[20]);
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("SLL x20, x18, x19");
	if (dut.reg_file.R[20] === 40)
		$display("TEST PASSED!		s4 = x20 = %d\n", dut.reg_file.R[20]);
	else begin
		$display("TEST FAILED!		s4 = x20 = %d, but should be 40\n", dut.reg_file.R[20]);
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("SRL x20, x18, x19");
	if (dut.reg_file.R[20] === 2)
		$display("TEST PASSED!		s4 = x20 = %d\n", dut.reg_file.R[20]);
	else begin
		$display("TEST FAILED!		s4 = x20 = %d, but should be 2\n", dut.reg_file.R[20]);
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("SRA x20, x18, x19");
	if (dut.reg_file.R[20] === 2)
		$display("TEST PASSED!		s4 = x20 = %d\n", dut.reg_file.R[20]);
	else begin
		$display("TEST FAILED!		s4 = x20 = %d, but should be 2\n", dut.reg_file.R[20]);
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("SLT x20, x18, x19");
	if (dut.reg_file.R[20] === 0)
		$display("TEST PASSED!		s4 = x20 = %d\n", dut.reg_file.R[20]);
	else begin
		$display("TEST FAILED!		s4 = x20 = %d, but should be 0\n", dut.reg_file.R[20]);
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("SLT x20, x19, x18");
	if (dut.reg_file.R[20] === 1)
		$display("TEST PASSED!		s4 = x20 = %d\n", dut.reg_file.R[20]);
	else begin
		$display("TEST FAILED!		s4 = x20 = %d, but should be 1\n", dut.reg_file.R[20]);
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("XOR x20, x18, x19");
	if (dut.reg_file.R[20] === 8)
		$display("TEST PASSED!		s4 = x20 = %d\n", dut.reg_file.R[20]);
	else begin
		$display("TEST FAILED!		s4 = x20 = %d, but should be 8\n", dut.reg_file.R[20]);
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("OR x20, x18, x19");
	if (dut.reg_file.R[20] === 10)
		$display("TEST PASSED!		s4 = x20 = %d\n", dut.reg_file.R[20]);
	else begin
		$display("TEST FAILED!		s4 = x20 = %d, but should be 10\n", dut.reg_file.R[20]);
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("AND x20, x18, x19");
	if (dut.reg_file.R[20] === 2)
		$display("TEST PASSED!		s4 = x20 = %d\n", dut.reg_file.R[20]);
	else begin
		$display("TEST FAILED!		s4 = x20 = %d, but should be 2\n", dut.reg_file.R[20]);
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("SLTI x20, x18, 5");
	if (dut.reg_file.R[20] === 0)
		$display("TEST PASSED!		s4 = x20 = %d\n", dut.reg_file.R[20]);
	else begin
		$display("TEST FAILED!		s4 = x20 = %d, but should be 0\n", dut.reg_file.R[20]);
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("SLTI x20, x18, 11");
	if (dut.reg_file.R[20] === 1)
		$display("TEST PASSED!		s4 = x20 = %d\n", dut.reg_file.R[20]);
	else begin
		$display("TEST FAILED!		s4 = x20 = %d, but should be 1\n", dut.reg_file.R[20]);
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("XORI x20, x18, 2");
	if (dut.reg_file.R[20] === 8)
		$display("TEST PASSED!		s4 = x20 = %d\n", dut.reg_file.R[20]);
	else begin
		$display("TEST FAILED!		s4 = x20 = %d, but should be 8\n", dut.reg_file.R[20]);
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("ORI x20, x18, 2");
	if (dut.reg_file.R[20] === 10)
		$display("TEST PASSED!		s4 = x20 = %d\n", dut.reg_file.R[20]);
	else begin
		$display("TEST FAILED!		s4 = x20 = %d, but should be 10\n", dut.reg_file.R[20]);
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("ANDI x20, x18, 2");
	if (dut.reg_file.R[20] === 2)
		$display("TEST PASSED!		s4 = x20 = %d\n", dut.reg_file.R[20]);
	else begin
		$display("TEST FAILED!		s4 = x20 = %d, but should be 2\n", dut.reg_file.R[20]);
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("SLLI x20, x18, 1");
	if (dut.reg_file.R[20] === 20)
		$display("TEST PASSED!		s4 = x20 = %d\n", dut.reg_file.R[20]);
	else begin
		$display("TEST FAILED!		s4 = x20 = %d, but should be 20\n", dut.reg_file.R[20]);
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("SRLI x20, x18, 1");
	if (dut.reg_file.R[20] === 5)
		$display("TEST PASSED!		s4 = x20 = %d\n", dut.reg_file.R[20]);
	else begin
		$display("TEST FAILED!		s4 = x20 = %d, but should be 5\n", dut.reg_file.R[20]);
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("SRAI x20, x18, 1");
	if (dut.reg_file.R[20] === 5)
		$display("TEST PASSED!		s4 = x20 = %d\n", dut.reg_file.R[20]);
	else begin
		$display("TEST FAILED!		s4 = x20 = %d, but should be 5\n", dut.reg_file.R[20]);
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("ADDI x8, x8, 0x123");
	if (dut.reg_file.R[8] === 32'habcde123)
		$display("TEST PASSED!		s2 = x18 = %h\n", dut.reg_file.R[8]);
	else begin
		$display("TEST FAILED!		s2 = x18 = %h, but should be abcde123\n", dut.reg_file.R[8]);
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("SW x8, 0(zero)");
	if ({dut.data_mem.mem[3], dut.data_mem.mem[2], dut.data_mem.mem[1], dut.data_mem.mem[0]} === 32'habcde123)
		$display("TEST PASSED!		data_mem[3:0] = %h\n", {dut.data_mem.mem[3], dut.data_mem.mem[2], dut.data_mem.mem[1], dut.data_mem.mem[0]});
	else begin
		$display("TEST FAILED!		data_mem[3:0] = %h, but should be abcde123\n", {dut.data_mem.mem[3], dut.data_mem.mem[2], dut.data_mem.mem[1], dut.data_mem.mem[0]});
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("SH x8, 4(zero)");
	if ({dut.data_mem.mem[7], dut.data_mem.mem[6], dut.data_mem.mem[5], dut.data_mem.mem[4]} === 32'hxxxxe123)
		$display("TEST PASSED!		data_mem[7:4] = %h\n", {dut.data_mem.mem[7], dut.data_mem.mem[6], dut.data_mem.mem[5], dut.data_mem.mem[4]});
	else begin
		$display("TEST FAILED!		data_mem[7:4] = %h, but should be xxxxe123\n", {dut.data_mem.mem[7], dut.data_mem.mem[6], dut.data_mem.mem[5], dut.data_mem.mem[4]});
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("SB x8, 8(zero)");
	if ({dut.data_mem.mem[11], dut.data_mem.mem[10], dut.data_mem.mem[9], dut.data_mem.mem[8]} === 32'hxxxxxx23)
		$display("TEST PASSED!		data_mem[11:8] = %h\n", {dut.data_mem.mem[11], dut.data_mem.mem[10], dut.data_mem.mem[9], dut.data_mem.mem[8]});
	else begin
		$display("TEST FAILED!		data_mem[11:8] = %h, but should be xxxxxx23\n", {dut.data_mem.mem[11], dut.data_mem.mem[10], dut.data_mem.mem[9], dut.data_mem.mem[8]});
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("LW x20, 0(zero)");
	if (dut.reg_file.R[20] === 32'habcde123)
		$display("TEST PASSED!		s4 = x20 = %h\n", dut.reg_file.R[20]);
	else begin
		$display("TEST FAILED!		s4 = x20 = %h, but should be abcde123\n", dut.reg_file.R[20]);
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("LH x20, 0(zero)");
	if (dut.reg_file.R[20] === 32'hffffe123)
		$display("TEST PASSED!		s4 = x20 = %h\n", dut.reg_file.R[20]);
	else begin
		$display("TEST FAILED!		s4 = x20 = %h, but should be ffffe123\n", dut.reg_file.R[20]);
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("LHU x20, 0(zero)");
	if (dut.reg_file.R[20] === 32'h0000e123)
		$display("TEST PASSED!		s4 = x20 = %h\n", dut.reg_file.R[20]);
	else begin
		$display("TEST FAILED!		s4 = x20 = %h, but should be 0000e123\n", dut.reg_file.R[20]);
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("LB x20, 0(zero)");
	if (dut.reg_file.R[20] === 32'h00000023)
		$display("TEST PASSED!		s4 = x20 = %h\n", dut.reg_file.R[20]);
	else begin
		$display("TEST FAILED!		s4 = x20 = %h, but should be 00000023\n", dut.reg_file.R[20]);
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("LBU x20, 0(zero)");
	if (dut.reg_file.R[20] === 32'h00000023)
		$display("TEST PASSED!		s4 = x20 = %h\n", dut.reg_file.R[20]);
	else begin
		$display("TEST FAILED!		s4 = x20 = %h, but should be 00000023\n", dut.reg_file.R[20]);
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("BEQ x8, x8, 8");
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("ADDI x20, x18, 5");
	if (dut.reg_file.R[20] === 15)
		$display("TEST PASSED!		s4 = x20 = %d\n", dut.reg_file.R[20]);
	else begin
		$display("TEST FAILED!		s4 = x20 = %d, but should be 15 (Maybe branch not taken)\n", dut.reg_file.R[20]);
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("BNE x18, x19, 8");
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("ADDI x20, x20, 5");
	if (dut.reg_file.R[20] === 20)
		$display("TEST PASSED!		s4 = x20 = %d\n", dut.reg_file.R[20]);
	else begin
		$display("TEST FAILED!		s4 = x20 = %d, but should be 20 (Maybe branch not taken)\n", dut.reg_file.R[20]);
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("BLT x19, x18, 8");
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("ADDI x20, x20, 5");
	if (dut.reg_file.R[20] === 25)
		$display("TEST PASSED!		s4 = x20 = %d\n", dut.reg_file.R[20]);
	else begin
		$display("TEST FAILED!		s4 = x20 = %d, but should be 25 (Maybe branch not taken)\n", dut.reg_file.R[20]);
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("BGTE x18, x19, 8");
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("ADDI x20, x20, 5");
	if (dut.reg_file.R[20] === 30)
		$display("TEST PASSED!		s4 = x20 = %d\n", dut.reg_file.R[20]);
	else begin
		$display("TEST FAILED!		s4 = x20 = %d, but should be 30 (Maybe branch not taken)\n", dut.reg_file.R[20]);
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("JAL x21, 8");
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("ADDI x20, x20, 5");
	if ((dut.reg_file.R[20] === 35))
		$display("TEST PASSED!		s4 = x20 = %d \n", dut.reg_file.R[20]);
	else begin
		$display("TEST FAILED!		s4 = x20 = %d (should be 35) (Maybe branch not taken)\n", dut.reg_file.R[20]);
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("AUIPC x21, 0x00000");
	if ((dut.reg_file.R[21] === 180))
		$display("TEST PASSED!		s5 = x21 = %d \n", dut.reg_file.R[21]);
	else begin
		$display("TEST FAILED!		s5 = x21 = %d, but should be %d\n", dut.reg_file.R[21], 180);
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("JALR zero, x21, 12");
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("ADDI x20, x20, 5");
	if ((dut.reg_file.R[20] === 40))
		$display("TEST PASSED!		s4 = x20 = %d \n", dut.reg_file.R[20]);
	else begin
		$display("TEST FAILED!		s4 = x20 = %d, but should be 40 (Maybe Jump not taken)\n", dut.reg_file.R[20]);
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("AND x21, x20, x20");
	if ((dut.reg_file.R[21] === 40))
		$display("TEST PASSED!		s5 = x21 = %d \n", dut.reg_file.R[21]);
	else begin
		$display("TEST FAILED!		s5 = x21 = %d, but should be 40 (Maybe Forwarding not working)\n", dut.reg_file.R[21]);
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("XOR x21, x20, x20");
	if ((dut.reg_file.R[21] === 0))
		$display("TEST PASSED!		s5 = x21 = %d \n", dut.reg_file.R[21]);
	else begin
		$display("TEST FAILED!		s5 = x21 = %d, but should be 0 (Maybe Forwarding not working)\n", dut.reg_file.R[21]);
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("OR x21, x20, x20");
	if ((dut.reg_file.R[21] === 40))
		$display("TEST PASSED!		s5 = x21 = %d \n", dut.reg_file.R[21]);
	else begin
		$display("TEST FAILED!		s5 = x21 = %d, but should be 40\n", dut.reg_file.R[21]);
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("LW x21, 0(zero)");
	if ((dut.reg_file.R[21] === 32'habcde123))
		$display("TEST PASSED!		s5 = x21 = %h \n", dut.reg_file.R[21]);
	else begin
		$display("TEST FAILED!		s5 = x21 = %h, but should be abcde123\n", dut.reg_file.R[21]);
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("AND x22, x21, x21");
	if ((dut.reg_file.R[22] === 32'habcde123))
		$display("TEST PASSED!		s6 = x22 = %h \n", dut.reg_file.R[22]);
	else begin
		$display("TEST FAILED!		s6 = x22 = %h, but should be abcde123 (Maybe Forwarding not working)\n", dut.reg_file.R[22]);
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("XOR x22, x21, x21");
	if ((dut.reg_file.R[22] === 0))
		$display("TEST PASSED!		s6 = x22 = %d \n", dut.reg_file.R[22]);
	else begin
		$display("TEST FAILED!		s6 = x22 = %d, but should be 0 (Maybe Forwarding not working)\n", dut.reg_file.R[22]);
		failed++;
	end
	
	#delay;
	CLK = 1'b0;
	
	#delay;
	CLK = 1'b1;
	$display("OR x22, x21, x21");
	if ((dut.reg_file.R[22] === 32'habcde123))
		$display("TEST PASSED!		s6 = x22 = %h \n", dut.reg_file.R[22]);
	else begin
		$display("TEST FAILED!		s6 = x22 = %h, but should be abcde123\n", dut.reg_file.R[22]);
		failed++;
	end
	
	
	
	if (failed === 0) $display("\nAll Tests PASSED!\n");
	else $display("\n%d Test(s) FAILED!\n", failed);
	#delay;
	$stop;

end

endmodule