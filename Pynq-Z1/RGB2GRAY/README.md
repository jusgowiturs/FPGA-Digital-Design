# AXI PE + AXI DMA Zynq Vivado Project

**Device:** `xc7z020clg400-3`

## Objective

Create a Vivado project containing:

- Zynq-7000 Processing System
- `axis_pe` custom RTL module
- AXI DMA in **Simple Mode**
- DMA buffer length width = **26 bits**
- FCLK0
- HP0 and HP2 for DDR/memory access
- GP0 for AXI-Lite control
- Two SmartConnects for the memory-side paths
- AXI-Stream path:

```text
AXI DMA MM2S → axis_pe → AXI DMA S2MM
```

- `en` tied permanently to `1`
- Proper clocks and resets
- Address assignment
- Design validation
- HDL wrapper
- Wrapper set as top module
- Bitstream generation

---

# 1. Create the Vivado Project

Open Vivado and select:

```text
Create Project
```

Use:

```text
Project Name: axis_pe_dma
Project Type: RTL Project
```

Select the target device:

```text
xc7z020clg400-3
```

Finish project creation.

---

# 2. Add the axis_pe RTL

Add the custom RTL source:

```text
axis_pe.sv
```

or:

```text
axis_pe.v
```

The module should have an AXI-Stream input and output, together with clock, reset, and enable.

Example interface:

```verilog
module axis_pe (
    input  wire        aclk,
    input  wire        aresetn,
    input  wire        en,

    input  wire [31:0] s_axis_tdata,
    input  wire        s_axis_tvalid,
    output wire        s_axis_tready,

    output wire [31:0] m_axis_tdata,
    output wire        m_axis_tvalid,
    input  wire        m_axis_tready
);

    // Processing logic

endmodule
```

> Adjust the interface according to the actual `axis_pe` RTL.

---

# 3. Create the Block Design

In Vivado:

```text
Flow Navigator
→ IP Integrator
→ Create Block Design
```

Use:

```text
Block Design Name: design_1
```

Click **OK**.

---

# 4. Add the Zynq Processing System

Click:

```text
Add IP
```

Search for:

```text
ZYNQ7 Processing System
```

Add it to the block design.

Run:

```text
Run Block Automation
```

Accept the default board/processing-system configuration initially.

---

# 5. Configure the Zynq PS

Double-click:

```text
ZYNQ7 Processing System
```

Configure the following interfaces.

## 5.1 Enable FCLK0

Enable:

```text
FCLK_CLK0
```

Set:

```text
FCLK_CLK0 Frequency = 100 MHz
```

The exact frequency can be changed if the design requires another clock frequency.

---

## 5.2 Enable M_AXI_GP0

Enable:

```text
M_AXI_GP0
```

This provides the PS master interface for accessing the AXI-Lite control registers of the AXI DMA.

The intended control path is:

```text
PS M_AXI_GP0
       │
       ▼
AXI SmartConnect
       │
       ▼
DMA S_AXI_LITE
```

---

## 5.3 Enable HP0

Enable:

```text
S_AXI_HP0
```

This provides a high-performance PS-to-DDR interface for one DMA memory channel.

---

## 5.4 Enable HP2

Enable:

```text
S_AXI_HP2
```

This provides the second high-performance memory-side interface.

The intended memory paths are:

```text
DMA MM2S → SmartConnect → HP0 → DDR
```

and:

```text
DMA S2MM → SmartConnect → HP2 → DDR
```

Click **OK** after configuring the PS.

---

# 6. Add the AXI DMA

Click:

```text
Add IP
```

Search for:

```text
AXI Direct Memory Access
```

Add:

```text
AXI DMA
```

Double-click the AXI DMA and configure it.

---

# 7. Configure AXI DMA

The DMA should operate in **Simple Mode**.

Disable:

```text
Scatter Gather Engine
```

The important configuration is:

```text
Simple DMA Mode = Enabled
```

The design will use:

```text
MM2S
```

