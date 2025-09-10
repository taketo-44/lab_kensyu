`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/16 20:06:06
// Design Name: 
// Module Name: main_logic
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: determine_winner, player_action
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Corrected module integration and logic
// Revision 0.03 - Instantiated player_action module
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////
// Module Name: main_logic
// Revision: 0.04 - Added outputs for VGA display
//////////////////////////////////////////////////////////////////////////////////
module main_logic(
    input clk,
    input rst,

    // 物理ボタンからの入力
    input btn_up,
    input btn_down,
    input btn_left,
    input btn_right,
    input btn_select,

    // VGA表示モジュールへの出力
    output wire [15*15*2-1:0] flat_board, // 2bit * 15 * 15
    output wire [3:0] cursor_x_out,
    output wire [3:0] cursor_y_out,
    output wire [1:0] winner_out
    );

    // パラメータ
    localparam BOARD_SIZE = 15;
    localparam EMPTY = 2'b00;
    localparam BLACK = 2'b01;
    localparam WHITE = 2'b10;

    // 内部レジスタ
    reg [1:0] current_player;
    reg [1:0] winner_reg;

    // --- player_actionモジュールとの接続 ---
    wire move_valid;
    wire [3:0] move_x;
    wire [3:0] move_y;

    player_action player_action_inst (
        .clk(clk), .rst(rst),
        .btn_up(btn_up), .btn_down(btn_down), .btn_left(btn_left), .btn_right(btn_right), .btn_select(btn_select),
        .move_valid(move_valid),
        .cursor_x(move_x),
        .cursor_y(move_y)
    );

    wire [1:0] winner_wire; 
    reg [1:0] board [BOARD_SIZE-1:0][BOARD_SIZE-1:0];
    genvar i,j;
    // 盤面データをフラット化
    generate
        for (i = 0; i < BOARD_SIZE; i = i + 1) begin
            for (j = 0; j < BOARD_SIZE; j = j + 1) begin
                assign flat_board[(i*BOARD_SIZE+j)*2 +: 2] = board[i][j];
            end
        end
    endgenerate

    determine_winner determine_winner_inst (
        .board(flat_board),
        .cursor_x(move_x),
        .cursor_y(move_y),
        .winner(winner_wire)
    );

    integer draw_judge = 0;

    integer row, col;
    // --- メインのゲームロジック ---
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (row = 0; row < BOARD_SIZE; row = row + 1) begin
                for (col = 0; col < BOARD_SIZE; col = col + 1) begin
                    board[row][col] <= EMPTY;
                end
            end
            current_player <= BLACK;
            winner_reg     <= EMPTY;
        end else begin
            if (winner_reg == EMPTY) begin
                if (move_valid && board[move_y][move_x] == EMPTY) begin
                    board[move_y][move_x] <= current_player;
                    current_player <= (current_player == BLACK) ? WHITE : BLACK;
                    draw_judge <= draw_judge + 1;
                end
            end
            if (winner_wire != EMPTY) begin
                winner_reg <= winner_wire;
            end else if (draw_judge == 15 * 15) begin
                winner_reg <= 2'b11; // 引き分け
            end
        end
    end

    // --- 出力ポートへの接続 ---
    assign cursor_x_out = move_x;
    assign cursor_y_out = move_y;
    assign winner_out = winner_reg;

endmodule
