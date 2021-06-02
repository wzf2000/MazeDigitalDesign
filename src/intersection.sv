module intersection
#(parameter wall = 0)
(
    input wire clk,
    input wire signed [9:0] dir,    // * 2 ^ 8
    input wire signed [9:0] ori,    // * 2 ^ 0
    output reg signed [18:0] p      // * 2 ^ 0
);

localparam [0:511][8:0] inverse = {
    9'b111111111,
    9'b111111111,
    9'b100000000,
    9'b010101011,
    9'b010000000,
    9'b001100110,
    9'b001010101,
    9'b001001001,
    9'b001000000,
    9'b000111001,
    9'b000110011,
    9'b000101111,
    9'b000101011,
    9'b000100111,
    9'b000100101,
    9'b000100010,
    9'b000100000,
    9'b000011110,
    9'b000011100,
    9'b000011011,
    9'b000011010,
    9'b000011000,
    9'b000010111,
    9'b000010110,
    9'b000010101,
    9'b000010100,
    9'b000010100,
    9'b000010011,
    9'b000010010,
    9'b000010010,
    9'b000010001,
    9'b000010001,
    9'b000010000,
    9'b000010000,
    9'b000001111,
    9'b000001111,
    9'b000001110,
    9'b000001110,
    9'b000001101,
    9'b000001101,
    9'b000001101,
    9'b000001100,
    9'b000001100,
    9'b000001100,
    9'b000001100,
    9'b000001011,
    9'b000001011,
    9'b000001011,
    9'b000001011,
    9'b000001010,
    9'b000001010,
    9'b000001010,
    9'b000001010,
    9'b000001010,
    9'b000001001,
    9'b000001001,
    9'b000001001,
    9'b000001001,
    9'b000001001,
    9'b000001001,
    9'b000001001,
    9'b000001000,
    9'b000001000,
    9'b000001000,
    9'b000001000,
    9'b000001000,
    9'b000001000,
    9'b000001000,
    9'b000001000,
    9'b000000111,
    9'b000000111,
    9'b000000111,
    9'b000000111,
    9'b000000111,
    9'b000000111,
    9'b000000111,
    9'b000000111,
    9'b000000111,
    9'b000000111,
    9'b000000110,
    9'b000000110,
    9'b000000110,
    9'b000000110,
    9'b000000110,
    9'b000000110,
    9'b000000110,
    9'b000000110,
    9'b000000110,
    9'b000000110,
    9'b000000110,
    9'b000000110,
    9'b000000110,
    9'b000000110,
    9'b000000110,
    9'b000000101,
    9'b000000101,
    9'b000000101,
    9'b000000101,
    9'b000000101,
    9'b000000101,
    9'b000000101,
    9'b000000101,
    9'b000000101,
    9'b000000101,
    9'b000000101,
    9'b000000101,
    9'b000000101,
    9'b000000101,
    9'b000000101,
    9'b000000101,
    9'b000000101,
    9'b000000101,
    9'b000000101,
    9'b000000101,
    9'b000000100,
    9'b000000100,
    9'b000000100,
    9'b000000100,
    9'b000000100,
    9'b000000100,
    9'b000000100,
    9'b000000100,
    9'b000000100,
    9'b000000100,
    9'b000000100,
    9'b000000100,
    9'b000000100,
    9'b000000100,
    9'b000000100,
    9'b000000100,
    9'b000000100,
    9'b000000100,
    9'b000000100,
    9'b000000100,
    9'b000000100,
    9'b000000100,
    9'b000000100,
    9'b000000100,
    9'b000000100,
    9'b000000100,
    9'b000000100,
    9'b000000100,
    9'b000000100,
    9'b000000100,
    9'b000000100,
    9'b000000100,
    9'b000000100,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000011,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000010,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001,
    9'b000000001
};

wire less;
wire sign;
wire signed [9:0] abs_dir;

assign less = (wall << 6) < ori;
assign sign = dir[9] ^ less;
assign abs_dir = dir[9] ? -dir : dir;

always @(posedge clk) begin
    if (dir[8:0] == 10'd0) begin
        p <= 19'b1111111111111111111;
    end
    else begin
        if (sign)
            p <= 19'b1111111111111111111;
        else begin
            p[18] <= 1'b0;
            p[17:0] <= ((less ? (ori - (wall << 6)) : ((wall << 6) - ori)) * inverse[abs_dir[8:0]]) >> 1;
        end
    end
end

endmodule
