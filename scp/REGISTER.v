`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/11 17:32:06
// Design Name: 
// Module Name: REGISTER
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


module REGISTER(clk, rst, read_reg1, read_reg2, write_reg, write_data, reg_write, read_data1, read_data2);
    input clk, rst, reg_write; // Clock signal, reset signal, and register write enable signal
    input [4:0] read_reg1, read_reg2, write_reg; // Input data to be stored in the register, to write
    input [31:0] write_data; // Data to write to the register
    output wire [31:0] read_data1, read_data2; // Output data from register 1, register 2

    reg [31:0] registers [31:0]; // 32 registers, each 32 bits wide
    integer i;
    // Initialize registers to zero
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] = 32'b0;
        end
    end

    //assign read_data1 = registers[read_reg1]; // Read data from register 1
    //assign read_data2 = registers[read_reg2]; // Read data from register 2
    assign read_data1 = reg_write && (write_reg == read_reg1)? write_data : registers[read_reg1]; // Register 0 is always zero
    assign read_data2 = reg_write && (write_reg == read_reg2)? write_data : registers[read_reg2]; // Register 0 is always zero

    // Write data to registers on clock edge
    always @(posedge clk or negedge rst) begin
        if (rst == 0) begin
            // Reset all registers to zero
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'b0;
            end
        end else if (reg_write) begin
            // Write data to the specified register if reg_write is high and write_register is not zero
            registers[write_reg] <= write_data;
        end
    end
endmodule
