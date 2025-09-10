`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/18 17:38:58
// Design Name: 
// Module Name: EX_MEM_REGISTER
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


module EX_MEM_REGISTER(
    input clk,
    input rst,

    input [31:0] alu_result_in, // Input ALU result
    input [31:0] read_data2_in, // Input Read Data 2
    input [4:0] write_reg_in, // Input Write Register

    input [31:0] jump_addr_in,
    input [31:0] pc_in, // Input Program Counter

    input reg_write_in, // Input Register Write Enable
    input mem_read_in, // Input Memory Read Enable
    input mem_write_in, // Input Memory Write Enable
    input memo_to_reg_in, // Input Memory to Register Select
    input branch_taken_in, // Input branch taken signal
    input zero_flag_in, // Input Zero flag
    input jump_in, // Input Jump signal
    input flush, // Input Flush signal

    output reg [31:0] alu_result_out, // Output ALU result
    output reg [31:0] read_data2_out, // Output Read Data 2
    output reg [4:0] write_reg_out, // Output Write Register

    output reg [31:0] jump_addr_out, // Output Jump Address
    output reg [31:0] pc_out, // Output Program Counter

    output reg reg_write_out, // Output Register Write Enable
    output reg mem_read_out, // Output Memory Read Enable
    output reg mem_write_out, // Output Memory Write Enable
    output reg memo_to_reg_out, // Output Memory to Register Select
    output reg branch_taken_out, // Output branch taken signal
    output reg zero_flag_out, // Output Zero flag
    output reg jump_out // Output Jump signal
    );
    always @(posedge clk or negedge rst) begin
        if (rst == 0) begin
            alu_result_out <= 32'b0; // Reset ALU result to 0
            read_data2_out <= 32'b0; // Reset Read Data 2 to 0
            write_reg_out <= 5'b0; // Reset Write Register to 0
            jump_addr_out <= 32'b0; // Reset Jump Address to 0
            pc_out <= 32'b0; // Reset Program Counter to 0
            reg_write_out <= 1'b0; // Reset Register Write Enable to 0
            mem_read_out <= 1'b0; // Reset Memory Read Enable to 0
            mem_write_out <= 1'b0; // Reset Memory Write Enable to 0
            memo_to_reg_out <= 1'b0; // Reset Memory to Register Select to 0
            branch_taken_out <= 1'b0; // Reset branch taken signal
            zero_flag_out <= 1'b0; // Reset Zero flag
            jump_out <= 1'b0; // Reset Jump signal
        end else if (flush) begin
            reg_write_out <= 1'b0; // Flush Register Write Enable
            mem_read_out <= 1'b0; // Flush Memory Read Enable
            mem_write_out <= 1'b0; // Flush Memory Write Enable
            memo_to_reg_out <= 1'b0; // Flush Memory to Register Select
            branch_taken_out <= 1'b0; // Flush branch taken signal
            jump_out <= 1'b0; // Keep Jump signal as is during flush
        end else begin
            alu_result_out <= alu_result_in; // Update ALU result
            read_data2_out <= read_data2_in; // Update Read Data 2
            write_reg_out <= write_reg_in; // Update Write Register
            pc_out <= pc_in; // Update Program Counter
            jump_addr_out <= jump_addr_in; // Update Jump Address
            reg_write_out <= reg_write_in; // Update Register Write Enable
            mem_read_out <= mem_read_in; // Update Memory Read Enable
            mem_write_out <= mem_write_in; // Update Memory Write Enable
            memo_to_reg_out <= memo_to_reg_in; // Update Memory to Register Select
            branch_taken_out <= branch_taken_in; // Update branch taken signal
            zero_flag_out <= zero_flag_in; // Update Zero flag
            jump_out <= jump_in; // Update Jump signal
        end
    end
endmodule
