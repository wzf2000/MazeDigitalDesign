module mod_top (
    // 时钟、复位
    input  wire clk_100m,           // 100M 输入时钟
    input  wire reset_n,            // 上电复位信号，低有效

    // 开关、LED 等
    input  wire clock_btn,          // 左侧微动开关，推荐作为手动时钟，带消抖电路，按下时为 1
    input  wire reset_btn,          // 右侧微动开关，推荐作为手动复位，带消抖电路，按下时为 1
    input  wire [3:0]  touch_btn,   // 四个按钮开关，按下时为 0
    input  wire [15:0] dip_sw,      // 16 位拨码开关，拨到 “ON” 时为 0
    output wire [31:0] leds,        // 32 位 LED 灯，输出 1 时点亮
    output wire [7: 0] dpy_digit,   // 七段数码管笔段信号
    output wire [7: 0] dpy_segment, // 七段数码管位扫描信号

    // PS/2 键盘、鼠标接口
    input  wire        ps2_clock,   // PS/2 时钟信号
    input  wire        ps2_data,    // PS/2 数据信号

    // // USB 转 TTL 调试串口
    // output wire        uart_txd,    // 串口发送数据
    // input  wire        uart_rxd,    // 串口接收数据

    // 4MB SRAM 内存
    inout  wire [31:0] base_ram_data,   // SRAM 数据
    output wire [19:0] base_ram_addr,   // SRAM 地址
    output wire [3: 0] base_ram_be_n,   // SRAM 字节使能，低有效。如果不使用字节使能，请保持为0
    output wire        base_ram_ce_n,   // SRAM 片选，低有效
    output wire        base_ram_oe_n,   // SRAM 读使能，低有效
    output wire        base_ram_we_n,   // SRAM 写使能，低有效

    // HDMI 图像输出
    output wire [7: 0] video_red,   // 红色像素，8位
    output wire [7: 0] video_green, // 绿色像素，8位
    output wire [7: 0] video_blue,  // 蓝色像素，8位
    output wire        video_hsync, // 行同步（水平同步）信号
    output wire        video_vsync, // 场同步（垂直同步）信号
    output wire        video_clk,   // 像素时钟输出
    output wire        video_de     // 行数据有效信号，用于区分消隐区

    // // RS-232 串口
    // input  wire        rs232_rxd,   // 接收数据
    // output wire        rs232_txd,   // 发送数据
    // input  wire        rs232_cts,   // Clear-To-Send 控制信号
    // output wire        rs232_rts,   // Request-To-Send 控制信号

    // // SD 卡（SPI 模式）
    // output wire        sd_sclk,     // SPI 时钟
    // output wire        sd_mosi,
    // input  wire        sd_miso,
    // output wire        sd_cs,       // SPI 片选，低有效
    // input  wire        sd_cd,       // 卡插入检测，0 表示有卡插入
    // input  wire        sd_wp,       // 写保护检测，0 表示写保护状态

    // // SDRAM 内存，信号具体含义请参考数据手册
    // output wire [12:0] sdram_addr,
    // output wire [1: 0] sdram_bank,
    // output wire        sdram_cas_n,
    // output wire        sdram_ce_n,
    // output wire        sdram_cke,
    // output wire        sdram_clk,
    // output wire [15:0] sdram_dq,
    // output wire        sdram_dqmh,
    // output wire        sdram_dqml,
    // output wire        sdram_ras_n,
    // output wire        sdram_we_n,

    // // GMII 以太网接口、MDIO 接口，信号具体含义请参考数据手册
    // output wire        eth_gtx_clk,
    // output wire        eth_rst_n,
    // input  wire        eth_rx_clk,
    // input  wire        eth_rx_dv,
    // input  wire        eth_rx_er,
    // input  wire [7: 0] eth_rxd,
    // output wire        eth_tx_clk,
    // output wire        eth_tx_en,
    // output wire        eth_tx_er,
    // output wire [7: 0] eth_txd,
    // input  wire        eth_col,
    // input  wire        eth_crs,
    // output wire        eth_mdc,
    // inout  wire        eth_mdio
);

/* =========== Demo code begin =========== */
wire clk_in = clk_100m;

// PLL 分频演示，从输入产生不同频率的时钟
wire clk_vga;
wire clk_ps2;
ip_pll u_ip_pll(
    .inclk0 (clk_in  ),
    .c0     (clk_vga ),  // 25MHz 像素时钟
    .c1     (clk_ps2)
);

