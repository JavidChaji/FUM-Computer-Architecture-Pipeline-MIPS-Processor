module ALUControl(input [2:0] ALUop, input [2:0]func, output reg [3:0]aluoperation);
		always@(*)begin
			if(ALUop == 3'b000)begin
				case(func)
					3'b000 : aluoperation = 4'b0000;
					3'b001 : aluoperation = 4'b0001;
					3'b010 : aluoperation = 4'b0010;
					3'b011 : aluoperation = 4'b0011;
					3'b100 : aluoperation = 4'b0100;
					3'b101 : aluoperation = 4'b0101;
					3'b110 : aluoperation = 4'b0110;
					default : aluoperation = 4'b0000;
				endcase
			end
			else begin
				case(ALUop)
					3'b001 : aluoperation = 4'b0000;
					3'b010 : aluoperation = 4'b0001;
					3'b011 : aluoperation = 4'b0010;
					3'b100 : aluoperation = 4'b0011;
					3'b101 : aluoperation = 4'b0100;
					3'b110 : aluoperation = 4'b0101;
					default : aluoperation = 4'b0000;
				endcase
			end
		end
endmodule
