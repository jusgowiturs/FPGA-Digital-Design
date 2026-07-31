module gpio #(
    parameter integer WIDTH = 8
) (
    input  wire             clk,
    input  wire             rst_n,
    input  wire [WIDTH-1:0] gpio_in,
    output reg  [WIDTH-1:0] gpio_in_q,
    input  wire [WIDTH-1:0] gpio_out_next,
    input  wire             gpio_out_load,
    output reg  [WIDTH-1:0] gpio_out
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            gpio_in_q <= {WIDTH{1'b0}};
            gpio_out <= {WIDTH{1'b0}};
        end else begin
            gpio_in_q <= gpio_in;
            if (gpio_out_load) begin
                gpio_out <= gpio_out_next;
            end
        end
    end
endmodule
