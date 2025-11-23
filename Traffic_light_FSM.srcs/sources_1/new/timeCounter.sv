`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.11.2025 18:01:19
// Design Name: 
// Module Name: timeCounter
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


module timeCounter(
    input clk,
    input reset,
    input enable,
    input [11:0] target,
    output logic [11:0] value,
    output logic done
    );

    always_ff @(posedge clk) begin
        if (reset)
            value <= 12'd0;
        else if (enable && value < target) 
            value <= value + 1;
    end

    always_comb begin
        done = (value >= target);
    end
endmodule
