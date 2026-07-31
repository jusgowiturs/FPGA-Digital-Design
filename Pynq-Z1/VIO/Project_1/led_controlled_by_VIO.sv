module led_vio(
input logic sysclk, // FOR VIO clocking

output logic [3:0] LED_TOP
);

logic [1:0]SW;
logic [3:0] out;
assign LED_TOP = out; 
led uut(
.SW(SW),
.LED(out)
);

vio_0 vio_uut(
.clk(sysclk),
.probe_out0(SW),
.probe_in0(out)
);
endmodule