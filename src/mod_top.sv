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
localparam maze = 25'b0100001010010100101000010;
localparam hor_wall = 30'b111001111111111111111111100111;
localparam ver_wall = 30'b100001000011100001110000100001;
//reg [2:0] pos[1:0] = {1'b0, 1'b0};

//define camera param
//localparam lights[3:0][31:0] = {32'd0, 32'd0, 32'd0};
localparam width = 10'd800;
localparam height = 10'd600;
localparam direction_z = 20'd512;
localparam center_z = 20'd50;
localparam half_angle_tan_rev = 10'd4;
localparam angle = 10'd28;
// localparam angle_sin = 20'd512;
// localparam angle_cos = 20'd887;
// localparam angle_tan = 20'd591;
reg [2:0] x;
reg [2:0] y;
reg _dx;
reg _dy;
reg [19:0] dx;
reg [19:0] dy;
reg _hx;
reg _hy;
reg [19:0] hx;
reg [19:0] hy;

// define state
reg [3:0] state = 4'b0000;
localparam STILL = 4'b0001;
localparam INIT_CAM = 4'b0010;
localparam DRAW = 4'b0011;

// define movement signal
reg [1:0] draw_mode = 2'b00; // 10 move 11 rotate
localparam MOVE = 2'b10;
localparam ROTATE = 2'b11;


// define pipeline
localparam GEN_RAY = 4'b0010;
localparam INTERSECT = 4'b0011;
localparam PHONG = 4'b0100;
localparam SET_PIXEL = 4'b0101;

reg [3:0] pip_en; // 使能 拉低有效
reg [9:0] px[3:0]; // 像素点x
reg [9:0] py[3:0]; // 像素点y

// main states
always @ (posedge clk_in or posedge reset_n)
begin
    case (state)
        STILL: begin
            if (draw_mode == MOVE || draw_mode == ROTATE) begin
                state <= INIT_CAM;
            end
            else begin // stay still
                state <= state;
            end
        end 
        INIT_CAM: begin
            //INIT_CAM
            
            px[0] <= 10'd0;
            py[0] <= 10'd0;

            state <= DRAW;
        end
        DRAW: begin
            // 流水线
            px[1] <= px[0];
            px[2] <= px[1];
            px[3] <= px[2];

            py[1] <= py[0];
            py[2] <= py[1];
            py[3] <= py[2];

            pip_en[1] <= pip_en[0];
            pip_en[2] <= pip_en[1];
            pip_en[3] <= pip_en[2];

            // GEN_RAY
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
                end
                else begin
                    pip_en[0] <= 1'b0;
                    px[0] <= px[0] + 1;
                    py[0] <= py[0];
                end
            end

            // INTERSECT
            if (pip_en[0] == 1'b0) begin
                // do intersect
            end
            else begin
                // stay
            end

            // PHONG
            if (pip_en[1] == 1'b0) begin
                // do phong
            end
            else begin
                // stay
            end

            // SET_PIXEL
            if (pip_en[2] == 1'b0) begin
                // do set_pixel
            end
            else begin
                // stay
            end

            // back to init_cam
            if (pip_en[3] == 1'b0) begin
                state <= DRAW;
            end
            else if (px[3] == width) begin
                state <= INIT_CAM;
            end
            else begin
                state <= DRAW;
            end
        end
        default: begin
        end
    endcase
end


wire [1:0] move_data;
reg move_en = 0;
wire signal;

// LED
assign leds[1:0] = move_data;
assign leds[15:2] = 12'd0;
assign leds[31:16] = ~(dip_sw);

ps2_controller u_ps2_controller(
    .clk(clk_ps2), // 50MHz
    .rst(reset_n),
    .ps2_clk(ps2_clock),
    .ps2_data(ps2_data),
    .data(move_data),
    .signal(signal)
);

reg rd_addr_offset = 1'b0;
reg wr_addr_offset = 1'b1;
reg wr_en;
reg [18:0] wr_addr;
reg [31:0] wr_data;
reg [7:0] wr_red = 8'd0;
reg [7:0] wr_green = 8'd0;
reg [7:0] wr_blue = 8'd0;
reg [7:0] red;
reg [7:0] green;
reg [7:0] blue;

assign wr_data = {{8{1'b0}}, red, green, blue};

always @(posedge clk_in) begin
    if (!move_en && signal) begin
        case (move_data)
            2'b01: begin
                wr_red <= wr_red + 16;
            end
            2'b10: begin
                wr_green <= wr_green + 16;
            end
            2'b11: begin
                wr_blue <= wr_blue + 16;
            end
            default: begin
            end
        endcase
        move_en <= 1'b1;
    end
    else if (!signal) begin
        move_en <= 1'b0;
    end
end

always @(posedge clk_vga) begin
    if (wr_addr == 19'd479999) begin
        wr_addr <= 0;
        rd_addr_offset <= wr_addr_offset;
        wr_addr_offset <= rd_addr_offset;
        red <= wr_red;
        green <= wr_green;
        blue <= wr_blue;
    end
    else begin
        wr_addr <= wr_addr + 1'b1;
    end
end

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