`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/11 17:26:22
// Design Name: 
// Module Name: SHIFT_2LEFT
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


module SHIFT_2LEFT(a, b);
    input [31:0] a;
    output wire [31:0] b;
    // Shift the input 'a' left by 2 bits
    assign b = a << 2;
endmodule
