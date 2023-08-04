//memory unit
module DMemBank(input clk, input memread, input memwrite, input [15:0] address, input [15:0] writedata, output [15:0] readdata);
 
  reg [15:0] mem_array [1023:0];
  
  integer i;
  initial begin
    for (i=0; i<256; i=i+1)   
      mem_array[i] = i;
	end
  integer j = 0;
 always@(negedge clk)
  begin
		if(memwrite)
			mem_array[address] = writedata;
      $display("%d   The binary value of a 19 th and 20 th block of Datamemory is: %b  and %b  ", j , mem_array[19] , mem_array[20] ) ;
      j = j + 1;
  end
  
  assign readdata = mem_array[address] & {16{memread}};

endmodule
