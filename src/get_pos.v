module get_pos(
    input wire clk,
    input wire [18:0] p,
    input wire signed [10:0] ori_x,
    input wire signed [10:0] ori_y,
    input wire signed [10:0] ori_z,
    input wire signed [9:0] dir_x, // * 2 ^ 8
    input wire signed [9:0] dir_y, // * 2 ^ 8
    input wire signed [9:0] dir_z, // * 2 ^ 8
    output wire signed [11:0] out_x,
    output wire signed [11:0] out_y,
    output wire signed [11:0] out_z,
    output reg [9:0] out_p
);
wire signed [10:0] signed_p;
assign signed_p = {1'b0, p[9:0]};
wire signed [19:0] signed_x;
assign signed_x = {ori_x, 8'b0};
wire signed [19:0] signed_y;
assign signed_y = {ori_y, 8'b0};
wire signed [19:0] signed_z;
assign signed_z = {ori_z, 8'b0};

reg signed [19:0] signed_out_x;
reg signed [19:0] signed_out_y;
reg signed [19:0] signed_out_z;

assign out_x = signed_out_x[19:8];
assign out_y = signed_out_y[19:8];
assign out_z = signed_out_z[19:8];

always @(posedge clk) begin
    if (p[17:10] > 0) begin
        out_p <= 10'b1111111111;
        signed_out_x <= 20'b11111111111111111111;
        signed_out_y <= 20'b11111111111111111111;
        signed_out_z <= 20'b11111111111111111111;
    end
    else begin
        out_p <= p[9:0];
        signed_out_x <= dir_x * signed_p + signed_x;
        signed_out_y <= dir_y * signed_p + signed_y;
        signed_out_z <= dir_z * signed_p + signed_z;
    end
end

endmodule
