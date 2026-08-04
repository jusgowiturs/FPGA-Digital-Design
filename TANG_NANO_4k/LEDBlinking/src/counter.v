module counter (
    input   sys_clk,
    input   sys_rst_n,     // reset input
    output  wire led        // LED
);

reg [31:0] counter;        
reg  ledreg;
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        counter <= 32'd0;
        ledreg  <= 1'b0;
    end
    else begin
        if (counter == 32'd1000000-2) begin
            counter <= 32'd0;
            ledreg <= ~ledreg;   // Toggle LED
        end
        else begin
            counter <= counter + 1'b1;
        end
    end
end

assign led = ledreg;
endmodule