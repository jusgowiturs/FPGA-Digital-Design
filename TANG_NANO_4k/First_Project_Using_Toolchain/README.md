# Building and Programming a Tang Nano 4K FPGA Project

This guide explains the complete FPGA build flow using the **OSS CAD Suite** toolchain:

1. **Synthesis** – Convert Verilog RTL into an FPGA netlist using Yosys.
2. **Place and Route (PnR)** – Map the design into FPGA resources using nextpnr.
3. **Bitstream Generation** – Generate the Gowin flash stream (`.fs`) file.
4. **Programming** – Load the generated bitstream into the Tang Nano 4K FPGA.

---

## Prerequisites

Install or download the [OSS CAD Suite](https://github.com/YosysHQ/oss-cad-suite-build).

Set the `OSS_DIR` environment variable to the OSS CAD Suite installation directory.

Example:

```bash
export OSS_DIR=OSS_CAD_Suite/oss-cad-suite
```

If OSS CAD Suite is installed in another location, update the path accordingly.

---

## Verify the Installation

After setting the `OSS_DIR` environment variable, verify that the required FPGA tools are available.

### Check Yosys

Yosys performs RTL synthesis and generates the FPGA netlist.

```bash
$OSS_DIR/bin/yosys -V
```

Example output:

```text
Yosys 0.xx+xxx (git sha1 ...)
```

---

### Check nextpnr

nextpnr performs FPGA placement and routing based on the target device and constraints.

```bash
$OSS_DIR/bin/nextpnr-himbaechel -V
```

Example output:

```text
nextpnr-himbaechel version ...
```

---

### Check openFPGALoader

openFPGALoader transfers the generated bitstream to the FPGA board.

```bash
"$OSS_DIR/bin/openFPGALoader" --version
```

Example output:

```text
openFPGALoader v0.x.x
```

If these commands execute successfully, the OSS CAD Suite environment is ready.

---

# Project Directory Structure

```text
.
├── README.md
├── build_fpga.sh
└── testing
    ├── counter.v
    └── tangnano4k.cst
```

### Project Files

- `counter.v` – Verilog RTL design source.
- `tangnano4k.cst` – Pin and clock constraint file for Tang Nano 4K.
- `build_fpga.sh` – Automation script for synthesis, PnR, bitstream generation, and programming.

---

# FPGA Build Flow

## 1. RTL Synthesis (Yosys)

Yosys converts the Verilog RTL design into a synthesized FPGA netlist.

```bash
$OSS_DIR/bin/yosys -p "read_verilog ./testing/counter.v; synth_gowin -top counter -json counter.json"
```

Generated file:

```text
counter.json
```

---

## 2. Place and Route (nextpnr)

nextpnr maps the synthesized design to physical FPGA resources such as LUTs, flip-flops, and routing connections.

```bash
$OSS_DIR/bin/nextpnr-himbaechel \
    --device GW1NSR-LV4CQN48PC6/I5 \
    --json counter.json \
    --write counter_pnr.json \
    --vopt family=GW1NS-4 \
    --vopt cst=./testing/tangnano4k.cst
```

Generated file:

```text
counter_pnr.json
```

---

## 3. Generate Gowin Bitstream

`gowin_pack` converts the routed design into a Gowin FPGA flash stream (`.fs`) file.

```bash
$OSS_DIR/bin/gowin_pack \
    -d GW1NS-4 \
    -o counter.fs \
    counter_pnr.json
```

Generated file:

```text
counter.fs
```

---

## 4. Program the Tang Nano 4K FPGA

Use openFPGALoader to program the FPGA with the generated flash stream.

```bash
sudo $OSS_DIR/bin/openFPGALoader \
    -b tangnano4k \
    counter.fs
```

---

# Automated Build

The `build_fpga.sh` script automates the complete FPGA build process.

Make the script executable:

```bash
chmod +x build_fpga.sh
```

Run the build:

```bash
./build_fpga.sh counter
```

The script performs:

1. Removes previously generated build files.
2. Runs Verilog synthesis using Yosys.
3. Performs place and route using nextpnr.
4. Generates the `.fs` bitstream using gowin_pack.
5. Programs the Tang Nano 4K FPGA using openFPGALoader.

> **Note:** The argument (`counter`) should match the Verilog source filename (`counter.v`) and the top-level module name (`module counter`).