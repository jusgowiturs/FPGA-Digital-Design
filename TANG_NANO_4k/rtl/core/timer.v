module timer #(
    parameter integer WIDTH = 32
) (
    input  wire             clk,
    input  wire             rst_n,
    input  wire             start,
    input  wire             load,
    input  wire [WIDTH-1:0] value,
    output wire             busy,
    output wire             done,
    output wire [WIDTH-1:0] count
);
    reg [WIDTH-1:0] count_r;
    reg busy_r;
    reg done_r;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count_r <= {WIDTH{1'b0}};
            busy_r <= 1'b0;
            done_r <= 1'b0;
        end else begin
            done_r <= 1'b0;
            if (load) begin
                count_r <= value;
                busy_r <= (value != {WIDTH{1'b0}});
            end else if (start) begin
                count_r <= value;
                busy_r <= (value != {WIDTH{1'b0}});
            end else if (busy_r) begin
                if (count_r == {{(WIDTH-1){1'b0}}, 1'b1}) begin
                    count_r <= {WIDTH{1'b0}};
                    busy_r <= 1'b0;
                    done_r <= 1'b1;
                end else if (count_r != {WIDTH{1'b0}}) begin
                    count_r <= count_r - {{(WIDTH-1){1'b0}}, 1'b1};
                end
            end
        end
    end

    assign busy = busy_r;
    assign done = done_r;
    assign count = count_r;
endmodule