for memory-to-stream transfers and:

```text
S2MM
```

for stream-to-memory transfers.

---

# 8. Configure DMA Data Width

For a 32-bit stream, configure:

```text
MM2S Data Width = 32
S2MM Data Width = 32
```

This gives:

```text
DDR
 ↓
32-bit AXI memory interface
 ↓
AXI DMA
 ↓
32-bit AXI-Stream
 ↓
axis_pe
```

and the reverse direction for S2MM.

Use the actual width required by `axis_pe` if it is different from 32 bits.

---

# 9. Configure DMA Buffer Length

Set:

```text
Width of Buffer Length Register = 26
```

This means the DMA length field is 26 bits.

The theoretical maximum representable transfer length is:

```text
2^26 bytes
```

which is:

```text
67,108,864 bytes
```

approximately:

```text
64 MiB
```

The exact usable transfer size can also depend on the DMA configuration and other system limitations.

---

# 10. Add the axis_pe Module

In the block design:

```text
Add Module
```

Select:

```text
axis_pe
```

Add it to the block diagram.

The block should expose:

```text
aclk
aresetn
en

S_AXIS
M_AXIS
```

or the corresponding ports from the actual RTL.

---

# 11. Add the Two Memory-Side SmartConnects

Add two instances of:

```text
AXI SmartConnect
```

For clarity, rename them:

```text
smartconnect_mm2s
smartconnect_s2mm
```

Their purpose is to connect the DMA memory-mapped interfaces to the two Zynq HP ports.

---

# 12. MM2S Memory Path

Connect:

```text
AXI DMA
M_AXI_MM2S
```

to:

```text
smartconnect_mm2s
```

Then connect:

```text
smartconnect_mm2s
```

to:

```text
Zynq PS
S_AXI_HP0
```

The resulting path is:

```text
DDR
 ↑
S_AXI_HP0
 ↑
smartconnect_mm2s
 ↑
M_AXI_MM2S
 ↑
AXI DMA
```

The direction from the software perspective is:

```text
DDR → DMA → AXI-Stream
```

---

# 13. S2MM Memory Path

Connect:

```text
AXI DMA
M_AXI_S2MM
```

to:

```text
smartconnect_s2mm
```

Then connect:

```text
smartconnect_s2mm
```

to:

```text
Zynq PS
S_AXI_HP2
```

The resulting path is:

```text
DDR
 ↓
S_AXI_HP2
 ↓
smartconnect_s2mm
 ↓
M_AXI_S2MM
 ↓
AXI DMA
```

The direction from the processing perspective is:

```text
AXI-Stream → DMA → DDR
```

---

# 14. Connect the AXI-Stream Path

The main processing path should be:

```text
DMA MM2S
     │
     │ AXI-Stream
     ▼
  axis_pe
     │
     │ AXI-Stream
     ▼
DMA S2MM
```

Connect:

```text
AXI DMA
M_AXIS_MM2S
```

to:

```text
axis_pe
S_AXIS
```

Then connect:

```text
axis_pe
M_AXIS
```

to:

```text
AXI DMA
S_AXIS_S2MM
```

---

# 15. AXI-Stream Handshake

The AXI-Stream path uses:

```text
TVALID
TREADY
TDATA
```

The normal data transfer condition is:

```text
TVALID && TREADY
```

The DMA and `axis_pe` should therefore correctly propagate the AXI-Stream handshake.

The intended flow is:

```text
MM2S DMA
   │
   │ TVALID
   ▼
axis_pe
   │
   │ TVALID
   ▼
S2MM DMA
```

with `TREADY` flowing in the reverse direction.

---

# 16. Add the AXI-Lite Control Path

The PS must be able to access the AXI DMA control/status registers.

The intended path is:

```text
Zynq PS
M_AXI_GP0
     │
     ▼
AXI SmartConnect
     │
     ▼
AXI DMA
S_AXI_LITE
```

Add another:

```text
AXI SmartConnect
```

if required by the block design.

