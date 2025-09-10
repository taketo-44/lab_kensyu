`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/28 16:04:42
// Design Name: 
// Module Name: CLA
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


module CLA(
    input [31:0] a, // 32-bit input a
    input [31:0] b, // 32-bit input b
    input cin, // Carry-in input
    output [31:0] sum, // 32-bit sum output
    output cout // Carry-out output
    );

    wire [7:0] block_carry; // Carry outputs for each block

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : block
            if (i == 0) begin
                // First block uses carry-in directly
                BCLA bcla_inst_fi (
                    .a(a[3: 0]), // Generate bits for the block
                    .b(b[3: 0]), // Propagate bits for the block
                    .cin(cin), // Carry-in for the first block
                    .sum(sum[3: 0]), // Sum output for the block
                    .cout(block_carry[i]) // Carry-out for the block
                );
            end else begin
                // Subsequent blocks use carry-out from the previous block
                BCLA bcla_inst (
                    .a(a[i * 4 + 3: i * 4]), // Generate bits for the block
                    .b(b[i * 4 + 3: i * 4]), // Propagate bits for the block
                    .cin(block_carry[i - 1]), // Carry-in from the previous block
                    .sum(sum[i * 4 + 3: i * 4]), // Sum output for the block
                    .cout(block_carry[i]) // Carry-out for the block
                );
            end
        end
    endgenerate

    assign cout = block_carry[7]; // Final carry-out is the carry-out of the last block
endmodule
