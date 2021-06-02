module get_pos(
    input wire clk,
    input wire [18:0] p,
    input wire signed [10:0] ori_x,
    input wire signed [10:0] ori_y,
    input wire signed [10:0] ori_z,
    input wire signed [9:0] dir_x, // * 2 ^ 8
    input wire signed [9:0] dir_y, // * 2 ^ 8
    input wire signed [9:0] dir_z, // * 2 ^ 8
    output reg signed [11:0] out_x,
    output reg signed [11:0] out_y,
    output reg signed [11:0] out_z,
    output reg [9:0] out_p
);

reg signed [7:0] tmp[2:0];

always @(posedge clk) begin
    if (p[17:10] > 0) begin
        out_p <= 10'b1111111111;
        out_x <= 18'b111111111111111111;
        out_y <= 18'b111111111111111111;
    end
    else begin
        out_p <= p[9:0];
        {out_x, tmp[0]} <= dir_x * p[9:0] + {ori_x, 8'b0};
        {out_y, tmp[1]} <= dir_y * p[9:0] + {ori_y, 8'b0};
        {out_z, tmp[2]} <= dir_z * p[9:0] + {ori_z, 8'b0};
    end
end

endmodule
