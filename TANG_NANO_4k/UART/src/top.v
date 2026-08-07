`timescale 1ns/1ps

module top(

    input  wire clk,
    input  wire rst_n,

    output wire tx

);

reg [7:0] rom_addr;
wire [7:0] rom_data;

reg        tx_start;
wire       tx_busy;
wire       tx_done;

reg [7:0] tx_data;

/////////////////////////////////////////////////
// ROM
/////////////////////////////////////////////////

rom ROM(
    .clk(clk),
    .addr(rom_addr),
    .data(rom_data)
);

/////////////////////////////////////////////////
// UART TX
/////////////////////////////////////////////////

Tx UART_TX(

    .clk(clk),
    .rst_n(rst_n),

    .tx_start(tx_start),
    .tx_data(tx_data),

    .tx(tx),
    .tx_busy(tx_busy),
    .tx_done(tx_done)

);

/////////////////////////////////////////////////
// FSM
/////////////////////////////////////////////////

localparam IDLE      = 3'd0;
localparam READ_ROM  = 3'd1;
localparam START_TX  = 3'd2;
localparam WAIT_DONE = 3'd3;
localparam NEXT_CHAR = 3'd4;

reg [2:0] state;

always @(posedge clk or negedge rst_n) begin

    if(!rst_n) begin

        state     <= IDLE;
        rom_addr  <= 0;
        tx_start  <= 0;
        tx_data   <= 0;

    end

    else begin

        case(state)

        //--------------------------------------
        IDLE:
        //--------------------------------------
        begin
            state <= READ_ROM;
        end

        //--------------------------------------
        READ_ROM:
        //--------------------------------------
        begin
            tx_data <= rom_data;
            state   <= START_TX;
        end

        //--------------------------------------
        START_TX:
        //--------------------------------------
        begin
            tx_start <= 1'b1;
            state    <= WAIT_DONE;
        end

        //--------------------------------------
        WAIT_DONE:
        //--------------------------------------
        begin

            tx_start <= 1'b0;

            if(tx_done)
                state <= NEXT_CHAR;

        end

        //--------------------------------------
        NEXT_CHAR:
        //--------------------------------------
        begin

            if(tx_data == 8'h00)
                state <= IDLE;
            else begin
                rom_addr <= rom_addr + 1'b1;
                state    <= READ_ROM;
            end

        end

        default:
            state <= IDLE;

        endcase

    end

end

endmodule
