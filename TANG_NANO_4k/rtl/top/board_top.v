module board_top (
    input  wire        clk_in,
    input  wire        rst_btn_n,
    input  wire [1:0]  btn,
    output wire [3:0]  led
);
    // Board wrapper: keep all Tang Nano 4K pin-level wiring here.
    system_top #(
        .CLK_HZ(27_000_000)
    ) u_system_top (
        .clk_in   (clk_in),
        .rst_n_in (rst_btn_n),
        .btn      (btn),
        .led      (led)
    );
endmodule
