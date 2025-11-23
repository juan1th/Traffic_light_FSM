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
    logic i_expired;
    logic i_fsmstep;
    logic i_clk;
    logic i_reset;

    logic o_stop;
    logic o_walk;
    logic o_red;
    logic o_yellow;
    logic o_green;
    
    logic [7:0] o_stime;
    logic o_set;

    module_TrafficLights dut (
        .i_button(i_button),
        .i_expired(i_expired),
        .i_fsmstep(i_fsmstep),
        .i_clk(i_clk),
        .i_reset(i_reset),
                
        .o_stop(o_stop),
        .o_walk(o_walk),
        .o_red(o_red),
        .o_yellow(o_yellow),
        .o_green(o_green),
        
        .o_stime(o_stime),
        .o_set(o_set)
    );

    initial i_clk = 0;
    always #5 i_clk = ~i_clk;

        initial begin
        // Start values should be in STOPcars mode (PLEASE TRY TO IMPLEMENT IT, currently it starts in CARSGO mode)
        i_button   = 0;
        i_expired  = 0;
        i_fsmstep  = 0;
        i_reset    = 0;

        @(posedge i_clk);                   // 1. This is the same thing as #10ns; 
        i_reset    = 1;

        @(posedge i_clk);
        i_reset = 0;
        

        // FSM sits in CARSgo: step FSM 3 times, no pedestrian request
        repeat (3) begin
            @(posedge i_clk);
            i_fsmstep = 1;
            @(posedge i_clk);
            i_fsmstep = 0;
        end

        // Pedestrian presses button at this point.
        i_button = 1;
        @(posedge i_clk);
        i_fsmstep = 1;
        @(posedge i_clk);
        i_fsmstep = 0;
        i_button = 0;

        @(posedge i_clk);
        $display("");
        $finish;
    end

endmodule
