`timescale 1ns/1ps

module Tx(
    input  wire       clk,
    input  wire       rst_n,      // Active-low reset

    input  wire       tx_start,
    input  wire [7:0] tx_data,

    output reg        tx,
    output reg        tx_busy,
    output reg        tx_done
);

    reg [9:0] shift_reg;
    reg [3:0] bit_count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx        <= 1'b1;     // UART idle
            tx_busy   <= 1'b0;
            tx_done   <= 1'b0;
            shift_reg <= 10'h3FF;
            bit_count <= 4'd0;
        end
        else begin
            tx_done <= 1'b0;

            // Load a new byte
            if (tx_start && !tx_busy) begin
                // {Stop, Data[7:0], Start}
                shift_reg <= {1'b1, tx_data, 1'b0};
                tx_busy   <= 1'b1;
                bit_count <= 4'd10;
            end

            // Shift out one bit every clock
            else if (tx_busy) begin
                tx <= shift_reg[0];

                shift_reg <= {1'b1, shift_reg[9:1]};
                bit_count <= bit_count - 1'b1;

                if (bit_count == 1) begin
                    tx_busy <= 1'b0;
                    tx_done <= 1'b1;
                    tx <= 1'b1;          // Return to idle
                end
            end
            else begin
                tx <= 1'b1;
            end
        end
    end

endmodule