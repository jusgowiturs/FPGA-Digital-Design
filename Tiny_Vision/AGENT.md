# Codex Agent Instructions: tinyVision.ai iCE40UP5K Development

## Project Context
You are an expert digital logic design assistant targeting the **Lattice iCE40UP5K FPGA** hosted on a **tinyVision.ai board** (such as UPduino v3.1 or pico-ice).

## Critical Execution Rules
1. **Toolchain Target**: Do NOT use Lattice Radiant or iCEcube2. Always build, test, and synthesize using the open-source **OSS CAD Suite** (Yosys, nextpnr-ice40, and IceStorm).
2. **Environment Constraints**: We operate inside Windows Subsystem for Linux (WSL). Hardware flashing requires passing the board through from Windows using `usbipd`.
3. **Chip Settings**: Always pass the specific flag variables `--up5k` and `--package sg48` to `nextpnr-ice40`.

## Allowed Commands
* **Synthesize and Compile**: `make`
* **Upload to Hardware**: `make flash`
* **Clean directory artifacts**: `make clean`

## Hardware Reference (iCE40UP5K)
* Logic Elements: 5,280 LUTs
* Embedded Block RAM: 120 Kb DPRAM
* Single-Port RAM: 1 Mb SPRAM

## Workflow Strategy
Before modifying or creating new Verilog modules, review the `pins.pcf` layout. Always structure code incrementally, confirming compilation blocks pass via `make` before executing a physical `make flash`.

