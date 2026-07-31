`timescale 1ns/1ps

module tb_gpio;
    reg clk;
    reg rst_n;
    reg [3:0] gpio_in;
    reg [3:0] gpio_out_next;
    reg gpio_out_load;
    wire [3:0] gpio_in_q;
    wire [3:0] gpio_out;

    gpio #(
        .WIDTH(4)
    ) dut (
        .clk          (clk),
        .rst_n        (rst_n),
        .gpio_in      (gpio_in),
        .gpio_in_q    (gpio_in_q),
        .gpio_out_next(gpio_out_next),
        .gpio_out_load(gpio_out_load),
        .gpio_out     (gpio_out)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    task expect_gpio;
        input [3:0] exp_in_q;
        input [3:0] exp_out;
        input [255:0] label;
        begin
            if (gpio_in_q !== exp_in_q || gpio_out !== exp_out) begin
                $display(
                    "FAIL: %0s in_q=%b out=%b expected_in_q=%b expected_out=%b time=%0t",
                    label, gpio_in_q, gpio_out, exp_in_q, exp_out, $time
                );
                $fatal(1);
            end else begin
                $display("PASS: %0s in_q=%b out=%b time=%0t", label, gpio_in_q, gpio_out, $time);
            end
        end
    endtask

    initial begin
        rst_n = 1'b0;
        gpio_in = 4'b0000;
        gpio_out_next = 4'b0000;
        gpio_out_load = 1'b0;

        repeat (2) @(posedge clk);
        expect_gpio(4'b0000, 4'b0000, "reset state");

        rst_n = 1'b1;
        gpio_in = 4'b1010;
        @(posedge clk);
        expect_gpio(4'b1010, 4'b0000, "input sampled");

        gpio_out_next = 4'b1100;
        gpio_out_load = 1'b1;
        @(posedge clk);
        gpio_out_load = 1'b0;
        expect_gpio(4'b1010, 4'b1100, "output loaded");

        gpio_in = 4'b0101;
        @(posedge clk);
        expect_gpio(4'b0101, 4'b1100, "input updates while output holds");

        gpio_out_next = 4'b0011;
        gpio_out_load = 1'b1;
        @(posedge clk);
        gpio_out_load = 1'b0;
        expect_gpio(4'b0101, 4'b0011, "output loads again");

        $display("PASS: tb_gpio completed successfully");
        $finish;
    end
endmodule
