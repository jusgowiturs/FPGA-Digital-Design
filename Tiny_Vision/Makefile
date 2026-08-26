CHIP = up5k
PKG = sg48

all: top.bin

top.json: top.v
	yosys -p "synth_ice40 -top top -json top.json" top.v

top.asc: top.json pins.pcf
	nextpnr-ice40 --$(CHIP) --package $(PKG) --json top.json --pcf pins.pcf --asc top.asc

top.bin: top.asc
	icepack top.asc top.bin

flash: top.bin
	iceprog top.bin

clean:
	rm -f top.json top.asc top.bin

.PHONY: all flash clean

