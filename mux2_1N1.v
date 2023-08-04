module mux2_1N1(input data1, input data2,input sel, output reg out);

always @(*)begin
	case(sel)
		1'b0 : out = data1;
		1'b1 : out = data2;
	endcase
end

endmodule
