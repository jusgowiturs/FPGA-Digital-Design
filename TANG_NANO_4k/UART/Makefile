#----------------------------------------------------
# FPGA Build Flow Makefile (Tang Nano 4K + OSS CAD Suite)
#----------------------------------------------------

# Default module (override using: make MODULE=uart_tx simulation)
MODULE ?= top

#----------------------------------------------------
# OSS CAD Suite
#----------------------------------------------------
OSS_DIR := $(HOME)/oss-cad-suite

#----------------------------------------------------
# Target FPGA
#----------------------------------------------------
DEVICE := GW1NSR-LV4CQN48PC6/I5
FAMILY := GW1NS-4
BOARD  := tangnano4k

#----------------------------------------------------
# Tools
#----------------------------------------------------
YOSYS      := $(OSS_DIR)/bin/yosys
NEXTPNR    := $(OSS_DIR)/bin/nextpnr-himbaechel
PACKER     := $(OSS_DIR)/bin/gowin_pack
PROGRAMMER := $(OSS_DIR)/bin/openFPGALoader

IVERILOG := iverilog
VVP       := vvp
GTKWAVE   := gtkwave

#----------------------------------------------------
# Directories
#----------------------------------------------------
SRC_DIR  := src
SIM_DIR  := sim
CST_DIR  := constraints
IMPL_DIR := impl
RUN_DIR  := run

#----------------------------------------------------
# Files
#----------------------------------------------------
#SRC := $(SRC_DIR)/$(MODULE).v
SRC := $(wildcard $(SRC_DIR)/*.v)
TB  := $(SIM_DIR)/$(MODULE)_tb.sv
CST := $(CST_DIR)/tangnano4k.cst

SIM_EXE  := $(SIM_DIR)/$(MODULE).out
VCD      := $(SIM_DIR)/$(MODULE).vcd
JSON     := $(IMPL_DIR)/$(MODULE).json
PNR_JSON := $(IMPL_DIR)/$(MODULE)_pnr.json
BIT      := $(RUN_DIR)/$(MODULE).fs

#----------------------------------------------------
# Phony Targets
#----------------------------------------------------
.PHONY: all check simulation showwave synthesis \
        implementation bitstream program clean

all: bitstream

#----------------------------------------------------
# Create directories
#----------------------------------------------------
$(SIM_DIR) $(IMPL_DIR) $(RUN_DIR):
	mkdir -p $@

#----------------------------------------------------
# Check Tool Installation
#----------------------------------------------------
check:
	@echo "========================================="
	@echo "Module      : $(MODULE)"
	@echo "OSS_DIR     : $(OSS_DIR)"
	@echo "========================================="
	@$(YOSYS) --version
	@$(NEXTPNR) --version
	@$(PROGRAMMER) --version
	@$(IVERILOG) -V
	@$(VVP) -V
	@$(GTKWAVE) --version

#----------------------------------------------------
# Simulation
#----------------------------------------------------
simulation: $(SIM_EXE)
	$(VVP) $<

$(SIM_EXE): $(SRC) $(TB) | $(SIM_DIR)
	$(IVERILOG) -g2012 -o $@ $^

#----------------------------------------------------
# View Waveform
#----------------------------------------------------
showwave: simulation
	$(GTKWAVE) $(VCD)

#----------------------------------------------------
# Synthesis
#----------------------------------------------------
synthesis: $(JSON)

$(JSON): $(SRC) | $(IMPL_DIR)
	$(YOSYS) -p "read_verilog $<; synth_gowin -top $(MODULE) -json $@"

#----------------------------------------------------
# Netlist Viewer
#----------------------------------------------------
netlist: synthesis
	$(YOSYS) -p "read_json $(JSON); show -format svg -prefix $(IMPL_DIR)/$(MODULE)_netlist"

#----------------------------------------------------
# Place and Route
#----------------------------------------------------
implementation: $(PNR_JSON)

$(PNR_JSON): $(JSON)
	$(NEXTPNR) \
		--device $(DEVICE) \
		--json $< \
		--write $@ \
		--vopt family=$(FAMILY) \
		--vopt cst=$(CST)

#----------------------------------------------------
# Bitstream
#----------------------------------------------------
bitstream: $(BIT)

$(BIT): $(PNR_JSON) | $(RUN_DIR)
	$(PACKER) -d $(FAMILY) -o $@ $<

#----------------------------------------------------
# Program FPGA
#----------------------------------------------------
program: bitstream
	sudo $(PROGRAMMER) -b $(BOARD) $(BIT)

#----------------------------------------------------
# Clean
#----------------------------------------------------
clean:
	rm -f $(SIM_DIR)/*.out
	rm -rf $(IMPL_DIR)
	rm -rf $(RUN_DIR)