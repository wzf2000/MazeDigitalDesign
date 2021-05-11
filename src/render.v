module render (
    input wire clk,

    inout wire [31:0] ram_data,
    output wire [19:0] ram_addr,
    output wire ram_ce_n,
    output wire ram_oe_n,
    output wire ram_we_n,

    input wire sram_wr_en,
    input wire [19:0] sram_wr_addr,
    input wire [31:0] sram_wr_data,

    output wire vga_hsync,
    output wire vga_vsync,

    output wire [7:0] vga_red, 
    output wire [7:0] vga_green,
    output wire [7:0] vga_blue,

    output wire vga_data_en
)

wire clk_vga;


reg [11:0] vdata = 12'b0;
reg [11:0] hdata = 12'b0;
reg [31:0] rd_data;
reg [19:0] rd_address;

sram_controller sram_controller0 (
    .clk_100m(clk),

    .ram_data(ram_data),
    .ram_addr(ram_addr),
    .ram_ce_n(ram_ce_n),
    .ram_oe_n(ram_oe_n),
    .ram_we_n(ram_we_n),

    .rd_data(rd_data),
    .rd_addr(rd_address),

    .wr_en(sram_en),
    .wr_data(sram_wr_data),
    .wr_addr(sram_wr_addr)
);


vga_controller #(12, 800, 856, 976, 1040, 600, 637, 643, 666, 1, 1) vga800x600at75 (
    .clk(clk_vga), 
    .hdata(hdata), //横坐标
    .vdata(vdata), //纵坐标
    .address(rd_address),

    .red(vga_red),
    .green(vga_green),
    .blue(vga_blue),

    .data(vga_data),

    .hsync(vga_hsync),
    .vsync(vga_vsync),
    .data_enable(vga_data_en)
);

end module