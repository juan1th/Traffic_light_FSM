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
    input [7:0] target,
    output logic [7:0] value,
    output logic done,
    input logic pulse
    );

    always_ff @(posedge clk) begin
        if (reset)
            value <= 7'd0;
        else if ((enable && (value < target)) && pulse) begin
            value <= value + 1;
            done <= 0;
            end
        else if (value >= target) begin
            done <= 1;
            value <= 0;
            end
        else begin
            done <= 0;
        end
        
    end

    //always_comb begin
    //    done = (value >= target);
    //end
endmodule
