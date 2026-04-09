`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2026 07:20:43 PM
// Design Name: 
// Module Name: d_ff
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

// D Flip Flop
module d_ff(
    input D,        // input [0] sw,   // D FF D, IN
    input clk,      // input btnC,     // D FF clk, IN
    input rst,
    output reg Q,   // output [0] led, // D FF Q, OUT       // reg = "this signal is allowed to be assigned inside an always block."
    output notQ     // output [1] led  // D FF ~Q, OUT
    );
    
    // Output starts low/0
    initial begin
        Q <= 1'b0;     // Q driver // non-blocking "<="
    end
    
    // On each rising clock edge, copy input D to output Q... or reset.
    // procedural assignment: inside always / initial
    always @(posedge clk or posedge rst) begin   // On the rising edge of clk, copy D into Q
        if (rst)
            Q <= 1'b0;
        else
            Q <= D;
    end
    
    // Don't forget to assign ~Q since we haven't used it
    assign notQ = ~Q;       // notQ driver
    
endmodule

