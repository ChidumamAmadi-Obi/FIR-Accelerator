# FIR FOR THE PULP CV32E40X
Custom Finite Impulse Response (FIR) accelerator in System Verilog designed for integration with the PULP CV32E40X RISC-V core. Performs real-time fixed-point filtering on streaming sensor data using a shift register and a multiply-accumulate (MAC) unit.

**What it does:** The accelerator offloads the multiply-accumulate operations of a digital FIR filter from the CPU.

## Features

 * 8-tap FIR filter (configureable with ```NUM_REGS``` in ```constants.svh```)
 * Q16.16 fixed point arithmetic, 32-bit data with 16 fractional bits
 * Auto-generated register interface using ```regtool```
 * Software driver (coefficient loading, data input, getting result)
   
*This accelerator is to be integrated into X_HEEP as a memory-mapped peripheral and is compatible with the PULP ```cv32e40x``` core*

## Architecture
<img width="700" height="829" alt="image" src="https://github.com/user-attachments/assets/4392e586-00e3-4799-bffb-65408d520f68" />

## RTL Modules

 * ```top.sv``` - Top integration
 * ```shiftreg.sv``` Shift register that holds the last 8 sensor values (SIPO)
 * ```mac.sv``` Multiply-Accumulate unit
 * ```fir_accelerator.sv``` X-HEEP peripheral wrapper, connects register interface to ```top```

 * ```fir_accelerator_reg_pkg.sv``` (genereted) register package
 * ```fir_accelerator_reg_top.sv``` (generated) register bank

 * ```constants.svh``` Project parameters

## Register Map
| OFFSET | NAME | ACCESS | DESC |
|--------|------|--------|------|
| 0x00 | CONTROL | RW | ```bit 0``` accelerate_en, ```bit 1``` coeff_write_en, ```bit 2``` clr_c, ```bit 3``` busy (RO) |
| 0x04 | COEFF_ADDR | RW | Coefficient address (0-7) for writing |
| 0x08 | COEFF_DATA | RW | Coefficient value to write (Q16.16) |
| 0x0C | SENSOR_DATA | RW | Raw sensor value (Q16.16) |
| 0x10 | RESULT | RO | Filtered output (Q16.16) |
| 0x14 | STATUS | RO | ```bit 0``` result_valid |

*NOTE: Register fields in ```fir_accelerator.h``` re generated and the driver uses the ```FIR_ACC_PERIPH``` pointer*

## Prerequisites
 - [X-Heep](https://github.com/x-heep/x-heep) environment
 - Python 3 for regtool
 - Verilator / Questa / or other simulator for RTL simulation
