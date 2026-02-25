# FIR Filter Accelerator
Custom Finite Impulse Response (FIR) accelerator in System Verilog designed for integration with the PULP CV32E40X RISC-V core. Performs real-time fixed-point filtering on streaming sensor data using a shift register and a multiply-accumulate (MAC) unit.

**What it does:** The accelerator offloads the multiply-accumulate operations of a digital FIR filter from the CPU.

## Features
 * 8-tap FIR filter (configureable with ```NUM_REGS``` in ```constants.svh```)
 * Q16.16 fixed point arithmetic, 32-bit data with 16 fractional bits
 * Auto-generated register interface using ```regtool```
 * Software driver (coefficient loading, data input, getting result)
   
*This accelerator is integrated into X_HEEP [**here**](https://github.com/ChidumamAmadi-Obi/x-heep-exploration/tree/fir-accelerator) as a memory-mapped peripheral and is compatible with the PULP ```cv32e40x``` core*

## Architecture
<img width="700" height="829" alt="image" src="https://github.com/user-attachments/assets/4392e586-00e3-4799-bffb-65408d520f68" />

## Quick Start (Using Docker)
1. **Pull Docker image and run the container** <br>
Click [here](https://x-heep.readthedocs.io/en/latest/GettingStarted/Setup.html) for more on how to set up x-heep on your computer <br>
``` powershell
git clone https://github.com/ChidumamAmadi-Obi/x-heep-exploration/tree/fir-accelerator
cd x-heep-exploration-fir-accelerator

make -C util/docker docker-pull TAG=latest
make -C util/docker docker-run TAG=latest
```

2. **Generate The Microcontroller**
``` bash
make mcu-gen CPU=cv32e40x # Generate cv32e40x core
make mcu-gen # Or default core
```

3. **Build and run example application with an FPU** <br>
The RISCV ISA string specifies the needed extentions to utilize the FPU. Click [here](https://gcc.gnu.org/onlinedocs/gcc/RISC-V-Options.html) for more information
```bash
make verilator-build PROJECT=example_fir_accelerator FUSESOC_PARAM="--FPU=1" ARCH=rv32imfc_zicsr_zifencei
make verilator-run-app PROJECT=example_fir_accelerator
```
```c
float coefficients[8] = {0.1, 0.2, 0.3, 0.4, 0.3, 0.2, 0.1, 0.05}; // default coefficients
```

### Output of Example Application & Graph With Python
<img width="434" height="886" alt="Screenshot 2026-02-23 183823" src="https://github.com/user-attachments/assets/1d4c5b87-8780-4565-b066-5e72bc92e3d7" />
<img width="1567" height="822" alt="image" src="https://github.com/user-attachments/assets/f1bd34cd-1ed7-44c2-9caf-36fb7beed9e3" /> <br>
**initial transient** - the first 8 filtered outputs are based on incomplete data, so these results should be ignored


## RTL Modules
 * ```top.sv``` - Top integration
 * ```shiftreg.sv``` Shift register that holds the last 8 sensor values (SIPO)
 * ```mac.sv``` Multiply-Accumulate unit
 * ```fir_accelerator.sv``` X-HEEP peripheral wrapper, connects register interface to ```top```

 * ```fir_accelerator_reg_pkg.sv``` (genereted) register package
 * ```fir_accelerator_reg_top.sv``` (generated) register bank

 * ```constants.svh``` Project parameters

## Register Map
| OFFSET | NAME | HW ACCESS | SW ACCESS | DESC |
|--------|------|-----------|-----------|------|
| 0x00 | CONTROL | WO/RO | RW/RO | ```bit 0``` accelerate_en, ```bit 1``` coeff_write_en, ```bit 2``` clr_c, ```bit 3``` busy (RO), ```bit 4``` shift |
| 0x04 | COEFF_ADDR | RO | RW | Coefficient address (0-7) for writing |
| 0x08 | COEFF_DATA | RO | RW | Coefficient value to write (Q16.16) |
| 0x0C | SENSOR_DATA | RO | RW | Raw sensor value (Q16.16) |
| 0x10 | RESULT | WO | RO | Filtered output (Q16.16) |
| 0x14 | STATUS | WO | RO | ```bit 0``` result_valid |

*NOTE: Register fields in ```fir_accelerator.h``` re generated and the driver uses the ```FIR_ACC_PERIPH``` pointer*

## Prerequisites
 - [X-Heep](https://github.com/x-heep/x-heep) environment
 - Python 3 for regtool
 - Verilator / Questa / or other simulator for RTL simulation

## How This Could be Improved
 - [ ] Support for negative numbers
 - [ ] Use of a proper timer for delays in the driver
 - [ ] Use of atomic operations when writing to the control register (theres a small chance of race conditions if interrupted)
 - [ ] More robust hardware design
 - [ ] Support for debug messages in the driver
 - [ ] Ability to read back and verify writes to the accelerator
