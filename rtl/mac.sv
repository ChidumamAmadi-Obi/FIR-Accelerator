/* MULTIPLY ACCUMULATE UNIT
multiplies each raw sensor value by their respective coef
and adds all the results
*/

`include "constants.svh"

module mac (
    input [`DATA_WIDTH-1:0] pDataIn [0:`NUM_REGS-1], // parallel data from shift reg
    input [`DATA_WIDTH-1:0] coefs [0:`NUM_REGS-1],
    output wire [`DATA_WIDTH-1:0] macResult
);
    integer i;
    reg [`DATA_WIDTH-1:0] macResultReg;

    always @* begin
        macResultReg=0;
        for (i=0; i<`NUM_REGS; i=i+1) begin
            macResultReg += coefs[i] * pDataIn[i];
        end
    end
    assign macResult=macResultReg;
endmodule
