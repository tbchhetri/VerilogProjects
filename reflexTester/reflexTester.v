`define fiveSec 29'd500000000
`define rest 2'b00
`define randomization 2'b01
`define record 2'b10

module reflexTester (clk, reset, button, start, led, anode, cathodes, test1, test2, test3, test4, test5);
  input clk; 
  input reset;
  input start;
  input button; 
  output led;  
  output reg [3:0] anode;
  reg [16:0] count;
  output reg [0:7] cathodes;
  output reg test1,test2,test3, test4, test5;

  reg  starts;
  reg led;

  reg [19:0] ms_counter;
  wire ms_tick = ms_counter == 20'd1_000; //1ms takes 100_000 clk cycles (100MHz/1000ms)
  
//////////////////////1ms Counter//////////////////////
   always @(posedge clk)
       if(reset)           ms_counter = 0;
       else if (ms_tick)   ms_counter = 0;
       else                ms_counter = ms_counter + 1;
  
//////////////////////Random Numbers//////////////////////

LFSR dut (.clk(clk), 
            .reset(reset),  
           .rnd(rnd));

//reg [28:0] rnd = 200000000;

//////////////////////Main State Machine//////////////////////
  reg  [1:0] state;
  reg [28:0] milisecond;
  reg [28:0] count_next_random;
  reg [28:0] randi;
  
  wire randi2 = randi == `fiveSec;
  
  always @(posedge clk)   //is putting in reset the only way to initialize a variable?  
        if (reset) 
          begin
            state = 0;
            //randi <= 0; //19th: make randi 0
            milisecond = 0;
            count = 0;
          end
          
        else
          begin
            case (state)
              `rest: if (start) 
                       begin
                         randi <= rnd;
                         state <= `randomization;
                       end                             
                     else
                       state <= `rest;
                       
              `randomization: if (randi2)
                                begin
                                  led = 1'b1;
                                  randi = 0;
                                  state = `record;
                                end
                              else if (!led && button)
                                count = 16'hdead;
                              else
                                randi = randi + 1;
                                
               `record: if (button && led) 
                          begin
                            count = milisecond;
                            led = 1'b0;
                          end
                        else if (led)
                               if (ms_tick)
                                 milisecond <= milisecond + 1;
                               else 
                                 milisecond <= milisecond;
                        else
                          count_next_random = count_next_random + 1;
                          
                default: test1 <= 1;
            endcase                               
          end                                  
  
 //////////////////////7segment dispaly//////////////////////
 reg   [39:0]                 counter;
 reg                          reset_debounced;
always @(posedge clk)             
	if(reset_debounced)       counter     <= 0;
	else                      counter     <= counter + 1;
                                  
wire                          anode_clk    =  (counter[15:0] == 16'h8000);

always @(posedge clk)
        if(reset)            anode <= 4'b0111;	
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
	       4'h0:  cathodes = {7'b0000_001,dp};
	       4'h1:  cathodes = {7'b1001_111,dp};
	       4'h2:  cathodes = {7'b0010_010,dp};
	       4'h3:  cathodes = {7'b0000_110,dp};
	       4'h4:  cathodes = {7'b1001_100,dp};
	       4'h5:  cathodes = {7'b0100_100,dp};
	       4'h6:  cathodes = {7'b1100_000,dp};
	       4'h7:  cathodes = {7'b0001_111,dp};
	       4'h8:  cathodes = {7'b0000_000,dp};
	       4'h9:  cathodes = {7'b0001_100,dp};
	       4'ha:  cathodes = {7'b0001_000,dp};
	       4'hb:  cathodes = {7'b1100_000,dp};
	       4'hc:  cathodes = {7'b0110_001,dp};
	       4'hd:  cathodes = {7'b1000_010,dp};
	       4'he:  cathodes = {7'b0110_000,dp};
	       4'hf:  cathodes = {7'b0111_000,dp};
     endcase
       
 endmodule                                                  
  
