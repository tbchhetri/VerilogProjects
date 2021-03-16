//Advanced FPGA counter.
//Make the counter increment/decrement with the press of a button and display
//it in 7seg

module AdvCounter (clk, reset, add, sub, anode, cathodes, count, dp);

input clk;
input reset;
input add;
input sub;
output reg [6:0] cathodes;
output reg [3:0] anode;
output [15:0] count;
output dp;

reg [15:0] count;
reg reset_debounced;

reg add_reg1;
reg add_reg2;

reg sub_reg1;
reg sub_reg2;

always @(posedge clk) add_reg1 <= add;
always @(posedge clk) add_reg2 <= add_reg1;
wire                  add_click = add_reg1 && !add_reg2;

always @(posedge clk) sub_reg1 <= sub;
always @(posedge clk) sub_reg2 <= sub_reg1;
wire                  sub_click = sub_reg1 && !sub_reg2;

always @(posedge clk)
        if (reset)         count = 0;
        else if (add_click) count = count +1;
        else if (sub_click) count = count -1;
        else                count = count;

//reg   [15:0]   answer;   // 16 bit number to be displayed

reg   [39:0]                      counter;
always @(posedge clk)             
	if(reset_debounced)       counter     <= 0;
	else                      counter     <= counter + 1;
                                  
wire                          anode_clk    =  (counter[15:0] == 16'h8000);


always @(posedge clk)
        if(reset)       anode <= 4'b0111;	
	     else if(anode_clk)   anode <= {anode[0],anode[3:1]}; // rotate
	     else                 anode <=  anode;  

reg [3:0] cathode_select;

always @(anode or count )
       case({anode})
	      4'b0111:  cathode_select = count[15:12]; 
	      4'b1011:  cathode_select = count[11:8]; 
	      4'b1101:  cathode_select = count[7:4]; 
	      4'b1110:  cathode_select = count[3:0];
	      default:  cathode_select = 4'h0; 
      endcase

wire dp = 1 ; //!(anodes == 4'b1011); 

always @(cathode_select or dp)
       case(cathode_select)
	       4'h0:  cathodes = {7'b0000_001};
	       4'h1:  cathodes = {7'b1001_111};
	       4'h2:  cathodes = {7'b0010_010};
	       4'h3:  cathodes = {7'b0000_110};
	       4'h4:  cathodes = {7'b1001_100};
	       4'h5:  cathodes = {7'b0100_100};
	       4'h6:  cathodes = {7'b1100_000};
	       4'h7:  cathodes = {7'b0001_111};
	       4'h8:  cathodes = {7'b0000_000};
	       4'h9:  cathodes = {7'b0001_100};
	       4'ha:  cathodes = {7'b0001_000};
	       4'hb:  cathodes = {7'b1100_000};
	       4'hc:  cathodes = {7'b0110_001};
	       4'hd:  cathodes = {7'b1000_010};
	       4'he:  cathodes = {7'b0110_000};
	       4'hf:  cathodes = {7'b0111_000};
     endcase
       
 endmodule   
        





