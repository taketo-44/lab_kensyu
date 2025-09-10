`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/28 17:40:00
// Design Name: 
// Module Name: BCLA_16BIT
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


module BCLA_16BIT(
    input [15:0] a,
    input [15:0] b,
    input cin,
    output [15:0] sum,
    output cout
    );
    wire c;
    BCLA_8BIT u0 (
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(cin),
        .sum(sum[7:0]),
        .cout(c)
    );
    BCLA_8BIT u1 (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(c),
        .sum(sum[15:8]),
        .cout(cout)
    );
endmodule
