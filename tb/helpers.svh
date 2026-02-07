`ifndef HELPERS // file guard
`define HELPERS

`include "constants.svh"

// TASKS AND FUNCTIONS
function automatic logic signed [DATA_WIDTH-1:0] r2f(real val); // real to fixed point 32 bit
 	return int'(val * SCALE + (val >= 0 ? 0.5 : -0.5));
endfunction
function automatic logic signed [DATA_WIDTH-1:0] i2f(int val); // integer to fixed-point 32 bit
    return val << Q_FORMAT;
endfunction
function automatic real f2r(logic signed [DATA_WIDTH-1:0] fixed); // fixed-point to real
 	return real'(fixed) / SCALE;
endfunction

task pulse(ref logic clk);
    // assume sig starts off low
    clk=~clk; #5; // high
    clk=~clk; #5; // low
endtask

// https://learn.verificationstudio.com/tutorials/1/systemverilog-tutorial/subcontents/10/randomization

`endif