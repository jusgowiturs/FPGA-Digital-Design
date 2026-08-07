`timescale 1ns/1ps

module Tx_tb;

reg clk;
reg rst_n;
reg tx_start;
reg [7:0] tx_data;

wire tx;
wire tx_busy;
wire tx_done;

Tx DUT(
    .clk(clk),
    .rst_n(rst_n),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx(tx),
    .tx_busy(tx_busy),
    .tx_done(tx_done)
);


//----------------------------------------------------
// Clock
//----------------------------------------------------
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

//----------------------------------------------------
// VCD
//----------------------------------------------------
initial begin
    $dumpfile("sim/Tx.vcd");
    $dumpvars(0, Tx_tb);
end

//----------------------------------------------------
// Test
//----------------------------------------------------
initial begin

    rst_n = 0;
    tx_start = 0;
    tx_data = 8'h00;

    #20;
    rst_n = 1;

    // Send ASCII 'H'
    @(posedge clk);
    tx_data  = 8'h48;
    tx_start = 1;

    @(posedge clk);
    tx_start = 0;

    wait(tx_done);

    $display("--------------------------------");
    $display("Transmission Completed");
    $display("--------------------------------");

    #20;
    $finish;

end

//----------------------------------------------------
// Monitor
//----------------------------------------------------
always @(posedge clk) begin
    $display("Time=%0t  tx=%b  busy=%b  done=%b",
              $time, tx, tx_busy, tx_done);
end

endmodule