`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/08/20 14:40:25
// Design Name: 
// Module Name: debounce
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


//module debounce(
//    input clk,
//    input rst,
//    input btn_in,
//    output reg btn_out
//    );
//
//    reg [21:0] cnt22; // Counter for debouncing
//
//    wire en40hz = (cnt22 == 22'd3125000 - 1); // Enable signal for 40Hz
//
//    always @(posedge clk) begin
//        if (!rst) begin
//            cnt22 <= 0;
//        end else begin
//            if (en40hz) begin
//                cnt22 <= 0; // Reset counter
//            end else begin
//                cnt22 <= cnt22 + 1; // Increment counter
//            end
//        end
//    end
//
//    reg ff1, ff2;
//    always @(posedge clk) begin
//        if (!rst) begin
//            ff1 <= 0;
//            ff2 <= 0;
//        end else if (en40hz) begin
//            ff2 <= ff1;    // Second flip-flop captures the first flip-flop's output
//            ff1 <= btn_in; // First flip-flop captures the input
//        end
//    end
//
//
//    wire temp = ff1 & ~ff2 & en40hz; // Detect rising edge
//    
//    always @(posedge clk) begin
//        if (!rst) begin
//            btn_out <= 0; // Reset output
//        end else begin
//            btn_out <= temp; // Update output based on temp
//        end
//    end
//endmodule

module debounce(
    input wire clk,       // システムクロック
    input wire rst,       // リセット
    input wire btn_in,    // 物理ボタンからの不安定な入力
    output wire btn_out   // チャタリングが除去された安定した出力
    );

    // 100MHzクロックで約10msの遅延を作るためのカウンタ
    // 100,000,000 Hz * 0.01 s = 1,000,000 cycles
    localparam DEBOUNCE_LIMIT = 20'd1000000;
    
    reg [19:0] counter = 0;
    reg btn_state = 0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            btn_state <= 0;
        end else begin
            if (btn_in != btn_state) begin
                // 入力と現在の状態が異なればカウンタをリセット
                counter <= 0;
            end else if (counter < DEBOUNCE_LIMIT) begin
                // 入力状態が安定していればカウントアップ
                counter <= counter + 1;
            end
            
            // カウンタが上限に達したら、その状態を安定した出力として確定
            if (counter == DEBOUNCE_LIMIT) begin
                btn_state <= btn_in;
            end
        end
    end
    
    assign btn_out = btn_state;

endmodule