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
    input i_button,
    input i_expired,
    input i_fsmstep,
    input i_clk,
    input i_reset,

    output o_stop,
    output o_walk,
    output o_red,
    output o_yellow,
    output o_green,
    output [7:0] o_stime,
    output o_set
    );
        
    typedef enum logic [2:0] {
        CARSgo, 
        STOPcars, 
        PEOPLEgo, 
        STOPppl
    } state_t;
    
    state_t state, next_state;                                                  // 1. Define the states of the pulse generator, IDLE, LOW or HIGH.
    
    pulseCounter pulseDUT(
        .clk(i_clk),
        .reset(i_reset | (state==IDLE && next_state==IDLE)),
        .inc_pulse(inc_pulse),
        .count(pulse_count)                                                     // 2. Declare the internal variables and call the pulse counter.
    );
    
    always_comb 
    begin
        next_state = state;
//        timer_enable = 1'b0;
//        inc_pulse = 1'b0;
//        timer_target = 12'd0;                                                   // 6. Initialize intermediate variable values.
    
        case (state)
            CARSgo:
            begin
                o_stop = 1;
                o_walk = 0;
                o_red = 0;
                o_yellow = 0;
                o_green = 1;
            
//                if (trigger_rise)
//                    next_state = LOW;
//            end                                                                 // 7. In the beginning where the trigger rises and PG goes from IDLE to LOW.
            
            STOPcars: 
            begin
                o_stop = 1;
                o_walk = 0;
                o_red = 1;
                o_yellow = 0;
                o_green = 0;                                        // 8. After a LOW, the pulse goes to high always. 
            end 
            
            PEOPLEgo: 
            begin
                o_stop = 0;
                o_walk = 1;
                o_red = 1;
                o_yellow = 0;
                o_green = 0;   
            end
            
            STOPppl: 
            begin
                o_stop = 1;
                o_walk = 0;
                o_red = 1;
                o_yellow = 1;
                o_green = 0;   
            end
            
            default:
            begin
                next_state = CARSgo;
            end                                                                 // 10. Just the default state in case things go sideways.
        endcase
    end

    always_ff @(posedge i_clk)
    begin
        if (i_reset)
            state <= CARSgo;
        else
            state <= next_state;                                                // 11. Makes the switch case take 1 step, i.e. re-evaluate the switch case.
    end
    
    always_comb 
    begin
      case (state)
        HIGH: o_pulse = 1'b1;
        default: o_pulse = 1'b0;                                                // 12. Is the result of the whole operation, the low or high pulses are emitted due ot this block.
      endcase
    end
    
endmodule
