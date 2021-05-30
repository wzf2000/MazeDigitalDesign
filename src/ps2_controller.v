// 0: no move
// 1: straight
// 2: left
// 3: right
module ps2_controller(
    input wire clk, // 50MHz
    input wire rst,
    input wire ps2_clk,
    input wire ps2_data,
    output reg [1:0] data,
    output reg signal
);

initial signal = 0;

wire ps2_clk_n;
reg ps2_clk_1;
reg ps2_clk_2;

// check the negedge of ps2 clock
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        ps2_clk_1 <= 1'b1;
        ps2_clk_2 <= 1'b1;
    end
    else begin
        ps2_clk_1 <= ps2_clk;
        ps2_clk_2 <= ps2_clk_1;
    end
end

assign ps2_clk_n = ps2_clk_2 & (!ps2_clk_1);

// save the data from ps2 data
reg [3:0] i;
reg [7:0] tmp;

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        i <= 4'd0;
        tmp <= 8'h00;
    end
    else if (ps2_clk_n) begin
        case (i)
            4'd0: i <= i + 1'b1;
            4'd1,4'd2,4'd3,4'd4,4'd5,4'd6,4'd7,4'd8: begin
                i <= i + 1'b1;
                tmp[i - 1] <= ps2_data;
            end
            4'd9: i <= i + 1'b1;
            4'd10: i <= 4'd0;
            default:;
        endcase
    end
end

reg ps2_f0;

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        ps2_f0 <= 1'b0;
        signal <= 0;
        data <= 2'd0;
    end
    else if (i == 4'd10) begin
        if (tmp == 8'hf0) begin
            ps2_f0 <= 1'b1;
            signal <= 0;
        end
        else if (!ps2_f0)
            case (tmp)
                8'h1d: begin
                    data <= 2'd1; // "W"
                    signal <= 1;
                end
                8'h43: begin
                    data <= 2'd1; // "I"
                    signal <= 1;
                end
                8'h1c: begin
                    data <= 2'd2; // "A"
                    signal <= 1;
                end
                8'h3b: begin
                    data <= 2'd2; // "J"
                    signal <= 1;
                end
                8'h23: begin
                    data <= 2'd3; // "D"
                    signal <= 1;
                end
                8'h4b: begin
                    data <= 2'd3; // "L"
                    signal <= 1;
                end
                default:;
            endcase
        else
            ps2_f0 <= 1'b0;
    end
end

endmodule
