module check_valid(
    input wire en,
    input wire [7:0] p,
    output wire [7:0] outp
);

assign outp = en ? p : 8'b11111111;

endmodule
