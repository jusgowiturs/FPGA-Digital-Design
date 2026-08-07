`timescale 1ns/1ps

module rom #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 8
)
(
    input  wire                     clk,
    input  wire [ADDR_WIDTH-1:0]    addr,
    output reg  [DATA_WIDTH-1:0]    data
);

    // 256 x 8 ROM
    reg [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];

    //--------------------------------------------------
    // Initialize ROM
    //--------------------------------------------------
    initial begin
        $readmemh("message.mem", mem);
    end

    //--------------------------------------------------
    // Synchronous Read
    //--------------------------------------------------
    /*always @(posedge clk)
        data <= mem[addr];*/

    //Asynchronous Read
    assign data = mem[addr];

endmodule