module sign_extend(input [5:0]in, output [15:0]out);

assign out[5:0] = in[5:0];
assign out[15:6] = {10 {in[5]}};

endmodule
