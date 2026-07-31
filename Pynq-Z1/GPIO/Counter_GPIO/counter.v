module counter (
    input wire clkpulse,       // Clock input
    input wire rst,         // Active low reset
    output reg [3:0] led // 4-bit counter output
);

    always @(posedge clkpulse or posedge rst) begin
        if (rst) begin
            led <= 4'b0000; // Reset counter to 0
        end else begin
            led <= led + 1; // Increment counter
        end
    end

endmodule