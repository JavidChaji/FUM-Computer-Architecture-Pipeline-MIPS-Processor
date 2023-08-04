module RegFile (clk, readreg1, readreg2, writereg, writedata, RegWrite, readdata1, readdata2);
  input [2:0] readreg1, readreg2, writereg;
  input [15:0] writedata;
  input clk, RegWrite;
  output [15:0] readdata1, readdata2;

  reg [15:0] regfile [7:0];

  always @(posedge clk)
  begin
    regfile[0]=0;
		  	if (RegWrite) 
	 				regfile[writereg] <= writedata;
           $display("The binary value of a %b register now is: %b", writereg , writedata);
  end

  assign readdata1 = regfile[readreg1];
  assign readdata2 = regfile[readreg2];
endmodule
 