// 七段数码管扫描演示
reg [31: 0] number;
dpy_scan u_dpy_scan (
    .clk     (clk_in      ),
    .number  (number      ),
    .dp      (7'b0        ),
    .digit   (dpy_digit   ),
    .segment (dpy_segment )
);

// 自增计数器，用于数码管演示
reg [31: 0] counter;
always @(posedge clk_in or posedge reset_btn) begin
    if (reset_btn) begin
	     counter <= 32'b0;
		  number <= 32'b0;
	 end else begin
        counter <= counter + 32'b1;
        if (counter == 32'd5_000_000) begin
            counter <= 32'b0;
            number <= number + 32'b1;
        end
	 end
end

// 图像输出演示，分辨率 800x600@75Hz，像素时钟为 50MHz，显示渐变色彩条
wire [11:0] hdata;  // 当前横坐标
wire [11:0] vdata;  // 当前纵坐标

// 生成彩条数据，分别取坐标低位作为 RGB 值
// 警告：该图像生成方式仅供演示，请勿使用横纵坐标驱动大量逻辑！！
// assign video_red = vdata < 200 ? hdata[8:1] : 0;
// assign video_green = vdata >= 200 && vdata < 400 ? hdata[8:1] : 0;
// assign video_blue = vdata >= 400 ? hdata[8:1] : 0;

// define maze param
// 01000
// 01010
// 01010
// 01010
// 00010
localparam [0:4][4:0] maze = {5'b00010, 5'b01010, 5'b01010, 5'b01010, 5'b01000};
localparam [0:5][4:0] hor_wall = {5'b11111, 5'b01000, 5'b00000, 5'b00000, 5'b00010, 5'b11111};
localparam [0:5][4:0] ver_wall = {5'b11111, 5'b01111, 5'b01111, 5'b11110, 5'b11110, 5'b11111};
//reg [2:0] pos[1:0] = {1'b0, 1'b0};

//define camera param
localparam width = 10'd800;
localparam height = 10'd600;
localparam unit_size = 8'd64;
reg [1:0] dir;
localparam U = 2'd0;
localparam L = 2'd1;
localparam D = 2'd2;
localparam R = 2'd3;
reg [2:0] x;
reg [2:0] y;

// define state
reg [3:0] state = 4'b0000;
localparam STILL = 4'b0001;
localparam INIT_CAM = 4'b0010;
localparam DRAW = 4'b0011;

// define movement signal
reg [1:0] draw_mode = 2'b00; // 01 move 10 left 11 right
localparam MOVE = 2'b01;
localparam LEFT = 2'b10;
localparam RIGHT = 2'b11;

reg [8:0] pip_en; // 使能 拉低有效
reg [9:0] px[8:0]; // 像素点x
reg [9:0] py[8:0]; // 像素点y

// LED
assign leds[1:0] = move_data;
assign leds[2] = wr_en;
assign leds[15:3] = 12'd0;
assign leds[31:16] = ~(dip_sw);

wire signal;

ps2_controller u_ps2_controller(
    .clk(clk_ps2), // 50MHz
    .rst(reset_btn),
    .ps2_clk(ps2_clock),
    .ps2_data(ps2_data),
    .data(move_data),
    .signal(signal)
);

wire [1:0] move_data;
reg move_en = 0;

reg rd_addr_offset = 1'b0;
reg wr_addr_offset = 1'b1;
reg wr_en = 1'b0;
reg [18:0] wr_addr;
reg [31:0] wr_data;
reg [7:0] image_cnt = 8'd0;
reg signed [9:0] center_x = unit_size >> 1;
reg signed [9:0] center_y = unit_size >> 1;
reg signed [9:0] center_z = unit_size >> 1;
reg [8:0] center_angle = 9'd180;
localparam signed [0:359][9:0] Dir_x = {
    10'b1000000000,
    10'b1000000000,
    10'b1000000000,
    10'b1000000001,
    10'b1000000001,
    10'b1000000010,
    10'b1000000011,
    10'b1000000100,
    10'b1000000101,
    10'b1000000110,
    10'b1000001000,
    10'b1000001001,
    10'b1000001011,
    10'b1000001101,
    10'b1000001111,
    10'b1000010001,
    10'b1000010100,
    10'b1000010110,
    10'b1000011001,
    10'b1000011100,
    10'b1000011111,
    10'b1000100010,
    10'b1000100101,
    10'b1000101001,
    10'b1000101100,
    10'b1000110000,
    10'b1000110100,
    10'b1000111000,
    10'b1000111100,
    10'b1001000000,
    10'b1001000101,
    10'b1001001001,
    10'b1001001110,
    10'b1001010011,
    10'b1001011000,
    10'b1001011101,
    10'b1001100010,
    10'b1001100111,
    10'b1001101101,
    10'b1001110010,
    10'b1001111000,
    10'b1001111110,
    10'b1010000100,
    10'b1010001010,
    10'b1010010000,
    10'b1010010110,
    10'b1010011100,
    10'b1010100011,
    10'b1010101001,
    10'b1010110000,
    10'b1010110111,
    10'b1010111110,
    10'b1011000101,
    10'b1011001100,
    10'b1011010011,
    10'b1011011010,
    10'b1011100010,
    10'b1011101001,
    10'b1011110001,
    10'b1011111000,
    10'b1100000000,
    10'b1100001000,
    10'b1100010000,
    10'b1100011000,
    10'b1100100000,
    10'b1100101000,
    10'b1100110000,
    10'b1100111000,
    10'b1101000000,
    10'b1101001001,
    10'b1101010001,
    10'b1101011001,
    10'b1101100010,
    10'b1101101010,
    10'b1101110011,
    10'b1101111011,
    10'b1110000100,
    10'b1110001101,
    10'b1110010110,
    10'b1110011110,
    10'b1110100111,
    10'b1110110000,
    10'b1110111001,
    10'b1111000010,
    10'b1111001010,
    10'b1111010011,
    10'b1111011100,
    10'b1111100101,
    10'b1111101110,
    10'b1111110111,
    10'b0000000000,
    10'b0000001001,
    10'b0000010010,
    10'b0000011011,
    10'b0000100100,
    10'b0000101101,
    10'b0000110110,
    10'b0000111110,
    10'b0001000111,
    10'b0001010000,
    10'b0001011001,
    10'b0001100010,
    10'b0001101010,
    10'b0001110011,
    10'b0001111100,
    10'b0010000101,
    10'b0010001101,
    10'b0010010110,
    10'b0010011110,
    10'b0010100111,
    10'b0010101111,
    10'b0010110111,
    10'b0011000000,
    10'b0011001000,
    10'b0011010000,
    10'b0011011000,
    10'b0011100000,
    10'b0011101000,
    10'b0011110000,
    10'b0011111000,
    10'b0100000000,
    10'b0100001000,
    10'b0100001111,
    10'b0100010111,
    10'b0100011110,
    10'b0100100110,
    10'b0100101101,
    10'b0100110100,
    10'b0100111011,
    10'b0101000010,
    10'b0101001001,
    10'b0101010000,
    10'b0101010111,
    10'b0101011101,
    10'b0101100100,
    10'b0101101010,
    10'b0101110000,
    10'b0101110110,
    10'b0101111100,
    10'b0110000010,
    10'b0110001000,
    10'b0110001110,
    10'b0110010011,
    10'b0110011001,
    10'b0110011110,
    10'b0110100011,
    10'b0110101000,
    10'b0110101101,
    10'b0110110010,
    10'b0110110111,
    10'b0110111011,
    10'b0111000000,
    10'b0111000100,
    10'b0111001000,
    10'b0111001100,
    10'b0111010000,
    10'b0111010100,
    10'b0111010111,
    10'b0111011011,
    10'b0111011110,
    10'b0111100001,
    10'b0111100100,
    10'b0111100111,
    10'b0111101010,
    10'b0111101100,
    10'b0111101111,
    10'b0111110001,
    10'b0111110011,
    10'b0111110101,
    10'b0111110111,
    10'b0111111000,
    10'b0111111010,
    10'b0111111011,
    10'b0111111100,
    10'b0111111101,
    10'b0111111110,
    10'b0111111111,
    10'b0111111111,
    10'b1000000000,
    10'b1000000000,
    10'b1000000000,
    10'b1000000000,
    10'b1000000000,
    10'b0111111111,
    10'b0111111111,
    10'b0111111110,
    10'b0111111101,
    10'b0111111100,
    10'b0111111011,
    10'b0111111010,
    10'b0111111000,
    10'b0111110111,
    10'b0111110101,
    10'b0111110011,
    10'b0111110001,
    10'b0111101111,
    10'b0111101100,
    10'b0111101010,
    10'b0111100111,
    10'b0111100100,
    10'b0111100001,
    10'b0111011110,
    10'b0111011011,
    10'b0111010111,
    10'b0111010100,
    10'b0111010000,
    10'b0111001100,
    10'b0111001000,
    10'b0111000100,
    10'b0111000000,
    10'b0110111011,
    10'b0110110111,
    10'b0110110010,
    10'b0110101101,
    10'b0110101000,
    10'b0110100011,
    10'b0110011110,
    10'b0110011001,
    10'b0110010011,
    10'b0110001110,
    10'b0110001000,
    10'b0110000010,
    10'b0101111100,
    10'b0101110110,
    10'b0101110000,
    10'b0101101010,
    10'b0101100100,
    10'b0101011101,
    10'b0101010111,
    10'b0101010000,
    10'b0101001001,
    10'b0101000010,
    10'b0100111011,
    10'b0100110100,
    10'b0100101101,
    10'b0100100110,
    10'b0100011110,
    10'b0100010111,
    10'b0100001111,
    10'b0100001000,
    10'b0100000000,
    10'b0011111000,
    10'b0011110000,
    10'b0011101000,
    10'b0011100000,
    10'b0011011000,
    10'b0011010000,
    10'b0011001000,
    10'b0011000000,
    10'b0010110111,
    10'b0010101111,
    10'b0010100111,
    10'b0010011110,
    10'b0010010110,
    10'b0010001101,
    10'b0010000101,
    10'b0001111100,
    10'b0001110011,
    10'b0001101010,
    10'b0001100010,
    10'b0001011001,
    10'b0001010000,
    10'b0001000111,
    10'b0000111110,
    10'b0000110110,
    10'b0000101101,
    10'b0000100100,
    10'b0000011011,
    10'b0000010010,
    10'b0000001001,
    10'b0000000000,
    10'b1111110111,
    10'b1111101110,
    10'b1111100101,
    10'b1111011100,
    10'b1111010011,
    10'b1111001010,
    10'b1111000010,
    10'b1110111001,
    10'b1110110000,
    10'b1110100111,
    10'b1110011110,
    10'b1110010110,
    10'b1110001101,
    10'b1110000100,
    10'b1101111011,
    10'b1101110011,
    10'b1101101010,
    10'b1101100010,
    10'b1101011001,
    10'b1101010001,
    10'b1101001001,
    10'b1101000000,
    10'b1100111000,
    10'b1100110000,
    10'b1100101000,
    10'b1100100000,
    10'b1100011000,
    10'b1100010000,
    10'b1100001000,
    10'b1100000000,
    10'b1011111000,
    10'b1011110001,
    10'b1011101001,
    10'b1011100010,
    10'b1011011010,
    10'b1011010011,
    10'b1011001100,
    10'b1011000101,
    10'b1010111110,
    10'b1010110111,
    10'b1010110000,
    10'b1010101001,
    10'b1010100011,
    10'b1010011100,
    10'b1010010110,
    10'b1010010000,
    10'b1010001010,
    10'b1010000100,
    10'b1001111110,
    10'b1001111000,
    10'b1001110010,
    10'b1001101101,
    10'b1001100111,
    10'b1001100010,
    10'b1001011101,
    10'b1001011000,
    10'b1001010011,
    10'b1001001110,
    10'b1001001001,
    10'b1001000101,
    10'b1001000000,
    10'b1000111100,
    10'b1000111000,
    10'b1000110100,
    10'b1000110000,
    10'b1000101100,
    10'b1000101001,
    10'b1000100101,
    10'b1000100010,
    10'b1000011111,
    10'b1000011100,
    10'b1000011001,
    10'b1000010110,
    10'b1000010100,
    10'b1000010001,
    10'b1000001111,
    10'b1000001101,
    10'b1000001011,
    10'b1000001001,
    10'b1000001000,
    10'b1000000110,
    10'b1000000101,
    10'b1000000100,
    10'b1000000011,
    10'b1000000010,
    10'b1000000001,
    10'b1000000001,
    10'b1000000000,
    10'b1000000000
};
localparam signed [0:359][9:0] Dir_y = {
    10'b0000000000,
    10'b0000001001,
    10'b0000010010,
    10'b0000011011,
    10'b0000100100,
    10'b0000101101,
    10'b0000110110,
    10'b0000111110,
    10'b0001000111,
    10'b0001010000,
    10'b0001011001,
    10'b0001100010,
    10'b0001101010,
    10'b0001110011,
    10'b0001111100,
    10'b0010000101,
    10'b0010001101,
    10'b0010010110,
    10'b0010011110,
    10'b0010100111,
    10'b0010101111,
    10'b0010110111,
    10'b0011000000,
    10'b0011001000,
    10'b0011010000,
    10'b0011011000,
    10'b0011100000,
    10'b0011101000,
    10'b0011110000,
    10'b0011111000,
    10'b0100000000,
    10'b0100001000,
    10'b0100001111,
    10'b0100010111,
    10'b0100011110,
    10'b0100100110,
    10'b0100101101,
    10'b0100110100,
    10'b0100111011,
    10'b0101000010,
    10'b0101001001,
    10'b0101010000,
    10'b0101010111,
    10'b0101011101,
    10'b0101100100,
    10'b0101101010,
    10'b0101110000,
    10'b0101110110,
    10'b0101111100,
    10'b0110000010,
    10'b0110001000,
    10'b0110001110,
    10'b0110010011,
    10'b0110011001,
    10'b0110011110,
    10'b0110100011,
    10'b0110101000,
    10'b0110101101,
    10'b0110110010,
    10'b0110110111,
    10'b0110111011,
    10'b0111000000,
    10'b0111000100,
    10'b0111001000,
    10'b0111001100,
    10'b0111010000,
    10'b0111010100,
    10'b0111010111,
    10'b0111011011,
    10'b0111011110,
    10'b0111100001,
    10'b0111100100,
    10'b0111100111,
    10'b0111101010,
    10'b0111101100,
    10'b0111101111,
    10'b0111110001,
    10'b0111110011,
    10'b0111110101,
    10'b0111110111,
    10'b0111111000,
    10'b0111111010,
    10'b0111111011,
    10'b0111111100,
    10'b0111111101,
    10'b0111111110,
    10'b0111111111,
    10'b0111111111,
    10'b1000000000,
    10'b1000000000,
    10'b1000000000,
    10'b1000000000,
    10'b1000000000,
    10'b0111111111,
    10'b0111111111,
    10'b0111111110,
    10'b0111111101,
    10'b0111111100,
    10'b0111111011,
    10'b0111111010,
    10'b0111111000,
    10'b0111110111,
    10'b0111110101,
    10'b0111110011,
    10'b0111110001,
    10'b0111101111,
    10'b0111101100,
    10'b0111101010,
    10'b0111100111,
    10'b0111100100,
    10'b0111100001,
    10'b0111011110,
    10'b0111011011,
    10'b0111010111,
    10'b0111010100,
    10'b0111010000,
    10'b0111001100,
    10'b0111001000,
    10'b0111000100,
    10'b0111000000,
    10'b0110111011,
    10'b0110110111,
    10'b0110110010,
    10'b0110101101,
    10'b0110101000,
    10'b0110100011,
    10'b0110011110,
    10'b0110011001,
    10'b0110010011,
    10'b0110001110,
    10'b0110001000,
    10'b0110000010,
    10'b0101111100,
    10'b0101110110,
    10'b0101110000,
    10'b0101101010,
    10'b0101100100,
    10'b0101011101,
    10'b0101010111,
    10'b0101010000,
    10'b0101001001,
    10'b0101000010,
    10'b0100111011,
    10'b0100110100,
    10'b0100101101,
    10'b0100100110,
    10'b0100011110,
    10'b0100010111,
    10'b0100001111,
    10'b0100001000,
    10'b0100000000,
    10'b0011111000,
    10'b0011110000,
    10'b0011101000,
    10'b0011100000,
    10'b0011011000,
    10'b0011010000,
    10'b0011001000,
    10'b0011000000,
    10'b0010110111,
    10'b0010101111,
    10'b0010100111,
    10'b0010011110,
    10'b0010010110,
    10'b0010001101,
    10'b0010000101,
    10'b0001111100,
    10'b0001110011,
    10'b0001101010,
    10'b0001100010,
    10'b0001011001,
    10'b0001010000,
    10'b0001000111,
    10'b0000111110,
    10'b0000110110,
    10'b0000101101,
    10'b0000100100,
    10'b0000011011,
    10'b0000010010,
    10'b0000001001,
    10'b0000000000,
    10'b1111110111,
    10'b1111101110,
    10'b1111100101,
    10'b1111011100,
    10'b1111010011,
    10'b1111001010,
    10'b1111000010,
    10'b1110111001,
    10'b1110110000,
    10'b1110100111,
    10'b1110011110,
    10'b1110010110,
    10'b1110001101,
    10'b1110000100,
    10'b1101111011,
    10'b1101110011,
    10'b1101101010,
    10'b1101100010,
    10'b1101011001,
    10'b1101010001,
    10'b1101001001,
    10'b1101000000,
    10'b1100111000,
    10'b1100110000,
    10'b1100101000,
    10'b1100100000,
    10'b1100011000,
    10'b1100010000,
    10'b1100001000,
    10'b1100000000,
    10'b1011111000,
    10'b1011110001,
    10'b1011101001,
    10'b1011100010,
    10'b1011011010,
    10'b1011010011,
    10'b1011001100,
    10'b1011000101,
    10'b1010111110,
    10'b1010110111,
    10'b1010110000,
    10'b1010101001,
    10'b1010100011,
    10'b1010011100,
    10'b1010010110,
    10'b1010010000,
    10'b1010001010,
    10'b1010000100,
    10'b1001111110,
    10'b1001111000,
    10'b1001110010,
    10'b1001101101,
    10'b1001100111,
    10'b1001100010,
    10'b1001011101,
    10'b1001011000,
    10'b1001010011,
    10'b1001001110,
    10'b1001001001,
    10'b1001000101,
    10'b1001000000,
    10'b1000111100,
    10'b1000111000,
    10'b1000110100,
    10'b1000110000,
    10'b1000101100,
    10'b1000101001,
    10'b1000100101,
    10'b1000100010,
    10'b1000011111,
    10'b1000011100,
    10'b1000011001,
    10'b1000010110,
    10'b1000010100,
    10'b1000010001,
    10'b1000001111,
    10'b1000001101,
    10'b1000001011,
    10'b1000001001,
    10'b1000001000,
    10'b1000000110,
    10'b1000000101,
    10'b1000000100,
    10'b1000000011,
    10'b1000000010,
    10'b1000000001,
    10'b1000000001,
    10'b1000000000,
    10'b1000000000,
    10'b1000000000,
    10'b1000000000,
    10'b1000000000,
    10'b1000000001,
    10'b1000000001,
    10'b1000000010,
    10'b1000000011,
    10'b1000000100,
    10'b1000000101,
    10'b1000000110,
    10'b1000001000,
    10'b1000001001,
    10'b1000001011,
    10'b1000001101,
    10'b1000001111,
    10'b1000010001,
    10'b1000010100,
    10'b1000010110,
    10'b1000011001,
    10'b1000011100,
    10'b1000011111,
    10'b1000100010,
    10'b1000100101,
    10'b1000101001,
    10'b1000101100,
    10'b1000110000,
    10'b1000110100,
    10'b1000111000,
    10'b1000111100,
    10'b1001000000,
    10'b1001000101,
    10'b1001001001,
    10'b1001001110,
    10'b1001010011,
    10'b1001011000,
    10'b1001011101,
    10'b1001100010,
    10'b1001100111,
    10'b1001101101,
    10'b1001110010,
    10'b1001111000,
    10'b1001111110,
    10'b1010000100,
    10'b1010001010,
    10'b1010010000,
    10'b1010010110,
    10'b1010011100,
    10'b1010100011,
    10'b1010101001,
    10'b1010110000,
    10'b1010110111,
    10'b1010111110,
    10'b1011000101,
    10'b1011001100,
    10'b1011010011,
    10'b1011011010,
    10'b1011100010,
    10'b1011101001,
    10'b1011110001,
    10'b1011111000,
    10'b1100000000,
    10'b1100001000,
    10'b1100010000,
    10'b1100011000,
    10'b1100100000,
    10'b1100101000,
    10'b1100110000,
    10'b1100111000,
    10'b1101000000,
    10'b1101001001,
    10'b1101010001,
    10'b1101011001,
    10'b1101100010,
    10'b1101101010,
    10'b1101110011,
    10'b1101111011,
    10'b1110000100,
    10'b1110001101,
    10'b1110010110,
    10'b1110011110,
    10'b1110100111,
    10'b1110110000,
    10'b1110111001,
    10'b1111000010,
    10'b1111001010,
    10'b1111010011,
    10'b1111011100,
    10'b1111100101,
    10'b1111101110,
    10'b1111110111
};

reg signed [9:0] dir_x = Dir_x[180]; // * 2 ^ 9
reg signed [9:0] dir_y = Dir_y[180]; // * 2 ^ 9
wire signed [9:0] hor_x;             // * 2 ^ 9
wire signed [9:0] hor_y;             // * 2 ^ 9
assign hor_x = dir_y;
assign hor_y = -dir_x;
/*
R = [[hor_x,    0,   dir_x],
     [hor_y,    0,   dir_y],
     [    0,   -1,       0]]
*/

reg [9:0] tmp[1:0];
reg signed [9:0] ray_dir[2:0];   // * 2 ^ 9
reg signed [9:0] ray_dir_R[1:0][2:0]; // * 2 ^ 8

wire signed [18:0] hor_p_1[5:0];
wire signed [18:0] ver_p_1[5:0];
wire signed [18:0] ground_1;
wire signed [9:0] hor_p_2[5:0];
wire signed [9:0] ver_p_2[5:0];
wire signed [9:0] ground_2;
wire signed [9:0] hor_p_3[5:0];
wire signed [9:0] ver_p_3[5:0];
wire signed [9:0] ground_3;
wire signed [17:0] hor_out_1[5:0][2:0];
wire signed [17:0] ver_out_1[5:0][2:0];
wire signed [17:0] ground_out_1[2:0];
wire signed [9:0] hor_out_2[5:0][2:0];
wire signed [9:0] ver_out_2[5:0][2:0];
wire signed [9:0] ground_out_2[2:0];
wire [5:0] hor_en;
wire [5:0] ver_en;
wire ground_en;

reg outp_en;
reg signed [9:0] outp;
reg rev;
reg [1:0] normal_dir;

wire signed [9:0] dir_to_light[3:0][2:0];

genvar xx;
generate
    for (xx = 0; xx < 6; xx = xx + 1) begin: hor
        intersection #(xx) intersection_x(
            .clk(clk_vga),
            .dir(ray_dir_R[0][0]),
            .ori(center_x),
            .p(hor_p_1[xx])
        );
        get_pos getter_x(
            .clk(clk_vga),
            .p(hor_p_1[xx]),
            .ori_x(center_x),
            .ori_y(center_y),
            .ori_z(center_z),
            .dir_x(ray_dir_R[1][0]),
            .dir_y(ray_dir_R[1][1]),
            .dir_z(ray_dir_R[1][2]),
            .out_x(hor_out_1[xx][0]),
            .out_y(hor_out_1[xx][1]),
            .out_z(hor_out_1[xx][2]),
            .out_p(hor_p_2[xx])
        );
        check_valid checker_x(
            .clk(clk_vga),
            .wall(hor_wall[xx]),
            .in_p(hor_p_2[xx]),
            .in_x(hor_out_1[xx][1]),
            .in_y(hor_out_1[xx][2]),
            .in_z(hor_out_1[xx][0]),
            .out_x(hor_out_2[xx][1]),
            .out_y(hor_out_2[xx][2]),
            .out_z(hor_out_2[xx][0]),
            .out_p(hor_p_3[xx]),
            .en(hor_en[xx])
        );
    end
endgenerate

genvar yy;
generate
    for (yy = 0; yy < 6; yy = yy + 1) begin: ver
        intersection #(yy) intersection_y(
            .clk(clk_vga),
            .dir(ray_dir_R[0][1]),
            .ori(center_y),
            .p(ver_p_1[yy])
        );
        get_pos getter_y(
            .clk(clk_vga),
            .p(ver_p_1[yy]),
            .ori_x(center_x),
            .ori_y(center_y),
            .ori_z(center_z),
            .dir_x(ray_dir_R[1][0]),
            .dir_y(ray_dir_R[1][1]),
            .dir_z(ray_dir_R[1][2]),
            .out_x(ver_out_1[yy][0]),
            .out_y(ver_out_1[yy][1]),
            .out_z(ver_out_1[yy][2]),
            .out_p(ver_p_2[yy])
        );
        check_valid checker_y(
            .clk(clk_vga),
            .wall(ver_wall[yy]),
            .in_p(ver_p_2[yy]),
            .in_x(ver_out_1[yy][0]),
            .in_y(ver_out_1[yy][2]),
            .in_z(ver_out_1[yy][1]),
            .out_x(ver_out_2[yy][0]),
            .out_y(ver_out_2[yy][2]),
            .out_z(ver_out_2[yy][1]),
            .out_p(ver_p_3[yy]),
            .en(ver_en[yy])
        );
    end
endgenerate

intersection #(0) intersection_z(
    .clk(clk_vga),
    .dir(ray_dir_R[0][2]),
    .ori(center_z),
    .p(ground_1)
);

