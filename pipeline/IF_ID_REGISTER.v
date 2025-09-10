`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/18 17:35:32
// Design Name: 
// Module Name: IF_ID_REGISTER
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


module IF_ID_REGISTER(
    input clk,
    input rst,
    input [31:0] PC_in, // Input Program Counter
    input [31:0] inst_in, // Input Program Counter
    input IF_ID_Write, // Input instruction
    input flush, // Input instruction
    output reg [31:0] PC_out, // Output Program Counter
    output reg [31:0] inst_out // Output instruction
);

    always @(posedge clk or negedge rst) begin
        if (rst == 0) begin
            PC_out <= 32'b0; // Reset Program Counter to 0
            inst_out <= 32'b0; // Reset instruction to 0
        end else if (IF_ID_Write) begin
            PC_out <= PC_in; // Update Program Counter
            inst_out <= inst_in; // Update instruction
        end else if (flush) begin
            PC_out <= 32'b0; // Flush Program Counter
            inst_out <= 32'b0; // Flush instruction
        end
        //no update if IF_ID_Write is low and IF_Flush is low
    end
endmodule
