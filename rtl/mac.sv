/* MULTIPLY ACCUMULATE UNIT
multiplies each raw sensor value by their respective coef
and adds all the results
*/

`include "constants.svh"

module mac# ( parameter Q_FORMAT=16) (
    input logic signed [`DATA_WIDTH-1:0] pDataIn [0:`NUM_REGS-1], // parallel data from shift reg
    input logic signed [`DATA_WIDTH-1:0] coefs [0:`NUM_REGS-1],
    output logic signed [`DATA_WIDTH-1:0] macResult
);

    localparam ACC_WIDTH = 2*`DATA_WIDTH + $clog2(`NUM_REGS);

    integer i;
    logic signed [ACC_WIDTH-1:0] accumulator;
    logic signed [ACC_WIDTH-1:0] accumulatorScaled;

    always_comb begin
        accumulator = 0;
        for (i=0; i<`NUM_REGS; i++) begin // fixed-point multiplication because result has 2*Q_FORMAT fractional bits
            accumulator += $signed(coefs[i]) * $signed(pDataIn[i]);
        end
        
        // then scale back to Q_FORMAT fractional bits
        // Add rounding ,2^(Q_FORMAT-1) before truncation
        accumulatorScaled = accumulator + (1 << (Q_FORMAT-1));
    end
    assign macResult = accumulatorScaled[ACC_WIDTH-1:Q_FORMAT];// Truncate to original width, keep sign extended
endmodule
