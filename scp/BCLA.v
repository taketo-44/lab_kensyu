`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/28 16:08:53
// Design Name: 
// Module Name: BCLA
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


module BCLA(
    input [3:0] a, // 4-bit generate input
    input [3:0] b, // 4-bit propagate input
    input cin, // Carry-in input
    output [3:0] sum, // 4-bit sum output
    output cout // Carry-out output
    );
    wire [3:0] p, g; // Intermediate wires for propagate and generate
    wire [3:0] c; // Carry wires for each bit

    assign p = a ^ b; // Propagate bits: p[i] = a[i] ^ b[i]
    assign g = a & b; // Generate bits: g[i] = a[i] & b[i]

    assign c[0] = cin; // First carry is the carry-in
    assign c[1] = g[0] | (p[0] & cin); // Carry for bit 1
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin); // Carry for bit 2
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) |
                    (p[2] & p[1] & p[0] & cin); // Carry for bit 3
    assign cout = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) |
                    (p[3] & p[2] & p[1] & g[0]) |
                    (p[3] & p[2] & p[1] & p[0] & cin); // Final carry-out
    assign sum = p ^ c; // Sum bits: sum[i] = p[i] ^ c[i]
endmodule