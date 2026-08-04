`timescale 1ns/1ps

module clock_divisor_tb;

    parameter Div = 10;

    reg clkin;
    reg rst_n;
    wire clkout;

    // Instantiate DUT
    clock_divisor #(
        .Div(Div)
    ) dut (
        .clkin(clkin),
        .rst_n(rst_n),
        .clkout(clkout)
    );

    // Generate 100 MHz clock (10 ns period)
    initial
        clkin = 0;

    always #5 clkin = ~clkin;

    // Stimulus
    initial begin
        $dumpfile("sim/clock_divisor.vcd");
        $dumpvars(0, clock_divisor_tb);

        rst_n = 0;
        #20;

        rst_n = 1;

        // Run long enough to observe several output cycles
        #(Div * 20 * 5);

        $finish;
    end

endmodule

