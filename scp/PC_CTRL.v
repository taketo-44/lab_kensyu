`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/13 14:46:53
// Design Name: 
// Module Name: PC_CTRL
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


//module PC_CTRL(clk, rst, pc, branch, jump, zero_flag, branch_address, jump_address);
//    input clk, rst;
//
//    input branch; // Branch signal (not used in this module, but can be extended)
//    input jump; // Jump signal (not used in this module, but can be extended)
//    input zero_flag; // Zero flag (not used in this module, but can be extended)
//
//    input [31:0] branch_address; // Branch address (not used in this module, but can be extended)
//    input [31:0] jump_address; // Jump address (not used in this module, but can be extended)
//
//    output reg [31:0] pc; // Next PC value
//    wire [31:0] fa32_out; // Output of the 32-bit adder
//    wire [31:0] pc_incremented; // Incremented PC value
//
//    // Instantiate the 32-bit adder to increment PC by 4
//    FA32 fa32_inst(.a(pc), .b(32'h00000004), .s(fa32_out));
//
//    assign pc_incremented = jump ? jump_address : 
//                            (branch && zero_flag ? branch_address : fa32_out); // Determine next PC value based on jump or branch
//    // Always block to update PC on clock edge or reset
//    always @(posedge clk or negedge rst) begin
//        if (rst == 0) begin
//            pc <= 32'h00000000; // Reset PC to 0
//        end else begin
//            pc <= pc_incremented; // Update PC to next value
//        end
//    end
//endmodule


module PC_CTRL(clk, rst, pc, pc_next, pc_write);
    input clk, rst;
    input pc_write; // Control signal to write to PC
    input [31:0] pc;
    output reg [31:0] pc_next; // Next PC value
    always @(posedge clk or negedge rst) begin
        if (rst == 0) begin
            pc_next <= 32'h00000000; // Reset PC to 0
        end else if (pc_write) begin
            pc_next <= pc; // Update PC to next value
            //no update on pc if pc_write is not asserted
        end
    end
endmodule
