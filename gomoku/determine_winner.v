`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/16 20:06:29
// Design Name: 
// Module Name: determine_winner
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Corrected syntax and logic
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module determine_winner(
    // 入力ポート
    // `board`は2次元配列として渡す必要があります。
    // Verilog-2001以降では、ポートで多次元配列を直接渡せます。
    // 例: input [1:0] board [14:0][14:0]
    // ここでは、平坦化された1次元配列を仮定します。
    // 2bit/cell * 15 * 15 = 450 bits
    input [15 * 15 * 2 - 1:0] board, 
    
    // 出力ポート
    // 0: 勝者なし, 1: プレイヤー1の勝ち, 2: プレイヤー2の勝ち
    input [3:0] cursor_x,
    input [3:0] cursor_y,
    output reg [1:0] winner 
    );

    // 盤面の状態を扱いやすい2次元配列に変換
    reg [1:0] board_2d [14:0][14:0];
    integer i, j, k;

    // 1次元配列のboardを2次元配列のboard_2dに変換する
    always @(*) begin
        for (i = 0; i < 15; i = i + 1) begin
            for (j = 0; j < 15; j = j + 1) begin
                board_2d[i][j] = board[i*30 + j*2 +: 2];
            end
        end
    end
    integer dx, dy;
    integer count_pos, count_neg, add;
    integer x1, y1, x2, y2;
    // 勝者を判定する組み合わせ回路
    always @(*) begin
        //デフォルトで引き分けに設定する
        count_pos = 0;
        count_neg = 0;
        for(i = 0; i < 4; i = i + 1) begin
            case(i)
                0: begin dx = 1; dy = 0; end  // 横
                1: begin dx = 0; dy = 1; end  // 縦
                2: begin dx = 1; dy = 1; end  // 右下がり斜め
                3: begin dx = 1; dy = -1; end // 左下がり斜め
            endcase
            y1 = cursor_y;
            x1 = cursor_x;
            add =  1;
            for(j = 0; j < 5; j = j + 1) begin
                y1 = y1 + dy;
                x1 = x1 + dx;
                if(y1 < 15 && x1 < 15 && x1 >= 0 && y1 >= 0 && board_2d[y1][x1] == board_2d[cursor_y][cursor_x]) begin
                    count_pos = count_pos + add;
                end else begin
                    add = 0;
                end
            end

            y2 = cursor_y;
            x2 = cursor_x;
            add =  1;
            for(j = 0; j < 5; j = j + 1) begin
                y2 = y2 - dy;
                x2 = x2 - dx;
                if(y2 < 15 && x2 < 15 && x2 >= 0 && y2 >= 0 && board_2d[y2][x2] == board_2d[cursor_y][cursor_x]) begin
                    count_neg = count_neg + add;
                end else begin
                    add = 0;
                end
            end

            if(count_pos + count_neg + 1 >= 5) begin
                winner = board_2d[cursor_y][cursor_x];
            end
        end
    end

endmodule
