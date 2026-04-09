`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2026 07:21:58 PM
// Design Name: 
// Module Name: t_ff
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

// T Flip Flop
module t_ff(
    input T,        // T=1 --> J=1, K=1 === toggle; T=0 --> J=0, K=0 === hold
    input clk,      // clk is the clock input port of this T FF module.
    input rst,
    output Q,
    output notQ
    );
    
    // T FF implemented using JK FF:
    // T=0 -> J=K=0 -> hold
    // T=1 -> J=K=1 -> toggle
    jk_ff t_jkff(
        .J(T),
        .K(T),
        .clk(clk),
        .rst(rst),
        .Q(Q),
        .notQ(notQ)
    );
    
endmodule

