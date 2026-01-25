/* SIMPLE SHIFT REGISTER TEST BENCH
*/

`include "helpers.svh"

module shiftreg_tb;
localparam DATA_WIDTH = `DATA_WIDTH;
localparam NUM_REGS = `NUM_REGS;

logic clk;
logic rst;

logic [DATA_WIDTH-1:0] rawSensorVal; // simulated raw sensor value
logic [DATA_WIDTH-1:0] pDataOut [0:NUM_REGS-1]; // parallel data out

shiftReg shiftRegInstance (
    .clk(clk),
    .rst(rst),
    .sDataIn(rawSensorVal),
    .pDataOut(pDataOut)
);

initial begin
    clk=0; rst=0; #10;

    $display("\n\n-----");
    $monitor("TIME: %d DATA IN: %d DATA OUT:%d %d %d %d %d %d %d %d ",
      $time,
      rawSensorVal, 
      pDataOut[0],pDataOut[1],pDataOut[2],pDataOut[3],
      pDataOut[4],pDataOut[5],pDataOut[6],pDataOut[7]);
    
    rawSensorVal=$urandom_range(1,5); pulse(clk); // test inserting into shift reg
    rawSensorVal=$urandom_range(1,5); pulse(clk);
    rawSensorVal=$urandom_range(1,5); pulse(clk);
    rawSensorVal=$urandom_range(1,5); pulse(clk);
    rawSensorVal=$urandom_range(1,5); pulse(clk);
    rawSensorVal=$urandom_range(1,5); pulse(clk);
    rawSensorVal=$urandom_range(1,5); pulse(clk);
    rawSensorVal=$urandom_range(1,5); pulse(clk);
    rawSensorVal=$urandom_range(1,5); pulse(clk);
    rawSensorVal=$urandom_range(1,5); pulse(clk);
    rawSensorVal=$urandom_range(1,5); pulse(clk);
    rawSensorVal=$urandom_range(1,5); pulse(clk);
    rawSensorVal=$urandom_range(1,5); pulse(clk);
    rawSensorVal=$urandom_range(1,5); pulse(clk);

    pulse(rst); // test reset
    
    rawSensorVal=$urandom_range(1,5); pulse(clk); // populate shift reg again
    rawSensorVal=$urandom_range(1,5); pulse(clk);
    rawSensorVal=$urandom_range(1,5); pulse(clk);
    rawSensorVal=$urandom_range(1,5); pulse(clk);

    $display("-----\n\n");
    $finish;
end

endmodule