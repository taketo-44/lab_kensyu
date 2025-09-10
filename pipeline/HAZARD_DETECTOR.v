`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/17 12:10:58
// Design Name: 
// Module Name: HAZARD_DETECTOR
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


module HAZARD_DETECTOR(
    input [4:0] ID_EX_RT, // Source register 1
    input [4:0] IF_ID_RS, // Source register from IF stage
    input [4:0] IF_ID_RT, // Source register from IF stage
    input ID_EX_MemRead, // Memory read signal from ID/EX stage
    output reg pc_write, // Control signal to write to PC
    output reg IF_ID_Write, // Control signal to write to IF/ID pipeline register
    output reg hazard_detected // Hazard detected signal
);
    always @(*) begin
        // Initialize control signals
        pc_write = 1'b1; // Default to allow PC write
        IF_ID_Write = 1'b1; // Default to allow IF/ID write
        hazard_detected = 1'b0; // Default to no hazard detected

        // Check for data hazards
        if (ID_EX_MemRead && ((ID_EX_RT == IF_ID_RS) || (ID_EX_RT == IF_ID_RT))) begin
            // Hazard detected, stall the pipeline
            pc_write = 1'b0; // Disable PC write
            IF_ID_Write = 1'b0; // Disable IF/ID write
            hazard_detected = 1'b1; // Set hazard detected signal
        end
    end
    
endmodule
