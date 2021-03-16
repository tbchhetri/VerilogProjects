`timescale 1ns / 1ps

module tb ();

reg clk;
reg reset;
wire ms_tick;
wire [3:0] count;


initial clk = 0;
initial forever #5 clk = ~clk;

initial
  begin
         reset <= 0;
#1000    reset <= 1;
#6000    $display("made it to 6000 @ %t", $time);

#5000    $finish;
  end

always @(count)
    $display("counter = %x at time %t", count, $time);

counter counter (
                 .clk(clk),
                 .reset(reset),
                 .counter(count));


initial 
    $dumpfile("verilog.dmp");

initial
    $dumpvars;


endmodule
