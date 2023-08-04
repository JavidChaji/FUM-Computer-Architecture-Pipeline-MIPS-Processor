module Data_Hazard_Dectection(input[2:0] src_reg_ID, tg_reg_ID, src_reg_EX, tg_reg_EX, dst_reg_MEM, dst_reg_WB, input RegWrite_MEM, 
RegWrite_WB, memRead_EX, memWrite_MEM, output reg[1:0] outA, outB, output reg stall, outMem);

	initial begin
		stall <= 0;
		outA <= 0;
		outB <= 0;
		outMem <= 0;
	end
	always@(*)begin
		//
		//add $3, $4, $5
		//add $1, $3, $9
		//
		//
		//add $3, $4, $5
		//add $7, $2, $0
		//add $1, $3, $9
		//
		if(dst_reg_MEM == src_reg_EX & RegWrite_MEM)
			outA = 2'b01;
		else if(dst_reg_WB == src_reg_EX & RegWrite_WB)
			outA = 2'b10;
		else
			outA = 2'b00;

		//
		//add $3, $4, $5
		//add $1, $9, $3
		//	
		//
		//add $3, $4, $5
		//add $7, $2, $3
		//add $1, $9, $3
		//
		if(dst_reg_MEM == tg_reg_EX & RegWrite_MEM)
			outB = 2'b01;
		else if(dst_reg_WB == tg_reg_EX & RegWrite_WB)
			outB = 2'b10;
		else
			outB = 2'b00;
		
		//
		//lw $5, 0($3)
		//add $8, $5, $0
		//
		if(((tg_reg_EX == src_reg_ID) | (tg_reg_EX == tg_reg_ID)) & memRead_EX)
			stall = 1'b1;
		else
			stall = 1'b0;
		//
		//lw $7, 0($3)
		//sw $7, 0($2)
		//
		if(dst_reg_MEM == dst_reg_WB & memWrite_MEM & RegWrite_WB)
			outMem = 1'b1;
		else
			outMem = 1'b0;
	end
endmodule
