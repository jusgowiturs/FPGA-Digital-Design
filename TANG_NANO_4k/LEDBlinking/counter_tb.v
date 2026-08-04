`timescale 1ns/1ps

module counter_tb;

    // Testbench signals
    reg sys_clk;
    reg sys_rst_n;
    wire led;

    // Instantiate the DUT
    counter dut (
        .sys_clk   (sys_clk),
        .sys_rst_n (sys_rst_n),
        .led       (led)
    );

    // Clock generation (100 MHz)
    initial begin
        sys_clk = 1'b0;
        forever #5 sys_clk = ~sys_clk;
    end

    // Stimulus
    initial begin
        // Generate VCD file
        $dumpfile("sim/counter.vcd");
        $dumpvars(0, counter_tb);

        // Apply reset
        sys_rst_n = 1'b0;

        // Hold reset for 100 ns
        #100;
        sys_rst_n = 1'b1;

        // Run simulation
        #(25_000_000);

        $display("Simulation completed.");
        $finish;
    end

endmodule
