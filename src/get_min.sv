module get_min(
    input wire clk,
    input wire [2:0] x,
    input wire [2:0] y,
    input wire p1_en,
    input wire [9:0] p1,
    input wire signed [9:0] p1_x,
    input wire signed [9:0] p1_y,
    input wire signed [9:0] p1_z,
    input wire p2_en,
    input wire [9:0] p2,
    input wire signed [9:0] p2_x,
    input wire signed [9:0] p2_y,
    input wire signed [9:0] p2_z,
    input wire p3_en,
    input wire [9:0] p3,
    input wire signed [9:0] p3_x,
    input wire signed [9:0] p3_y,
    input wire signed [9:0] p3_z,
    input wire p4_en,
    input wire [9:0] p4,
    input wire signed [9:0] p4_x,
    input wire signed [9:0] p4_y,
    input wire signed [9:0] p4_z,
    input wire p5_en,
    input wire [9:0] p5,
    input wire signed [9:0] p5_x,
    input wire signed [9:0] p5_y,
    input wire signed [9:0] p5_z,
    input wire p6_en,
    input wire [9:0] p6,
    input wire signed [9:0] p6_x,
    input wire signed [9:0] p6_y,
    input wire signed [9:0] p6_z,
    input wire p7_en,
    input wire [9:0] p7,
    input wire signed [9:0] p7_x,
    input wire signed [9:0] p7_y,
    input wire signed [9:0] p7_z,
    input wire p8_en,
    input wire [9:0] p8,
    input wire signed [9:0] p8_x,
    input wire signed [9:0] p8_y,
    input wire signed [9:0] p8_z,
    input wire p9_en,
    input wire [9:0] p9,
    input wire signed [9:0] p9_x,
    input wire signed [9:0] p9_y,
    input wire signed [9:0] p9_z,
    input wire p10_en,
    input wire [9:0] p10,
    input wire signed [9:0] p10_x,
    input wire signed [9:0] p10_y,
    input wire signed [9:0] p10_z,
    input wire p11_en,
    input wire [9:0] p11,
    input wire signed [9:0] p11_x,
    input wire signed [9:0] p11_y,
    input wire signed [9:0] p11_z,
    input wire p12_en,
    input wire [9:0] p12,
    input wire signed [9:0] p12_x,
    input wire signed [9:0] p12_y,
    input wire signed [9:0] p12_z,
    input wire p13_en,
    input wire [9:0] p13,
    input wire signed [9:0] p13_x,
    input wire signed [9:0] p13_y,
    input wire signed [9:0] p13_z,
    output wire outp_en,
    output reg [9:0] outp,
    output reg rev,
    output reg [1:0] normal_dir, // 0: x 1: y 2: z
    output reg signed [9:0] dir_to_light_0_x,
    output reg signed [9:0] dir_to_light_0_y,
    output reg signed [9:0] dir_to_light_0_z,
    output reg signed [9:0] dir_to_light_1_x,
    output reg signed [9:0] dir_to_light_1_y,
    output reg signed [9:0] dir_to_light_1_z,
    output reg signed [9:0] dir_to_light_2_x,
    output reg signed [9:0] dir_to_light_2_y,
    output reg signed [9:0] dir_to_light_2_z,
    output reg signed [9:0] dir_to_light_3_x,
    output reg signed [9:0] dir_to_light_3_y,
    output reg signed [9:0] dir_to_light_3_z
);

localparam [0:3][2:0][9:0] light_position = {{10'd256, 10'd0, 10'd160},{10'd256, 10'd160, 10'd0},{10'd256, 10'd160, 10'd320},{10'd256, 10'd320, 10'd160}};

