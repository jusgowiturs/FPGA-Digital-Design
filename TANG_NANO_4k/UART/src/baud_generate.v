`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module : baud_gen
// Description:
// Generates a baud-rate tick from the system clock.
//
// Example:
//   CLK_FREQ = 27_000_000 Hz
//   BAUD_RATE = 115200
//
// Tick period = CLK_FREQ / BAUD_RATE ≈ 234 clocks
//
//////////////////////////////////////////////////////////////////////////////////

module baud_gen #(
    parameter CLK_FREQ  = 27_000_000,
    parameter BAUD_RATE = 115200
)(
    input  wire clk,
    input  wire rst_n,

    output reg  baud_tick
);

    localparam integer BAUD_DIV = CLK_FREQ / BAUD_RATE;

    reg [$clog2(BAUD_DIV)-1:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (rst_n==0) begin
            counter   <= 0;
            baud_tick <= 1'b0;
        end
        else begin
        //$display("Else part in design code %d",counter);
            if (counter == BAUD_DIV -1) begin
                counter   <= 0;
                // $display("I am design code at %d the value of baud tick =%b",counter,baud_tick);
                baud_tick <= ~baud_tick;   // One-clock pulse
            end
            else begin
                counter   <= counter + 1'b1;
                
                // $display("Baud_div = %d Else part in design code %d",BAUD_DIV,counter);
            end
        end
    end

endmodule
