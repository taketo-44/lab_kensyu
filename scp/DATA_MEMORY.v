`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/11 18:02:15
// Design Name: 
// Module Name: DATA_MEMORY
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


module DATA_MEMORY(clk, rst, addr, write_data, mem_write, mem_read, read_data);
    input clk, rst, mem_write, mem_read;
    input [31:0] addr, write_data; // 32-bit address input
    output wire [31:0] read_data; // 32-bit data read from memory

    reg [31:0] registers [31:0]; // 32 registers, each 32 bits wide
    integer i;
    // Initialize registers to zero
    initial begin
        registers[0] = 32'b0; // Register 0 is always zero
        registers[1] = 32'b1; // Register 1 is also initialized to zero
        registers[2] = 32'b1011; // Register 2 is initialized to 11
        for (i = 3; i < 32; i = i + 1) begin
            registers[i] = 32'b0;
        end
    end

    // Read data from memory
    assign read_data = mem_read?registers[addr]:0; // Default read data to zero

    // Write data to memory on clock edge
    always @(posedge clk or negedge rst) begin
        if (rst == 0) begin
            // Reset all registers to zero
            registers[0] = 32'b0; // Register 0 is always zero
            registers[1] = 32'b1; // Register 1 is also initialized to zero
            registers[2] = 32'b1011; // Register 2 is initialized to 11
            //registers[2] = 32'b1100101; // Register 2 is initialized to 11
            //registers[2] = 32'b1111101001; // Register 2 is initialized to 11
            for (i = 3; i < 32; i = i + 1) begin
                registers[i] <= 32'b0;
            end
        end else if (mem_write) begin
            // Write data to the specified addr if mem_write is high
            registers[addr] <= write_data;
        end
    end
endmodule
