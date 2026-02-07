`include "helpers.svh"

module top_tb;

    logic clk; // inputs
    logic rstN;
    logic clrC;
    logic accelerateEn;
    logic coeffWriteEn;
    logic [2:0] coeffAddress;
    logic [DATA_WIDTH-1:0] sensorIn;
    logic signed [DATA_WIDTH-1:0] coeffsIn;

    logic signed [DATA_WIDTH-1:0] resultOut; // outputs
    logic busy;
    logic valid;
    
    top topInstance (
        .clk(clk),
        .rstN(rstN),
        .clrC(clrC),
        .coeffWriteEn(coeffWriteEn),
        .coeffAddress(coeffAddress),
        .coeffIn(coeffsIn),
        .accelerateEn(accelerateEn),
        .rawSensorVal(sensorIn),
        .macResult(resultOut),
        .resultIsValid(valid),
        .busy(busy)
    );

    task loadCoeffs(
        input real coeffVal,
        ref logic signed [DATA_WIDTH-1:0] coeffsIn,
        ref logic [2:0] coeffAddress,
        ref logic coeffWriteEn );

        coeffWriteEn=1; // start with coeff write enabled to load coefs into memory
        coeffAddress=3'b000; // start writting from address 000

        for (integer i=0; i<NUM_REGS; i++) begin
            coeffsIn=r2f(coeffVal); 
            coeffAddress++;   
            pulse(clk); // after each clock pulse the coef   
            $display("WROTE 0.2 TO COEFF %d...",i);    
        end
        coeffWriteEn=0;
    endtask
    task sendRandomData(
        input integer no, // number of data points to be inserted
        input real min,
        input real max,
        ref logic [DATA_WIDTH-1:0] sensorIn);

        for (integer i=0; i<=no; i++) begin
            sensorIn=i2f($urandom_range(min,max));
            pulse(clk);           
        end
    endtask

    initial begin
        clrC=0;
        clk=0; // start clock low
        rstN=1; // start reset high (active low input)
        accelerateEn=1; // start enable high (active high input)

        pulse(rstN); // start by reseting module first
        
        $display("\n\n-----");
        loadCoeffs(0.2,coeffsIn, coeffAddress, coeffWriteEn); // first load coeffs into reg file
        $display("\n-----\n");
        $display("T     SENSORIN   RESULT VALIDITY A_ENABLE RSTN");
        $monitor("%0d -     %d     %0f     %b       %b     %b",
          $time, f2r(sensorIn), f2r(resultOut), valid, accelerateEn, rstN);

        // test inserting 16 random sensor values between 0 and 5, result is zero until all (8) registers are populated
        sendRandomData(16,0,5,sensorIn); 

        // test enable
        // when sensor values come in and the accelerator is not enabled
        // the accelerator does not process it and its output is not affected
        accelerateEn=0; pulse(clk);
        sendRandomData(6,0,5,sensorIn);

        accelerateEn=1; pulse(clk); // re enable module
        sendRandomData(6,0,5,sensorIn);
      
        pulse(rstN); // test reset  (high to low pulse), this should clear all registers
        sendRandomData(16,0,5,sensorIn); 
        
        $display("-----\n\n");
        $finish;        
    end
endmodule














