`include "constants.svh"

module top_tb;
	localparam DATA_WIDTH = `DATA_WIDTH;
	localparam NUM_REGS = `NUM_REGS;

    logic clk; // inputs
    logic rstN;
    logic accelerateEn;
    logic sensorIn;
    logic signed [DATA_WIDTH-1:0] coefs [0:NUM_REGS-1];

    logic signed [DATA_WIDTH-1:0] resultOut; // outputs
    logic valid;
    
    top topInstance (
        .clk(clk),
        .rstN(rstN),
        .accelerateEn(accelerateEn),
        .rawSensorVal(sensorIn),
        .coefs(coefs),
        .macResult(resultOut),
        resultIsValid(valid)
    );

    initial begin
        $display("hello world");  $finish;
    end
endmodule