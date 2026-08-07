`timescale 1ns/1ps

module testbench;

reg clk, rst_n;
wire baud_tick;

localparam CLK_FREQ  = 27000000;
localparam BAUD_RATE = 115200;

baud_gen #(
    .CLK_FREQ(CLK_FREQ),
    .BAUD_RATE(BAUD_RATE)
) dut (
    .clk(clk),
    .rst_n(rst_n),
    .baud_tick(baud_tick)
);

// 27 MHz clock
initial begin
    clk = 0;
    forever #18.52 clk = ~clk;
end

initial begin

    $dumpfile("sim/baud_generate.vcd");
    $dumpvars(0, testbench);

    //-------------------------------------------------
    // Apply Reset
    //-------------------------------------------------
    rst_n = 1'b0;

    #5;
    assert (baud_tick == 1'b0)
        else $error("FAIL: baud_tick should be LOW during reset.");

    //-------------------------------------------------
    // Release Reset
    //-------------------------------------------------
    rst_n = 1'b1;

    //-------------------------------------------------
    // After 233 positive edges
    // baud_tick should still be LOW
    //-------------------------------------------------
    repeat (233)
        @(posedge clk);
		#1;

    assert (baud_tick == 1'b0)
        else $fatal(1,"FAIL: baud_tick toggled too early.");

    //-------------------------------------------------
    // 234th positive edge
    //-------------------------------------------------
    @(posedge clk);
#1;
    assert (baud_tick == 1'b1)
        else $fatal(1,"FAIL: baud_tick did not toggle after 234 clocks.");

    $display("--------------------------------");
    $display("PASS : Baud Generator Verified");
    $display("--------------------------------");

    #500;
    $finish;

end

endmodule