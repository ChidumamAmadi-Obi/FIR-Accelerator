/* SHIFT REGISTER MODULE
on every positive edge, add new raw register value to the 
shift register, then paralell out all elements in shift register
*/

`include "header.vh"

module shiftReg (
    input clk,
    input rst,
    input [`DATA_WIDTH-1:0] serialDataIn, // serial data in
    output reg [`DATA_WIDTH-1:0] pDataOut [0:NUM_REGS-1] // parallel data out
);

    reg [`DATA_WIDTH-1:0] sReg [0:NUM_REGS-1]; // shift register
    integer i;

    always @(posedge clk) begin // sequential logic
      if (rst == 1) begin // if reset, set all registers to zero
        for (i=0; i<NUM_REGS; i=i+1) begin sReg[i] <= 0; end
      end else begin // else, shift over one to make room for serialDatain
          for (i=NUM_REGS-1; i!=0; i=i+1) begin sReg[i] <= sReg[i-1]; end
            sReg[0] <= serialDataIn; // insert serial data in
        end
    end

    always @* begin // combinational output
      for (i=0; i<NUM_REGS; i=i+1) begin pDataOut[i]=sReg[i]; end
    end            
endmodule
