#----------------------------------------------------
# FPGA Build Flow Makefile (Tang Nano 4K + OSS CAD Suite)
#
# Usage:
#   make check
#   make simulation MODULE=counter
#   make showwave  MODULE=counter
#   make synthesis MODULE=counter
#   make implementation MODULE=counter
#   make bitstream MODULE=counter
#   make program MODULE=counter
#   make clean
#----------------------------------------------------

# Top module name (can be overridden)
# Example:
#   make MODULE=clock_divisor
MODULE ?= clock_divisor

#----------------------------------------------------
# OSS CAD Suite
#----------------------------------------------------
OSS_DIR := $(HOME)/oss-cad-suite

#----------------------------------------------------
# Target FPGA
#----------------------------------------------------
DEVICE      := GW1NSR-LV4CQN48PC6/I5
FAMILY      := GW1NS-4
BOARD       := tangnano4k

#----------------------------------------------------
# FPGA Tools
#----------------------------------------------------
YOSYS       := $(OSS_DIR)/bin/yosys
NEXTPNR     := $(OSS_DIR)/bin/nextpnr-himbaechel
PACKER      := $(OSS_DIR)/bin/gowin_pack
PROGRAMMER  := $(OSS_DIR)/bin/openFPGALoader

#----------------------------------------------------
# Simulation Tools
#----------------------------------------------------
IVERILOG    := iverilog
VVP         := vvp
GTKWAVE     := gtkwave

#----------------------------------------------------
# Project Directories
#----------------------------------------------------
SRC_DIR     := src
CST_DIR     := constraints

SIM_DIR     := sim
IMPL_DIR    := impl
RUN_DIR     := run

#----------------------------------------------------
# Source Files
#----------------------------------------------------
SRC          := $(SRC_DIR)/$(MODULE).v
TB           := $(SRC_DIR)/$(MODULE)_tb.v
CST          := $(CST_DIR)/tangnano4k.cst

#----------------------------------------------------
# Generated Files
#----------------------------------------------------
SIM_EXE      := $(SIM_DIR)/$(MODULE).out
VCD          := $(SIM_DIR)/$(MODULE).vcd

JSON         := $(IMPL_DIR)/$(MODULE).json
PNR_JSON     := $(IMPL_DIR)/$(MODULE)_pnr.json

BITSTREAM    := $(RUN_DIR)/$(MODULE).fs

#----------------------------------------------------
# Targets
#----------------------------------------------------
.PHONY: all \
	check \
	simulation \
	showwave \
	synthesis \
	implementation \
	bitstream \
	program \
	clean

# Default target
all: bitstream

#----------------------------------------------------
# Create output directories
#----------------------------------------------------
$(SIM_DIR):
	mkdir -p $@

$(IMPL_DIR):
	mkdir -p $@

$(RUN_DIR):
	mkdir -p $@

#----------------------------------------------------
# Check Installation
#----------------------------------------------------
check:
	@echo "========================================="
	@echo " FPGA Build Environment"
	@echo "========================================="
	@echo "MODULE      : $(MODULE)"
	@echo "OSS_DIR     : $(OSS_DIR)"
	@echo ""
	@echo "---------- FPGA Tools ----------"
	@$(YOSYS) --version
	@$(NEXTPNR) --version
	#@$(PACKER) --version
	@$(PROGRAMMER) --version
	@echo ""
	@echo "------- Simulation Tools -------"
	@$(IVERILOG) -V
	@$(VVP) -V
	@$(GTKWAVE) --version
	@echo "========================================="

#----------------------------------------------------
# Simulation
#----------------------------------------------------
simulation: $(SIM_EXE)
	$(VVP) $(SIM_EXE)

$(SIM_EXE): $(SRC) $(TB) | $(SIM_DIR)
	$(IVERILOG) -g2012 -o $@ $^

#----------------------------------------------------
# View Waveform
#----------------------------------------------------
showwave: simulation
	$(GTKWAVE) $(VCD)

#----------------------------------------------------
# Synthesis (Generate JSON Netlist)
#----------------------------------------------------
synthesis: $(JSON)

$(JSON): $(SRC) | $(IMPL_DIR)
	$(YOSYS) -p "read_verilog $<; synth_gowin -top $(MODULE) -json $@"

#----------------------------------------------------
# View Synthesized Netlist (Gate-Level Schematic)
#----------------------------------------------------
netlist: synthesis
	$(YOSYS) -p "read_json $(JSON); show -format svg -prefix $(IMPL_DIR)/$(MODULE)_netlist"

#----------------------------------------------------
# Implementation (Place & Route)
#----------------------------------------------------
implementation: $(PNR_JSON)

$(PNR_JSON): $(JSON) | $(IMPL_DIR)
	$(NEXTPNR) \
		--device $(DEVICE) \
		--json $< \
		--write $@ \
		--vopt family=$(FAMILY) \
		--vopt cst=$(CST)

#----------------------------------------------------
# Bitstream Generation
#----------------------------------------------------
bitstream: $(BITSTREAM)

$(BITSTREAM): $(PNR_JSON) | $(RUN_DIR)
	$(PACKER) \
		-d $(FAMILY) \
		-o $@ \
		$<

#----------------------------------------------------
# Program FPGA
#----------------------------------------------------
program: bitstream
	sudo $(PROGRAMMER) -b $(BOARD) $(BITSTREAM)

#----------------------------------------------------
# Clean Generated Files
#----------------------------------------------------
clean:
	rm -rf $(SIM_DIR) $(IMPL_DIR) $(RUN_DIR)
