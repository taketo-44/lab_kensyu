`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/26 16:52:37
// Design Name: 
// Module Name: vga_control
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

//////////////////////////////////////////////////////////////////////////////////
// Module Name: vga_controller
// Description: 640x480 @ 60Hz VGA タイミングジェネレータ
//              ピクセルクロック (25.175MHz) で動作することを想定
//////////////////////////////////////////////////////////////////////////////////
module vga_controller (
    input wire clk,         // Pixel Clock (25.175MHz)
    input wire rst,         // Active-high reset
    output reg hsync,       // 水平同期信号
    output reg vsync,       // 垂直同期信号
    output wire [9:0] pixel_x,   // 現在の描画X座標
    output wire [9:0] pixel_y,   // 現在の描画Y座標
    output wire video_on    // 描画領域内かを示す信号
);

    // 640x480 @ 60Hz VGA タイミングパラメータ
    // 水平タイミング (ピクセル単位)
    localparam H_DISPLAY      = 640; // 表示領域
    localparam H_FP           = 16;  // フロントポーチ
    localparam H_SYNC         = 96;  // 同期パルス
    localparam H_BP           = 48;  // バックポーチ
    localparam H_TOTAL        = H_DISPLAY + H_FP + H_SYNC + H_BP; // 全体 = 800

    // 垂直タイミング (ライン単位)
    localparam V_DISPLAY      = 480; // 表示領域
    localparam V_FP           = 10;  // フロントポーチ
    localparam V_SYNC         = 2;   // 同期パルス
    localparam V_BP           = 33;  // バックポーチ
    localparam V_TOTAL        = V_DISPLAY + V_FP + V_SYNC + V_BP; // 全体 = 525

    // 水平・垂直カウンタ
    reg [9:0] h_count = 0;
    reg [9:0] v_count = 0;

    // カウンタの更新
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            h_count <= 0;
            v_count <= 0;
        end else begin
            if (h_count == H_TOTAL - 1) begin
                h_count <= 0;
                if (v_count == V_TOTAL - 1) begin
                    v_count <= 0;
                end else begin
                    v_count <= v_count + 1;
                end
            end else begin
                h_count <= h_count + 1;
            end
        end
    end

    // 同期信号の生成
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            hsync <= 1;
            vsync <= 1;
        end else begin
            // HSyncは表示領域とフロントポーチの後、同期パルス期間だけLowになる
            hsync <= !((h_count >= H_DISPLAY + H_FP) && (h_count < H_DISPLAY + H_FP + H_SYNC));
            // VSyncも同様
            vsync <= !((v_count >= V_DISPLAY + V_FP) && (v_count < V_DISPLAY + V_FP + V_SYNC));
        end
    end

    // 描画座標と描画領域内フラグ
    assign pixel_x = h_count;
    assign pixel_y = v_count;
    assign video_on = (h_count < H_DISPLAY) && (v_count < V_DISPLAY);

endmodule

//////////////////////////////////////////////////////////////////////////////////
// Module Name: vga_board_display
// Description: 五目並べの盤面、石、カーソルを描画する
// Revision: 0.02 - Corrected syntax for variable declarations
//////////////////////////////////////////////////////////////////////////////////
module vga_board_display (
    input wire clk,
    input wire rst,
    
    // vga_controllerからの入力
    input wire [9:0] pixel_x,
    input wire [9:0] pixel_y,
    input wire video_on,

    // main_logicからの入力
    input wire [15*15*2-1:0] flat_board,
    input wire [3:0] cursor_x,
    input wire [3:0] cursor_y,
    input wire [1:0] winner, // 0: 勝者なし, 1: プレイヤー1の勝ち, 2: プレイヤー2の勝ち

    // VGA DACへの出力 (12-bit color: R4, G4, B4)
    output reg [3:0] vga_r,
    output reg [3:0] vga_g,
    output reg [3:0] vga_b
);

    // 描画パラメータ
    localparam BOARD_SIZE     = 15;
    localparam BOARD_OFFSET_X = 80;
    localparam BOARD_OFFSET_Y = 0;
    localparam CELL_SIZE      = 32;
    localparam LINE_WIDTH     = 2;
    localparam STONE_RADIUS   = 14;
    localparam CURSOR_WIDTH   = 4;

    // 色の定義 (R4, G4, B4)
    localparam C_BLACK      = 12'h000;
    localparam C_WHITE      = 12'hFFF;
    localparam C_BOARD_BG   = 12'hDB4;
    localparam C_GRID       = 12'h000;
    localparam C_CURSOR     = 12'hF00;

    // 盤面の描画範囲を計算
    localparam BOARD_AREA_X_START = BOARD_OFFSET_X;
    localparam BOARD_AREA_X_END   = BOARD_OFFSET_X + CELL_SIZE * BOARD_SIZE + LINE_WIDTH;
    localparam BOARD_AREA_Y_START = BOARD_OFFSET_Y;
    localparam BOARD_AREA_Y_END   = BOARD_OFFSET_Y + CELL_SIZE * BOARD_SIZE + LINE_WIDTH;


    // 1次元の盤面データを扱いやすい2次元配列に変換する
    reg [1:0] board [0:BOARD_SIZE-1][0:BOARD_SIZE-1];
    integer i, j;

    always @(*) begin
        for (i = 0; i < BOARD_SIZE; i = i + 1) begin
            for (j = 0; j < BOARD_SIZE; j = j + 1) begin
                board[i][j] = flat_board[(i*BOARD_SIZE+j)*2 +: 2];
            end
        end
    end

    reg [11:0] rgb_out;
    integer x_in_board, y_in_board;
    integer cell_x, cell_y;
    integer x_in_cell, y_in_cell;
    integer center_offset;
    integer dx, dy;

    // 勝者表示用変数
    localparam MSG_LEN = 11;
    localparam MSG_WIDTH = MSG_LEN * 8;
    localparam MSG_HEIGHT = 16;
    localparam MSG_X_START = 320 - (MSG_WIDTH / 2);
    localparam MSG_Y_START = 240 - (MSG_HEIGHT / 2);
    localparam MSG_X_END = MSG_X_START + MSG_WIDTH;
    localparam MSG_Y_END = MSG_Y_START + MSG_HEIGHT;
    localparam C_TEXT_FG = 12'h000; // 黒
    localparam C_TEXT_BG = 12'hFFF; // 白

    integer x_in_msg, y_in_msg;
    integer char_index, x_in_char, y_in_char;

    // 8x8フォント ROM
    function [7:0] font_rom;
        // (内容は変更なしのため省略)
        input [6:0] char_ascii;
        input [2:0] row;
        begin
            case (char_ascii)
                "B": case(row) 3'd0:font_rom=8'h7C; 3'd1:font_rom=8'h42; 3'd2:font_rom=8'h42; 3'd3:font_rom=8'h7C; 3'd4:font_rom=8'h42; 3'd5:font_rom=8'h42; 3'd6:font_rom=8'h7C; default:font_rom=8'h00; endcase
                "L": case(row) 3'd0:font_rom=8'h40; 3'd1:font_rom=8'h40; 3'd2:font_rom=8'h40; 3'd3:font_rom=8'h40; 3'd4:font_rom=8'h40; 3'd5:font_rom=8'h40; 3'd6:font_rom=8'h7E; default:font_rom=8'h00; endcase
                "A": case(row) 3'd0:font_rom=8'h38; 3'd1:font_rom=8'h44; 3'd2:font_rom=8'h44; 3'd3:font_rom=8'h7C; 3'd4:font_rom=8'h44; 3'd5:font_rom=8'h44; 3'd6:font_rom=8'h44; default:font_rom=8'h00; endcase
                "C": case(row) 3'd0:font_rom=8'h3C; 3'd1:font_rom=8'h42; 3'd2:font_rom=8'h40; 3'd3:font_rom=8'h40; 3'd4:font_rom=8'h40; 3'd5:font_rom=8'h42; 3'd6:font_rom=8'h3C; default:font_rom=8'h00; endcase
                "K": case(row) 3'd0:font_rom=8'h44; 3'd1:font_rom=8'h48; 3'd2:font_rom=8'h50; 3'd3:font_rom=8'h60; 3'd4:font_rom=8'h50; 3'd5:font_rom=8'h48; 3'd6:font_rom=8'h44; default:font_rom=8'h00; endcase
                "W": case(row) 3'd0:font_rom=8'h42; 3'd1:font_rom=8'h42; 3'd2:font_rom=8'h42; 3'd3:font_rom=8'h5A; 3'd4:font_rom=8'h66; 3'd5:font_rom=8'h24; 3'd6:font_rom=8'h24; default:font_rom=8'h00; endcase
                "H": case(row) 3'd0:font_rom=8'h42; 3'd1:font_rom=8'h42; 3'd2:font_rom=8'h42; 3'd3:font_rom=8'h7E; 3'd4:font_rom=8'h42; 3'd5:font_rom=8'h42; 3'd6:font_rom=8'h42; default:font_rom=8'h00; endcase
                "I": case(row) 3'd0:font_rom=8'h7E; 3'd1:font_rom=8'h18; 3'd2:font_rom=8'h18; 3'd3:font_rom=8'h18; 3'd4:font_rom=8'h18; 3'd5:font_rom=8'h18; 3'd6:font_rom=8'h7E; default:font_rom=8'h00; endcase
                "T": case(row) 3'd0:font_rom=8'h7E; 3'd1:font_rom=8'h18; 3'd2:font_rom=8'h18; 3'd3:font_rom=8'h18; 3'd4:font_rom=8'h18; 3'd5:font_rom=8'h18; 3'd6:font_rom=8'h18; default:font_rom=8'h00; endcase
                "E": case(row) 3'd0:font_rom=8'h7E; 3'd1:font_rom=8'h40; 3'd2:font_rom=8'h40; 3'd3:font_rom=8'h7C; 3'd4:font_rom=8'h40; 3'd5:font_rom=8'h40; 3'd6:font_rom=8'h7E; default:font_rom=8'h00; endcase
                "N": case(row) 3'd0:font_rom=8'h42; 3'd1:font_rom=8'h62; 3'd2:font_rom=8'h52; 3'd3:font_rom=8'h4A; 3'd4:font_rom=8'h46; 3'd5:font_rom=8'h42; 3'd6:font_rom=8'h42; default:font_rom=8'h00; endcase
                "S": case(row) 3'd0:font_rom=8'h3C; 3'd1:font_rom=8'h42; 3'd2:font_rom=8'h40; 3'd3:font_rom=8'h3C; 3'd4:font_rom=8'h02; 3'd5:font_rom=8'h42; 3'd6:font_rom=8'h3C; default:font_rom=8'h00; endcase
                "D": case(row) 3'd0:font_rom=8'h7C; 3'd1:font_rom=8'h42; 3'd2:font_rom=8'h42; 3'd3:font_rom=8'h42; 3'd4:font_rom=8'h42; 3'd5:font_rom=8'h42; 3'd6:font_rom=8'h7C; default:font_rom=8'h00; endcase
                "R": case(row) 3'd0:font_rom=8'h7C; 3'd1:font_rom=8'h42; 3'd2:font_rom=8'h42; 3'd3:font_rom=8'h7C; 3'd4:font_rom=8'h42; 3'd5:font_rom=8'h42; 3'd6:font_rom=8'h7C; default:font_rom=8'h00; endcase
                "!": case(row) 3'd0:font_rom=8'h18; 3'd1:font_rom=8'h18; 3'd2:font_rom=8'h18; 3'd3:font_rom=8'h18; 3'd4:font_rom=8'h00; 3'd5:font_rom=8'h18; 3'd6:font_rom=8'h18; default:font_rom=8'h00; endcase
                default: font_rom = 8'h00;
            endcase
        end
    endfunction

    reg [6:0] char_to_draw;
    reg [7:0] font_data;
    // 描画ロジック (組み合わせ回路)
    always @(*) begin
        //// デフォルトの色（背景色）
        rgb_out = C_BOARD_BG;


        if (pixel_x >= BOARD_AREA_X_START && pixel_x <= BOARD_AREA_X_END &&
            pixel_y >= BOARD_AREA_Y_START && pixel_y <= BOARD_AREA_Y_END)
        begin
            // ピクセル座標を盤面内の相対座標に変換
            x_in_board = pixel_x - BOARD_OFFSET_X;
            y_in_board = pixel_y - BOARD_OFFSET_Y;

            // どのマスにいるかを計算
            cell_x = x_in_board / CELL_SIZE;
            cell_y = y_in_board / CELL_SIZE;

            // マスの中での相対座標を計算
            x_in_cell = x_in_board % CELL_SIZE;
            y_in_cell = y_in_board % CELL_SIZE;
            
            // 1. 碁盤の線を描画
            if (x_in_cell <= LINE_WIDTH || y_in_cell <= LINE_WIDTH) begin
                rgb_out = C_GRID;
            end else begin
                // 2. 碁石を描画
                center_offset = CELL_SIZE / 2;
                dx = x_in_cell - center_offset;
                dy = y_in_cell - center_offset;
                if (dx*dx + dy*dy < STONE_RADIUS*STONE_RADIUS) begin
                    case (board[cell_y][cell_x])
                        2'b01: rgb_out = C_BLACK;
                        2'b10: rgb_out = C_WHITE;
                        default:;
                    endcase
                end
            end

            // 3. カーソルを描画
            if (cursor_x == cell_x && cursor_y == cell_y) begin
                if (x_in_cell < CURSOR_WIDTH || x_in_cell >= CELL_SIZE - CURSOR_WIDTH ||
                    y_in_cell < CURSOR_WIDTH || y_in_cell >= CELL_SIZE - CURSOR_WIDTH)
                begin
                    rgb_out = C_CURSOR;
                end
            end

            if(winner != 2'b00) begin
                // 勝者がいる場合の処理
                // 画面の中央に勝者を表示
                // BLACK WINS!
                if (pixel_x >= MSG_X_START && pixel_x < MSG_X_END &&
                    pixel_y >= MSG_Y_START && pixel_y < MSG_Y_END) begin
                    
                    rgb_out = C_TEXT_BG; // テキストの背景

                    x_in_msg = pixel_x - MSG_X_START;
                    y_in_msg = pixel_y - MSG_Y_START;
                    char_index = x_in_msg / 8;
                    x_in_char = x_in_msg % 8;
                    y_in_char = y_in_msg - 4;

                    if (y_in_char >= 0 && y_in_char < 8) begin
                        if (char_index < MSG_LEN) begin
                            case (winner)
                                2'b01: begin
                                    case (char_index)
                                        0: char_to_draw = "B";
                                        1: char_to_draw = "L";
                                        2: char_to_draw = "A";
                                        3: char_to_draw = "C";
                                        4: char_to_draw = "K";
                                        5: char_to_draw = " ";
                                        6: char_to_draw = "W";
                                        7: char_to_draw = "I";
                                        8: char_to_draw = "N";
                                        9: char_to_draw = "S";
                                       10: char_to_draw = "!";
                                        default: char_to_draw = " ";
                                    endcase
                                end
                                2'b10: begin
                                    case (char_index)
                                        0: char_to_draw = "W";
                                        1: char_to_draw = "H";
                                        2: char_to_draw = "I";
                                        3: char_to_draw = "T";
                                        4: char_to_draw = "E";
                                        5: char_to_draw = " ";
                                        6: char_to_draw = "W";
                                        7: char_to_draw = "I";
                                        8: char_to_draw = "N";
                                        9: char_to_draw = "S";
                                       10: char_to_draw = "!";
                                        default: char_to_draw = " ";
                                    endcase
                                end
                                2'b11: begin
                                    case (char_index)
                                        0: char_to_draw = "D";
                                        1: char_to_draw = "R";
                                        2: char_to_draw = "A";
                                        3: char_to_draw = "W";
                                        4: char_to_draw = "!";
                                       default: char_to_draw = " ";
                                    endcase
                                end
                                default: char_to_draw = " ";
                            endcase
                        end else begin
                            char_to_draw = " ";
                        end

                        font_data = font_rom(char_to_draw, y_in_char[2:0]);
                        if (font_data[7-x_in_char]) begin
                            rgb_out = C_TEXT_FG;
                        end
                    end
                end
            end
        end

        // video_onが有効な時だけ色を出力
        if (video_on) begin
            vga_r = rgb_out[11:8];
            vga_g = rgb_out[7:4];
            vga_b = rgb_out[3:0];
        end else begin
            vga_r = 4'h0;
            vga_g = 4'h0;
            vga_b = 4'h0;
        end
    end

endmodule
