module rgb2gray
    #( 
        parameter WIDTH = 8,
        parameter FRAC_BIT = 0
    )
    (
        input wire signed [WIDTH-1:0]  r_in,
        input wire signed [WIDTH-1:0]  g_in,
        input wire signed [WIDTH-1:0]  b_in,
        output wire signed [WIDTH-1:0] y_out
    );
    wire [WIDTH*2-1:0]  y_scale;
    assign y_scale = r_in* 76 + g_in*150 + b_in * 29;
    assign y_out  = y_scale[15:8];

endmodule