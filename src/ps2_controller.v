// 0: no move
// 1: straight
// 2: left
// 3: right
module ps2_controller(
    input wire clk, // 50MHz
    input wire rst,
    input wire ps2_clk,
    input wire ps2_data,
    output reg [1:0] data
);

wire ps2_clk_n;
reg ps2_clk_1;
reg ps2_clk_2;

// check the negedge of ps2 clock
always @(posedge clk or posedge rst) begin
    if (rst) begin
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

always @(posedge clk or posedge rst) begin
    if (rst) begin
        i <= 4'd0;
        tmp <= 8'h00;
    end
    else begin
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
reg [7:0] ret_data;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        ps2_f0 <= 1'b0;
        ret_data <= 8'd0;
    end
    else if (i == 4'd10) begin
        if (tmp == 8'hf0)
            ps2_f0 <= 1'b1;
        else if (!ps2_f0)
            ret_data <= tmp;
        else
            ps2_f0 <= 1'b0;
    end
end

always @(ret_data) begin
    case (ret_data)
        8'h1d: data = 2'd1; // "W"
        8'h43: data = 2'd1; // "I"
        8'h1c: data = 2'd2; // "A"
        8'h3b: data = 2'd2; // "J"
        8'h23: data = 2'd3; // "D"
        8'h4b: data = 2'd3; // "L"
        default: data = 2'd0;
    endcase
end

endmodule