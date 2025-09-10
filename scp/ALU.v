`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/10 17:28:04
// Design Name: 
// Module Name: ALU
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


module ALU(a, b, op, c_in, c_out, s);
    input a, b, c_in; // 1-bit inputs
    input [3:0] op; // 4-bit operation select
    output reg c_out, s; // 1-bit outputs

    wire a, b; // Intermediate wires for full adders
    
    always @(*) begin
        // Default assignments to avoid latches
        s = 0;
        c_out = 0;
        case (op)
            4'b0000: begin // AND operation
                s = a & b;
                c_out = 0; // No carry out for AND
            end
            4'b0001: begin // OR operation
                s = a | b;
                c_out = 0; // No carry out for OR
            end
            4'b0010: begin //ADD operation
                // Use a full adder for addition
                s = a ^ b ^ c_in; // Sum output
                c_out = (a & b) | (c_in & a) | (c_in & b); // Carry out
            end
            4'b0110: begin // SUB operation
                // Use a full adder for subtraction (b is inverted)
                s = a ^ ~b ^ c_in; // Sum output
                c_out = (a & ~b) | (c_in & a) | (c_in & ~b); // Carry out
            end
            4'b0111: begin // SLT operation (Set Less Than)
                c_out = (a < b | (a == b & c_in)) ? 1 : 0; // Set c_in to 1 if a < b, else 0
                s = 0; // No signal output for SLT
            end
        endcase
    end

endmodule
