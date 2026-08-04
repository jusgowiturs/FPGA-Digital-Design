#----------------------------------------------------
# Tang Nano 4K FPGA Build Flow Makefile
#----------------------------------------------------
#
# Usage:
#   make check
#   make sim MODULE=counter
#   make showwave MODULE=counter
#   make synthesis MODULE=counter
#   make implementation MODULE=counter
#   make bitstream MODULE=counter
#   make program MODULE=counter
#   make clean
#
#----------------------------------------------------

# Top module name
MODULE ?= counter

#----------------------------------------------------
# OSS CAD Suite Location
#----------------------------------------------------
# Uses environment variable if defined.
# Otherwise defaults to $HOME/oss-cad-suite

OSS_DIR ?= $(HOME)/oss-cad-suite

#----------------------------------------------------
# FPGA Device
#----------------------------------------------------
DEVICE := GW1NSR-LV4CQN48PC6/I5
FAMILY := GW1NS-4
BOARD  := tangnano4k

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
IVERILOG := iverilog
VVP       := vvp
GTKWAVE   := gtkwave

#----------------------------------------------------
# Project Directories
#----------------------------------------------------
SRC_DIR         := src
CONSTRAINT_DIR  := constraints
SIM_DIR         := sim
SYNTH_DIR       := synthesis
IMPL_DIR        := impl
RUN_DIR         := run

#----------------------------------------------------
# Source Files
#----------------------------------------------------
SRC := $(SRC_DIR)/$(MODULE).v
TB  := $(SRC_DIR)/$(MODULE)_tb.v
CST := $(CONSTRAINT_DIR)/tangnano4k.cst

#----------------------------------------------------
# Generated Files
#----------------------------------------------------
SIM_EXE := $(SIM_DIR)/$(MODULE).out
VCD     := $(SIM_DIR)/$(MODULE).vcd

JSON     := $(SYNTH_DIR)/$(MODULE).json
PNR_JSON := $(IMPL_DIR)/$(MODULE)_pnr.json

BITFILE := $(RUN_DIR)/$(MODULE).fs

#----------------------------------------------------
# Targets
#----------------------------------------------------
.PHONY: \
	all \
	check \
	sim \
	showwave \
	synthesis \
	implementation \
	bitstream \
	program \
	clean

all: bitstream

#----------------------------------------------------
# Create directories if required
#----------------------------------------------------
$(SIM_DIR):
	mkdir -p $@

$(SYNTH_DIR):
	mkdir -p $@

$(IMPL_DIR):
	mkdir -p $@

$(RUN_DIR):
	mkdir -p $@

#----------------------------------------------------
# Check Installation
#----------------------------------------------------
check:
	@echo "======================================="
	@echo " Tang Nano 4K FPGA Build Environment"
	@echo "======================================="
	@echo "MODULE      : $(MODULE)"
	@echo "OSS_DIR     : $(OSS_DIR)"
	@echo ""
	@echo "Yosys               :"
	@$(YOSYS) --version
	@echo ""
	@echo "nextpnr-himbaechel  :"
	@$(NEXTPNR) --version
	@echo ""
	@echo "gowin_pack          :"
	@$(PACKER) --help | head -1
	@echo ""
	@echo "openFPGALoader      :"
	@$(PROGRAMMER) --version
	@echo ""
	@echo "Icarus Verilog      :"
	@$(IVERILOG) -V | head -1
	@echo ""
	@echo "GTKWave             :"
	@$(GTKWAVE) --version

#----------------------------------------------------
# Simulation
#----------------------------------------------------
sim: $(SIM_EXE)
	$(VVP) $(SIM_EXE)

$(SIM_EXE): $(SRC) $(TB) | $(SIM_DIR)
	$(IVERILOG) -g2012 \
	-o $(SIM_EXE) \
	$(SRC) \
	$(TB)

#----------------------------------------------------
# Show Waveform
#----------------------------------------------------
showwave: sim
	$(GTKWAVE) $(VCD)

#----------------------------------------------------
# RTL Synthesis
#----------------------------------------------------
synthesis: $(JSON)

$(JSON): $(SRC) | $(SYNTH_DIR)
	$(YOSYS) \
	-p "read_verilog $(SRC); synth_gowin -top $(MODULE) -json $(JSON)"

#----------------------------------------------------
# Place and Route
#----------------------------------------------------
implementation: $(PNR_JSON)

$(PNR_JSON): $(JSON) | $(IMPL_DIR)
	$(NEXTPNR) \
		--device $(DEVICE) \
		--json $(JSON) \
		--write $(PNR_JSON) \
		--vopt family=$(FAMILY) \
		--vopt cst=$(CST)

#----------------------------------------------------
# Bitstream Generation
#----------------------------------------------------
bitstream: $(BITFILE)

$(BITFILE): $(PNR_JSON) | $(RUN_DIR)
	$(PACKER) \
		-d $(FAMILY) \
		-o $(BITFILE) \
		$(PNR_JSON)

#----------------------------------------------------
# Program FPGA
#----------------------------------------------------
program: bitstream
	sudo $(PROGRAMMER) \
		-b $(BOARD) \
		$(BITFILE)

#----------------------------------------------------
# Clean
#----------------------------------------------------
clean:
	rm -f $(SIM_DIR)/*
	rm -f $(SYNTH_DIR)/*
	rm -f $(IMPL_DIR)/*
	rm -f $(RUN_DIR)/*
