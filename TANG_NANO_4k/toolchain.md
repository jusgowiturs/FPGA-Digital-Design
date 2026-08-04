# OSS CAD Suite Installation

This project uses the **OSS CAD Suite** toolchain for FPGA synthesis, place-and-route, bitstream generation, and programming.

The OSS CAD Suite package includes all required FPGA tools:

- Yosys (RTL synthesis)
- nextpnr-himbaechel (place and route)
- gowin_pack (Gowin bitstream generation)
- openFPGALoader (FPGA programming)

---

## 1. Install Required Dependencies

Update the package list and install the required dependencies:

```bash
sudo apt update
sudo apt install -y wget python3 python3-pip libftdi1-2 libusb-1.0-0
```

---

## 2. Download Precompiled OSS CAD Suite

Move to your home directory:

```bash
cd ~
```

Download the latest stable [OSS CAD Suite](https://github.com/YosysHQ/oss-cad-suite-build/releases) release from:



Example:

```bash
wget <OSS_CAD_Suite_download_url>
```

Extract the archive:

```bash
tar -xvzf oss-cad-suite-linux-x64-<version>.tgz
```

This creates the OSS CAD Suite directory:

```text
oss-cad-suite
```

Remove the downloaded archive:

```bash
rm oss-cad-suite-linux-x64-<version>.tgz
```

---

## 3. Configure OSS CAD Suite Path

Set the `OSS_DIR` environment variable to point to the extracted OSS CAD Suite directory.

Example:

```bash
export OSS_DIR=$HOME/oss-cad-suite
```

To make it permanent:

```bash
echo 'export OSS_DIR=$HOME/oss-cad-suite' >> ~/.bashrc
source ~/.bashrc
```

---

## 4. Verify Installation

Check that the required tools from OSS CAD Suite are available:

### Check Yosys

```bash
$OSS_DIR/bin/yosys -V
```

### Check nextpnr

```bash
$OSS_DIR/bin/nextpnr-himbaechel -V
```

### Check Gowin Pack

```bash
$OSS_DIR/bin/gowin_pack --help
```

### Check openFPGALoader

```bash
$OSS_DIR/bin/openFPGALoader --version
```

If these commands execute successfully, the OSS CAD Suite installation is ready for Tang Nano 4K FPGA development.