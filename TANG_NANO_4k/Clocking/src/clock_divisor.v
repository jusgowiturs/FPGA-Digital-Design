module clock_divisor #(
    parameter integer Div = 2
)(
    input  wire clkin,
    input  wire rst_n,
    output reg  clkout
);

    integer count;

    always @(posedge clkin or negedge rst_n) begin
        if (!rst_n) begin
            count  <= 0;
            clkout <= 1'b0;
        end
        else begin
            if (count == (Div/2)-1) begin
                count  <= 0;
                clkout <= ~clkout;
            end
            else begin
                count <= count + 1;
            end
        end
    end

endmodule
