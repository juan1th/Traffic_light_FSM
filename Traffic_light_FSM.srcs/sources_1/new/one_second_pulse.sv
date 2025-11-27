`timescale 1ns / 1ps

module one_second_pulse (
    input  logic clk,       // 100 MHz clock
    input  logic reset,
    logic [11:0] i_fsmstep,
    output logic pulse       // High for 1 clock cycle every second
);

    // 27 bits are enough for 100,000,000 (since 2^27 ≈ 134M)
    logic [26:0] counter;

    always_ff @(posedge clk) begin
        if (reset) begin
            counter <= 0;
            pulse   <= 0;
        end 
        else begin
            if (counter == (i_fsmstep - 1)) begin
                counter <= 0;
                pulse   <= 1;   // Generate 1-cycle pulse
            end 
            else begin
                counter <= counter + 1;
                pulse   <= 0;
            end
        end
    end
    
endmodule
