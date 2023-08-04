module controlUnit(input[3:0] opCode, output reg regDest,jump, BranchEq, BranchNeq, BranchGt, BranchLt, memRead, memToReg,
 output reg [3:0]ALUop, output reg memWrite, ALUsrc, RegWrite);
 
	initial begin
		jump <= 1'b0;
		BranchEq <= 1'b0;
		BranchNeq <= 1'b0;
		BranchGt <= 1'b0;
		BranchLt <= 1'b0;
	end

	always @(opCode)begin
		if(opCode == 4'b0000)begin
			regDest = 1'b1;
			jump = 1'b0;
			BranchEq = 1'b0;
			BranchNeq = 1'b0;
			BranchGt = 1'b0;
			BranchLt = 1'b0;
			memRead = 1'b0;
			memToReg = 1'b0;
			ALUop = 3'b000;
			memWrite = 1'b0;
			ALUsrc = 1'b0;
			RegWrite = 1'b1;
		end
		else if(opCode == 4'b0001)begin
			regDest = 1'b0;
			jump = 1'b0;
			BranchEq = 1'b0;
			BranchNeq = 1'b0;
			BranchGt = 1'b0;
			BranchLt = 1'b0;
			memRead = 1'b0;
			memToReg = 1'b0;
			ALUop = 3'b001;
			memWrite = 1'b0;
			ALUsrc = 1'b1;
			RegWrite = 1'b1;
		end
		else if(opCode == 4'b0010)begin
			regDest = 1'b0;
			jump = 1'b0;
			BranchEq = 1'b0;
			BranchNeq = 1'b0;
			BranchGt = 1'b0;
			BranchLt = 1'b0;
			memRead = 1'b0;
			memToReg = 1'b0;
			ALUop = 3'b011;
			memWrite = 1'b0;
			ALUsrc = 1'b1;
			RegWrite = 1'b1;
		end
		else if(opCode == 4'b0011)begin
			regDest = 1'b0;
			jump = 1'b0;
			BranchEq = 1'b0;
			BranchNeq = 1'b0;
			BranchGt = 1'b0;
			BranchLt = 1'b0;
			memRead = 1'b0;
			memToReg = 1'b0;
			ALUop = 3'b100;
			memWrite = 1'b0;
			ALUsrc = 1'b1;
			RegWrite = 1'b1;
		end
		else if(opCode == 4'b0100)begin
			regDest = 1'b0;
			jump = 1'b0;
			BranchEq = 1'b0;
			BranchNeq = 1'b0;
			BranchGt = 1'b0;
			BranchLt = 1'b0;
			memRead = 1'b0;
			memToReg = 1'b0;
			ALUop = 3'b010;
			memWrite = 1'b0;
			ALUsrc = 1'b1;
			RegWrite = 1'b1;
		end
		else if(opCode == 4'b0111)begin
			regDest = 1'b0;
			jump = 1'b0;
			BranchEq = 1'b0;
			BranchNeq = 1'b0;
			BranchGt = 1'b0;
			BranchLt = 1'b0;
			memRead = 1'b1;
			memToReg = 1'b1;
			ALUop = 3'b001;
			memWrite = 1'b0;
			ALUsrc = 1'b1;
			RegWrite = 1'b1;
		end
		else if(opCode == 4'b1000)begin
			regDest = 1'b0;
			jump = 1'b0;
			BranchEq = 1'b0;
			BranchNeq = 1'b0;
			BranchGt = 1'b0;
			BranchLt = 1'b0;
			memRead = 1'b0;
			memToReg = 1'b0;
			ALUop = 3'b001;
			memWrite = 1'b1;
			ALUsrc = 1'b1;
			RegWrite = 1'b0;
		end
		else if(opCode == 4'b1001)begin
			regDest = 1'b0;
			jump = 1'b0;
			BranchEq = 1'b1;
			BranchNeq = 1'b0;
			BranchGt = 1'b0;
			BranchLt = 1'b0;
			memRead = 1'b0;
			memToReg = 1'b0;
			ALUop = 3'b010;
			memWrite = 1'b0;
			ALUsrc = 1'b0;
			RegWrite = 1'b0;
		end
		else if(opCode == 4'b1010)begin
			regDest = 1'b0;
			jump = 1'b0;
			BranchEq = 1'b0;
			BranchNeq = 1'b1;
			BranchGt = 1'b0;
			BranchLt = 1'b0;
			memRead = 1'b0;
			memToReg = 1'b0;
			ALUop = 3'b010;
			memWrite = 1'b0;
			ALUsrc = 1'b0;
			RegWrite = 1'b0;
		end
		else if(opCode == 4'b1011)begin
			regDest = 1'b0;
			jump = 1'b0;
			BranchEq = 1'b0;
			BranchNeq = 1'b0;
			BranchGt = 1'b0;
			BranchLt = 1'b1;
			memRead = 1'b0;
			memToReg = 1'b0;
			ALUop = 3'b010;
			memWrite = 1'b0;
			ALUsrc = 1'b0;
			RegWrite = 1'b0;
		end
		else if(opCode == 4'b1100)begin
			regDest = 1'b0;
			jump = 1'b0;
			BranchEq = 1'b0;
			BranchNeq = 1'b0;
			BranchGt = 1'b1;
			BranchLt = 1'b0;
			memRead = 1'b0;
			memToReg = 1'b0;
			ALUop = 3'b010;
			memWrite = 1'b0;
			ALUsrc = 1'b0;
			RegWrite = 1'b0;
		end
		else if(opCode == 4'b1111)begin
			regDest = 1'b0;
			jump = 1'b1;
			BranchEq = 1'b0;
			BranchNeq = 1'b0;
			BranchGt = 1'b0;
			BranchLt = 1'b0;
			memRead = 1'b0;
			memToReg = 1'b0;
			ALUop = 3'b001;
			memWrite = 1'b0;
			ALUsrc = 1'b1;
			RegWrite = 1'b0;
		end
	end
endmodule
