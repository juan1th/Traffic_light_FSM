`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2025 10:35:15 AM
// Design Name: 
// Module Name: top_level
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


module top_level(

input i_button,             // Pedestrian button
           // Timer/counter expired output
input logic [11:0] i_fsmstep,            // External FSM step signal (timing strobe)
input i_clk,                // System clock
input i_reset,              // Asynchronous reset

output logic o_stop,        // Signal to stop cars
output logic o_walk,        // Signal for pedestrian walk
output logic o_red,         // Red light output
output logic o_yellow,      // Yellow light output
output logic o_green       // Green light output
);

logic [7:0] o_stime; // State-time for external monitoring
logic o_set;
logic i_expired;
logic pulse;
logic [11:0] timer_value;


module_TrafficLights fsm(
    .i_clk(i_clk),
    .i_reset(i_reset),
    .o_stop(o_stop),
    .o_walk(o_walk),
    .o_red(o_red),
    .o_yellow(o_yellow),
    .o_green(o_green),
    .o_stime(o_stime),
    .o_set(o_set),
    .i_expired(i_expired),
    .i_button(i_button)

);

timeCounter timer_inst (
    .clk(i_clk),
    .reset(i_reset),
    .enable(o_set),
    .target(o_stime),
    .value(timer_value),
    .done(i_expired),
    .pulse(pulse)
);

one_second_pulse fsmstep(
    .i_fsmstep(i_fsmstep),
    .clk(i_clk),
    .reset(i_reset),               
    .pulse(pulse)
);


endmodule
