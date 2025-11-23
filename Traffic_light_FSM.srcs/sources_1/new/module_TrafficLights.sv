`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.11.2025 10:25:49
// Design Name: 
// Module Name: module_TrafficLights
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


module module_TrafficLights(
    input i_button,             // Pedestrian button
    input i_expired,            // Timer/counter expired output
    input i_fsmstep,            // External FSM step signal (timing strobe)
    input i_clk,                // System clock
    input i_reset,              // Asynchronous reset

    output logic o_stop,        // Signal to stop cars
    output logic o_walk,        // Signal for pedestrian walk
    output logic o_red,         // Red light output
    output logic o_yellow,      // Yellow light output
    output logic o_green,       // Green light output
    output logic [7:0] o_stime, // State-time for external monitoring
    output logic o_set          // Signal to (re)set timer/counter
    );
        
    typedef enum logic [1:0] {
        CARSgo    = 2'b00,
        STOPcars  = 2'b01,
        PEOPLEgo  = 2'b10,
        STOPppl   = 2'b11
    } state_t;

    state_t state, next_state;

    // Example interface to modular timer/counter
    logic timer_done;
    logic timer_enable;
    logic [11:0] timer_value;
    logic [11:0] timer_target;
    logic i_init_stopcars;


    timeCounter timer_inst (
        .clk(i_clk),
        .reset(i_reset | o_set),
        .enable(timer_enable),
        .target(timer_target),
        .value(timer_value),
        .done(timer_done)
    );

    always_comb begin
        // Default outputs
        o_stop    = 0;
        o_walk    = 0;
        o_red     = 0;
        o_yellow  = 0;
        o_green   = 0;
        o_stime   = 0;
        o_set     = 0;                              // Set high to reset timer

        timer_enable = 0;
        timer_target = 12'd0;
        next_state = state;

        case (state)
            CARSgo: begin
                o_stop    = 1;
                o_walk    = 0;
                o_red     = 0;
                o_yellow  = 0;
                o_green   = 1;

                if (i_fsmstep) begin
                    if (i_button) begin
                        next_state = STOPcars;
                        o_set = 1;
                        timer_enable = 1;
//                        timer_value = 0;
                        timer_target = 120;
                    end
                end
            end

            STOPcars: begin
                o_stop    = 1;
                o_walk    = 0;
                o_red     = 1;
                o_yellow  = 0;
                o_green   = 0;

                if (i_fsmstep) begin
                    if (timer_done) begin
                        next_state = PEOPLEgo;
                        o_set = 1;
                        timer_enable = 1;
                        timer_target = 60;
                    end else begin
                        timer_enable = 1;           // Keep counting until done
                    end
                end
            end

            PEOPLEgo: begin
                o_stop    = 0;
                o_walk    = 1;
                o_red     = 1;
                o_yellow  = 0;
                o_green   = 0;

                if (i_fsmstep) begin
                    if (timer_done) begin
                        next_state = STOPppl;
                        o_set = 1;
                        timer_enable = 1;
                        timer_target = 60;
                    end else begin
                        timer_enable = 1;
                    end
                end
            end

            STOPppl: begin
                o_stop    = 1;
                o_walk    = 0;
                o_red     = 1;
                o_yellow  = 1;
                o_green   = 0;

                if (i_fsmstep) begin
                    if (timer_done) begin
                        next_state = CARSgo;
                    end else begin
                        timer_enable = 1;
                    end
                end
            end

            default: begin
                next_state = CARSgo;
            end
        endcase
    end

    always_ff @(posedge i_clk) begin
        if (i_reset)
            state <= CARSgo;
        else
            state <= next_state;
    end

endmodule
