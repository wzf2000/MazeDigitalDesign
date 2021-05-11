module sram_controler(
    input wire clk_100m,
    inout reg [31:0] ram_data,
    output reg [19:0] ram_addr,
    output wire ram_ce_n,
    output reg ram_oe_n,
    output reg ram_we_n,
    input wire [19:0] rd_addr,
    output reg [31:0] rd_data,
    input wire wr_en,
    input wire [19:0] wr_addr,
    input wire [31:0] wr_data
);

reg [1:0] state;

assign ram_ce_n = 1'b0;

always @(posedge clk_100m) begin
    case (state)
        2'd0: begin
            rd_data <= rd_data;
            ram_addr <= rd_addr;
            ram_oe_n <= 1'b0;
            ram_we_n <= 1'b1;
            state <= 2'd1;
        end
        2'd1: begin
            rd_data <= rd_data;
            ram_addr <= rd_addr;
            rd_data <= rd_data;
            ram_oe_n <= 1'b1;
            ram_we_n <= 1'b1;
            state <= 2'd2;
        end
        2'd2: begin
            rd_data <= ram_data;
            ram_addr <= wr_addr;
            ram_data <= wr_data;
            ram_oe_n <= 1'b1;
            ram_we_n <= !wr_en;
            state <= 2'd3;
        end
        2'd3: begin
            rd_data <= rd_data;
            ram_addr <= wr_addr;
            ram_data <= wr_data;
            ram_oe_n <= 1'b1;
            ram_we_n <= 1'b1;
            state <= 2'd0;
        end
        default: state <= 2'd0;
    endcase
end

endmodule