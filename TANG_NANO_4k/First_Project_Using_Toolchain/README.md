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
## 4.1  Programming FPGA from WSL

When using **WSL (Windows Subsystem for Linux)**, USB devices are not automatically available inside Linux.  
The Tang Nano 4K programmer USB interface must first be attached to WSL using `usbipd`.

#### 4.1.1. Open Windows PowerShell (Administrator)

List available USB devices:

```powershell
usbipd list
```

Example output:

```text
BUSID   VID:PID    DEVICE
1-1     0403:6010  USB Serial Converter
```

Identify the Tang Nano 4K USB device and note the `BUSID`.

---

#### 4.1.2. Bind the USB Device

Attach the USB device for WSL access:

```powershell
usbipd bind --busid <BusID>
```

Example:

```powershell
usbipd bind --busid 1-1
```

---

#### 4.1.3. Attach the Device to WSL

From PowerShell:

```powershell
usbipd attach --wsl --busid <BusID>
```

Example:

```powershell
usbipd attach --wsl --busid 1-1
```

---

#### 4.1.4. Verify USB Access in WSL

Inside the WSL terminal:

```bash
lsusb
```

The Tang Nano programmer should appear in the USB device list.

---

#### 4.1.5. Program the FPGA

Run the normal openFPGALoader command:

```bash
sudo $OSS_DIR/bin/openFPGALoader \
    -b tangnano4k \
    counter.fs
```

---

## Notes for WSL Users

- The USB device must be attached every time WSL starts.
- If programming fails, check the USB connection using:

```bash
lsusb
```

- If the device is still attached to Windows, detach it before using it in WSL:

```powershell
usbipd detach --busid <BusID>
```

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


# Next Development Steps

This project can be extended with reusable FPGA modules:

- Clock divider
- Reset synchronizer
- Timer
- GPIO
- UART
- PWM
- SPI
- I2C
- Register interface

The goal is to gradually build a reusable FPGA hardware framework.