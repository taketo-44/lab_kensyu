`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/11 23:26:25
// Design Name: 
// Module Name: player_action
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: debounce module
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Adapted for 15x15 board and improved logic
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module player_action(
    input clk,
    input rst, // Active-high reset

    // 物理ボタンからの入力（debounceモジュールに接続されることを想定）
    input btn_up,
    input btn_down,
    input btn_left,
    input btn_right,
    input btn_select,

    // main_logicへの出力
    output reg move_valid,      // 石を置くタイミングを伝える1サイクルパルス
    output reg [3:0] cursor_x,  // カーソルのX座標 (0-14)
    output reg [3:0] cursor_y   // カーソルのY座標 (0-14)
    );

    // --- ボタン入力のデバウンスとエッジ検出 ---
    wire db_up_out, db_down_out, db_left_out, db_right_out, db_select_out;

    // debounceモジュールをインスタンス化
    debounce db_up   (.clk(clk), .rst(rst), .btn_in(btn_up),    .btn_out(db_up_out));
    debounce db_down (.clk(clk), .rst(rst), .btn_in(btn_down),  .btn_out(db_down_out));
    debounce db_left (.clk(clk), .rst(rst), .btn_in(btn_left),  .btn_out(db_left_out));
    debounce db_right(.clk(clk), .rst(rst), .btn_in(btn_right), .btn_out(db_right_out));
    debounce db_select(.clk(clk), .rst(rst), .btn_in(btn_select),.btn_out(db_select_out));

    // ボタンが押された瞬間を検出するためのレジスタ
    reg up_reg, down_reg, left_reg, right_reg, select_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            up_reg <= 0;
            down_reg <= 0;
            right_reg <= 0;
            left_reg <= 0;
            select_reg <= 0;
        end else begin
            up_reg <= db_up_out;
            down_reg <= db_down_out;
            left_reg <= db_left_out;
            right_reg <= db_right_out;
            select_reg <= db_select_out;
        end
    end
    // ボタンの立ち上がりエッジ（押された瞬間）を検出
    wire up_posedge    = db_up_out    && ~up_reg;
    wire down_posedge  = db_down_out  && ~down_reg;
    wire left_posedge  = db_left_out  && ~left_reg;
    wire right_posedge = db_right_out && ~right_reg;
    wire select_posedge = db_select_out && ~select_reg;


    // --- カーソル移動と決定ロジック ---
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // リセット時、カーソルをボード中央(7,7)に配置
            cursor_x <= 7;
            cursor_y <= 7;
            move_valid <= 1'b0;

        end else begin
            move_valid <= 1'b0; // デフォルトでLow

            // カーソル移動ロジック (ボタンが押された瞬間だけ反応)
            if (up_posedge && cursor_y > 0) begin
                cursor_y <= cursor_y - 1;
            end else if (down_posedge && cursor_y < 14) begin
                cursor_y <= cursor_y + 1;
            end else if (left_posedge && cursor_x > 0) begin
                cursor_x <= cursor_x - 1;
            end else if (right_posedge && cursor_x < 14) begin
                cursor_x <= cursor_x + 1;
            end

            // 決定ロジック (selectボタンが押された瞬間に1クロックだけHighになるパルスを生成)
            if (select_posedge) begin
                move_valid <= 1'b1;
            end
        end
    end

endmodule
