<!-- # Step by Step Procedure


1. Step1: Create New project(RTL Project)
    - 1.1 : Select Device XC7Z020CLG400.1
2. Step2: Create Block Design under IP integrator
    -   Select ZYNQ7 Processing System PS and then RUN Block Automation

3. Step3: Create Design code(Here : [Johnson Counter](https://www.myhdl.org/docs/examples/jc2.html))
    -    Add Module into Diagram Window of Design

4. Step :  Make output line (required) as Make external 
    -    Rename port at External Port Properties
5. Step : Double Click ZYNQ7 PS-> MIO Configuration -> GPIO  Checkin required
 
6. Clock Divider : Create new Design Code [Clock Divider.vhdl](https://allaboutfpga.com/vhdl-code-for-clock-divider/)
    -    Add Module into Diagram Window of Design

7. Connection as Follows:
    -   From PS FCLK_CLK0 -> CLK(ClockDivider)
    -   From PS FCLK_RESET_N-> `reset` of Clock Divider
    - clockout from Clock Divider   to Design Source `Clock`(Here:johnson_counter)
8. Expand GPIO of PS and add/insert `Slice` into `Design Diagram`
    -   Input to the Slice from GPIO of PS 
    - Rename and number of port pins
    -   Output from the `Slice` to RTL Design Source Input signal like `goLeft`, `goRight`, `stop`

9.  Step: `AXI` port not needed, so remove to avoid errors druing Build
    -   By Re-Customizing IP(Double Click PS)
    -   Select PS_PL Configuration
    -   Checkout `M_AXI_GPIO interface`
10. Step: Validate Design
11. Step: HDL Wrapper on design source(`design_1.bd`)
    -   Ignore Warning that not all GPIO are not connected
    -   Save it and then `Set as TOP`
12. Step : Run Synthesis before configure pins

13. Step: Need to add pin constraints for LEDs
14. Step: For IO port configuration
The I/O Ports window shows the I/O signal ports defined in the design. To open the I/O Ports window, select Window > I/O Ports.


Switch FPGA Pin Configurations
D19 = BTN0
D20 = BTN1
L20 = BTN2
L19 = BTN3
M20 = SW0
M19 = SW1

LED FPGA Pin Configuration
R14 =   LD0
P14 =   LD1
N16 =   LD2
M14 =   LD3

Tri Color LED

N15 =   LD4 Red
G17 =   LD4 Green
L15 =   LD4 Blue

M15 =   LD5 Red
L14 =   LD5 Green
G14 =   LD5 Blue

-   Along with IOSTANARD as LVCMOS33


15. Step: Save and then Generate bitstream

16. Upload the following files into jupyter notebook
    -   "<filename.bit>" under <PROJECT>.runs-> impl_1->.
    - 
    <PROJECTName>\<PROJECTName>.gen\sources_1\bd\design_1\hw_handoff\*.hwh
    -   Example
    johnson_counter\johnson_counter.gen\sources_1\bd\design_1\hw_handoff

    -   Export <>*.tcl of design but <>*.hwh only suitable to import Custom Overlay
17. Step [GPIO access](https://pynq.readthedocs.io/en/latest/pynq_libraries.html#pynq-iops)
     -->

# Step-by-Step Procedure

## 1. Create a New RTL Project

1. Create a new **RTL Project** in Vivado.
2. Select the FPGA device:
`XC7Z020CLG400-1`

---

## 2. Create Block Design Using IP Integrator

1. Open **IP Integrator**.
2. Create a new **Block Design**.
3. Add **ZYNQ7 Processing System (PS)** IP.
4. Run **Block Automation** to configure the ZYNQ Processing System.

---

## 3. Add Design Source Code

1. Create the required RTL design module.

Example:

**Johnson Counter**

Reference:
[Johnson Counter](https://www.myhdl.org/docs/examples/jc2.html)

2. Add the RTL module into the Block Design diagram.

---

## 4. Make Required Output Signals External

1. Select the required output signal from the RTL design.
2. Right-click and select: Make External

3. Rename the external port using **External Port Properties**.

---

## 5. Configure GPIO in ZYNQ Processing System

1. Double-click the **ZYNQ7 Processing System** block.
2. Navigate to: `MIO Configuration → GPIO`

3. Enable the required GPIO signals.

---

## 6. Add Clock Divider Module

1. Create a clock divider RTL module.

Reference:

[Clock Divider.vhdl](https://allaboutfpga.com/vhdl-code-for-clock-divider/)

2. Add the Clock Divider module into the Block Design diagram.

---

## 7. Connect Clock and Reset Signals

Make the following connections:

| Source                        | Destination                                   |
| ----------------------------- | --------------------------------------------- |
| `FCLK_CLK0` from PS           | `CLK` of Clock Divider                        |
| `FCLK_RESET_N` from PS        | `reset` of Clock Divider                      |
| `clockout` from Clock Divider | `Clock` input of RTL design (Johnson Counter) |

---

## 8. Add Slice IP for GPIO Signals

1. Expand the GPIO interface of the ZYNQ PS.
2. Insert a **Slice** IP into the Block Design.

Connections:

- GPIO output from PS → Slice input.
- Configure Slice width and bit positions.
- Rename output ports appropriately.

Connect Slice outputs to RTL design inputs:
`Slice output → goLeft`
`Slice output → goRight`
`Slice output → stop`

---

## 9. Remove Unused AXI Interface

The AXI interface is not required for this design. Disable it to avoid build errors.

Steps:

1. Double-click the ZYNQ Processing System block.
2. Navigate to:
`PS-PL Configuration`

3. Disable:
`M_AXI_GPIO interface`


---

## 10. Validate Design

Run:
`Validate Design`


Resolve all errors before proceeding.

---

## 11. Generate HDL Wrapper

1. Generate HDL Wrapper for:
`design_1.bd`



2. Ignore warnings related to unconnected GPIO signals.
3. Save the wrapper.
4. Set the HDL Wrapper as **Top Module**.

---

## 12. Run Synthesis

Run synthesis before configuring FPGA pins.

---

# 13. FPGA Pin Configuration

Open:
Window → I/O Ports

The I/O Ports window displays all design signal ports.

---

## Switch / Button FPGA Pin Configuration

| Signal | FPGA Pin |
| ------ | -------- |
| BTN0   | D19      |
| BTN1   | D20      |
| BTN2   | L20      |
| BTN3   | L19      |
| SW0    | M20      |
| SW1    | M19      |

---

## LED FPGA Pin Configuration

| LED | FPGA Pin |
| --- | -------- |
| LD0 | R14      |
| LD1 | P14      |
| LD2 | N16      |
| LD3 | M14      |

---

## Tri-Color LED Pin Configuration

### LD4

| Color | FPGA Pin |
| ----- | -------- |
| Red   | N15      |
| Green | G17      |
| Blue  | L15      |

### LD5

| Color | FPGA Pin |
| ----- | -------- |
| Red   | M15      |
| Green | L14      |
| Blue  | G14      |

Apply the following I/O standard:
IOSTANDARD = LVCMOS33

---

# 14. Generate Bitstream

1. Save the project.
2. Generate the FPGA bitstream.

---

# 15. Upload Files to PYNQ Jupyter Notebook

Upload the following files:

## Bitstream File

Location:
<PROJECT>.runs/
impl_1/
<filename>.bit


---

## Hardware Handoff File

Location:


<PROJECTName>
<PROJECTName>.gen
sources_1
bd
design_1
hw_handoff
*.hwh


Example:


johnson_counter
johnson_counter.gen
sources_1
bd
design_1
hw_handoff


---

## Export TCL File

Export the Vivado design TCL file:


<PROJECT>.tcl


However, for importing a custom PYNQ Overlay, the required file is:


*.hwh


The `.hwh` file provides the hardware description required by PYNQ.

---

# 16. Reference GPIO Access in PYNQ

Refer to:

[GPIO access](https://pynq.readthedocs.io/en/latest/pynq_libraries.html#pynq-iops)