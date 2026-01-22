/*  FINITE IMPULSE RESPONSE ACCELERATOR FOR THE PULP CV32E40X

*/

`include "constants.vh"
`include "shiftreg.v"
`include "mac.v"

module top #(
    parameter NUM_REGS `NUM_REGS // number of elements in shift register
    parameter DATA_WIDTH `DATA_WIDTH // 32 bits
)( 
    input clk, 
    input rst, // reset shift register in accelerator
    input accelerateEn, // to enable accelerator
    input rawSensorVal[DATA_WIDTH-1:0], 
    input [DATA_WIDTH-1:0] coefs [0:NUM_REGS-1], // coefficneits
    output reg macResult[DATA_WIDTH-1:0] // result
    );

    wire [DATA_WIDTH-1:0] pDataIntoMac [0:NUM_REGS-1]
    wire [DATA_WIDTH-1:0] out; 

    shiftReg shiftRegInstance (
        .clk(clk),
        .rst(rst),
        .serialDataIn(rawSensorVal),
        .pDataOut(pDataIntoMac),
    );

    mac macInstance (
        pDataIn(pDataIntoMac),
        coefs(coefs),
        macResult(macResult)
    );

endmodule