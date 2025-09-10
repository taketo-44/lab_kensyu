`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/28 16:05:51
// Design Name: 
// Module Name: PPA
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


module PPA(
    input [31:0] a,
    input [31:0] b,
    input cin,
    output [31:0] sum,
    output cout
    );
    wire c;
    BCLA_16BIT u0 (
        .a(a[15:0]),
        .b(b[15:0]),
        .cin(cin),
        .sum(sum[15:0]),
        .cout(c)
    );
    BCLA_16BIT u1 (
        .a(a[31:16]),
        .b(b[31:16]),
        .cin(c),
        .sum(sum[31:16]),
        .cout(cout)
    );
endmodule
