`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/10 18:18:45
// Design Name: 
// Module Name: ALU_32
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


module ALU_32(a, b, op, s, zero_flag);
    input [31:0] a, b; // 32-bit inputs
    input [3:0] op; // Operation select
    output wire [31:0] s; // 32-bit output
    output wire zero_flag; // Zero flag output
    // Zero flag is set if the output is zero

    wire [31:0] c; // Register for carry
    //the last bit of c means overflow
    //if it is addition or subtraction, use FA32 instead
    generate
        for (genvar i = 0; i < 32; i = i + 1) begin : ALU
            if (i == 0) begin
                ALU_BOTTOM ab0 (.a(a[i]), .b(b[i]), .op(op), .c_out(c[i]), .s(s[i])); // First bit
                // No carry in for the first bit
            end else if (i == 31) begin
                ALU_TOP ab31 (.a(a[i]), .b(b[i]), .op(op), .c_in(c[i - 1]) ,.c_out(c[i]), .s(s[i])); // Last bit
                // No carry out for the last bit
            end else begin
                ALU ab (.a(a[i]), .b(b[i]), .op(op), .c_in(c[i - 1]), .c_out(c[i]), .s(s[i])); // Middle bits
                // Both carry in or out for middle bits
            end
        end
    endgenerate

    // Set zero_flag if any bit in s is non-zero
    assign zero_flag = ~|s;
endmodule

