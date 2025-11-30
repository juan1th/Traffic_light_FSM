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
    input i_clk,                // System clock
    input i_reset,              // Asynchronous reset
    input logic i_expired,

    output logic o_stop,        // Signal to stop cars
    output logic o_walk,        // Signal for pedestrian walk
    output logic o_red,         // Red light output
    output logic o_yellow,      // Yellow light output
    output logic o_green,       // Green light output

    output logic [7:0] o_stime,  // State duration
    output logic o_set           // Timer enable

         
    );
    //logic i_expired;    // Timer/counter expired output
        
    typedef enum logic [1:0] {
        CARSgo    = 2'b00,
        STOPcars  = 2'b01,
        PEOPLEgo  = 2'b10,
        STOPppl   = 2'b11
    } state_t;

    state_t state, next_state;

    // Example interface to modular timer/counter
    logic [11:0] timer_value;
    logic i_init_stopcars;
    logic button_register;
    logic expired_register;





    always_comb begin
        // Default outputs

        next_state = state;

        case (state)
            CARSgo: begin
                o_stop    = 1;
                o_walk    = 0;
                o_red     = 0;
                o_yellow  = 0;
                o_green   = 1;
                
                
                
                if (i_button)
                    button_register = 1;
                
                if (i_expired) 
                    expired_register = 1;
                    
                if(expired_register)
                    o_set = 0;
                    else
                    o_set = 1;
                

                if (button_register == 1 && expired_register == 1) begin
                    
                    button_register = 0;
                    expired_register = 0;
                    o_set = 0;
                    o_stime = 2;
                    next_state = STOPcars;

                end
            end

            STOPcars: begin
                o_stop    = 1;
                o_walk    = 0;
                o_red     = 1;
                o_yellow  = 0;
                o_green   = 0;
                
                o_stime = 2;
                o_set = 1;
                expired_register = i_expired;

                if (expired_register) begin
                
                    expired_register = 0;
                    o_set = 0;
                    o_stime = 30;
                    next_state = PEOPLEgo;
                    
                end else begin
                    o_set = 1;           // Keep counting until done
                end
            end

            PEOPLEgo: begin
                o_stop    = 0;
                o_walk    = 1;
                o_red     = 1;
                o_yellow  = 0;
                o_green   = 0;
                
                o_set = 1;
                expired_register = i_expired;

                    if (expired_register) begin
                    
                        expired_register = 0;
                        next_state = STOPppl;
                        o_stime = 2;
                        o_set = 0;
                        
                    end else begin
                        o_set = 1;
                    end

            end

            STOPppl: begin
                o_stop    = 1;
                o_walk    = 0;
                o_red     = 1;
                o_yellow  = 1;
                o_green   = 0;
                
                if (i_button)
                    button_register = 1;
                    
                expired_register = i_expired;

                    if (i_expired) begin
                    
                        expired_register = 0;
                        next_state = CARSgo;
                        o_stime = 60;
                        
                    end else begin
                        o_set = 1;
                    end
            end

            default: begin
                next_state = STOPcars;
            end
        endcase
    end

    always_ff @(posedge i_clk) begin
        if (i_reset)
        begin
            button_register     <= 0;
            expired_register     <= 0;
            o_stop     <= 0;
            o_walk     <= 0;
            o_red     <= 0;
            o_yellow     <= 0;
            o_green     <= 0;
            o_stime     <= 2;
            o_set     <= 0;
            o_stime <= 8'd0;
            state <= STOPcars;
            end
        else
            state <= next_state;
    end

endmodule
