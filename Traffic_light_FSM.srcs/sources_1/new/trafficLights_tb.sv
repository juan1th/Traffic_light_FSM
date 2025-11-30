`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.11.2025 18:36:13
// Design Name: 
// Module Name: trafficLights_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module trafficLights_tb();
    
    logic i_button;
    logic [11:0] i_fsmstep;
    logic i_clk;
    logic i_reset;

    logic o_stop;
    logic o_walk;
    logic o_red;
    logic o_yellow;
    logic o_green;

    top_level dut (
        .i_button(i_button),
        .i_fsmstep(i_fsmstep),
        .i_clk(i_clk),
        .i_reset(i_reset),
                
        .o_stop(o_stop),
        .o_walk(o_walk),
        .o_red(o_red),
        .o_yellow(o_yellow),
        .o_green(o_green)
    );
    
    initial i_clk = 0;
    always #5 i_clk = ~i_clk;

        initial begin
        // Start values should be in STOPcars mode (PLEASE TRY TO IMPLEMENT IT, currently it starts in CARSGO mode)
        i_button   = 0;
        i_fsmstep  = 100;                 
        i_reset    = 1;

        #10ns; 
        i_reset = 0;
        
        #20ns; 
        

        // FSM sits in CARSgo: step FSM 3 times, no pedestrian request
        //repeat (3) begin
         //   @(posedge i_clk);
         //   i_fsmstep = 1;
          //  @(posedge i_clk);
          //  i_fsmstep = 0;
        //end

        // Pedestrian presses button at this point.
        i_button = 1;
        @(posedge i_clk);
        //i_fsmstep = 1;
        @(posedge i_clk);
        //i_fsmstep = 0;
        i_button = 0;

        @(posedge i_clk);
        #40000ns;
        i_button = 1;
        #10ns; 
        i_button = 0;
        
        #160000ns;
        i_button = 1;
        #10ns; 
        i_button = 0;
        
        #40000ns;
        $finish;
    end

endmodule
