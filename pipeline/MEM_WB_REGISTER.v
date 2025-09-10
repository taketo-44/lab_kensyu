`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/18 17:39:18
// Design Name: 
// Module Name: MEM_WB_REGISTER
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


module MEM_WB_REGISTER(
    input clk,
    input rst,
    input [31:0] alu_result_in, // Input ALU result
    input [31:0] read_data_in, // Input Read Data from Memory
    input [4:0] write_reg_in, // Input Write Register
    input reg_write_in, // Input Register Write Enable
    input memo_to_reg_in, // Input Memory to Register Select
    output reg [31:0] alu_result_out, // Output ALU result
    output reg [31:0] read_data_out, // Output Read Data from Memory
    output reg [4:0] write_reg_out, // Output Write Register
    output reg reg_write_out, // Output Register Write Enable
    output reg memo_to_reg_out // Output Memory to Register Select
    );
    always @(posedge clk or negedge rst) begin
        if (rst == 0) begin
            alu_result_out <= 32'b0; // Reset ALU result to 0
            read_data_out <= 32'b0; // Reset Read Data to 0
            write_reg_out <= 5'b0; // Reset Write Register to 0
            reg_write_out <= 1'b0; // Reset Register Write Enable to 0
            memo_to_reg_out <= 1'b0; // Reset Memory to Register Select to 0
        end else begin
            alu_result_out <= alu_result_in; // Update ALU result
            read_data_out <= read_data_in; // Update Read Data from Memory
            write_reg_out <= write_reg_in; // Update Write Register
            reg_write_out <= reg_write_in; // Update Register Write Enable
            memo_to_reg_out <= memo_to_reg_in; // Update Memory to Register Select
        end
    end
endmodule
