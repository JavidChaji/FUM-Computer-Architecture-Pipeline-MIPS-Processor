module PipLine(clk,  PC,  readIWire, readDataA, readDataB, result, writeData, readDataMem, RegDst, Jump,
 BranchEq, BranchNeq, BranchLt, BranchGt, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite, alu_src, operation,
 sign_extend_imd, sign_extend_EX, readDataB_EX, readDataA_EX, newPC_EX, jumpAdress_EX, newAdress, 
 RegDst_EX, jump_EX, BranchEq_EX, BranchNeq_EX, BranchGt_EX, BranchLt_EX,memRead_EX, memToReg_EX,
 memWrite_EX, ALUSrc_EX, RegWrite_EX, src_reg_EX,tg_reg_EX, dst_reg_EX, function_EX, ALUOp_EX, 
 readDataB_MEM, result_MEM, regDest_MEM, regWrite_MEM, memRead_MEM, memWrite_MEM, memToReg_MEM
 , result_WB, readDataMem_WB, RegDest_WB, memToReg_WB, RegWrite_WB, jumpAdress, readInst_ID, newPC_ID, 
 DataA, DataB, DataBAlu, SelA, SelB, isStall, hazardMem, inputMemory, jump_MEM, BranchEq_MEM, BranchNeq_MEM,
		BranchGt_MEM, BranchLt_MEM, isAdress, isAdress_MEM,pcwire, IF_ID ,ID_EX, EX_MEM, MEM_WB);

input clk;
output reg [15:0]PC;
output wire [15:0]pcwire;
assign pcwire = PC;


output reg [31:0]IF_ID;
output reg [105:0]ID_EX;
output reg [44:0]EX_MEM;
output reg [36:0]MEM_WB;

output wire [15:0] readIWire;

reg [15:0] newPC;



initial begin
	PC <= 0;
	// IF_ID[15:0] <= 0;
	// IF_ID[31:16] <= 0;
end


			// FETCH
	
	

