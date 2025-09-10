`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/28 17:39:21
// Design Name: 
// Module Name: BCLA_8BIT
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


module BCLA_8BIT(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
    );
    wire c;
    
    BCLA u0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(cin),
        .sum(sum[3:0]),
        .cout(c)
    );
    BCLA u1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(c),
        .sum(sum[7:4]),
        .cout(cout)
    );
endmodule
