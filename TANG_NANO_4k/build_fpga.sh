#!/bin/bash

set -e

if [ $# -ne 1 ]; then
    echo "Usage: $0 <module_name>"
    echo "Example: $0 counter"
    exit 1
fi

MODULE=$1

echo "Cleaning previous build..."
rm -f "${MODULE}.json" "${MODULE}_pnr.json" "${MODULE}.fs"

echo "Running Yosys..."
$OSS_DIR/bin/yosys -p "read_verilog ./testing/${MODULE}.v; synth_gowin -top ${MODULE} -json ${MODULE}.json"

echo "Running nextpnr..."
$OSS_DIR/bin/nextpnr-himbaechel \
    --device GW1NSR-LV4CQN48PC6/I5 \
    --json "${MODULE}.json" \
    --write "${MODULE}_pnr.json" \
    --vopt family=GW1NS-4 \
    --vopt cst=./testing/tangnano4k.cst

echo "Packing bitstream..."
$OSS_DIR/bin/gowin_pack \
    -d GW1NS-4 \
    -o "${MODULE}.fs" \
    "${MODULE}_pnr.json"

echo "Programming FPGA..."
sudo $OSS_DIR/bin/openFPGALoader \
    -b tangnano4k \
    "${MODULE}.fs"

echo "Done."