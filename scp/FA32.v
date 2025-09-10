`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/09 17:03:58
// Design Name: 
// Module Name: FA32
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


module FA32(a, b, s);
    input [31:0] a, b;
    output [31:0] s;

    wire [31:0] c;


    // Generate 32 full adders

    parameter WIDTH = 32; // 32 bits
    genvar i;
    // Generate the rest of the adders
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : FA_GEN
            if(i == 0) begin
                // First adder, no carry-in
                FA fa_inst (
                    .a(a[i]),
                    .b(b[i]),
                    .c_in(1'b0), // No carry-in for the first adder
                    .s(s[i]),
                    .c_out(c[i])
                );
            end else begin
                // Subsequent adders, use carry-out from previous adder
                FA fa_inst (
                    .a(a[i]),
                    .b(b[i]),
                    .c_in(c[i-1]), // Carry-in from the previous adder
                    .s(s[i]),
                    .c_out(c[i])
                );
            end
        end
    endgenerate
endmodule
