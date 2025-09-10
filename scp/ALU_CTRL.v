`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/11 17:07:35
// Design Name: 
// Module Name: ALU_CTRL
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


module ALU_CTRL(funct, alu_op, alu_ctrl);
    input [5:0] funct;
    input [1:0] alu_op;
    output reg [3:0] alu_ctrl; // 4-bit ALU control signal
    // ALU control signals:
    // 0000: AND
    // 0001: OR
    // 0010: ADD
    // 0011: XOR (not used in this design)
    // 0100: NOR (not used in this design)
    // 0110: SUB
    // 0111: SLT (Set Less Than)
    // 1111: Invalid operation (default case)
    always @(*) begin
        case (alu_op)
            2'b00: alu_ctrl = 4'b0010; // ADD
            2'b01: alu_ctrl = 4'b0110; // SUB
            2'b10: begin // R-type instructions
                case (funct)
                    6'b100000: alu_ctrl = 4'b0010; // ADD
                    6'b100010: alu_ctrl = 4'b0110; // SUB
                    6'b100100: alu_ctrl = 4'b0000; // AND
                    6'b100101: alu_ctrl = 4'b0001; // OR
                    6'b101010: alu_ctrl = 4'b0111; // SLT
                    default:   alu_ctrl = 4'b1111; // Invalid operation
                endcase
            end
            default: alu_ctrl = 4'b1111; // Invalid operation
        endcase
    end
endmodule