Rename it:

```text
smartconnect_control
```

Connect:

```text
Zynq PS
M_AXI_GP0
```

to:

```text
smartconnect_control
```

and:

```text
smartconnect_control
```

to:

```text
AXI DMA
S_AXI_LITE
```

---

# 17. Tie `en` to Constant 1

Add:

```text
xlconstant
```

Configure it as:

```text
Const Width = 1
Const Value = 1
```

Connect:

```text
xlconstant/dout
```

to:

```text
axis_pe/en
```

Therefore:

```text
axis_pe/en = 1
```

permanently.

The processing element is consequently enabled whenever the clock/reset conditions allow it to operate.

---

# 18. Clock Connections

Use:

```text
Zynq PS
FCLK_CLK0
```

as the primary AXI clock.

The clock should drive:

```text
AXI DMA
axis_pe
smartconnect_mm2s
smartconnect_s2mm
smartconnect_control
Processor System Reset
```

The basic clock relationship is:

```text
                 ┌───────────────┐
                 │    Zynq PS    │
                 │               │
                 │   FCLK_CLK0   │
                 └───────┬───────┘
                         │
          ┌──────────────┼──────────────┐
          │              │              │
          ▼              ▼              ▼
        DMA           axis_pe       SmartConnects
```

Make sure all connected AXI interfaces use compatible clock domains.

---

# 19. Add Processor System Reset

Add:

```text
Processor System Reset
```

Connect:

```text
FCLK_CLK0
```

to:

```text
Processor System Reset
slowest_sync_clk
```

Connect the Zynq reset signal appropriately to:

```text
ext_reset_in
```

Use:

```text
peripheral_aresetn
```

for the AXI peripherals and custom RTL where an active-low reset is required.

The intended reset relationship is:

```text
Zynq PS
   │
   ├── FCLK_CLK0
   │
   └── FCLK_RESET0_N
            │
            ▼
    Processor System Reset
            │
            ▼
       peripheral_aresetn
            │
      ┌─────┼─────────┐
      ▼     ▼         ▼
     DMA  axis_pe  SmartConnect
```

---

# 20. Connect axis_pe Reset

If the RTL uses:

```text
aresetn
```

connect:

```text
Processor System Reset
peripheral_aresetn
```

to:

```text
axis_pe
aresetn
```

Thus:

```text
axis_pe
```

uses the same reset domain as the DMA/AXI infrastructure.

---

# 21. Connect DMA Clock and Reset

Connect the appropriate clock:

```text
FCLK_CLK0
```

to the DMA AXI and stream clock inputs.

Connect the appropriate active-low reset:

```text
peripheral_aresetn
```

to the DMA reset input.

Depending on the Vivado IP configuration, the DMA may expose separate clock/reset inputs for:

```text
S_AXI_LITE
M_AXI_MM2S
M_AXI_S2MM
M_AXIS_MM2S
S_AXIS_S2MM
```

Keep these in the same clock domain if the design is intended to operate entirely from FCLK0.

---

# 22. Configure SmartConnect Clocks

Both memory-side SmartConnect instances should use the same clock domain:

```text
FCLK_CLK0
```

and corresponding reset:

```text
peripheral_aresetn
```

Do the same for the AXI-Lite SmartConnect.

---

# 23. Check the Complete Data Path

The final stream/data movement should be:

```text
                         ZYNQ PS
                    ┌──────────────┐
                    │              │
                    │     DDR      │
                    │              │
                    └──────┬───────┘
                           │
                ┌──────────┴──────────┐
                │                     │
               HP0                   HP2
                │                     │
                ▼                     ▲
       ┌────────────────┐    ┌────────────────┐
       │ SmartConnect   │    │ SmartConnect   │
       │    MM2S        │    │     S2MM       │
       └───────┬────────┘    └────────▲───────┘
               │                      │
               ▼                      │
        ┌──────────────────────────────────┐
        │             AXI DMA              │
        │                                  │
        │ MM2S                 S2MM         │
        └───────┬──────────────▲───────────┘
                │ AXI-Stream    │
                ▼               │
           ┌────────────────────────┐
           │        axis_pe          │
           │                        │
           │  S_AXIS → Processing   │
           │  M_AXIS → Output       │
           └────────────────────────┘
```

