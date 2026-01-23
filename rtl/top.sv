/*  FINITE IMPULSE RESPONSE ACCELERATOR FOR THE PULP CV32E40X

*/

`include "constants.svh"
`include "shiftreg.sv"
`include "mac.sv"

module top( 
    input logic clk, 
    input logic rstN, // active low reset
    input logic accelerateEn, // to enable accelerator
    input logic [`DATA_WIDTH-1:0] rawSensorVal, 
    input logic [`DATA_WIDTH-1:0] coefs [0:`NUM_REGS-1], // coefficients
    output logic [`DATA_WIDTH-1:0] macResult, // result
    output logic resultIsValid
    );

    // internal signals
    logic [`DATA_WIDTH-1:0] pDataIntoMac [0:`NUM_REGS-1];
    logic [`DATA_WIDTH-1:0] macResultWire;
    logic accelerateEnSync;

    // sync enable signal (1-stage synchronizer)
    // NEED TO ADD TWO STAGE SYNCHRONIZER
    always_ff @(posedge clk or negedge rstN) begin
        if (!rstN) begin
            accelerateEnSync <= 1'b0;
        end else begin
            accelerateEnSync <= accelerateEn;
        end
    end

    shiftReg shiftRegInstance (
        .clk(clk),
        .rst(!rstN), // convert reset sig to active high
        .sDataIn(rawSensorVal),
        .pDataOut(pDataIntoMac)
    );

    mac macInstance (
        .pDataIn(pDataIntoMac),
        .coefs(coefs),
        .macResult(macResultWire)
    );   

    always_ff @(posedge clk or negedge rstN) begin // output result to register with enable
        if (!rstN) begin
            macResult   <= '0;
            resultIsValid <= 1'b0;
        end else if (accelerateEnSync) begin
            macResult   <= macResultWire;
            resultIsValid <= 1'b1; // sig valid result
        end else begin
            resultIsValid <= 1'b0;
        end
    end
endmodule