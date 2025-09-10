`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/12 14:38:36
// Design Name: 
// Module Name: CTRL
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


module CTRL(op, reg_dst, alu_src, mem_to_reg, reg_write, mem_read, mem_write, branch, alu_op, jump, hazard_detected);

    input [5:0] op;
    input hazard_detected; // Input to detect hazards
    
    output reg reg_dst;
    output reg alu_src;
    output reg mem_to_reg;
    output reg reg_write;
    output reg mem_read;
    output reg mem_write;
    output reg branch;
    output reg [1:0] alu_op;
    output reg jump;

    always @(*) begin
        if(hazard_detected) begin
            // If a hazard is detected, disable all control signals
            reg_dst <= 0;
            alu_src <= 0;
            mem_to_reg <= 0;
            reg_write <= 0;
            mem_read <= 0;
            mem_write <= 0;
            branch <= 0;
            alu_op <= 2'b00; // Default ALU operation
            jump <= 0; // No jump
        end else begin
            case (op)
                6'b000000: begin // R-type instruction
                    reg_dst <= 1;
                    alu_src <= 0;
                    mem_to_reg <= 0;
                    reg_write <= 1;
                    mem_read <= 0;
                    mem_write <= 0;
                    branch <= 0;
                    alu_op <= 2'b10; // ALU operation for R-type
                    jump <= 0; // No jump for R-type
                end
                6'b100011: begin // LW instruction
                    reg_dst <= 0;
                    alu_src <= 1;
                    mem_to_reg <= 1;
                    reg_write <= 1;
                    mem_read <= 1;
                    mem_write <= 0;
                    branch <= 0;
                    alu_op <= 2'b00; // ALU operation for LW
                    jump <= 0; // No jump for LW
                end
                6'b101011: begin // SW instruction
                    reg_dst <= 'bx; // Don't care
                    alu_src <= 1;
                    mem_to_reg <= 'bx; // Don't care
                    reg_write <= 0; // No register write for SW
                    mem_read <= 0; // No memory read for SW
                    mem_write <= 1; // Memory write enabled
                    branch <= 0; // No branching for SW
                    alu_op <= 2'b00; // ALU operation for SW
                    jump <= 0; // No jump for SW
                end
                6'b000100: begin // BEQ instruction
                    reg_dst <= 'bx; // Don't care
                    alu_src <= 0; // ALU source is the second register
                    mem_to_reg <= 'bx; // Don't care
                    reg_write <= 0; // No register write for BEQ
                    mem_read <= 0; // No memory read for BEQ
                    mem_write <= 0; // No memory write for BEQ
                    branch <= 1; // Branching enabled for BEQ
                    alu_op <= 2'b01; // ALU operation for BEQ
                    jump <= 0; // No jump for BEQ
                end
                6'b000010: begin // JUMP instruction
                    reg_dst <= 'bx; // Don't care
                    alu_src <= 'bx; // Don't care
                    mem_to_reg <= 'bx; // Don't care
                    reg_write <= 0; // No register write for JUMP
                    mem_read <= 0; // No memory read for JUMP
                    mem_write <= 0; // No memory write for JUMP
                    branch <= 0; // No branching for JUMP
                    alu_op <= 'bx; // Don't care for JUMP
                    jump <= 1; // Jump enabled
                end
                default: begin // Default case for unsupported opcodes
                    reg_dst <= 0;
                    alu_src <= 0;
                    mem_to_reg <= 0;
                    reg_write <= 0;
                    mem_read <= 0;
                    mem_write <= 0;
                    branch <= 0;
                    alu_op <= 2'b00; // Default ALU operation
                    jump <= 0; // No jump
                end
            endcase
        end
    end
endmodule
