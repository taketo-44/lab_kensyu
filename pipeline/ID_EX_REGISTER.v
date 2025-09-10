`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/18 17:37:55
// Design Name: 
// Module Name: ID_EX_REGISTER
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


module ID_EX_REGISTER(
    input clk,
    input rst,
    input [31:0] pc_in, // Input Program Counter
    input [31:0] inst_in, // Input instruction
    input [31:0] read_data1_in, // Input Read Data 1
    input [31:0] read_data2_in, // Input Read Data 2
    input [31:0] expanded_value_in, // Input Expanded Value

    input [1:0] alu_op_in, // Input ALUop
    input reg_dst_in, // Input Register Destination Select
    input alu_src_in, // Input ALU Source Select
    input mem_to_reg_in, // Input Memory to Register Select
    input reg_write_in, // Input Register Write Enable
    input mem_read_in, // Input Memory Read Enable
    input mem_write_in, // Input Memory Write Enable
    input branch_taken_in, // Input branch taken signal
    input jump_in, // Input Jump signal
    input flush, // Input Flush signal
    input IF_ID_Write, // Input IF_ID Write Enable


    output reg [31:0] pc_out, // Output Program Counter
    output reg [31:0] inst_out, // Output instruction
    output reg [31:0] read_data1_out, // Output Read Data 1
    output reg [31:0] read_data2_out, // Output Read Data 2
    output reg [31:0] expanded_value_out, // Output Expanded Value

    output reg [1:0] alu_op_out, // Output ALUop out
    output reg reg_dst_out, // Output Register Destination Select
    output reg alu_src_out, // Output ALU Source Select
    output reg mem_to_reg_out, // Output Memory to Register Select
    output reg reg_write_out, // Output Register Write Enable
    output reg mem_read_out, // Output Memory Read Enable
    output reg mem_write_out, // Output Memory Write Enable
    output reg branch_taken_out, // Output branch taken signal
    output reg jump_out // Output Jump signal


); 

    always @(posedge clk or negedge rst) begin
        if (rst == 0) begin
            pc_out <= 32'b0; // Reset Program Counter to 0
            inst_out <= 32'b0; // Reset instruction to 0
            read_data1_out <= 32'b0; // Reset Read Data 1 to 0
            read_data2_out <= 32'b0; // Reset Read Data 2 to 0
            expanded_value_out <= 32'b0; // Reset Expanded Value to 0

            alu_op_out <= 2'b0; // Reset ALUop to 0
            reg_dst_out <= 1'b0; // Reset Register Destination Select to 0
            alu_src_out <= 1'b0; // Reset ALU Source Select to 0
            mem_to_reg_out <= 1'b0; // Reset Memory to Register Select to 0
            reg_write_out <= 1'b0; // Reset Register Write Enable to 0
            mem_read_out <= 1'b0; // Reset Memory Read Enable to 0
            mem_write_out <= 1'b0; // Reset Memory Write Enable to 0
            branch_taken_out <= 1'b0; // Reset branch taken signal to 0
            jump_out <= 1'b0; // Reset Jump signal to 0
        end else if (flush) begin
            reg_write_out <= 1'b0; // Flush Register Write Enable
            mem_read_out <= 1'b0; // Flush Memory Read Enable
            mem_write_out <= 1'b0; // Flush Memory Write Enable
            branch_taken_out <= 1'b0; // Flush branch taken signal
            mem_to_reg_out <= 1'b0; // Flush Memory to Register Select
            jump_out <= 1'b0; // Flush Jump signal
        end else if (IF_ID_Write) begin
            pc_out <= pc_in; // Update Program Counter
            inst_out <= inst_in; // Update instruction
            read_data1_out <= read_data1_in; // Update Read Data 1
            read_data2_out <= read_data2_in; // Update Read Data 2
            expanded_value_out <= expanded_value_in; // Update Expanded Value

            alu_op_out <= alu_op_in; // Update ALUop
            reg_dst_out <= reg_dst_in; // Update Register Destination Select
            alu_src_out <= alu_src_in; // Update ALU Source Select
            mem_to_reg_out <= mem_to_reg_in; // Update Memory to Register Select
            reg_write_out <= reg_write_in; // Update Register Write Enable
            mem_read_out <= mem_read_in; // Update Memory Read Enable
            mem_write_out <= mem_write_in; // Update Memory Write Enable
            branch_taken_out <= branch_taken_in; // Update branch taken signal
            jump_out <= jump_in; // Update Jump signal
        end else begin
            // No update if IF_ID_Write is low and IF_Flush is low
            // Retain previous values
            pc_out <= pc_out; // Retain Program Counter
            inst_out <= inst_out; // Retain instruction
            read_data1_out <= read_data1_out; // Retain Read Data 1
            read_data2_out <= read_data2_out; // Retain Read Data 2
            expanded_value_out <= expanded_value_out; // Retain Expanded Value
            alu_op_out <= alu_op_out; // Retain ALUop
            reg_dst_out <= reg_dst_out; // Retain Register Destination Select
            alu_src_out <= alu_src_out; // Retain ALU Source Select
            mem_to_reg_out <= mem_to_reg_out; // Retain Memory to Register Select
            reg_write_out <= reg_write_out; // Retain Register Write Enable
            mem_read_out <= mem_read_out; // Retain Memory Read Enable
            mem_write_out <= mem_write_out; // Retain Memory Write Enable
            branch_taken_out <= branch_taken_out; // Retain branch taken signal
            jump_out <= jump_out; // Retain Jump signal
        end
    end
endmodule
