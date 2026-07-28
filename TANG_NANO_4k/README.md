# Tang Nano 4K Reusable FPGA Project

This repository is structured as a long-term FPGA project, not a collection of disconnected demos.

The goal is to build a reusable hardware framework where each module has one clear job, a stable interface, and minimal dependence on board-specific details.

## Design Goals

- Keep board-specific code separate from reusable logic.
- Make every module small, testable, and reusable.
- Use one clock domain at first.
- Synchronize reset cleanly.
- Build peripherals from shared primitives instead of copy-pasting logic.
- Grow the design in layers so each new block teaches a new FPGA concept.

## Recommended Folder Structure

```text
project/
  rtl/
    top/
      board_top.v
      system_top.v
    board/
      tangnano4k_pins.v
      tangnano4k_clk.v
    core/
      reset_sync.v
      tick_gen.v
      timer.v
      edge_detect.v
      debounce.v
      pulse_stretch.v
    bus/
      reg_if.v
      addr_decode.v
      simple_bus.v
    periph/
      gpio.v
      uart_tx.v
      uart_rx.v
      uart.v
      pwm.v
      spi_master.v
      i2c_master.v
    fsm/
      fsm_pkg.v
    util/
      clog2.v
      sync_2ff.v
      counter.v
  constraints/
    tangnano4k.cst
  sim/
    tb_timer.v
    tb_uart.v
    tb_spi.v
  docs/
    block_diagram.md
    register_map.md
```

## Big Picture

The top-level design should be split into two layers:

- `board_top.v`: handles the physical Tang Nano 4K pins and board-specific connections.
- `system_top.v`: contains the reusable system logic and peripheral integration.

This keeps the design portable. If you move to another FPGA board later, most of your logic can stay unchanged.

## Module Roles

### `board/`

Contains code that depends on the Tang Nano 4K board.

Use this layer for:

- clock input handling
- pin mapping
- LED and button wiring
- board-specific constraints

Do not put reusable peripheral logic here.

### `core/`

Contains building blocks used by many modules.

Examples:

- `reset_sync.v`: makes reset release safe
- `tick_gen.v`: creates periodic enable pulses
- `timer.v`: counts delays or timeouts
- `edge_detect.v`: finds rising/falling edges
- `debounce.v`: cleans up button input

### `periph/`

Contains higher-level reusable peripherals.

Examples:

- `gpio.v`: general-purpose input/output
- `uart.v`: serial communication
- `pwm.v`: pulse-width modulation
- `spi_master.v`: SPI controller
- `i2c_master.v`: I2C controller

### `bus/`

Contains register and decoding logic if you decide to add a control bus.

This becomes useful once you have multiple peripherals with configuration registers.

### `fsm/`

Contains state machine conventions or shared enum definitions if your toolflow supports them.

### `util/`

Contains small helper functions and generic reusable primitives.

## Why Each Module Exists

### Clock Generation

The FPGA needs a stable clock to coordinate all sequential logic.

Start here because:

- every counter depends on it
- every UART baud generator depends on it
- every timer and FSM depends on it

Use one main system clock at first. Prefer clock-enable pulses over creating many derived clocks.

### Reset Synchronization

Reset must not release unpredictably.

Use a reset synchronizer so each clock domain leaves reset on a clean clock edge.

This prevents:

- half-started counters
- broken state machines
- metastability during reset release

### Timer Modules

Timers are the foundation for all time-based logic.

Use them for:

- LED blink
- button debounce timing
- UART baud generation
- PWM timing
- protocol timeouts

### GPIO

GPIO is your simplest useful peripheral.

Use it to:

- read buttons and switches
- drive LEDs
- verify that the board, clock, and reset all work

### UART

UART is the best early debug tool.

Use it to:

- print status messages
- send commands from a PC
- inspect internal behavior without a debugger

Split UART into separate TX and RX blocks if you want maximum reuse.

### PWM

PWM turns a digital output into a controllable average signal.

Use it for:

- LED dimming
- buzzers
- motor or servo-related control blocks later

### SPI

SPI is useful for sensors, displays, and memories.

It teaches:

- shift registers
- bit counters
- chip select handling
- protocol timing

### I2C

I2C is useful for low-speed configuration devices and sensors.

It teaches:

- open-drain behavior
- start and stop conditions
- ACK/NACK handling
- more complex timing than SPI

### State Machines

State machines describe ordered behavior.

Use them for:

- UART transmit and receive sequencing
- SPI transaction control
- I2C bus control
- higher-level command handling

Keep each FSM small and focused on one task.

### Parameterized Modules

Parameters make modules reusable.

Examples:

- `WIDTH`
- `COUNT_MAX`
- `CLK_HZ`
- `BAUD_RATE`
- `CHANNELS`

This lets one module handle many cases without duplication.

## How Modules Communicate

Use clear, predictable port names:

- control inputs: `en`, `start`, `load`, `cfg_*`
- data inputs: `data_in`, `rx_data`
- data outputs: `data_out`, `tx_data`
- status outputs: `busy`, `done`, `valid`, `ready`

Recommended communication patterns:

- direct wires for simple signal flow
- register-style interfaces for configuration and status
- streaming interfaces for byte or packet movement

## Build Order for a Beginner

Follow this sequence:

1. Clock and reset handling
2. LED blink using a timer
3. GPIO for buttons and LEDs
4. UART TX for debug output
5. UART RX for simple command input
6. PWM for LED brightness control
7. SPI master
8. I2C master
9. Register block for configuration
10. Command interface over UART

This order matters because each step introduces one new concept while reusing what you already built.

## Suggested System Architecture

```text
board_top
  -> clock/reset
  -> system_top
       -> timer
       -> gpio
       -> uart
       -> pwm
       -> spi
       -> i2c
       -> register block
```

The board layer connects physical pins.
The system layer connects reusable logic.
The peripherals do the actual work.

## Rules for Reuse

- Keep board code separate from generic logic.
- Avoid putting protocol details in `top`.
- Build modules with one responsibility.
- Add parameters when you see duplication.
- Use synchronized resets.
- Prefer clock enables over extra clocks.
- Add testbenches for each reusable block.

## What to Learn First

If you are learning FPGA development, study the project in this order:

1. combinational logic
2. registers and clocked logic
3. reset and synchronization
4. counters and timers
5. GPIO
6. finite state machines
7. UART
8. PWM
9. SPI
10. I2C
11. register maps and integration

## Next Step

When you are ready, I can add a matching starter RTL skeleton with:

- `board_top.v`
- `system_top.v`
- `reset_sync.v`
- `tick_gen.v`
- `timer.v`
- `gpio.v`

That would give you a real starting point instead of just documentation.
