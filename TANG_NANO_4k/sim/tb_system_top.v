`timescale 1ns/1ps

module tb_system_top;
    reg clk;
    reg rst_n_in;
    reg [1:0] btn;
    wire [3:0] led;

    localparam integer CLK_HZ = 10;

    system_top #(
        .CLK_HZ(CLK_HZ)
    ) dut (
        .clk_in  (clk),
        .rst_n_in(rst_n_in),
        .btn     (btn),
        .led     (led)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    task expect_led;
        input [3:0] expected;
        input [255:0] label;
        begin
            if (led !== expected) begin
                $display("FAIL: %0s expected=%b actual=%b time=%0t", label, expected, led, $time);
                $fatal(1);
            end else begin
                $display("PASS: %0s led=%b time=%0t", label, led, $time);
            end
        end
    endtask

    integer i;

    initial begin
        rst_n_in = 1'b0;
        btn = 2'b00;

        repeat (4) @(posedge clk);
        rst_n_in = 1'b1;

        repeat (4) @(posedge clk);
        expect_led(4'b0001, "reset release sets initial LED");

        repeat (12) @(posedge clk);
        if (led == 4'b0000) begin
            $display("FAIL: LED must never be all zero during rotation time=%0t", $time);
            $fatal(1);
        end

        btn[0] = 1'b1;
        @(posedge clk);
        btn[0] = 1'b0;
        repeat (2) @(posedge clk);
        expect_led(4'b0001, "button 0 forces LED state");

        btn[1] = 1'b1;
        @(posedge clk);
        btn[1] = 1'b0;
        repeat (2) @(posedge clk);
        expect_led(4'b1000, "button 1 forces LED state");

        repeat (15) @(posedge clk);
        if (led == 4'b0000) begin
            $display("FAIL: LED became zero unexpectedly time=%0t", $time);
            $fatal(1);
        end

        $display("PASS: tb_system_top completed successfully");
        $finish;
    end
endmodule