get_pos getter_z(
    .clk(clk_vga),
    .p(ground_1),
    .ori_x(center_x),
    .ori_y(center_y),
    .ori_z(center_z),
    .dir_x(ray_dir_R[1][0]),
    .dir_y(ray_dir_R[1][1]),
    .dir_z(ray_dir_R[1][2]),
    .out_x(ground_out_1[0]),
    .out_y(ground_out_1[1]),
    .out_z(ground_out_1[2]),
    .out_p(ground_2)
);

check_valid_ground checker_z(
    .clk(clk_vga),
    .in_p(ground_2),
    .in_x(ground_out_1[0]),
    .in_y(ground_out_1[1]),
    .in_z(ground_out_1[2]),
    .out_x(ground_out_2[0]),
    .out_y(ground_out_2[1]),
    .out_z(ground_out_2[2]),
    .out_p(ground_3),
    .en(ground_en)
);

get_min miner(
    .clk(clk_vga),
    .x(x),
    .y(y),
    .p1_en(ground_en),
    .p1(ground_3),
    .p1_x(ground_out_2[0]),
    .p1_y(ground_out_2[1]),
    .p1_z(ground_out_2[2]),
    .p2_en(hor_en[0]),
    .p2(hor_p_3[0]),
    .p2_x(hor_out_2[0][0]),
    .p2_y(hor_out_2[0][1]),
    .p2_z(hor_out_2[0][2]),
    .p3_en(hor_en[1]),
    .p3(hor_p_3[1]),
    .p3_x(hor_out_2[1][0]),
    .p3_y(hor_out_2[1][1]),
    .p3_z(hor_out_2[1][2]),
    .p4_en(hor_en[2]),
    .p4(hor_p_3[2]),
    .p4_x(hor_out_2[2][0]),
    .p4_y(hor_out_2[2][1]),
    .p4_z(hor_out_2[2][2]),
    .p5_en(hor_en[3]),
    .p5(hor_p_3[3]),
    .p5_x(hor_out_2[3][0]),
    .p5_y(hor_out_2[3][1]),
    .p5_z(hor_out_2[3][2]),
    .p6_en(hor_en[4]),
    .p6(hor_p_3[4]),
    .p6_x(hor_out_2[4][0]),
    .p6_y(hor_out_2[4][1]),
    .p6_z(hor_out_2[4][2]),
    .p7_en(hor_en[5]),
    .p7(hor_p_3[5]),
    .p7_x(hor_out_2[5][0]),
    .p7_y(hor_out_2[5][1]),
    .p7_z(hor_out_2[5][2]),
    .p8_en(ver_en[0]),
    .p8(ver_p_3[0]),
    .p8_x(ver_out_2[0][0]),
    .p8_y(ver_out_2[0][1]),
    .p8_z(ver_out_2[0][2]),
    .p9_en(ver_en[1]),
    .p9(ver_p_3[1]),
    .p9_x(ver_out_2[1][0]),
    .p9_y(ver_out_2[1][1]),
    .p9_z(ver_out_2[1][2]),
    .p10_en(ver_en[2]),
    .p10(ver_p_3[2]),
    .p10_x(ver_out_2[2][0]),
    .p10_y(ver_out_2[2][1]),
    .p10_z(ver_out_2[2][2]),
    .p11_en(ver_en[3]),
    .p11(ver_p_3[3]),
    .p11_x(ver_out_2[3][0]),
    .p11_y(ver_out_2[3][1]),
    .p11_z(ver_out_2[3][2]),
    .p12_en(ver_en[4]),
    .p12(ver_p_3[4]),
    .p12_x(ver_out_2[4][0]),
    .p12_y(ver_out_2[4][1]),
    .p12_z(ver_out_2[4][2]),
    .p13_en(ver_en[5]),
    .p13(ver_p_3[5]),
    .p13_x(ver_out_2[5][0]),
    .p13_y(ver_out_2[5][1]),
    .p13_z(ver_out_2[5][2]),
    .outp_en(outp_en),
    .outp(outp),
    .rev(rev),
    .normal_dir(normal_dir), // 0: x 1: y 2: z
    .dir_to_light_0_x(dir_to_light[0][0]),
    .dir_to_light_0_y(dir_to_light[0][1]),
    .dir_to_light_0_z(dir_to_light[0][2]),
    .dir_to_light_1_x(dir_to_light[1][0]),
    .dir_to_light_1_y(dir_to_light[1][1]),
    .dir_to_light_1_z(dir_to_light[1][2]),
    .dir_to_light_2_x(dir_to_light[2][0]),
    .dir_to_light_2_y(dir_to_light[2][1]),
    .dir_to_light_2_z(dir_to_light[2][2]),
    .dir_to_light_3_x(dir_to_light[3][0]),
    .dir_to_light_3_y(dir_to_light[3][1]),
    .dir_to_light_3_z(dir_to_light[3][2])
);

