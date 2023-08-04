module adder(input[15:0] a, input [15:0] b, output reg [15:0] result);
	always @(*)
		result = a + b;
endmodule
