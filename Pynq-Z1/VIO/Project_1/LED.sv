module led(
input logic [1:0] SW,
output logic [3:0] LED
);
always_comb begin
    if(SW[1] && SW[0])
        LED = 4'hF;
    else if(~SW[0] && SW[1])
        LED = 4'h2;
    else if (SW[0] && ~SW[1])
        LED = 4'h1;
    else
        LED = 4'h0;
end
endmodule