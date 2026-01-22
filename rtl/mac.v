/* MULTIPLY ACCUMULATE UNIT
multiplies each raw sensor value by their respective coef
and adds all the results
*/

`include "constants.vh"

module mac (
    input [DATA_WIDTH-1:0] pDataIn [0:NUM_REGS-1], // parallel data from shift reg
    input [DATA_WIDTH-1:0] coefs [0:NUM_REGS-1]
    output wire [DATA_WIDTH] macResult;
)

    integer i;
    reg [DATA_WIDTH-1:0] macResultReg;
    reg [DATA_WIDTH-1:0] temp;

    always *@begin
        for (i=0; i<NUM_REGS; i=i+1) begin
            temp = coefs[i] * pDataIn[i];
            macResultReg = temp + macResult;
        end
        // ALSO: take care of if mac result is more then 32 bits
    assign macResult=macResultReg;
    end
endmodule