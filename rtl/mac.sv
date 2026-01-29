/* MULTIPLY ACCUMULATE UNIT
multiplies each raw sensor value by their respective coef
and adds all the results
*/

`include "constants.svh"

module mac# ( 
    parameter DATA_WIDTH=`DATA_WIDTH,
    parameter NUM_REGS=`NUM_REGS,
    parameter Q_FORMAT=`Q_FORMAT
) (
    input logic signed [DATA_WIDTH-1:0] pDataIn [0:NUM_REGS-1], // parallel data from shift reg
    input logic signed [DATA_WIDTH-1:0] coefs [0:NUM_REGS-1],
    output logic signed [DATA_WIDTH-1:0] macResult
);

    localparam ACC_WIDTH = 2*DATA_WIDTH + $clog2(NUM_REGS); // ref https://circuitcove.com/system-tasks-clog2/

    logic signed [ACC_WIDTH-1:0] accumulator;
    logic signed [ACC_WIDTH-1:0] accumulatorScaled;

    always_comb begin
        accumulator = 0;
        accumulatorScaled = 0;
        for (integer i=0; i<NUM_REGS; i++) begin // fixed-point multiplication because result has 2*Q_FORMAT fractional bits
            accumulator += (coefs[i]) * (pDataIn[i]);
        end
        
        // then scale back to Q_FORMAT fractional bits
        // Add rounding ,2^(Q_FORMAT-1) before truncation
        accumulatorScaled = accumulator + (1 << (Q_FORMAT-1));
    end
    assign macResult = accumulatorScaled[ACC_WIDTH-1:Q_FORMAT];// Truncate to original width, keep sign extended
endmodule
