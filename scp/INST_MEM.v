`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2018/04/20 16:41:15
// Design Name:
// Module Name: INST_MEM
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


module INST_MEM(r_address, r_data);
    input  [31:0] r_address;
    output [31:0] r_data;
    reg [7:0] inst_mem [255:0];

    integer i;
    initial begin
		for (i = 32; i <= 255; i = i + 1) begin
			inst_mem[i] <= 8'h0;
    	end
																												// PC : Instruction 　　 : Meaning
		{inst_mem[0],  inst_mem[1],  inst_mem[2],  inst_mem[3]}    <= 32'b100011_11111_00001_0000000000000001;   //  0 : lw  $1, 1(M)     : $1 = M[1] (=  1)
		{inst_mem[4],  inst_mem[5],  inst_mem[6],  inst_mem[7]}    <= 32'b100011_11111_00010_0000000000000010;   //  4 : lw  $2, 2(M)     : $2 = M[2] (= 11)
		{inst_mem[8],  inst_mem[9],  inst_mem[10], inst_mem[11]}   <= 32'b100011_11111_00011_0000000000000011;   //  8 : lw  $3, 3(M)     : $3 = M[3] (=  0)
		{inst_mem[12], inst_mem[13], inst_mem[14], inst_mem[15]}   <= 32'b000000_00010_00001_00010_00000_100010; // 12 : sub $2, $2, $1   : $2 -= $1
		{inst_mem[16], inst_mem[17], inst_mem[18], inst_mem[19]}   <= 32'b000000_00011_00010_00011_00000_100000; // 16 : add $3, $3, $2   : $3 += $2
		{inst_mem[20], inst_mem[21], inst_mem[22], inst_mem[23]}   <= 32'b000100_00010_11111_0000000000000001;   // 20 : beq $2, M, 1     : if M == $2 then PC = 24 + 4 else PC = 24
		{inst_mem[24], inst_mem[25], inst_mem[26], inst_mem[27]}   <= 32'b000010_00000000000000000000000011;     // 24 : jump 3           : PC = 12
		{inst_mem[28], inst_mem[29], inst_mem[30], inst_mem[31]}   <= 32'b101011_11111_00011_0000000000000011;   // 28 : sw  $3, 3(M)     : M[3] = $3
																												// Result: M[3] = 10 + 9 + ... + 1 = 55 = 32'h37
    end

    assign r_data = {inst_mem[r_address], inst_mem[r_address+1], inst_mem[r_address+2], inst_mem[r_address+3]};
endmodule