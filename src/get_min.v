module get_min(
    input wire clk,
    input wire p1_en,
    input wire [7:0] p1,
    input wire p2_en,
    input wire [7:0] p2,
    input wire p3_en,
    input wire [7:0] p3,
    input wire p4_en,
    input wire [7:0] p4,
    input wire p5_en,
    input wire [7:0] p5,
    input wire p6_en,
    input wire [7:0] p6,
    input wire p7_en,
    input wire [7:0] p7,
    input wire p8_en,
    input wire [7:0] p8,
    input wire p9_en,
    input wire [7:0] p9,
    input wire p10_en,
    input wire [7:0] p10,
    input wire p11_en,
    input wire [7:0] p11,
    input wire p12_en,
    input wire [7:0] p12,
    input wire p13_en,
    input wire [7:0] p13,
    output wire outp_en,
    output reg [7:0] outp
);

always @(posedge clk) begin
    if (outp_en) begin
        if (p1 < p2 && p1 < p3 && p1 < p4 && p1 < p5 && p1 < p6 && p1 < p7 && p1 < p8 && p1 < p9 && p1 < p10 && p1 < p11 && p1 < p12 && p1 < p13) begin
            outp <= p1;
        end
        else if (p2 < p1 && p2 < p3 && p2 < p4 && p2 < p5 && p2 < p6 && p2 < p7 && p2 < p8 && p2 < p9 && p2 < p10 && p2 < p11 && p2 < p12 && p2 < p13) begin
            outp <= p2;
        end
        else if (p3 < p1 && p3 < p2 && p3 < p4 && p3 < p5 && p3 < p6 && p3 < p7 && p3 < p8 && p3 < p9 && p3 < p10 && p3 < p11 && p3 < p12 && p3 < p13) begin
            outp <= p3;
        end
        else if (p4 < p1 && p4 < p2 && p4 < p3 && p4 < p5 && p4 < p6 && p4 < p7 && p4 < p8 && p4 < p9 && p4 < p10 && p4 < p11 && p4 < p12 && p4 < p13) begin
            outp <= p4;
        end
        else if (p5 < p1 && p5 < p2 && p5 < p3 && p5 < p4 && p5 < p6 && p5 < p7 && p5 < p8 && p5 < p9 && p5 < p10 && p5 < p11 && p5 < p12 && p5 < p13) begin
            outp <= p5;
        end
        else if (p6 < p1 && p6 < p2 && p6 < p3 && p6 < p4 && p6 < p5 && p6 < p7 && p6 < p8 && p6 < p9 && p6 < p10 && p6 < p11 && p6 < p12 && p6 < p13) begin
            outp <= p6;
        end
        else if (p7 < p1 && p7 < p2 && p7 < p3 && p7 < p4 && p7 < p5 && p7 < p6 && p7 < p8 && p7 < p9 && p7 < p10 && p7 < p11 && p7 < p12 && p7 < p13) begin
            outp <= p7;
        end
        else if (p8 < p1 && p8 < p2 && p8 < p3 && p8 < p4 && p8 < p5 && p8 < p6 && p8 < p7 && p8 < p9 && p8 < p10 && p8 < p11 && p8 < p12 && p8 < p13) begin
            outp <= p8;
        end
        else if (p9 < p1 && p9 < p2 && p9 < p3 && p9 < p4 && p9 < p5 && p9 < p6 && p9 < p7 && p9 < p8 && p9 < p10 && p9 < p11 && p9 < p12 && p9 < p13) begin
            outp <= p9;
        end
        else if (p10 < p1 && p10 < p2 && p10 < p3 && p10 < p4 && p10 < p5 && p10 < p6 && p10 < p7 && p10 < p8 && p10 < p9 && p10 < p11 && p10 < p12 && p10 < p13) begin
            outp <= p10;
        end
        else if (p11 < p1 && p11 < p2 && p11 < p3 && p11 < p4 && p11 < p5 && p11 < p6 && p11 < p7 && p11 < p8 && p11 < p9 && p11 < p10 && p11 < p12 && p11 < p13) begin
            outp <= p11;
        end
        else if (p12 < p1 && p12 < p2 && p12 < p3 && p12 < p4 && p12 < p5 && p12 < p6 && p12 < p7 && p12 < p8 && p12 < p9 && p12 < p10 && p12 < p11 && p12 < p13) begin
            outp <= p12;
        end
        else if (p13 < p1 && p13 < p2 && p13 < p3 && p13 < p4 && p13 < p5 && p13 < p6 && p13 < p7 && p13 < p8 && p13 < p9 && p13 < p10 && p13 < p11 && p13 < p12) begin
            outp <= p13;
        end
    end
end

assign outp_en = p1_en | p2_en | p3_en | p4_en | p5_en | p6_en | p7_en | p8_en | p9_en | p10_en | p11_en | p12_en | p13_en;

endmodule
