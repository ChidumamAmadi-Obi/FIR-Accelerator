`ifndef HELPERS // file guard
`define HELPERS

`timescale 1ns/1ps
`define DATA_WIDTH 32 // 32 bit mcu
`define NUM_REGS 8
`define ACC_WIDTH `DATA_WIDTH*2
`define Q_FORMAT `DATA_WIDTH/2
`define SCALE 1<<`Q_FORMAT

// TASKS AND FUNCTIONS
task clkPulse(ref logic clk); // assume clk starts off low
    clk=~clk; #5; // high
    clk=~clk; #5; // low
endtask

// https://learn.verificationstudio.com/tutorials/1/systemverilog-tutorial/subcontents/10/randomization

`endif