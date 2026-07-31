# To select a board (e.g., PYNQ-Z1 / PYNQ-Z2) in Vivado instead of manually choosing the FPGA part.
## Step 1: Download Board Files

Download the required board files from:
Github [Link](https://github.com/xupsh/pynq-supported-board-file/tree/master)

##Step 2: Add Board Repository in Vivado
```
Open Vivado
Go to: Tools → Settings → Board Repository
Click “+” (Add Repository)
Select the folder containing the downloaded board files
```
Ensure the folder structure is correct:
```
board_files/
   pynq-z1/
   pynq-z2/
```
## Step 3: Restart Vivado

Restart Vivado to load the newly added board files.

## Step 4: Select Board During Project Creation
- Click Create New Project
- Navigate to Default Part selection
- Switch from Parts tab → Boards tab
  - Search and select:
    -   PYNQ-Z1
    -   PYNQ-Z2