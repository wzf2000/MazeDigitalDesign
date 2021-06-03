module sram_controller(
    input wire clk_100m,
    input wire clk_delay,
    inout wire [31:0] ram_data,
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

reg [1:0] state = 2'd0;

reg [31:0] ram_wr_data_reg;
reg wr_en_reg;
wire flag;

assign flag = (~ram_oe_n) & ram_we_n;
assign ram_data = flag ? 32'bz : ram_wr_data_reg;

assign ram_ce_n = 1'b0;

always @(posedge clk_100m) begin
    case (state)
        2'd0: begin
            ram_addr <= rd_addr;
            // ram_oe_n <= rd_addr[0];
            ram_oe_n <= 1'b0;
            ram_we_n <= 1'b1;
            // ram_we_n <= ~wr_en;
            state <= 2'd1;
        end
        2'd1: begin
            // rd_data <= ram_data;
            // ram_addr <= ram_addr;
            // ram_oe_n <= 1'b1;
            // ram_we_n <= 1'b1;
            // ram_we_n <= ~wr_en;
            state <= 2'd2;
        end
        2'd2: begin
            rd_data <= ram_data;
            // ram_addr <= wr_addr;
            // ram_addr <= 20'b0;
            // ram_addr <= ram_addr;
            // ram_data <= wr_data;
            // ram_data <= {32'd255};
            // ram_data <= ram_data;
            ram_oe_n <= 1'b1;
            if (wr_en) begin
                ram_addr <= wr_addr;
                ram_wr_data_reg <= wr_data;
            end
            wr_en_reg <= wr_en;
            // ram_we_n <= ~wr_en;
            // ram_we_n <= 1'b1;
            state <= 2'd3;
        end
        2'd3: begin
            // ram_addr <= ram_addr;
            // ram_addr <= wr_addr;
            // ram_data <= ram_data;
            // ram_data <= wr_data;
            // ram_oe_n <= 1'b1;
            if (wr_en_reg) begin
                ram_we_n <= 1'b0;
            end
            // ram_we_n <= ~wr_en;
            // ram_we_n <= 1'b1;
            state <= 2'd0;
        end
        default: state <= 2'd0;
    endcase
end

endmodule