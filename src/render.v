module render (
    input wire clk,
    input wire clk_vga,
    input wire clk_50m,

    inout wire [31:0] ram_data,
    output wire [19:0] ram_addr,
    output wire ram_ce_n,
    output wire ram_oe_n,
    output wire ram_we_n,

    input wire rd_addr_offset,
    input wire wr_addr_offset,
    input wire sram_wr_en,
    input wire [18:0] sram_wr_addr,
    input wire [31:0] sram_wr_data,

    output wire vga_hsync,
    output wire vga_vsync,

    output wire [7:0] vga_red, 
    output wire [7:0] vga_green,
    output wire [7:0] vga_blue,

    output wire vga_data_en
);


wire [11:0] vdata;
wire [11:0] hdata;
wire [31:0] rd_data;
wire [18:0] rd_address;

sram_controller sram_controller0 (
    .clk_100m(clk),

    .ram_data(ram_data),
    .ram_addr(ram_addr),
    .ram_ce_n(ram_ce_n),
    .ram_oe_n(ram_oe_n),
    .ram_we_n(ram_we_n),

    .rd_data(rd_data),
    .rd_addr({rd_addr_offset, rd_address}),

    .wr_en(sram_wr_en),
    .wr_data(sram_wr_data),
    .wr_addr({wr_addr_offset, sram_wr_addr})
);


vga_controller #(12, 800, 856, 976, 1040, 600, 637, 643, 666, 1, 1) vga800x600at75 (
    .clk(clk_50m), 
    .hdata(hdata), //横坐标
    .vdata(vdata), //纵坐标
    .address(rd_address),

    .red(vga_red),
    .green(vga_green),
    .blue(vga_blue),

    .data(rd_data),

    .hsync(vga_hsync),
    .vsync(vga_vsync),
    .data_enable(vga_data_en)
);

endmodule
