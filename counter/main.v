module counter(input CLK, output [7:0] LED);
  reg [31:0] count;

  always @(posedge CLK) count <= count + 1;
  assign LED = count[31:24];
endmodule
