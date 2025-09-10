`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/18 18:10:55
// Design Name: 
// Module Name: PIPELINING
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


module PIPELINING(
    input clk,
    input rst ,
    output wire [31:0] pc_out // Output Program Counter
    );
    wire [31:0] pc_out, pc_next, inst_out, pc_pre, pc_jump_out;
    wire IF_ID_Write, pc_write;
    wire [31:0] PC_IF_ID_out, inst_IF_ID_out, read_data1, read_data2, expanded_value;

    wire reg_dst, alu_src, mem_to_reg, reg_write, mem_read, mem_write, branch, jump;
    wire [1:0] alu_op;

    wire stall;

    wire [31:0] PC_ID_EX_out, inst_ID_EX_out, read_data1_ID_EX_out, read_data2_ID_EX_out, expanded_value_ID_EX_out;
    wire reg_dst_ID_EX_out, alu_src_ID_EX_out, mem_to_reg_ID_EX_out, reg_write_ID_EX_out;
    wire mem_read_ID_EX_out, mem_write_ID_EX_out, branch_ID_EX_out, jump_ID_EX_out;
    wire [1:0] alu_op_ID_EX_out;

    wire [31:0] shifted_value_ID_EX_out, target_ID_EX_out;
    wire [31:0] mux_out1, mux_out2, mux_out3, mux_out4, mux_out5;

    wire [3:0] alu_ctrl;
    wire [31:0] alu_result;
    wire zero_flag;

    wire [1:0] forward_A, forward_B;
    wire [31:0] alu_result_EX_MEM_out, read_data2_EX_MEM_out, jump_addr_EX_MEM_out, PC_EX_MEM_out;
    wire [27:0] jump_addr_ID_EX_out;
    wire [4:0] write_reg_EX_MEM_out;
    wire reg_write_EX_MEM_out, mem_read_EX_MEM_out, mem_write_EX_MEM_out, mem_to_reg_EX_MEM_out;
    wire branch_taken_EX_MEM_out, zero_flag_EX_MEM_out, jump_EX_MEM_out;

    wire [31:0] read_data_out;

    wire [31:0] alu_result_MEM_WB_out, read_data_MEM_WB_out, jump_addr_MEM_WB_out;
    wire [4:0] write_reg_MEM_WB_out;
    wire reg_write_MEM_WB_out, mem_to_reg_MEM_WB_out;


    MUX mux_pc(
        .a(pc_next), 
        .b(PC_EX_MEM_out), 
        .s(branch_taken_EX_MEM_out && zero_flag_EX_MEM_out), // Branch taken condition
        .out(pc_pre)
    );

    MUX mux_jump(
        .a(pc_pre), 
        .b(jump_addr_EX_MEM_out), 
        .s(jump_EX_MEM_out), // Jump condition
        .out(pc_jump_out)
    );

    (*DONT_TOUCH = "true"*) 
    PC_CTRL pc_ctrl(.clk(clk), .rst(rst), .pc(pc_jump_out), .pc_next(pc_out), .pc_write(pc_write));
    (*DONT_TOUCH = "true"*) 
    FA32 fa32(.a(pc_out), .b(32'h00000004), .s(pc_next)); // PC increment by 4
    (*DONT_TOUCH = "true"*) 
    INST_MEM inst_mem(.r_address(pc_out), .r_data(inst_out)); // Instruction memory

    (*DONT_TOUCH = "true"*) 
    IF_ID_REGISTER if_id_reg(.clk(clk), .rst(rst), .PC_in(pc_next), .inst_in(inst_out), 
                              .IF_ID_Write(IF_ID_Write), .flush((branch_taken_EX_MEM_out && zero_flag_EX_MEM_out) || jump_EX_MEM_out), 
                              .PC_out(PC_IF_ID_out), .inst_out(inst_IF_ID_out));

    (*DONT_TOUCH = "true"*) 
    REGISTER register(.clk(clk), .rst(rst), .read_reg1(inst_IF_ID_out[25:21]),
                        .read_reg2(inst_IF_ID_out[20:16]), .write_reg(write_reg_MEM_WB_out), .write_data(mux_out5),
                        .reg_write(reg_write_MEM_WB_out), .read_data1(read_data1), .read_data2(read_data2));

    (*DONT_TOUCH = "true"*) 
    EXPANDER expander(.in(inst_IF_ID_out[15:0]), .out(expanded_value));

    (*DONT_TOUCH = "true"*) 
    CTRL ctrl(.op(inst_IF_ID_out[31:26]), .reg_dst(reg_dst), .alu_src(alu_src), 
               .mem_to_reg(mem_to_reg), .reg_write(reg_write), 
               .mem_read(mem_read), .mem_write(mem_write), 
               .branch(branch), .alu_op(alu_op), .jump(jump), .hazard_detected(stall));

    (*DONT_TOUCH = "true"*) 
    HAZARD_DETECTOR hazard_detector(.ID_EX_RT(inst_ID_EX_out[20:16]), .IF_ID_RS(inst_IF_ID_out[25:21]), .IF_ID_RT(inst_IF_ID_out[20:16]),
                                    .ID_EX_MemRead(mem_read_ID_EX_out), .pc_write(pc_write), .IF_ID_Write(IF_ID_Write), .hazard_detected(stall));

    (*DONT_TOUCH = "true"*) 
    ID_EX_REGISTER id_ex_reg(
        .clk(clk), 
        .rst(rst), 
        .pc_in(PC_IF_ID_out), 
        .inst_in(inst_IF_ID_out), 
        .read_data1_in(read_data1), 
        .read_data2_in(read_data2), 
        .expanded_value_in(expanded_value), 

        .alu_op_in(alu_op), 
        .reg_dst_in(reg_dst), 
        .alu_src_in(alu_src), 
        .mem_to_reg_in(mem_to_reg), 
        .reg_write_in(reg_write), 
        .mem_read_in(mem_read), 
        .mem_write_in(mem_write),
        .branch_taken_in(branch),
        .jump_in(jump),
        .flush((branch_taken_EX_MEM_out && zero_flag_EX_MEM_out) || jump_EX_MEM_out), // Flush signal to reset the pipeline
        .IF_ID_Write(IF_ID_Write), // Control signal to write to IF/ID register

        .pc_out(PC_ID_EX_out),
        .inst_out(inst_ID_EX_out),
        .read_data1_out(read_data1_ID_EX_out),
        .read_data2_out(read_data2_ID_EX_out),
        .expanded_value_out(expanded_value_ID_EX_out),
        .alu_op_out(alu_op_ID_EX_out),
        .reg_dst_out(reg_dst_ID_EX_out),
        .alu_src_out(alu_src_ID_EX_out),
        .mem_to_reg_out(mem_to_reg_ID_EX_out),
        .reg_write_out(reg_write_ID_EX_out),
        .mem_read_out(mem_read_ID_EX_out),
        .mem_write_out(mem_write_ID_EX_out),
        .branch_taken_out(branch_ID_EX_out),
        .jump_out(jump_ID_EX_out)
    );

    (*DONT_TOUCH = "true"*) 
    SHIFT_2LEFT_26 shift_2left_jump(
        .a(inst_ID_EX_out[25:0]), 
        .b(jump_addr_ID_EX_out)
    );

    (*DONT_TOUCH = "true"*) 
    SHIFT_2LEFT shift_2left_inst(
        .a(expanded_value_ID_EX_out), 
        .b(shifted_value_ID_EX_out)
    );

    (*DONT_TOUCH = "true"*) 
    FA32 fa32_inst(
        .a(PC_ID_EX_out), 
        .b(shifted_value_ID_EX_out), 
        .s(target_ID_EX_out)
    );

    (*DONT_TOUCH = "true"*) 
    MUX_2BIT mux1(
        .a(read_data1_ID_EX_out), 
        .b(mux_out5), 
        .c(alu_result_EX_MEM_out), 
        .s(forward_A), 
        .out(mux_out1)
    );

    (*DONT_TOUCH = "true"*) 
    MUX_2BIT mux2(
        .a(read_data2_ID_EX_out), 
        .b(mux_out5), 
        .c(alu_result_EX_MEM_out), 
        .s(forward_B), 
        .out(mux_out2)
    );


    (*DONT_TOUCH = "true"*) 
    MUX mux3(
        .a(inst_ID_EX_out[20:16]), // $rt register
        .b(inst_ID_EX_out[15:11]), // $rd register
        .s(reg_dst_ID_EX_out), // Select signal for register destination
        .out(mux_out3)
    );


    (*DONT_TOUCH = "true"*) 
    MUX mux4(
        .a(mux_out2), // Selected register
        .b(expanded_value_ID_EX_out), // $ra register
        .s(alu_src_ID_EX_out), // Select signal for jump
        .out(mux_out4) // Output write register
    );


    (*DONT_TOUCH = "true"*) 
    ALU_CTRL alu_ctrl_inst(
        .alu_op(alu_op_ID_EX_out), // ALU operation code
        .funct(inst_ID_EX_out[5:0]), // Function code for R-type instructions
        .alu_ctrl(alu_ctrl) // Output ALU control signal
    );

    (*DONT_TOUCH = "true"*) 
    ALU_32 alu_inst(
        .a(mux_out1), // First operand
        .b(mux_out4), // Second operand
        .op(alu_ctrl), // ALU operation code
        .s(alu_result), // ALU result output
        .zero_flag(zero_flag) // Zero flag output
    );


    (*DONT_TOUCH = "true"*) 
    FORWARDING_UNIT forwarding_unit(
        .ID_EX_RS(inst_ID_EX_out[25:21]), 
        .ID_EX_RT(inst_ID_EX_out[20:16]), 
        .EX_MEM_RD(write_reg_EX_MEM_out), 
        .MEM_WB_RD(write_reg_MEM_WB_out), 
        .EX_MEM_RegWrite(reg_write_EX_MEM_out), 
        .MEM_WB_RegWrite(reg_write_MEM_WB_out), 
        .ForwardA(forward_A), 
        .ForwardB(forward_B)
    );

    (*DONT_TOUCH = "true"*) 
    EX_MEM_REGISTER ex_mem_reg(
        .clk(clk), 
        .rst(rst), 
        .alu_result_in(alu_result),
        .read_data2_in(mux_out2),
        .write_reg_in(mux_out3),
        .jump_addr_in({PC_ID_EX_out[31:28], jump_addr_ID_EX_out}), // Jump address
        .pc_in(target_ID_EX_out), // PC value for EX stage
        .reg_write_in(reg_write_ID_EX_out),
        .mem_read_in(mem_read_ID_EX_out),
        .mem_write_in(mem_write_ID_EX_out),
        .memo_to_reg_in(mem_to_reg_ID_EX_out),
        .branch_taken_in(branch_ID_EX_out),
        .zero_flag_in(zero_flag),
        .jump_in(jump_ID_EX_out),
        .flush((branch_taken_EX_MEM_out && zero_flag_EX_MEM_out) || jump_EX_MEM_out),
        .alu_result_out(alu_result_EX_MEM_out),
        .read_data2_out(read_data2_EX_MEM_out),
        .write_reg_out(write_reg_EX_MEM_out),
        .jump_addr_out(jump_addr_EX_MEM_out),
        .pc_out(PC_EX_MEM_out),
        .reg_write_out(reg_write_EX_MEM_out),
        .mem_read_out(mem_read_EX_MEM_out),
        .mem_write_out(mem_write_EX_MEM_out),
        .memo_to_reg_out(mem_to_reg_EX_MEM_out),
        .branch_taken_out(branch_taken_EX_MEM_out),
        .zero_flag_out(zero_flag_EX_MEM_out),
        .jump_out(jump_EX_MEM_out)
    );

    (*DONT_TOUCH = "true"*) 
    DATA_MEMORY data_mem_inst(
        .clk(clk), 
        .rst(rst), 
        .addr(alu_result_EX_MEM_out), 
        .write_data(read_data2_EX_MEM_out), 
        .mem_write(mem_write_EX_MEM_out), 
        .mem_read(mem_read_EX_MEM_out), 
        .read_data(read_data_out) // Output read data
    );


    (*DONT_TOUCH = "true"*) 
    MEM_WB_REGISTER mem_wb_reg(
        .clk(clk), 
        .rst(rst), 
        .alu_result_in(alu_result_EX_MEM_out), // Input ALU result
        .read_data_in(read_data_out), // Input Read Data from Memory
        .write_reg_in(write_reg_EX_MEM_out), // Input Write Register
        .reg_write_in(reg_write_EX_MEM_out), // Input Register Write Enable
        .memo_to_reg_in(mem_to_reg_EX_MEM_out), // Input Memory to Register Select
        .alu_result_out(alu_result_MEM_WB_out), // Output ALU result
        .read_data_out(read_data_MEM_WB_out), // Output Read Data from Memory
        .write_reg_out(write_reg_MEM_WB_out), // Output Write Register
        .reg_write_out(reg_write_MEM_WB_out), // Output Register Write Enable
        .memo_to_reg_out(mem_to_reg_MEM_WB_out) // Output Memory to Register
    );

    (*DONT_TOUCH = "true"*) 
    MUX mux5(
        .a(alu_result_MEM_WB_out), // ALU result
        .b(read_data_MEM_WB_out), // Read data from memory
        .s(mem_to_reg_MEM_WB_out), // Select signal for memory to register
        .out(mux_out5) // Output write data
    );
endmodule
