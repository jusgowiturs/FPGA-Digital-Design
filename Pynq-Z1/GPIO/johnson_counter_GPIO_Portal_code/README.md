# Step by Step Procedure


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
    