`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/12 16:35:45
// Design Name: 
// Module Name: MUX_5BIT
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

module MUX_5BIT(a, b, s, out);
    input [4:0] a, b; // 5-bit inputs
    wire [4:0] a, b; // Declare inputs as wires
    input s; // Select signal
    output wire [4:0] out; // 5-bit output
    // MUX logic: if s is 0, output a; if s is 1, output b
    assign out = s ? b : a;
endmodule
