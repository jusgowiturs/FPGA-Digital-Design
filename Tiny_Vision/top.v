module top (
    input clk,
    output led_red,
    output led_green,
    output led_blue
);
    // 24-bit register to track clock ticks
    reg [23:0] counter = 24'd0;

    // Triangle-wave brightness for a smooth fade in/out.
    wire [7:0] red_brightness;
    wire red_pwm;

    assign red_brightness = counter[23]
        ? ~counter[22:15]
        :  counter[22:15];

    always @(posedge clk) begin
        counter <= counter + 1;
    end

    // Inverted logic (0 = ON, 1 = OFF) is common on tinyVision boards.
    // Drive red through PWM so it fades smoothly instead of blinking.
    pwm red_pwm_driver (
        .clk(clk),
        .duty(red_brightness),
        .pwm_out(red_pwm)
    );

    assign led_red   = ~red_pwm;
    assign led_green = 1'b1; // Turned OFF
    assign led_blue  = 1'b1; // Turned OFF
endmodule

module pwm (
    input clk,
    input [7:0] duty,
    output pwm_out
);
    reg [7:0] level = 8'd0;

    always @(posedge clk) begin
        level <= level + 1;
    end

    assign pwm_out = (level < duty);
endmodule
