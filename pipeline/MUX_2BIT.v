`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/17 11:53:40
// Design Name: 
// Module Name: MUX_2BIT
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


module MUX_2BIT(a, b, c, s, out);
    input [31:0] a, b, c; // 32-bit inputs
    wire [31:0] a, b, c; // Declare inputs as wires
    input [1:0] s; // 2-bit select signal
    output wire [31:0] out; // 32-bit output
    // MUX logic: if s is 00, output a; if s is 01, output b; if s is 10, output c
    assign out = (s == 2'b00) ? a : 
                 (s == 2'b01) ? b : 
                 (s == 2'b10) ? c : 
                 32'b0; // Default case to avoid latches
endmodule
