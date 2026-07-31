`timescale 1ns/1ps

module tb_reset_sync;
    reg clk;
    reg rst_n_in;
    wire rst_n_out;

    reset_sync dut (
        .clk      (clk),
        .rst_n_in (rst_n_in),
        .rst_n_out(rst_n_out)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    task expect_rst;
        input expected;
        input [255:0] label;
        begin
            if (rst_n_out !== expected) begin
                $display("FAIL: %0s expected=%b actual=%b time=%0t", label, expected, rst_n_out, $time);
                $fatal(1);
            end else begin
                $display("PASS: %0s rst_n_out=%b time=%0t", label, rst_n_out, $time);
            end
        end
    endtask

    initial begin
        rst_n_in = 1'b0;
        #1;
        expect_rst(1'b0, "async reset drives output low");

        repeat (2) @(posedge clk);
        expect_rst(1'b0, "still low while reset held");

        rst_n_in = 1'b1;
        #1;
        expect_rst(1'b0, "release is not immediate");

        @(posedge clk);
        expect_rst(1'b0, "first sync stage only");

        @(posedge clk);
        expect_rst(1'b1, "reset released after two clocks");

        rst_n_in = 1'b0;
        #1;
        expect_rst(1'b0, "asserting reset pulls output low immediately");

        $display("PASS: tb_reset_sync completed successfully");
        $finish;
    end
endmodule
