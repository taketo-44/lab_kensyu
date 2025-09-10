`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/12 14:50:16
// Design Name: 
// Module Name: EXPANDER
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


module EXPANDER(in, out);
    input [15:0] in; // 16-bit input
    output wire [31:0] out; // 32-bit output
    assign out = { {16{in[15]}}, in }; // Sign-extend the 16-bit input to 32 bits
    // The output is formed by concatenating 16 sign bits (in[15]) with the original 16 bits of in
endmodule