---

# 24. Check the AXI-Lite Control Path

The software-control path should be:

```text
Zynq PS
    │
    │ M_AXI_GP0
    ▼
AXI-Lite SmartConnect
    │
    ▼
AXI DMA
S_AXI_LITE
```

This allows the ARM processor to configure the DMA registers.

---

# 25. Address Assignment

Open:

```text
Address Editor
```

Select:

```text
Auto Assign Address
```

or assign the addresses manually.

The AXI DMA control registers should receive an address in the PS GP0 address space.

For example:

```text
AXI DMA
S_AXI_LITE
→ 0x40400000
```

The exact address selected by Vivado may differ.

Do **not** assume the example address is mandatory; use the address shown in the generated Address Editor.

---

# 26. Validate the Block Design

Select:

```text
Tools
→ Validate Design
```

or use the validation button in IP Integrator.

The design should be checked for:

- Unconnected AXI interfaces
- Unconnected clocks
- Unconnected resets
- AXI clock-domain problems
- Address conflicts
- Missing memory mappings
- Invalid AXI-Stream connections
- Incorrect DMA configuration
- Missing PS HP connections

Resolve all critical errors before proceeding.

---

# 27. Generate Output Products

After validation:

```text
Right-click design_1
→ Generate Output Products
```

Select the appropriate option, such as:

```text
Global
```

and allow Vivado to generate the IP output products.

---

# 28. Create HDL Wrapper

In the Sources window:

```text
Design Sources
    design_1.bd
```

Right-click:

```text
design_1
→ Create HDL Wrapper
```

Select:

```text
Let Vivado manage wrapper and auto-update
```

Vivado will create something similar to:

```text
design_1_wrapper.v
```

or:

```text
design_1_wrapper.vhd
```

depending on the project language.

---

# 29. Set the Wrapper as Top Module

In the Sources window locate:

```text
design_1_wrapper
```

Right-click:

```text
Set as Top
```

The hierarchy should now look like:

```text
design_1_wrapper
    └── design_1
        ├── Zynq PS
        ├── AXI DMA
        ├── axis_pe
        ├── SmartConnect
        ├── SmartConnect
        ├── SmartConnect
        ├── Processor System Reset
        └── xlconstant
```

The exact hierarchy depends on Vivado's generated wrapper.

---

# 30. Run Synthesis

Select:

```text
Flow Navigator
→ Synthesis
→ Run Synthesis
```

Wait for synthesis to complete.

Check:

```text
Open Synthesized Design
```

and inspect:

```text
Reports
→ Report Utilization
```

and:

```text
Reports
→ Report Timing Summary
```

---

# 31. Run Implementation

After synthesis:

```text
Run Implementation
```

Vivado performs:

```text
Opt Design
→ Place Design
→ Phys Opt
→ Route Design
```

Check the implementation results.

---

# 32. Generate Bitstream

After implementation:

```text
Generate Bitstream
```

The complete flow is:

```text
RTL
 ↓
Block Design
 ↓
Validate Design
 ↓
Generate Output Products
 ↓
Create HDL Wrapper
 ↓
Set Wrapper as Top
 ↓
Synthesis
 ↓
Implementation
 ↓
Bitstream
```

The generated bitstream will normally be located under the project's generated runs directory, for example:

```text
axis_pe_dma.runs/impl_1/
```

with a file similar to:

```text
design_1_wrapper.bit
```

---

# 33. Final Architecture

The completed system should conceptually be:

