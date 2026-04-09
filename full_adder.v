`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2026 07:22:12 PM
// Design Name: 
// Module Name: full_adder
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


module full_adder( // Implement module called full_adder
    input A,
    input B, 
    input carryIn,  // full adder adds three 1-bit values A, B, carryIn
    output Y,       // sum bit
    output carryOut     // produces Y (sum bit), and carryOut (carry bit)
                        // Example: 1+1+0 = 10_2; where Sum = 0, carryOut = 1
);

assign Y = A^B^carryIn;     // At all times, keep Y equal to this logic expression.
                            // ^ means XOR
                            // XOR outputs 1 when an odd number of inputs are 1
                            // A^B^carryIn means "the sum bit is 1 if an odd number of A, B, and carryIn are 1"
assign carryOut = (A & B) | (carryIn & (A^B));  // computes the carry out.
                                                // if both A and B are 1, we definitely generate a carry
                                                // if carryIn = 1 and exactly one of A or B is 1, then we also get a carry
                                                // In Short: either A and B already made a carry, or carryIn combines with exactly one of A and B to make a carry

endmodule
