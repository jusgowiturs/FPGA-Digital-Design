`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2026 03:57:20 PM
// Design Name: 
// Module Name: axi_rgb_channelizer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module axi_rgb_channelizer
(
        input wire         aclk,
        input wire         aresetn,
        // *** Control ***
        input wire         en,
        // *** AXIS slave port ***
        output wire        s_axis_tready,
        input wire [31:0]  s_axis_tdata,
        input wire         s_axis_tvalid,
        input wire         s_axis_tlast,
        // *** AXIS master port ***
        input wire         m_axis_tready,
        output wire [31:0] m_axis_tdata,
        output wire        m_axis_tvalid,
        output wire        m_axis_tlast
    );
    
    wire [7:0] y_out;
    
    // AXI-Stream control
    assign s_axis_tready = m_axis_tready;
    assign m_axis_tdata = en ? {24'h000000, y_out} : 32'd0;
    assign m_axis_tvalid = s_axis_tvalid;
    assign m_axis_tlast = s_axis_tlast;
    
    // PE
    rgb2gray #(8, 0) pe_0
    (
        .r_in(s_axis_tdata[7:0]),
        .g_in(s_axis_tdata[15:8]),
        .b_in(s_axis_tdata[23:16]),
        .y_out(y_out)
    );
    
endmodule
