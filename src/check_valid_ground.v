module check_valid_ground(
    input wire clk,
    input wire signed [9:0] in_p,
    input wire signed [17:0] in_x,
    input wire signed [17:0] in_y,
    input wire signed [17:0] in_z,
    output reg signed [9:0] out_x,
    output reg signed [9:0] out_y,
    output reg signed [9:0] out_z,
    output reg signed [9:0] out_p,
    output reg en
);

always @(posedge clk) begin
    if (in_y > 320 || in_y < 0 || in_x > 320 || in_x < 0) begin
        out_p <= -1;
        en <= 0;
        out_x <= 10'b1111111111;
        out_y <= 10'b1111111111;
        out_z <= 10'b1111111111;
    end
    else begin
        out_p <= in_p;
        en <= 1;
        out_x <= {in_x[17], in_x[8:0]};
        out_y <= {in_y[17], in_y[8:0]};
        out_z <= {in_z[17], in_z[8:0]};
    end
end

endmodule