```text
                         ┌───────────────────────────┐
                         │       Zynq-7000 PS        │
                         │                           │
                         │  ARM                     │
                         │    │                      │
                         │    │ M_AXI_GP0            │
                         │    ▼                      │
                         │ AXI-Lite Control          │
                         │                           │
                         │ DDR                       │
                         │  ▲                    ▲  │
                         │  │                    │  │
                         │ HP0                  HP2 │
                         └──┼────────────────────┼──┘
                            │                    │
                            ▼                    ▲
                    ┌──────────────┐    ┌──────────────┐
                    │ SmartConnect │    │ SmartConnect │
                    │    MM2S      │    │     S2MM     │
                    └──────┬───────┘    └──────▲───────┘
                           │                    │
                           ▼                    │
                    ┌────────────────────────────────┐
                    │            AXI DMA             │
                    │                                │
                    │ M_AXI_MM2S        M_AXI_S2MM   │
                    │       │                ▲       │
                    │       │                │       │
                    │ M_AXIS_MM2S      S_AXIS_S2MM   │
                    └───────┼────────────────▲───────┘
                            │                │
                            ▼                │
                    ┌────────────────────────────┐
                    │          axis_pe            │
                    │                            │
                    │       AXI-Stream            │
                    │                            │
                    │  S_AXIS → Processing       │
                    │  M_AXIS → Output           │
                    │                            │
                    │  en = 1                    │
                    └────────────────────────────┘
```

---

# 34. Overall Data Flow

For an input buffer in DDR:

```text
DDR Input Buffer
      │
      ▼
PS HP0
      │
      ▼
SmartConnect MM2S
      │
      ▼
AXI DMA MM2S
      │
      │ AXI-Stream
      ▼
axis_pe
      │
      │ AXI-Stream
      ▼
AXI DMA S2MM
      │
      ▼
SmartConnect S2MM
      │
      ▼
PS HP2
      │
      ▼
DDR Output Buffer
```

The ARM processor controls the DMA through:

```text
PS M_AXI_GP0
      │
      ▼
AXI-Lite SmartConnect
      │
      ▼
AXI DMA S_AXI_LITE
```

---

# 35. Final Checklist

Before generating the bitstream, verify:

- [ ] Project device = `xc7z020clg400-3`
- [ ] `axis_pe` RTL added
- [ ] Block design created
- [ ] Zynq PS added
- [ ] `FCLK_CLK0` enabled
- [ ] `M_AXI_GP0` enabled
- [ ] `S_AXI_HP0` enabled
- [ ] `S_AXI_HP2` enabled
- [ ] AXI DMA added
- [ ] Scatter Gather disabled
- [ ] Simple DMA mode enabled
- [ ] DMA MM2S enabled
- [ ] DMA S2MM enabled
- [ ] DMA buffer length width = `26`
- [ ] DMA data width configured correctly
- [ ] `axis_pe` instantiated
- [ ] DMA MM2S → `axis_pe` S_AXIS connected
- [ ] `axis_pe` M_AXIS → DMA S2MM connected
- [ ] Two memory-side SmartConnects added
- [ ] MM2S SmartConnect → HP0
- [ ] S2MM SmartConnect → HP2
- [ ] AXI-Lite control path connected through GP0
- [ ] `xlconstant` added
- [ ] `axis_pe/en = 1`
- [ ] FCLK0 connected to required AXI clocks
- [ ] Processor System Reset added
- [ ] Resets connected
- [ ] Address assignment completed
- [ ] Validate Design completed successfully
- [ ] Output products generated
- [ ] HDL wrapper created
- [ ] Wrapper set as top
- [ ] Synthesis completed
- [ ] Implementation completed
- [ ] Bitstream generated

# 36. One-Line Design Summary

```text
Zynq PS DDR → HP0 → SmartConnect → AXI DMA MM2S → AXIS → axis_pe → AXIS → AXI DMA S2MM → SmartConnect → HP2 → DDR
                                      ↑
                                      │
                         GP0 → AXI-Lite → DMA Control
```

**Final top module:**

```text
design_1_wrapper
```

**Final output:**

```text
Bitstream (.bit)
```
