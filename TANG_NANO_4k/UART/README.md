# UART Tx and Rx

## Project Directory
.
-   src/
        - FIFO.v for RX
        - Tx.v   // Design at 27 MHz
        - Top.v(to make Rx device to operate upto 27MHz using sysclk or reduced frequency using clock_divisor.v)
            -   Rx.v  // Design to opearate at 1 MHz using clock divisor
            -   clock_divisor.v may be used or ignored
-   sim/
        - TX and Rx works at same time
-   synthesis/ yosys synthesised content.json
-   constrain/
        -   TANGNANO 4k constraint file as .cst
-   impl/   nextpnr_himachel pnr .json 
-   run/    using gowin_pack generate .fs file