localparam [0:3][2:0] light_color = {2'b100, 2'b010, 2'b001, 2'b111};
reg signed [9:0] single_shade[3:0][2:0];
reg [7:0] phone[2:0];

reg [7:0] red;
reg [7:0] green;
reg [7:0] blue;
assign wr_data = {{8{1'b0}}, red, green, blue};

// main states
always @ (posedge clk_vga or posedge reset_btn) begin
    if (reset_btn) begin
        draw_mode <= RIGHT;
        image_cnt <= 8'd89;
        center_angle <= 9'd179;
        {center_x, center_y, center_z} <= {10'd32, 10'd32, 10'd32};
        x <= 3'd0;
        y <= 3'd0;
        dir <= R;
        move_en <= 1'b1;
        state <= INIT_CAM;
    end
    else begin
        case (state)
            STILL: begin
                if (!move_en && signal) begin
                    case (move_data)
                        MOVE: begin
                            case (dir)
                                U: begin
                                    if (x > 3'd0 && !maze[x - 1][y]) begin
                                        draw_mode <= move_data;
                                        state <= INIT_CAM;
                                        image_cnt <= 8'd0;
                                    end
                                end
                                L: begin
                                    if (y > 3'd0 && !maze[x][y - 1]) begin
                                        draw_mode <= move_data;
                                        state <= INIT_CAM;
                                        image_cnt <= 8'd0;
                                    end
                                end
                                D: begin
                                    if (x < 3'd4 && !maze[x + 1][y]) begin
                                        draw_mode <= move_data;
                                        state <= INIT_CAM;
                                        image_cnt <= 8'd0;
                                    end
                                end
                                R: begin
                                    if (y < 3'd4 && !maze[x][y + 1]) begin
                                        draw_mode <= move_data;
                                        state <= INIT_CAM;
                                        image_cnt <= 8'd0;
                                    end
                                end
                            endcase
                        end
                        LEFT, RIGHT: begin
                            draw_mode <= move_data;
                            state <= INIT_CAM;
                            image_cnt <= 8'd0;
                        end
                        default: state <= state;
                    endcase
                    move_en <= 1'b1;
                end
                else if (!signal) begin
                    move_en <= 1'b0;
                end
            end
            INIT_CAM: begin
                //INIT_CAM
                if (!signal) begin
                    move_en <= 1'b0;
                end
                px[0] <= 10'd0;
                py[0] <= 10'd0;
                if ((image_cnt == 8'd90 && (draw_mode == LEFT || draw_mode == RIGHT)) || (image_cnt == unit_size && draw_mode == MOVE)) begin
                    image_cnt <= 8'd0;
                    state <= STILL;
                    case (draw_mode)
                        MOVE:
                            case (dir)
                                U: begin
                                    if (x > 3'd0 && !maze[x - 1][y])
                                        x <= x - 1;
                                end
                                L: begin
                                    if (y > 3'd0 && !maze[x][y - 1])
                                        y <= y - 1;
                                end
                                D: begin
                                    if (x < 3'd4 && !maze[x + 1][y])
                                        x <= x + 1;
                                end
                                R: begin
                                    if (y < 3'd4 && !maze[x][y + 1])
                                        y <= y + 1;
                                end
                            endcase
                        LEFT, RIGHT:
                            case (dir)
                                U: begin
                                    if (draw_mode == LEFT)
                                        dir <= L;
                                    else
                                        dir <= R;
                                end
                                L: begin
                                    if (draw_mode == LEFT)
                                        dir <= D;
                                    else
                                        dir <= U;
                                end
                                D: begin
                                    if (draw_mode == LEFT)
                                        dir <= R;
                                    else
                                        dir <= L;
                                end
                                R: begin
                                    if (draw_mode == LEFT)
                                        dir <= U;
                                    else
                                        dir <= D;
                                end
                                endcase
                    endcase
                end
                else begin
                    image_cnt <= image_cnt + 1'b1;
                    state <= DRAW;
                    case (draw_mode)
                        MOVE:
                            case (dir)
                                U: begin
                                    center_x <= center_x - 1;
                                    center_y <= center_y;
                                end
                                L: begin
                                    center_x <= center_x;
                                    center_y <= center_y - 1;
                                end
                                D: begin
                                    center_x <= center_x + 1;
                                    center_y <= center_y;
                                end
                                R: begin
                                    center_x <= center_x;
                                    center_y <= center_y + 1;
                                end
                            endcase
                        LEFT: begin
                            if (center_angle == 9'd0)
                                center_angle <= 9'd359;
                            else
                                center_angle <= center_angle - 1;
                        end
                        RIGHT: begin
                            if (center_angle == 9'd359)
                                center_angle <= 9'd0;
                            else
                                center_angle <= center_angle + 1;
                        end
                    endcase
                    dir_x <= Dir_x[center_angle];
                    dir_y <= Dir_y[center_angle];
                end
            end
            DRAW: begin
                // 流水线
                if (!signal) begin
                    move_en <= 1'b0;
                end
                px[1] <= px[0];
                px[2] <= px[1];
                px[3] <= px[2];
                px[4] <= px[3];
                px[5] <= px[4];
                px[6] <= px[5];
                px[7] <= px[6];
                px[8] <= px[7];

                py[1] <= py[0];
                py[2] <= py[1];
                py[3] <= py[2];
                py[4] <= py[3];
                py[5] <= py[4];
                py[6] <= py[5];
                px[7] <= px[6];
                px[8] <= px[7];

                pip_en[1] <= pip_en[0];
                pip_en[2] <= pip_en[1];
                pip_en[3] <= pip_en[2];
                pip_en[4] <= pip_en[3];
                pip_en[5] <= pip_en[4];
                pip_en[6] <= pip_en[5];
                pip_en[7] <= pip_en[6];
                pip_en[8] <= pip_en[7];

                ray_dir_R[1] <= ray_dir_R[0];

                // GEN_RAY 1
                if (pip_en[0] == 1'b1) begin // 激活
                    if (px[0] == width) begin
                        pip_en[0] <= 1'b1;
                        px[0] <= px[0];
                        py[0] <= py[0];
                    end
                    else begin
                        pip_en[0] <= 1'b0;
                        px[0] <= 10'd0;
                        py[0] <= 10'd0;
                        ray_dir[0] <= -400;
                        ray_dir[1] <= 300;
                        ray_dir[2] <= 511;
                    end
                end
                else begin
                    if (px[0] == width - 1 && py[0] == height - 1) begin
                        pip_en[0] <= 1'b1;
                        px[0] <= width;
                        py[0] <= height;
                    end
                    else if (px[0] == width - 1) begin
                        pip_en[0] <= 1'b0;
                        px[0] <= 10'd0;
                        py[0] <= py[0] + 1;
                        ray_dir[0] <= -400;
                        ray_dir[1] <= 149 - (py[0] >> 1);
                        ray_dir[2] <= 511;
                    end
                    else begin
                        pip_en[0] <= 1'b0;
                        px[0] <= px[0] + 1;
                        py[0] <= py[0];
                        ray_dir[0] <= (px[0] >> 1) - 200;
                        ray_dir[1] <= 149 - (py[0] >> 1);
                        ray_dir[2] <= 511;
                    end
                end

                // GEN_RAY 2
                if (pip_en[0] == 1'b0) begin
                    // do GEN_RAY
                    {ray_dir_R[0][0], tmp[0]} <= ray_dir[0] * hor_x
                                            + ray_dir[2] * dir_x;
                    {ray_dir_R[0][1], tmp[1]} <= ray_dir[0] * hor_y
                                            + ray_dir[2] * dir_y;
                    ray_dir_R[0][2] <= ray_dir[1] / 2;
                end
                else begin
                    // stay
                end

                // INTERSECT 1
                if (pip_en[1] == 1'b0) begin
                    // do intersect
                end
                else begin
                    // stay
                end

                // INTERSECT 2
                if (pip_en[2] == 1'b0) begin
                    // do intersect
                end
                else begin
                    // stay
                end

                // INTERSECT 3
                if (pip_en[3] == 1'b0) begin
                    // do intersect
                end
                else begin
                    // stay
                end

                // INTERSECT 4
                if (pip_en[4] == 1'b0) begin
                    // do intersect
                end
                else begin
                    // stay
                end

                // PHONG 1
                if (pip_en[5] == 1'b0) begin
                    // do phong
                    integer i;
                    integer j;
                    if (rev) begin
                        for (i = 0; i < 4; i = i + 1)
                            for (j = 0; j < 3; j = j + 1)
                                single_shade[i][j] <= light_color[i][j] ? -dir_to_light[j][normal_dir] : 0;
                    end
                    else begin
                        for (i = 0; i < 4; i = i + 1)
                            for (j = 0; j < 3; j = j + 1)
                                single_shade[i][j] <= light_color[i][j] ? dir_to_light[j][normal_dir] : 0;
                    end
                end
                else begin
                    // stay
                end

                // PHONG 2
                if (pip_en[6] == 1'b0) begin
                    // do phong
                    if (outp_en) begin
                        phone[0] <= 8'd0;
                        phone[1] <= 8'd0;
                        phone[2] <= 8'd102;
                    end
                    else begin
                        integer i;
                        for (i = 0; i < 3; i = i + 1)
                            phone[i] <= (single_shade[0][i][9] ? 0 : single_shade[0][i][8:2])
                                    + (single_shade[1][i][9] ? 0 : single_shade[1][i][8:2])
                                    + (single_shade[2][i][9] ? 0 : single_shade[2][i][8:2])
                                    + (single_shade[3][i][9] ? 0 : single_shade[3][i][8:2]);
                    end
                end
                else begin
                    // stay
                end

                // SET_PIXEL
                if (pip_en[7] == 1'b0) begin
                    // do set_pixel
                    wr_en <= 1'b1;
                    red <= phone[0];
                    green <= phone[1];
                    blue <= phone[2];
                    wr_addr <= width * py[6] + px[6];
                end
                else begin
                    // stay
                    wr_en <= 1'b0;
                end

                // back to init_cam
                if (pip_en[8] == 1'b0) begin
                    state <= DRAW;
                end
                else if (px[8] == width) begin
                    state <= INIT_CAM;
                end
                else begin
                    state <= DRAW;
                end
            end
            default:;
        endcase        
    end
    
end

// always @(posedge clk_vga) begin
//     if (wr_en) begin
//         if (wr_addr == 19'd479999) begin
//             wr_addr <= 19'd0;
//             rd_addr_offset <= wr_addr_offset;
//             wr_addr_offset <= rd_addr_offset;
//         end
//         else begin
//             wr_addr <= wr_addr + 1'b1;
//         end
//     end
// end

assign video_clk = clk_vga;
render imgae_render(
    .clk(clk_100m),
    .clk_vga(clk_vga),

    .ram_data(base_ram_data),
    .ram_addr(base_ram_addr),
    .ram_ce_n(base_ram_ce_n),
    .ram_oe_n(base_ram_oe_n),
    .ram_we_n(base_ram_we_n),

    .rd_addr_offset(rd_addr_offset),
    .wr_addr_offset(wr_addr_offset),
    .sram_wr_en(wr_en),
    .sram_wr_addr(wr_addr),
    .sram_wr_data(wr_data),

    .vga_hsync(video_hsync),
    .vga_vsync(video_vsync),

    .vga_red(video_red), 
    .vga_green(video_green),
    .vga_blue(video_blue),

    .vga_data_en(video_de)
);
/* =========== Demo code end =========== */

endmodule
