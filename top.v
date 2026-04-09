`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2026 07:11:59 PM
// Design Name: 
// Module Name: top
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
//        Modulo Counter jobs in top.v:
//            1) hold the current state (mc_q2, mc_q1, mc_q0)
//            2) compute count + 1 using full_adder
//            3) choose between:
//                - incrementing
//                - resetting state to 000
//                - toggling the modulo output 
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input btnU, // Reset
    input btnC, // Input clock
    output [6:0] led    // Ripple counter stage 3,2, and 1
                        // Modulo counter state bit 2,1,0
                        // Modulo counter output
    );
    
    // Ripple Counter Wires: 
    //      - Hold the outputs of the three T flip-flop stages in the ripple counter
    wire rc_q0;     // normal Q outputs of stages 0, 1, 2   // stage 1 output
    wire rc_nq0;    // inverted outputs (notQ) of those same stages
    wire rc_q1;     // stage 2 output
    wire rc_nq1;
    wire rc_q2;     // // stage 3 output
    wire rc_nq2;
    
    // Modulo Counter Wires:
    //      - 
    wire mc_q0; // three stored state bits // if the modulo counter is currently at binary 101, then mc_q2 = 1; mc_q1 = 0; mc_q0 = 1 // keep track of where you are in the count
    wire mc_nq0;
    wire mc_q1;
    wire mc_nq1;
    wire mc_q2;
    wire mc_nq2;
    
    // Modulo Counter Helper Wires:
    //      - incrementer outputs for count + 1
    //      - carry chain from the full adders
    //      - terminal-count detect
    //      - next-state inputs for the D flip-flops
    wire mc_inc0;   // incrementer outputs for count + 1
    wire mc_inc1;
    wire mc_inc2;
    
    wire mc_c1;     // carry chain from full adders
    wire mc_c2;
    wire mc_c3;
    
    wire mc_tc;     // terminal count detect
    wire mc_d0;     // next-state input for state bit 0
    wire mc_d1;     // next-state input for state bit 1
    wire mc_d2;     // next-state input for state bit 2
    
    wire mc_out_d;  // next state INPUT for modulo output FF
    wire mc_out_nq;     // inverted output of modulo output FF
    
    
    // Modulo Output Wire:
    //      - 
    wire mc_out;        // clock divider output
                        // toggles whenever the counter reaches the terminal count
    
    // TODO:
    // 1) Instantiate the ripple counter T flip-flops
    // 2) Instantiate the modulo counter adder + D flip-flops
    // 3) Add LED assignments
    
    // =========================================================
    // Ripple Counter: divide by 8 using three cascaded T-FFs
    // =========================================================
    // Each T fF has T = 1, so it toggles on each active clock edge.
    //      - Stage 0 is clocked by btnC.
    //      - Stage 1 is clocked by stage 0's Q.
    //      - Stage 2 is clocked by stage 1's Q.
    t_ff rc0(
        .T(1'b1),
        .clk(btnC),
        .rst(btnU),
        .Q(rc_q0),
        .notQ(rc_nq0)
    );
    
    t_ff rc1(
        .T(1'b1),
        .clk(rc_q0),
        .rst(btnU),
        .Q(rc_q1),
        .notQ(rc_nq1)
    );
    
    t_ff rc2(
        .T(1'b1),
        .clk(rc_q1),
        .rst(btnU),
        .Q(rc_q2),
        .notQ(rc_nq2)
    );
    
    // =========================================================
    // Modulo Counter Incrementer: current count + 1
    // =========================================================
    full_adder fa0(
        .A(mc_q0),
        .B(1'b1),
        .carryIn(1'b0),
        .Y(mc_inc0),     // sum bit
        .carryOut(mc_c1)
    );
        
    full_adder fa1(
        .A(mc_q1),
        .B(1'b0),
        .carryIn(mc_c1),
        .Y(mc_inc1),     // sum bit
        .carryOut(mc_c2)
    );
        
    full_adder fa2(
        .A(mc_q2),
        .B(1'b0),
        .carryIn(mc_c2),
        .Y(mc_inc2),     // sum bit
        .carryOut(mc_c3)
    );
    
    // =========================================================
    // Modulo Counter Terminal Count / Next-State Logic
    // =========================================================
    // We want led[6] to toggle once every 6 button presses.
    // Terefore the 3-bit state should cycle through:
    //      - 000, 001, 010, 011, 100, 101
    //      - Output toggles every 6 button clocks, so the six visible states are these
    //      - on the next clock after 101, the state resets to 000 and the output toggles.
    // , and when current state it's 101 (dec 5), the next clock:
    //      - resets state to 000
    //      - toggles mc_out
    // In Short: on the next rising edge of btnC, the modulo flip-flops will load 0 if btnU=1
    assign mc_tc = mc_q2 & mc_nq1 & mc_q0;   // mc_tc is our terminal count detect // current state = 101 
    
    assign mc_d0 = mc_tc ? 1'b0 : mc_inc0;
    // assign mc_d0 = btnU ? 1'b0 : (mc_tc ? 1'b0 : mc_inc0);  // next-state input for state bit 0
    assign mc_d1 = mc_tc ? 1'b0 : mc_inc1;
    // assign mc_d1 = btnU ? 1'b0 : (mc_tc ? 1'b0 : mc_inc1);  // next-state input for state bit 1
    assign mc_d2 = mc_tc ? 1'b0 : mc_inc2;
    // assign mc_d2 = btnU ? 1'b0 : (mc_tc ? 1'b0 : mc_inc2);  // next-state input for state bit 2
               // condition ? value_if_true : value_if_false
               
    assign mc_out_d = mc_tc ? mc_out_nq : mc_out;
    // assign mc_out_d = btnU ? 1'b0 : (mc_tc ? mc_out_nq : mc_out);   // next state INPUT for modulo output FF
    
    // =========================================================
    // Modulo Counter State Storage (D FFs)
    // =========================================================
    //      - makes mc_out a stored output
    //      - output toggles when the terminal count is reached
    d_ff mc_ff0(
        .D(mc_d0),      // next-state input for state bit 0
        .clk(btnC),     // Input clock
        .Q(mc_q0),      // three stored state bitS: mc_q0, mc_q1, mc_q2
        .notQ(mc_nq0)   // inverse
    );
    
    d_ff mc_ff1(
        .D(mc_d1),
        .clk(btnC),
        .rst(btnU),
        .Q(mc_q1),
        .notQ(mc_nq1)
    );
    
    d_ff mc_ff2(
        .D(mc_d2),
        .clk(btnC),
        .rst(btnU),
        .Q(mc_q2),
        .notQ(mc_nq2)
    );
    
    d_ff mc_out_ff(
        .D(mc_out_d),
        .clk(btnC),
        .rst(btnU),
        .Q(mc_out),
        .notQ(mc_out_nq)
    );
    
    
    
    // Ripple Counter led --> wire assignments
    assign led[0] = rc_q0;
    assign led[1] = rc_q1;
    assign led[2] = rc_q2;
    
    // Modulo counter led --> wire assignments
    assign led[3] = mc_q0;
    assign led[4] = mc_q1;
    assign led[5] = mc_q2;

    assign led[6] = mc_out;
    
    
    
endmodule
