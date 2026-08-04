`timescale 1ns / 1ps

module tb_counter;

    // Inputs
    reg sys_clk;
    reg sys_rst_n;

    // Outputs
    wire led;

    // Instantiate the Unit Under Test (UUT)
    counter uut (
        .sys_clk(sys_clk), 
        .sys_rst_n(sys_rst_n), 
        .led(led)
    );

    // Clock generation (50 MHz clock -> 20ns period)
    always begin
        #10 sys_clk = ~sys_clk;
    end

    // Stimulus process
    initial begin
        // Initialize inputs
        sys_clk = 0;
        sys_rst_n = 0;

        // Hold reset state for 100ns
        #100;
        sys_rst_n = 1;
        
        // Let the simulation run
        // Note: In real simulation, reaching 100,000,000 cycles will take a long time.
        // You may want to temporarily change 32'd100000000 to a smaller number (like 32'd10) 
        // in your design module just to verify the toggle behavior quickly.
        #200; 
        
        $finish;
    end
    initial begin
    $dumpfile("./sim/counter.vcd");
    $dumpvars(0,uut);
    end
      
endmodule
