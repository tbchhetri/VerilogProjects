`timescale 1ns/1ps

module reflexTB ();
  reg clk;
  reg reset;
  reg start;
  reg button;
  wire led;
  wire anode;
  wire cathodes;
  
  reflexTester DUT (
    .clk(clk),
    .reset(reset),
    .start(start),
    .button(button),
    .led(led),
    .anode(anode),
    .cathodes(cathodes)
  );
  
  always 
    begin
        clk = 0; #10;
        clk =~clk; #10;
     end
   
   initial 
    begin 
        reset <= 1; 
        #100 reset <= 0;
        start = 0; #1050;
        start = 1; #1090;
        button = 0; #1250;
        button = 1; #1300;     
        #9000000 $finish;
    end
  
  initial 
   $dumpfile("dump.vcd");
   
 initial 
   $dumpvars;
        
  
endmodule
