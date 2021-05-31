module get_pos(
    input wire clk,
    input wire [18:0] p,
    input wire [9:0] ori_x,
    input wire [9:0] ori_y,
    input wire [9:0] ori_z,
    input wire [9:0] dir_x, // * 2 ^ 8
    input wire [9:0] dir_y, // * 2 ^ 8
    input wire [9:0] dir_z, // * 2 ^ 8
    output reg [17:0] out_x,
    output reg [17:0] out_y,
    output reg [17:0] out_z,
    output reg [9:0] out_p
);

always @(posedge clk) begin
    if (p < 0 || p[17:10] > 0) begin
        out_p <= 10'b1111111111;
        out_x <= 18'b111111111111111111;
        out_y <= 18'b111111111111111111;
    end
    else begin
        out_p <= p[9:0];
        out_x <= dir_x * p[9:0] + ori_x;
        out_y <= dir_y * p[9:0] + ori_y;
        out_z <= dir_z * p[9:0] + ori_z;
    end
end

endmodule