always @(posedge clk) begin
    if (outp_en) begin
        if (p1 < p2 && p1 < p3 && p1 < p4 && p1 < p5 && p1 < p6 && p1 < p7 && p1 < p8 && p1 < p9 && p1 < p10 && p1 < p11 && p1 < p12 && p1 < p13) begin
            outp <= p1;
            rev <= 0;
            normal_dir <= 2'b10;
            dir_to_light_0_x <= light_position[0][0] - p1_x;
            dir_to_light_0_y <= light_position[0][1] - p1_y;
            dir_to_light_0_z <= light_position[0][2] - p1_z;
            dir_to_light_1_x <= light_position[1][0] - p1_x;
            dir_to_light_1_y <= light_position[1][1] - p1_y;
            dir_to_light_1_z <= light_position[1][2] - p1_z;
            dir_to_light_2_x <= light_position[2][0] - p1_x;
            dir_to_light_2_y <= light_position[2][1] - p1_y;
            dir_to_light_2_z <= light_position[2][2] - p1_z;
            dir_to_light_3_x <= light_position[3][0] - p1_x;
            dir_to_light_3_y <= light_position[3][1] - p1_y;
            dir_to_light_3_z <= light_position[3][2] - p1_z;
        end
        else if (p2 < p1 && p2 < p3 && p2 < p4 && p2 < p5 && p2 < p6 && p2 < p7 && p2 < p8 && p2 < p9 && p2 < p10 && p2 < p11 && p2 < p12 && p2 < p13) begin
            outp <= p2;
            rev <= 0;
            normal_dir <= 2'b00;
            dir_to_light_0_x <= light_position[0][0] - p2_x;
            dir_to_light_0_y <= light_position[0][1] - p2_y;
            dir_to_light_0_z <= light_position[0][2] - p2_z;
            dir_to_light_1_x <= light_position[1][0] - p2_x;
            dir_to_light_1_y <= light_position[1][1] - p2_y;
            dir_to_light_1_z <= light_position[1][2] - p2_z;
            dir_to_light_2_x <= light_position[2][0] - p2_x;
            dir_to_light_2_y <= light_position[2][1] - p2_y;
            dir_to_light_2_z <= light_position[2][2] - p2_z;
            dir_to_light_3_x <= light_position[3][0] - p2_x;
            dir_to_light_3_y <= light_position[3][1] - p2_y;
            dir_to_light_3_z <= light_position[3][2] - p2_z;
        end
        else if (p3 < p1 && p3 < p2 && p3 < p4 && p3 < p5 && p3 < p6 && p3 < p7 && p3 < p8 && p3 < p9 && p3 < p10 && p3 < p11 && p3 < p12 && p3 < p13) begin
            outp <= p3;
            rev <= (x < 1);
            normal_dir <= 2'b00;
            dir_to_light_0_x <= light_position[0][0] - p3_x;
            dir_to_light_0_y <= light_position[0][1] - p3_y;
            dir_to_light_0_z <= light_position[0][2] - p3_z;
            dir_to_light_1_x <= light_position[1][0] - p3_x;
            dir_to_light_1_y <= light_position[1][1] - p3_y;
            dir_to_light_1_z <= light_position[1][2] - p3_z;
            dir_to_light_2_x <= light_position[2][0] - p3_x;
            dir_to_light_2_y <= light_position[2][1] - p3_y;
            dir_to_light_2_z <= light_position[2][2] - p3_z;
            dir_to_light_3_x <= light_position[3][0] - p3_x;
            dir_to_light_3_y <= light_position[3][1] - p3_y;
            dir_to_light_3_z <= light_position[3][2] - p3_z;
        end
        else if (p4 < p1 && p4 < p2 && p4 < p3 && p4 < p5 && p4 < p6 && p4 < p7 && p4 < p8 && p4 < p9 && p4 < p10 && p4 < p11 && p4 < p12 && p4 < p13) begin
            outp <= p4;
            rev <= (x < 2);
            normal_dir <= 2'b00;
            dir_to_light_0_x <= light_position[0][0] - p4_x;
            dir_to_light_0_y <= light_position[0][1] - p4_y;
            dir_to_light_0_z <= light_position[0][2] - p4_z;
            dir_to_light_1_x <= light_position[1][0] - p4_x;
            dir_to_light_1_y <= light_position[1][1] - p4_y;
            dir_to_light_1_z <= light_position[1][2] - p4_z;
            dir_to_light_2_x <= light_position[2][0] - p4_x;
            dir_to_light_2_y <= light_position[2][1] - p4_y;
            dir_to_light_2_z <= light_position[2][2] - p4_z;
            dir_to_light_3_x <= light_position[3][0] - p4_x;
            dir_to_light_3_y <= light_position[3][1] - p4_y;
            dir_to_light_3_z <= light_position[3][2] - p4_z;
        end
        else if (p5 < p1 && p5 < p2 && p5 < p3 && p5 < p4 && p5 < p6 && p5 < p7 && p5 < p8 && p5 < p9 && p5 < p10 && p5 < p11 && p5 < p12 && p5 < p13) begin
            outp <= p5;
            rev <= (x < 3);
            normal_dir <= 2'b00;
            dir_to_light_0_x <= light_position[0][0] - p5_x;
            dir_to_light_0_y <= light_position[0][1] - p5_y;
            dir_to_light_0_z <= light_position[0][2] - p5_z;
            dir_to_light_1_x <= light_position[1][0] - p5_x;
            dir_to_light_1_y <= light_position[1][1] - p5_y;
            dir_to_light_1_z <= light_position[1][2] - p5_z;
            dir_to_light_2_x <= light_position[2][0] - p5_x;
            dir_to_light_2_y <= light_position[2][1] - p5_y;
            dir_to_light_2_z <= light_position[2][2] - p5_z;
            dir_to_light_3_x <= light_position[3][0] - p5_x;
            dir_to_light_3_y <= light_position[3][1] - p5_y;
            dir_to_light_3_z <= light_position[3][2] - p5_z;
        end
        else if (p6 < p1 && p6 < p2 && p6 < p3 && p6 < p4 && p6 < p5 && p6 < p7 && p6 < p8 && p6 < p9 && p6 < p10 && p6 < p11 && p6 < p12 && p6 < p13) begin
            outp <= p6;
            rev <= (x < 4);
            normal_dir <= 2'b00;
            dir_to_light_0_x <= light_position[0][0] - p6_x;
            dir_to_light_0_y <= light_position[0][1] - p6_y;
            dir_to_light_0_z <= light_position[0][2] - p6_z;
            dir_to_light_1_x <= light_position[1][0] - p6_x;
            dir_to_light_1_y <= light_position[1][1] - p6_y;
            dir_to_light_1_z <= light_position[1][2] - p6_z;
            dir_to_light_2_x <= light_position[2][0] - p6_x;
            dir_to_light_2_y <= light_position[2][1] - p6_y;
            dir_to_light_2_z <= light_position[2][2] - p6_z;
            dir_to_light_3_x <= light_position[3][0] - p6_x;
            dir_to_light_3_y <= light_position[3][1] - p6_y;
            dir_to_light_3_z <= light_position[3][2] - p6_z;
        end
        else if (p7 < p1 && p7 < p2 && p7 < p3 && p7 < p4 && p7 < p5 && p7 < p6 && p7 < p8 && p7 < p9 && p7 < p10 && p7 < p11 && p7 < p12 && p7 < p13) begin
            outp <= p7;
            rev <= 1;
            normal_dir <= 2'b00;
            dir_to_light_0_x <= light_position[0][0] - p7_x;
            dir_to_light_0_y <= light_position[0][1] - p7_y;
            dir_to_light_0_z <= light_position[0][2] - p7_z;
            dir_to_light_1_x <= light_position[1][0] - p7_x;
            dir_to_light_1_y <= light_position[1][1] - p7_y;
            dir_to_light_1_z <= light_position[1][2] - p7_z;
            dir_to_light_2_x <= light_position[2][0] - p7_x;
            dir_to_light_2_y <= light_position[2][1] - p7_y;
            dir_to_light_2_z <= light_position[2][2] - p7_z;
            dir_to_light_3_x <= light_position[3][0] - p7_x;
            dir_to_light_3_y <= light_position[3][1] - p7_y;
            dir_to_light_3_z <= light_position[3][2] - p7_z;
        end
        else if (p8 < p1 && p8 < p2 && p8 < p3 && p8 < p4 && p8 < p5 && p8 < p6 && p8 < p7 && p8 < p9 && p8 < p10 && p8 < p11 && p8 < p12 && p8 < p13) begin
            outp <= p8;
            rev <= 0;
            normal_dir <= 2'b01;
            dir_to_light_0_x <= light_position[0][0] - p8_x;
            dir_to_light_0_y <= light_position[0][1] - p8_y;
            dir_to_light_0_z <= light_position[0][2] - p8_z;
            dir_to_light_1_x <= light_position[1][0] - p8_x;
            dir_to_light_1_y <= light_position[1][1] - p8_y;
            dir_to_light_1_z <= light_position[1][2] - p8_z;
            dir_to_light_2_x <= light_position[2][0] - p8_x;
            dir_to_light_2_y <= light_position[2][1] - p8_y;
            dir_to_light_2_z <= light_position[2][2] - p8_z;
            dir_to_light_3_x <= light_position[3][0] - p8_x;
            dir_to_light_3_y <= light_position[3][1] - p8_y;
            dir_to_light_3_z <= light_position[3][2] - p8_z;
        end
        else if (p9 < p1 && p9 < p2 && p9 < p3 && p9 < p4 && p9 < p5 && p9 < p6 && p9 < p7 && p9 < p8 && p9 < p10 && p9 < p11 && p9 < p12 && p9 < p13) begin
            outp <= p9;
            rev <= (y < 1);
            normal_dir <= 2'b01;
            dir_to_light_0_x <= light_position[0][0] - p9_x;
            dir_to_light_0_y <= light_position[0][1] - p9_y;
            dir_to_light_0_z <= light_position[0][2] - p9_z;
            dir_to_light_1_x <= light_position[1][0] - p9_x;
            dir_to_light_1_y <= light_position[1][1] - p9_y;
            dir_to_light_1_z <= light_position[1][2] - p9_z;
            dir_to_light_2_x <= light_position[2][0] - p9_x;
            dir_to_light_2_y <= light_position[2][1] - p9_y;
            dir_to_light_2_z <= light_position[2][2] - p9_z;
            dir_to_light_3_x <= light_position[3][0] - p9_x;
            dir_to_light_3_y <= light_position[3][1] - p9_y;
            dir_to_light_3_z <= light_position[3][2] - p9_z;
        end
        else if (p10 < p1 && p10 < p2 && p10 < p3 && p10 < p4 && p10 < p5 && p10 < p6 && p10 < p7 && p10 < p8 && p10 < p9 && p10 < p11 && p10 < p12 && p10 < p13) begin
            outp <= p10;
            rev <= (y < 2);
            normal_dir <= 2'b01;
            dir_to_light_0_x <= light_position[0][0] - p10_x;
            dir_to_light_0_y <= light_position[0][1] - p10_y;
            dir_to_light_0_z <= light_position[0][2] - p10_z;
            dir_to_light_1_x <= light_position[1][0] - p10_x;
            dir_to_light_1_y <= light_position[1][1] - p10_y;
            dir_to_light_1_z <= light_position[1][2] - p10_z;
            dir_to_light_2_x <= light_position[2][0] - p10_x;
            dir_to_light_2_y <= light_position[2][1] - p10_y;
            dir_to_light_2_z <= light_position[2][2] - p10_z;
            dir_to_light_3_x <= light_position[3][0] - p10_x;
            dir_to_light_3_y <= light_position[3][1] - p10_y;
            dir_to_light_3_z <= light_position[3][2] - p10_z;
        end
        else if (p11 < p1 && p11 < p2 && p11 < p3 && p11 < p4 && p11 < p5 && p11 < p6 && p11 < p7 && p11 < p8 && p11 < p9 && p11 < p10 && p11 < p12 && p11 < p13) begin
            outp <= p11;
            rev <= (y < 3);
            normal_dir <= 2'b01;
            dir_to_light_0_x <= light_position[0][0] - p11_x;
            dir_to_light_0_y <= light_position[0][1] - p11_y;
            dir_to_light_0_z <= light_position[0][2] - p11_z;
            dir_to_light_1_x <= light_position[1][0] - p11_x;
            dir_to_light_1_y <= light_position[1][1] - p11_y;
            dir_to_light_1_z <= light_position[1][2] - p11_z;
            dir_to_light_2_x <= light_position[2][0] - p11_x;
            dir_to_light_2_y <= light_position[2][1] - p11_y;
            dir_to_light_2_z <= light_position[2][2] - p11_z;
            dir_to_light_3_x <= light_position[3][0] - p11_x;
            dir_to_light_3_y <= light_position[3][1] - p11_y;
            dir_to_light_3_z <= light_position[3][2] - p11_z;
        end
        else if (p12 < p1 && p12 < p2 && p12 < p3 && p12 < p4 && p12 < p5 && p12 < p6 && p12 < p7 && p12 < p8 && p12 < p9 && p12 < p10 && p12 < p11 && p12 < p13) begin
            outp <= p12;
            rev <= (y < 4);
            normal_dir <= 2'b01;
            dir_to_light_0_x <= light_position[0][0] - p12_x;
            dir_to_light_0_y <= light_position[0][1] - p12_y;
            dir_to_light_0_z <= light_position[0][2] - p12_z;
            dir_to_light_1_x <= light_position[1][0] - p12_x;
            dir_to_light_1_y <= light_position[1][1] - p12_y;
            dir_to_light_1_z <= light_position[1][2] - p12_z;
            dir_to_light_2_x <= light_position[2][0] - p12_x;
            dir_to_light_2_y <= light_position[2][1] - p12_y;
            dir_to_light_2_z <= light_position[2][2] - p12_z;
            dir_to_light_3_x <= light_position[3][0] - p12_x;
            dir_to_light_3_y <= light_position[3][1] - p12_y;
            dir_to_light_3_z <= light_position[3][2] - p12_z;
        end
        else if (p13 < p1 && p13 < p2 && p13 < p3 && p13 < p4 && p13 < p5 && p13 < p6 && p13 < p7 && p13 < p8 && p13 < p9 && p13 < p10 && p13 < p11 && p13 < p12) begin
            outp <= p13;
            rev <= 1;
            normal_dir <= 2'b01;
            dir_to_light_0_x <= light_position[0][0] - p13_x;
            dir_to_light_0_y <= light_position[0][1] - p13_y;
            dir_to_light_0_z <= light_position[0][2] - p13_z;
            dir_to_light_1_x <= light_position[1][0] - p13_x;
            dir_to_light_1_y <= light_position[1][1] - p13_y;
            dir_to_light_1_z <= light_position[1][2] - p13_z;
            dir_to_light_2_x <= light_position[2][0] - p13_x;
            dir_to_light_2_y <= light_position[2][1] - p13_y;
            dir_to_light_2_z <= light_position[2][2] - p13_z;
            dir_to_light_3_x <= light_position[3][0] - p13_x;
            dir_to_light_3_y <= light_position[3][1] - p13_y;
            dir_to_light_3_z <= light_position[3][2] - p13_z;
        end
    end
end

assign outp_en = p1_en | p2_en | p3_en | p4_en | p5_en | p6_en | p7_en | p8_en | p9_en | p10_en | p11_en | p12_en | p13_en;

endmodule
