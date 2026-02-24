`ifndef TB_CONSTANTS // file guard
`define TB_CONSTANTS

`timescale 1ns/1ps
`define TB_DATA_WIDTH 32 // 32 bit mcu
`define TB_NUM_REGS 8
`define TB_ACC_WIDTH `TB_DATA_WIDTH*2

localparam TB_DATA_WIDTH = `TB_DATA_WIDTH; // 32 bit mcu
localparam TB_Q_FORMAT = `TB_DATA_WIDTH/2;
localparam TB_SCALE = 1<<TB_Q_FORMAT;
localparam TB_NUM_REGS = `TB_NUM_REGS;
localparam TB_ACC_WIDTH = `TB_ACC_WIDTH;

// https://learn.verificationstudio.com/tutorials/1/systemverilog-tutorial/subcontents/10/randomization

`endif