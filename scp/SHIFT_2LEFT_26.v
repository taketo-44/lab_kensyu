`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/12 16:27:34
// Design Name: 
// Module Name: SHIFT_2LEFT_26
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

module SHIFT_2LEFT_26(a, b);
    input [25:0] a;
    output wire [27:0] b;
    // Shift the input 'a' left by 2 bits
    assign b = a << 2;
endmodule
