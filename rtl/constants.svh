`ifndef CONSTANTS // file guard
`define CONSTANTS

`timescale 1ns/1ps
`define DATA_WIDTH 32 // 32 bit mcu
`define NUM_REGS 8
`define ACC_WIDTH `DATA_WIDTH*2
`define Q_FORMAT `DATA_WIDTH/2
`define SCALE 1<<`Q_FORMAT

// https://learn.verificationstudio.com/tutorials/1/systemverilog-tutorial/subcontents/10/randomization

`endif