IMemBank IMemBank_inst
(
	.memread(1'b1) ,	// input  memread_sig
	.address(pcwire) ,	// input [7:0] address_sig
	.readdata(readIWire) 	// output [15:0] readdata_sig
);


always@(PC)
	newPC = PC+1;
	
wire [15:0]PCinput;
output wire RegDst_EX, jump_EX;
output wire isAdress; 
wire isBranch;
assign isAdress = jump_EX | isBranch;

output wire [15:0]newAdress;
	
mux2_1N16 mux2_1N16_PCinput
(
	.data1(newPC) ,	// input [15:0] data1_sig
	.data2(newAdress) ,	// input [15:0] data2_sig
	.sel(isAdress) ,	// input  sel_sig
	.out(PCinput) 	// output [15:0] out_sig
);





	//DECODE

output wire[15:0] readInst_ID, newPC_ID;
assign readInst_ID = IF_ID[15:0];
assign newPC_ID = IF_ID[31:16];


output wire RegDst, Jump, BranchEq, BranchNeq, BranchLt, BranchGt, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite;
wire[2:0] ALUOp;
wire jump_ID, BranchEq_ID, BranchNeq_ID, BranchGt_ID, BranchLt_ID, memWrite_ID, regWrite_ID;

controlUnit controlUnit_inst
(
	.opCode(readInst_ID[15:12]) ,	// input [3:0] opCode_sig
	.regDest(RegDst) ,	// output  regDest_sig
	.jump(jump_ID) ,	// output  jump_sig
	.BranchEq(BranchEq_ID) ,	// output  BranchEq_sig
	.BranchNeq(BranchNeq_ID) ,	// output  BranchNeq_sig
	.BranchGt(BranchGt_ID) ,	// output  BranchGt_sig
	.BranchLt(BranchLt_ID) ,	// output  BranchLt_sig
	.memRead(MemRead) ,	// output  memRead_sig
	.memToReg(MemToReg) ,	// output  memToReg_sig
	.ALUop(ALUOp[2:0]) ,	// output [3:0] ALUop_sig
	.memWrite(memWrite_ID) ,	// output  memWrite_sig
	.ALUsrc(ALUSrc) ,	// output  ALUsrc_sig
	.RegWrite(RegWrite_ID) 	// output  RegWrite_sig
);

wire isControl;

assign isControl = Jump | BranchEq | BranchNeq | BranchGt | BranchLt ;

wire isControl_EX, isControl_MEM;

output wire BranchEq_EX, BranchNeq_EX, BranchGt_EX, BranchLt_EX;
output wire jump_MEM, BranchEq_MEM, BranchNeq_MEM, BranchGt_MEM, BranchLt_MEM, isAdress_MEM;


assign isControl_EX = jump_EX | BranchEq_EX | BranchNeq_EX | BranchGt_EX | BranchLt_EX;
assign isControl_MEM = (jump_MEM | BranchEq_MEM | BranchNeq_MEM | BranchGt_MEM | BranchLt_MEM) & isAdress_MEM;


output wire isStall;

mux2_1N3 mux2_1N3_controls1
(
	.data1({jump_ID, BranchEq_ID, BranchNeq_ID}) ,	// input [2:0] data1_sig
	.data2(3'b000) ,	// input [2:0] data2_sig
	.sel(isControl_EX | isControl_MEM | isStall) ,	// input  sel_sig
	.out({Jump, BranchEq, BranchNeq}) 	// output [2:0] out_sig
);

mux2_1N3 mux2_1N3_controls2
(
	.data1({BranchGt_ID, BranchLt_ID, memWrite_ID}) ,	// input [2:0] data1_sig
	.data2(3'b000) ,	// input [2:0] data2_sig
	.sel(isControl_EX | isControl_MEM | isStall) ,	// input  sel_sig
	.out({BranchGt, BranchLt, MemWrite}) 	// output [2:0] out_sig
);

mux2_1N1 mux2_1N1_control3
(
	.data1(RegWrite_ID) ,	// input  data1_sig
	.data2(1'b0) ,	// input  data2_sig
	.sel(isControl_EX | isControl_MEM | isStall) ,	// input  sel_sig
	.out(RegWrite) 	// output  out_sig
);

output wire RegWrite_WB;

output wire [2:0] RegDest_WB;

output wire[15:0] writeData, readDataA, readDataB;

RegFile RegFile_inst
(
	.clk(clk) ,	// input  clk_sig
	.readreg1(readInst_ID[11:9]) ,	// input [2:0] readreg1_sig
	.readreg2(readInst_ID[8:6]) ,	// input [2:0] readreg2_sig
	.writereg(RegDest_WB) ,	// input [2:0] writereg_sig
	.writedata(writeData) ,	// input [15:0] writedata_sig
	.RegWrite(RegWrite_WB) ,	// input  RegWrite_sig
	.readdata1(readDataA) ,	// output [15:0] readdata1_sig
	.readdata2(readDataB) 	// output [15:0] readdata2_sig
);




output wire [15:0]sign_extend_imd;

sign_extend sign_extend_Imdiate
(
	.in(readInst_ID[5:0]) ,	// input in_sig
	.out(sign_extend_imd) 	// output out_sig
);


output reg[15:0] jumpAdress;

always @(*)begin
	jumpAdress = {newPC_ID[15:12], readInst_ID[11:0] };
end





		// EXECUTION
		
		output wire[15:0] sign_extend_EX, readDataB_EX, readDataA_EX, newPC_EX, jumpAdress_EX; 
		output wire[2:0] src_reg_EX,tg_reg_EX, dst_reg_EX, function_EX, ALUOp_EX;
		output wire memRead_EX, memToReg_EX, memWrite_EX, ALUSrc_EX, RegWrite_EX;
		assign sign_extend_EX = ID_EX[15:0];
		assign dst_reg_EX = ID_EX[18:16];
		assign tg_reg_EX = ID_EX[21:19];
		assign src_reg_EX = ID_EX[24:22];
		assign readDataB_EX = ID_EX[40:25];
		assign readDataA_EX = ID_EX[56:41];
		assign newPC_EX = ID_EX[72:57];
		assign jumpAdress_EX = ID_EX[88:73];
		assign RegDst_EX = ID_EX[89];
		assign jump_EX = ID_EX[90];
		assign BranchEq_EX = ID_EX[91];
		assign BranchNeq_EX = ID_EX[92];
		assign BranchGt_EX = ID_EX[93];
		assign BranchLt_EX = ID_EX[94];
		assign memRead_EX = ID_EX[95];
		assign memToReg_EX = ID_EX[96];
		assign ALUOp_EX = ID_EX[99:97];
		assign memWrite_EX = ID_EX[100];
		assign ALUSrc_EX = ID_EX[101];
		assign RegWrite_EX = ID_EX[102];
		assign function_EX = ID_EX[105:103];
	
		
 wire[2:0] regDest_EX;

mux2_1N3 mux2_1N3_Dest
(
	.data1(tg_reg_EX) ,	// input [2:0] data1_sig
	.data2(dst_reg_EX) ,	// input [2:0] data2_sig
	.sel(RegDst_EX) ,	// input sel_sig
	.out(regDest_EX) 	// output [2:0] out_sig
);

output wire[1:0] SelA, SelB;

output wire [2:0] regDest_MEM;

output wire	regWrite_MEM;

output wire memWrite_MEM;

output wire hazardMem;

Data_Hazard_Dectection Data_Hazard_Dectection_inst
(
	.src_reg_ID(readInst_ID[11:9]) ,	// input [2:0] src_reg_ID_sig
	.tg_reg_ID(readInst_ID[8:6]) ,	// input [2:0] tg_reg_ID_sig
	.src_reg_EX(src_reg_EX) ,	// input [2:0] src_reg_EX_sig
	.tg_reg_EX(tg_reg_EX) ,	// input [2:0] tg_reg_EX_sig
	.dst_reg_MEM(regDest_MEM) ,	// input [2:0] dst_reg_MEM_sig
	.dst_reg_WB(RegDest_WB) ,	// input [2:0] dst_reg_WB_sig
	.RegWrite_MEM(regWrite_MEM) ,	// input  RegWrite_MEM_sig
	.RegWrite_WB(RegWrite_WB) ,	// input  RegWrite_WB_sig
	.memRead_EX(memRead_EX) ,	// input  memRead_EX_sig
	.memWrite_MEM(memWrite_MEM) ,	// input  memWrite_MEM_sig
	.outA(SelA) ,	// output [1:0] outA_sig
	.outB(SelB) , 	// output [1:0] outB_sig
	.stall(isStall) ,	// output  stall_sig
	.outMem(hazardMem) 	// output  outMem_sig memory hazard
);



input wire [15:0] result_MEM;

output wire [15:0]DataA;
mux2_1N16 mux2_1N16_Hazard_src_MEM
(
	.data1(readDataA_EX) ,	// input [15:0] data1_sig
	.data2(result_MEM) ,	// input [15:0] data2_sig
	.sel(SelA[0]) ,	// input  sel_sig
	.out(DataA) 	// output [15:0] out_sig
);

// output wire [15:0]DataAAlu;
// output wire [15:0]DataAAlu = readDataA_EX;
mux2_1N16 mux2_1N16_Hazard_src_WB
(
	.data1(DataA) ,	// input [15:0] data1_sig
	.data2(writeData) ,	// input [15:0] data2_sig
	.sel(SelA[1]) ,	// input  sel_sig
	.out(readDataA_EX) 	// output [15:0] out_sig
);

output wire[15:0] DataB;
mux2_1N16 mux2_1N16_Hazard_tg_MEM
(
	.data1(readDataB_EX) ,	// input [15:0] data1_sig
	.data2(result_MEM) ,	// input [15:0] data2_sig
	.sel(SelB[0]) ,	// input  sel_sig
	.out(DataB) 	// output [15:0] out_sig
);

output wire[15:0] DataBAlu;
mux2_1N16 mux2_1N16_Hazard_tg_WB
(
	.data1(DataB) ,	// input [15:0] data1_sig
	.data2(writeData) ,	// input [15:0] data2_sig
	.sel(SelB[1]) ,	// input  sel_sig
	.out(DataBAlu) 	// output [15:0] out_sig
);


output wire [15:0]alu_src;

mux2_1N16 mux2_1N16_AluSrc
(
	.data1(DataBAlu) ,	// input [16:0] data1_sig
	.data2(sign_extend_EX) ,	// input [16:0] data2_sig
	.sel(ALUSrc_EX) ,	// input  sel_sig
	.out(alu_src) 	// output [16:0] out_sig
);

output wire [3:0]operation;

ALUControl ALUControl_inst
(
	.ALUop(ALUOp_EX) ,	// input [2:0] ALUop_sig
	.func(function_EX) ,	// input [2:0] func_sig
	.aluoperation(operation) 	// output [3:0] aluoperation_sig
);

output wire [15:0] result;
wire zero, lt, gt;

ALU ALU_inst
(
	.data1(DataAAlu) ,	// input [15:0] data1_sig
	.data2(alu_src) ,	// input [15:0] data2_sig
	.aluoperation(operation) ,	// input [3:0] aluoperation_sig
	.result(result) ,	// output [15:0] result_sig
	.zero(zero) ,	// output  zero_sig
	.lt(lt) ,	// output  lt_sig
	.gt(gt) 	// output  gt_sig
);


assign isBranch = (BranchEq_EX & zero) | (BranchNeq_EX & ~zero) | (BranchGt_EX & gt) | (BranchLt_EX & lt);



wire[15:0] branchResult;


adder adder_branch
(
	.a(newPC_EX) ,	// input [15:0] a_sig
	.b(sign_extend_EX) ,	// input [15:0] b_sig
	.result(branchResult) 	// output [15:0] result_sig
);



mux2_1N16 mux2_1N16_jump
(
	.data1(branchResult) ,	// input [15:0] data1_sig
	.data2(jumpAdress_EX) ,	// input [15:0] data2_sig
	.sel(jump_EX) ,	// input  sel_sig
	.out(newAdress) 	// output [15:0] out_sig
);





		// MEMORY
		
		output wire [15:0] readDataB_MEM;
		
		output wire memRead_MEM, memToReg_MEM;
		assign regDest_MEM = EX_MEM[2:0];
		assign readDataB_MEM = EX_MEM[18:3];
		assign result_MEM = EX_MEM[34:19];
		assign regWrite_MEM = EX_MEM[35];
		assign memWrite_MEM = EX_MEM[36];
		assign memToReg_MEM = EX_MEM[37];
		assign memRead_MEM = EX_MEM[38];
		assign jump_MEM = EX_MEM[39];
		assign BranchEq_MEM = EX_MEM[40];
		assign BranchNeq_MEM = EX_MEM[41];
		assign BranchGt_MEM = EX_MEM[42];
		assign BranchLt_MEM = EX_MEM[43];
		assign isAdress_MEM = EX_MEM[44];

output wire [15:0]readDataMem, inputMemory;

mux2_1N16 mux2_1N16_hazard_Mem
(
	.data1(readDataB_MEM) ,	// input [15:0] data1_sig
	.data2(writeData) ,	// input [15:0] data2_sig
	.sel(hazardMem) ,	// input  sel_sig
	.out(inputMemory) 	// output [15:0] out_sig
);



DMemBank DMemBank_inst
(
	.clk(clk) ,	// input clk_sig
	.memread(memRead_MEM) ,	// input  memread_sig
	.memwrite(memWrite_MEM) ,	// input  memwrite_sig
	.address(result_MEM) ,	// input [15:0] address_sig
	.writedata(inputMemory) ,	// input [15:0] writedata_sig
	.readdata(readDataMem) 	// output [15:0] readdata_sig
);




		//  	WRITE BACK
		output wire [15:0] result_WB, readDataMem_WB;
		
		output wire memToReg_WB;
		assign result_WB = MEM_WB[15:0];
		assign readDataMem_WB = MEM_WB[31:16];
		assign memToReg_WB = MEM_WB[32];
		assign RegWrite_WB = MEM_WB[33];
		assign RegDest_WB = MEM_WB[36:34];

mux2_1N16 mux2_1N16_writeData
(
	.data1(result_WB) ,	// input [15:0] data1_sig
	.data2(readDataMem_WB) ,	// input [15:0] data2_sig
	.sel(memToReg_WB) ,	// input  sel_sig
	.out(writeData) 	// output [15:0] out_sig
);






always @(posedge clk)begin
	// if(~(isControl | isStall))begin
	if(~isStall)begin
		PC <= PCinput;
		$display("isStall is: %b   and isControl is: %b", isStall, isControl) ;
		IF_ID[15:0] <= readIWire;
		IF_ID[31:16] <= newPC;
	end
	// $display("isStall is: %b   and isControl is: %b", isStall, isControl) ;
	ID_EX[15:0] <= sign_extend_imd;
	ID_EX[18:16] <= readInst_ID[5:3];
	ID_EX[21:19] <= readInst_ID[8:6];
	ID_EX[24:22] <= readInst_ID[11:9];
	ID_EX[40:25] <= readDataB;
	ID_EX[56:41] <= readDataA;
	ID_EX[72:57] <= newPC_ID;
	ID_EX[88:73] <= jumpAdress;
	ID_EX[89] <= RegDst;
	ID_EX[90] <= Jump;
	ID_EX[91] <= BranchEq;
	ID_EX[92] <= BranchNeq;
	ID_EX[93] <= BranchGt;
	ID_EX[94] <= BranchLt;
	ID_EX[95] <= MemRead;
	ID_EX[96] <= MemToReg;
	ID_EX[99:97] <= ALUOp;
	ID_EX[100] <= MemWrite;
	ID_EX[101] <= ALUSrc;
	ID_EX[102] <= RegWrite;
	ID_EX[105:103] <= readInst_ID[2:0];
	
	EX_MEM[2:0] <= regDest_EX;
	EX_MEM[18:3] <= readDataB_EX;
	EX_MEM[34:19] <= result;
	EX_MEM[35] <= RegWrite_EX;
	EX_MEM[36] <= memWrite_EX;
	EX_MEM[37] <= memToReg_EX;
	EX_MEM[38] <= memRead_EX;
	EX_MEM[39] <= jump_EX;
	EX_MEM[40] <= BranchEq_EX;
	EX_MEM[41] <= BranchNeq_EX;
	EX_MEM[42] <= BranchGt_EX;
	EX_MEM[43] <= BranchLt_EX;
	EX_MEM[44] <= isAdress;
	
	MEM_WB[15:0] <= result_MEM;
	MEM_WB[31:16] <= readDataMem;
	MEM_WB[32] <= memToReg_MEM;
	MEM_WB[33] <= regWrite_MEM;
	MEM_WB[36:34] <= regDest_MEM;
end

endmodule





