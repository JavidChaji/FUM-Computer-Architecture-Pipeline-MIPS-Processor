module mux2_1N3(input [2:0]data1, input [2:0]data2,input sel, output reg [2:0]out);

always @(*)begin
	case(sel)
		1'b0 : out = data1;
		1'b1 : out = data2;
	endcase
end

endmodule
