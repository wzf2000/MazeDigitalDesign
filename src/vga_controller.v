`timescale 1ns / 1ps
//
// WIDTH: bits in register hdata & vdata
// HSIZE: horizontal size of visible field 
// HFP: horizontal front of pulse
// HSP: horizontal stop of pulse
// HMAX: horizontal max size of value
// VSIZE: vertical size of visible field 
// VFP: vertical front of pulse
// VSP: vertical stop of pulse
// VMAX: vertical max size of value
// HSPP: horizontal synchro pulse polarity (0 - negative, 1 - positive)
// VSPP: vertical synchro pulse polarity (0 - negative, 1 - positive)
//
module vga_controller
#(parameter WIDTH = 0, HSIZE = 0, HFP = 0, HSP = 0, HMAX = 0, VSIZE = 0, VFP = 0, VSP = 0, VMAX = 0, HSPP = 0, VSPP = 0)
(
    input wire clk,
    output wire hsync,
    output wire vsync,

    output wire [7:0] red, 
    output wire [7:0] green,
    output wire [7:0] blue,

    input wire [31:0] data,

    output reg [WIDTH - 1:0] hdata,
    output reg [WIDTH - 1:0] vdata,
    output reg [19:0] address,

    output wire data_enable
);

// hdata&vdata
always @ (posedge clk)
begin
    address <= 20'b0;

    red <= data[23:16];
    green <= data[15:8];
    red <= data[7:0];
    if (hdata == (HMAX - 1)) begin
        if (vdata == (VMAX - 1)) begin
            hdata <= 0;
            vdata <= 0;
        end
        else begin
            hdata <= 0;
            vdata <= vdata + 1;
        end
    end
    else begin
        hdata <= hdata + 1;
        vdata <= vdata;
    end
end

// hsync & vsync & blank
assign hsync = ((hdata >= HFP) && (hdata < HSP)) ? HSPP : !HSPP;
assign vsync = ((vdata >= VFP) && (vdata < VSP)) ? VSPP : !VSPP;
assign data_enable = ((hdata < HSIZE) & (vdata < VSIZE));

endmodule
