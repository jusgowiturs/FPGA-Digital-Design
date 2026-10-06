# AXI RGB Channelizer — Vivado Flow

**Device:** `xc7z020clg400-3`

## 1. Create Project

Create Vivado RTL project:

```text
Project: axi_rgb_channelizer
Device: xc7z020clg400-3
```

Add RTL:

```text
axi_rgb_channelizer.v
rgb2gray.v
```

---

## 2. Create Block Design

Add:

- ZYNQ7 Processing System
- AXI DMA
- `axi_rgb_channelizer`
- 2 × AXI SmartConnect
- Processor System Reset
- `xlconstant`

---

## 3. Configure Zynq PS

Enable:

```text
FCLK_CLK0 = 100 MHz
M_AXI_GP0
S_AXI_HP0
S_AXI_HP2
```

---

## 4. Configure AXI DMA

Use:

```text
Simple Mode
Scatter Gather = OFF
MM2S = ON
S2MM = ON
Buffer Length Width = 26
Data Width = 32
```

---

## 5. Connect Stream Path

```text
DMA MM2S
    ↓
axi_rgb_channelizer
    ↓
DMA S2MM
```

Inside `axi_rgb_channelizer`:

```text
AXI-Stream
    ↓
rgb2gray
    ↓
AXI-Stream
```

---

## 6. Memory Paths

```text
DMA MM2S → SmartConnect → PS HP0
DMA S2MM → SmartConnect → PS HP2
```

---

## 7. AXI-Lite Control

```text
PS M_AXI_GP0
      ↓
SmartConnect
      ↓
DMA S_AXI_LITE
```

---

## 8. Clock / Reset

Use:

```text
PS FCLK_CLK0 → DMA
              → axi_rgb_channelizer
              → SmartConnects
```

Add **Processor System Reset** and connect the generated `peripheral_aresetn` to the required AXI/RTL resets.

Tie:

```text
axi_rgb_channelizer/en = 1
```

using `xlconstant`.

---

## 9. Address Assignment

Open **Address Editor** → **Auto Assign Address**.

---

## 10. Validate and Generate

```text
Validate Design
→ Generate Output Products
→ Create HDL Wrapper
→ Set Wrapper as Top
→ Run Synthesis
→ Run Implementation
→ Generate Bitstream
```

---

## Final Data Path

```text
DDR
 ↓
HP0
 ↓
SmartConnect
 ↓
DMA MM2S
 ↓
axi_rgb_channelizer
 ↓
rgb2gray
 ↓
DMA S2MM
 ↓
SmartConnect
 ↓
HP2
 ↓
DDR
```

**Top module:** `design_1_wrapper`

**RTL files:**

```text
axi_rgb_channelizer.v
rgb2gray.v
```
