/* SIMPLE SHIFT REGISTER TEST BENCH
*/

`include "constants.svh"

module shiftreg_tb;

reg clk;
reg rst;

reg [`DATA_WIDTH-1:0] rawSensorVal; // simulated raw sensor value
wire [`DATA_WIDTH-1:0] pDataOut [0:`NUM_REGS-1]; // parallel data out

shiftReg dut(
    .clk(clk),
    .rst(rst),
    .serialDataIn(rawSensorVal),
    .pDataOut(pDataOut)
);

initial begin
    clk=1'b0;
    rst=1'b0;
    #10;
    $monitor("DATA IN: %d DATA OUT:%d %d %d %d %d %d %d %d ",rawSensorVal, pDataOut[0],pDataOut[1],pDataOut[2],pDataOut[3],pDataOut[4],pDataOut[5],pDataOut[6],pDataOut[7]);
    
    rawSensorVal=1; 
    clk=~clk; #5 clk=~clk; // one clock cycle
    #10;
    rawSensorVal=2;
    clk=~clk; #5 clk=~clk;
    #10;
    rawSensorVal=3;
    clk=~clk; #5 clk=~clk;
    #10;
    rawSensorVal=4;
    clk=~clk; #5 clk=~clk;
    #10;
    rawSensorVal=5;
    clk=~clk; #5 clk=~clk;
    #10;
    rawSensorVal=6;
    clk=~clk; #5 clk=~clk;
    #10;
    rawSensorVal=7;
    clk=~clk; #5 clk=~clk;
    #10;
    rawSensorVal=8;
    clk=~clk; #5 clk=~clk;
    #10;
    rawSensorVal=9;
    clk=~clk; #5 clk=~clk;
    #10;
    rawSensorVal=10;
    clk=~clk; #5 clk=~clk;
    #10;
    rawSensorVal=11;
    clk=~clk; #5 clk=~clk;
    #10;
    rawSensorVal=12;
    clk=~clk; #5 clk=~clk;
    #10;  
    $finish;
end

endmodule