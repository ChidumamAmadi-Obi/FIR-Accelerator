/* SIMPLE SHIFT REGISTER TEST BENCH
*/

`include "helpers.svh"

module shiftreg_tb;

logic shift;
logic rst;

logic [TB_DATA_WIDTH-1:0] rawSensorVal; // simulated raw sensor value
logic [TB_DATA_WIDTH-1:0] pDataOut [0:TB_NUM_REGS-1]; // parallel data out

shiftReg shiftRegInstance (
    .shift(shift),
    .rst(rst),
    .sDataIn(rawSensorVal),
    .pDataOut(pDataOut)
);

initial begin
    shift=0; rst=0; #10;

    $display("\n\n-----");
    $monitor("TIME: %d DATA IN: %d DATA OUT:%d %d %d %d %d %d %d %d ",
      $time,
      rawSensorVal, 
      pDataOut[0],pDataOut[1],pDataOut[2],pDataOut[3],
      pDataOut[4],pDataOut[5],pDataOut[6],pDataOut[7]);
    
    rawSensorVal=$urandom_range(1,5); pulse(shift); // test inserting into shift reg
    rawSensorVal=$urandom_range(1,5); pulse(shift);
    rawSensorVal=$urandom_range(1,5); pulse(shift);
    rawSensorVal=$urandom_range(1,5); pulse(shift);
    rawSensorVal=$urandom_range(1,5); pulse(shift);
    rawSensorVal=$urandom_range(1,5); pulse(shift);
    rawSensorVal=$urandom_range(1,5); pulse(shift);
    rawSensorVal=$urandom_range(1,5); pulse(shift);
    rawSensorVal=$urandom_range(1,5); pulse(shift);
    rawSensorVal=$urandom_range(1,5); pulse(shift);
    rawSensorVal=$urandom_range(1,5); pulse(shift);
    rawSensorVal=$urandom_range(1,5); pulse(shift);
    rawSensorVal=$urandom_range(1,5); pulse(shift);
    rawSensorVal=$urandom_range(1,5); pulse(shift);

    pulse(rst); // test reset
    
    rawSensorVal=$urandom_range(1,5); pulse(shift); // populate shift reg again
    rawSensorVal=$urandom_range(1,5); pulse(shift);
    rawSensorVal=$urandom_range(1,5); pulse(shift);
    rawSensorVal=$urandom_range(1,5); pulse(shift);

    $display("-----\n\n");
    $finish;
end

endmodule