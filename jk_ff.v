`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2026 07:21:45 PM
// Design Name: 
// Module Name: jk_ff
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


// JK Flip Flop w/ Internal D Flip Flop
module jk_ff(
    input J,
    input K,
    input clk,  // clk is the clock input port of the JK module.
    input rst,
    output Q,
    output notQ
    );
    
    wire d_in;
    
    // JK combinational logic:
    // D = J~Q + ~KQ
    assign d_in = (J & notQ) | ((~K) & Q); // <-- review
    
    // Internal D FF
    d_ff jk_dff(
        .D(d_in),
        .clk(clk),      // jk_ff passes clock into d_ff
        .rst(rst),
        .Q(Q),          // connect internal D FF Q directly to jk_ff output Q
        .notQ(notQ)     // connect internal D FF ~Q directly to jk_ff output ~Q
    );
    
endmodule
