# WHAT IS AN FIR ACCELERATOR
Finite Impulse Response (FIR) accelerator in System Verilog designed for integration with the PULP CV32E40X RISC-V core. Performs real-time fixed-point filtering on streaming sensor data using a shift register and a multiply-accumulate (MAC) unit.
# HOW ITS SUPPOSE TO WORK
1.  Clock tick.
2.  Shift all data registers.
3.  Latch new input into the first register.
4.  Enable multipliers and adders (they work combinatorially—output appears after some nanosecond delay).
5.  Latch the final sum y_out into an output register.
6.  Repeat forever.


# WHAT WAS DONE
implimented busy bit in top module
implemented proper error tracking in accelerator.sv
fixed negative fixed point rounding in mac module
# roadmap
- [x] complete shift register module
- [x] complete mac module
- [x] complete top module 
- [x] complete wrapper module
- [x] complete bus interface (APB or AXI4-Lite compatible)
- [ ] create rigourous testbenches for each module

- [ ] create driver for peripheral in C
- [ ] successfully integrate drivers and peripheral with PULP CV32E40X in the X-heep enviroment
- [ ] create example firmware that uses peripheral with driver

# WHAT WAS LEARNED