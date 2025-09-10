`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/17 11:57:54
// Design Name: 
// Module Name: FORWARDING_UNIT
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


module FORWARDING_UNIT(ID_EX_RS, ID_EX_RT, EX_MEM_RD, MEM_WB_RD, EX_MEM_RegWrite, MEM_WB_RegWrite, ForwardA, ForwardB);

    input [4:0] ID_EX_RS; // Source register 1
    input [4:0] ID_EX_RT; // Source register 2
    input [4:0] EX_MEM_RD; // Destination register from EX stage
    input [4:0] MEM_WB_RD; // Destination register from MEM stage
    input EX_MEM_RegWrite; // Write enable signal from EX stage
    input MEM_WB_RegWrite; // Write enable signal from MEM stage

    output reg [1:0] ForwardA = 2'b00; // Forwarding control for source register 1
    output reg [1:0] ForwardB = 2'b00; // Forwarding control for source register 2

    always @(*) begin
        // Forwarding logic for ForwardA
        if (EX_MEM_RegWrite && (EX_MEM_RD != 0) && (EX_MEM_RD == ID_EX_RS)) begin
            ForwardA = 2'b10; // Forward from EX stage
        end else if (MEM_WB_RegWrite && (MEM_WB_RD != 0) && (MEM_WB_RD == ID_EX_RS) && !(EX_MEM_RegWrite && (EX_MEM_RD != 0) && (EX_MEM_RD == ID_EX_RT)) && (MEM_WB_RD == ID_EX_RS)) begin
            ForwardA = 2'b01; // Forward from MEM stage
        end else begin
            ForwardA = 2'b00; // No forwarding
        end

        // Forwarding logic for ForwardB
        if (EX_MEM_RegWrite && (EX_MEM_RD != 0) && (EX_MEM_RD == ID_EX_RT)) begin
            ForwardB = 2'b10; // Forward from EX stage
        end else if (MEM_WB_RegWrite && (MEM_WB_RD != 0) && (MEM_WB_RD == ID_EX_RT) && !(EX_MEM_RegWrite && (EX_MEM_RD != 0) && (EX_MEM_RD == ID_EX_RT)) && (MEM_WB_RD == ID_EX_RT)) begin
            ForwardB = 2'b01; // Forward from MEM stage
        end else begin
            ForwardB = 2'b00; // No forwarding
        end
    end
endmodule
