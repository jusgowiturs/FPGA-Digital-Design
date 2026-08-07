`timescale 1ns/1ps

module rom_tb;

reg clk;
reg [7:0] addr;
wire [7:0] data;

rom uut(
    .clk(clk),
    .addr(addr),
    .data(data)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    addr = 0;

    repeat (11) begin
        @(posedge clk);
        #1;
        
        $display("Address=%0d Data=0x%02h Character=%c",
                  addr, data, data);
        addr = addr + 1;
        
    end

    $finish;
end

endmodule