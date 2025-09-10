`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/12 14:54:47
// Design Name: 
// Module Name: SCP
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


module SCP(input clk, input rst, output wire [31:0] pc);
    wire [27:0] shifted_value;
    wire [31:0] inst, pc, pc_next, shifted_value2, target, pc_next_before_addition;
    wire [31:0] read_data1, read_data2, expanded_value, alu_result, read_data_mem, mux_out2, mux_out3, mux_out4;
    wire [5:0] funct;
    wire [3:0] alu_ctrl;
    wire [4:0] mux_out1;
    wire reg_dst, alu_src, mem_to_reg, reg_write, mem_read, mem_write, branch, zero_flag, jump;
    wire [1:0] alu_op;
    (*DONT_TOUCH = "true"*) 
    PC_CTRL pc_ctrl(.clk(clk), .rst(rst), .pc(pc), .pc_next(pc_next_before_addition));
    (*DONT_TOUCH = "true"*) 
    FA32 fa32(.a(pc_next_before_addition), .b(32'h00000004), .s(pc_next));
    (*DONT_TOUCH = "true"*) 
    INST_MEM inst_mem (.r_address(pc_next_before_addition), .r_data(inst));

    (*DONT_TOUCH = "true"*) 
    SHIFT_2LEFT_26 shift_2left(.a(inst[25:0]), .b(shifted_value));

    (*DONT_TOUCH = "true"*) 
    CTRL ctrl(.op(inst[31:26]), .reg_dst(reg_dst), .alu_src(alu_src), 
               .mem_to_reg(mem_to_reg), .reg_write(reg_write), 
               .mem_read(mem_read), .mem_write(mem_write), 
               .branch(branch), .alu_op(alu_op), .jump(jump));


    (*DONT_TOUCH = "true"*) 
    MUX_5BIT mux1(.a(inst[20:16]), .b(inst[15:11]), .s(reg_dst), .out(mux_out1));
    (*DONT_TOUCH = "true"*) 
    REGISTER register(.clk(clk), .rst(rst), .read_reg1(inst[25:21]), 
                      .read_reg2(inst[20:16]), .write_reg(mux_out1), 
                      .write_data(mux_out3), .reg_write(reg_write), 
                      .read_data1(read_data1), .read_data2(read_data2));

    (*DONT_TOUCH = "true"*) 
    EXPANDER expander(.in(inst[15:0]), .out(expanded_value));
    (*DONT_TOUCH = "true"*) 
    MUX mux2(.a(read_data2), .b(expanded_value), .s(alu_src), .out(mux_out2));

    (*DONT_TOUCH = "true"*) 
    ALU_CTRL alu_control(.funct(inst[5:0]),.alu_op(alu_op),  .alu_ctrl(alu_ctrl));
    (*DONT_TOUCH = "true"*) 
    ALU_32 alu(.a(read_data1), .b(mux_out2), .op(alu_ctrl), .s(alu_result), .zero_flag(zero_flag));

    (*DONT_TOUCH = "true"*) 
    DATA_MEMORY data_memory(.clk(clk), .rst(rst), .addr(alu_result), 
                            .write_data(read_data2), .mem_read(mem_read), 
                            .mem_write(mem_write), .read_data(read_data_mem));

    (*DONT_TOUCH = "true"*) 
    MUX mux3(.a(alu_result), .b(read_data_mem), .s(mem_to_reg), .out(mux_out3));

    (*DONT_TOUCH = "true"*) 
    SHIFT_2LEFT shift_2left2(.a(expanded_value), .b(shifted_value2));
    (*DONT_TOUCH = "true"*) 
    FA32 fa32_branch(.a(pc_next), .b(shifted_value2), .s(target));

    (*DONT_TOUCH = "true"*) 
    MUX mux4(.a(pc_next), .b(target), .s(branch & zero_flag), .out(mux_out4));
    (*DONT_TOUCH = "true"*) 
    MUX mux5(.a(mux_out4), .b({pc_next[31:28], shifted_value}), .s(jump), .out(pc));
endmodule
