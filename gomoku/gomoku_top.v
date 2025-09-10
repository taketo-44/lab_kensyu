`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/26 16:54:53
// Design Name: 
// Module Name: gomoku_top
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


module gomoku_top(
    // --- FPGAボードの物理ピンに接続するポート ---
    // クロックとリセット
    input wire clk_100mhz, // ボードのメインクロック (例: 100MHz)
    input wire cpu_reset,  // ボードのリセットボタン

    // 5方向のボタン
    input wire btn_up,
    input wire btn_down,
    input wire btn_left,
    input wire btn_right,
    input wire btn_center, // 決定ボタン

    // VGA出力
    output wire vga_hsync,
    output wire vga_vsync,
    output wire [3:0] vga_r,
    output wire [3:0] vga_g,
    output wire [3:0] vga_b
    );

    // --- 内部信号 ---
    wire sys_clk;   // ゲームロジック用クロック (100MHz)
    wire vga_clk;   // VGA表示用ピクセルクロック (25.175MHz)
    wire locked;    // PLLが安定したかを示す信号
    wire rst;       // 同期リセット信号

    // --- 1. クロック生成 ---
    // VivadoのClocking Wizardなどで生成したクロックモジュールをインスタンス化
    clk_wiz_0 clk_wiz_inst (
       .clk_in1(clk_100mhz), // 100MHz入力
       .clk_out1(sys_clk),   // 100MHz出力
       .clk_out2(vga_clk),   // 25.175MHz出力
       .reset(~cpu_reset),
       .locked(locked)
    );
    
    // PLLがロックするまでリセットをかけ続ける
    assign rst = ~locked | (~cpu_reset);

    // --- 2. ゲームロジック本体 ---
    wire [15*15*2-1:0] flat_board;
    wire [3:0] cursor_x;
    wire [3:0] cursor_y;
    wire [1:0] winner;

    main_logic main_logic_inst (
        .clk(sys_clk), 
        .rst(rst),
        .btn_up(btn_up),
        .btn_down(btn_down),
        .btn_left(btn_left),
        .btn_right(btn_right),
        .btn_select(btn_center),
        .flat_board(flat_board), 
        .cursor_x_out(cursor_x),
        .cursor_y_out(cursor_y),
        .winner_out(winner)
    );

    // --- 3. VGA表示 ---
    wire [9:0] pixel_x;
    wire [9:0] pixel_y;
    wire video_on;

    vga_controller vga_ctrl_inst (
        .clk(vga_clk), 
        .rst(rst),
        .hsync(vga_hsync),
        .vsync(vga_vsync),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .video_on(video_on)
    );

    vga_board_display vga_display_inst (
        .clk(vga_clk), 
        .rst(rst),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .video_on(video_on),
        .flat_board(flat_board),
        .cursor_x(cursor_x),
        .cursor_y(cursor_y),
        .winner(winner),
        .vga_r(vga_r),
        .vga_g(vga_g),
        .vga_b(vga_b)
    );

endmodule
