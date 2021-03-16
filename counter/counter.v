module counter (clk, reset, counter);
input          clk;
input          reset;
output  [3:0]  counter;

reg  [3:0]     counter;   // 17 bits for 128k counting at 100MHz
wire           ms_tick = counter == 17'd100_000; 


always @(posedge clk)
  if (!reset)            counter <= 0 ;
  else if (ms_tick)      counter <= 0 ;
  else                   counter  <= counter + 1;

endmodule
