module tick_gen #(
    parameter integer CLK_HZ  = 27_000_000,
    parameter integer TICK_HZ = 1
) (
    input  wire clk,
    input  wire rst_n,
    output wire tick
);
    localparam integer COUNT_MAX = CLK_HZ / TICK_HZ;
    function integer clog2;
        input integer value;
        integer tmp;
        begin
            tmp = value - 1;
            clog2 = 0;
            while (tmp > 0) begin
                tmp = tmp >> 1;
                clog2 = clog2 + 1;
            end
            if (clog2 == 0) begin
                clog2 = 1;
            end
        end
    endfunction

    localparam integer CNT_W = clog2(COUNT_MAX);

    reg [CNT_W-1:0] count_r;
    reg tick_r;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count_r <= {CNT_W{1'b0}};
            tick_r <= 1'b0;
        end else begin
            if (count_r == COUNT_MAX - 1) begin
                count_r <= {CNT_W{1'b0}};
                tick_r <= 1'b1;
            end else begin
                count_r <= count_r + {{(CNT_W-1){1'b0}}, 1'b1};
                tick_r <= 1'b0;
            end
        end
    end

    assign tick = tick_r;
endmodule
