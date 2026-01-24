`ifndef HELPERS // file guard
`define HELPERS

`timescale 1ns/1ps
`define DATA_WIDTH 32 // 32 bit mcu
`define NUM_REGS 8

// HELPER FUNCTIONS
function automatic logic signed [DATA_WIDTH-1:0] r2f(real val); // real number to interger
	return int'(val * SCALE + (val >= 0 ? 0.5 : -0.5));
endfunction
function automatic logic signed [DATA_WIDTH-1:0] i2f(int val); // interger to real number
	return val << Q_FORMAT;
endfunction
function automatic real f2r(logic signed [DATA_WIDTH-1:0] fixed); // fixed-point to real
	return real'(fixed) / SCALE;
endfunction

`endif