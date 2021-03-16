////two input squence detector
module sequenceDetector (clk, reset, x, y, button, out, state);
  input clk;
  input reset;
  input x,y;
  input button;
  output out;
  output state;
  
  reg [3:0] state;
  
  wire out=((state == 3) || (state == 6));

reg button_reg;
reg button_sync;
wire button_done;
reg [31:0] button_count;

parameter DEBOUNCE_DELAY = 32'd0_500_000;   /// 10nS * 1M = 10mS

always @(posedge clk)   button_reg   <= button;
always @(posedge clk)   button_sync  <= button_reg;

assign                  button_done  = (button_count == DEBOUNCE_DELAY); 
assign                  button_click = (button_count == DEBOUNCE_DELAY - 1); 

always @(posedge clk) 
          if (!button_sync)      button_count <= 0;
          else if (button_done)  button_count <= button_count;
          else                   button_count <= button_count + 1;
          
 

always @(posedge clk)
  if (reset)            state <= 0;

  else if (button_click) begin
        case (state)
        3'b000: if (x && !y)      state <= 1;
                else if (x && y) state <= 4;
                else            state <= 0;

        3'b001: if (x && !y)      state <= 2;
                else if (x && y) state <= 4;
                else            state <= 0;

        3'b010: if (x && y)      state <= 3;
                else if (x && !y) state <= 2;
                else            state <= 0;

        3'b011: if (x && y)      state <= 5;
                else if (x && !y) state <= 1;
                else            state <= 0;
//---------------end of first sequence----------
        3'b100: if (x && y)      state <= 5;
                else if (x && !y) state <= 1;
                else            state <= 0;

        3'b101: if (x && y)      state <= 6;
                else if (x && !y) state <= 1;
                else            state <= 0;

        3'b110: if (x && y)      state <= 6;
                else if (x && !y) state <= 1;
                else            state <= 0;

       
        endcase
        end

  else state <= state;
  
endmodule
 
