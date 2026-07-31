module system_top #(
    parameter integer CLK_HZ = 27_000_000
) (
    input  wire        clk_in,
    input  wire        rst_n_in,
    input  wire [1:0]  btn,
    output wire [3:0]  led
);
    wire rst_n;
    wire timer_busy;
    wire timer_done;
    wire [31:0] timer_count;
    wire [3:0] gpio_in_q;
    reg [3:0] led_r;

    reset_sync u_reset_sync (
        .clk      (clk_in),
        .rst_n_in (rst_n_in),
        .rst_n_out(rst_n)
    );

    timer #(
        .WIDTH(32)
    ) u_timer (
        .clk     (clk_in),
        .rst_n   (rst_n),
        .start   (~timer_busy),
        .load    (1'b0),
        .value   (CLK_HZ),
        .busy    (timer_busy),
        .done    (timer_done),
        .count   (timer_count)
    );

    gpio #(
        .WIDTH(4)
    ) u_gpio (
        .clk          (clk_in),
        .rst_n        (rst_n),
        .gpio_in      ({2'b00, btn}),
        .gpio_in_q    (gpio_in_q),
        .gpio_out_next(led_r),
        .gpio_out_load(1'b1),
        .gpio_out     (led)
    );

    always @(posedge clk_in or negedge rst_n) begin
        if (!rst_n) begin
            led_r <= 4'b0001;
        end else begin
            if (gpio_in_q[0]) begin
                led_r <= 4'b0001;
            end else if (gpio_in_q[1]) begin
                led_r <= 4'b1000;
            end else
            if (timer_done) begin
                led_r <= {led_r[2:0], led_r[3]};
            end
        end
    end
endmodule
