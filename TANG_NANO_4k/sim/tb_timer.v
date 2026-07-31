`timescale 1ns/1ps

module tb_timer;
    reg clk;
    reg rst_n;
    reg start;
    reg load;
    reg [3:0] value;
    wire busy;
    wire done;
    wire [3:0] count;

    timer #(
        .WIDTH(4)
    ) dut (
        .clk  (clk),
        .rst_n(rst_n),
        .start(start),
        .load (load),
        .value(value),
        .busy (busy),
        .done (done),
        .count(count)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    task expect_state;
        input exp_busy;
        input exp_done;
        input [3:0] exp_count;
        input [255:0] label;
        begin
            if (busy !== exp_busy || done !== exp_done || count !== exp_count) begin
                $display(
                    "FAIL: %0s busy=%b done=%b count=%b expected_busy=%b expected_done=%b expected_count=%b time=%0t",
                    label, busy, done, count, exp_busy, exp_done, exp_count, $time
                );
                $fatal(1);
            end else begin
                $display("PASS: %0s busy=%b done=%b count=%b time=%0t", label, busy, done, count, $time);
            end
        end
    endtask

    initial begin
        rst_n = 1'b0;
        start = 1'b0;
        load = 1'b0;
        value = 4'd0;

        repeat (2) @(posedge clk);
        expect_state(1'b0, 1'b0, 4'd0, "reset state");

        rst_n = 1'b1;
        @(posedge clk);
        expect_state(1'b0, 1'b0, 4'd0, "idle after reset");

        value = 4'd3;
        start = 1'b1;
        @(posedge clk);
        start = 1'b0;
        expect_state(1'b1, 1'b0, 4'd3, "start loads value");

        @(posedge clk);
        expect_state(1'b1, 1'b0, 4'd2, "count decrements to 2");

        @(posedge clk);
        expect_state(1'b1, 1'b0, 4'd1, "count decrements to 1");

        @(posedge clk);
        expect_state(1'b0, 1'b1, 4'd0, "timer done pulse");

        @(posedge clk);
        expect_state(1'b0, 1'b0, 4'd0, "done clears after one cycle");

        value = 4'd5;
        load = 1'b1;
        @(posedge clk);
        load = 1'b0;
        expect_state(1'b1, 1'b0, 4'd5, "load primes the timer");

        $display("PASS: tb_timer completed successfully");
        $finish;
    end
endmodule
