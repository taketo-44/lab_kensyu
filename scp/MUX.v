`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/10 17:03:42
// Design Name: 
// Module Name: MUX
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


module MUX(a, b, s, out);
    input [31:0] a, b; // 32-bit inputs
    wire [31:0] a, b; // Declare inputs as wires
    input s; // Select signal
    output wire [31:0] out; // 32-bit output
    // MUX logic: if s is 0, output a; if s is 1, output b
    assign out = s ? b : a;
endmodule
