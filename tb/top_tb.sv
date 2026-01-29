`include "helpers.svh"

module top_tb;
	localparam DATA_WIDTH = `DATA_WIDTH;
	localparam NUM_REGS = `NUM_REGS;
    localparam SCALE = `SCALE;
    localparam Q_FORMAT = `Q_FORMAT;
    localparam NUM_TESTS = 0;

    logic clk; // inputs
    logic rstN;
    logic clrC;
    logic accelerateEn;
    logic coeffWriteEn;
    logic [2:0] coeffAddress;
    logic [DATA_WIDTH-1:0] sensorIn;
    logic signed [DATA_WIDTH-1:0] coeffsIn;

    logic signed [DATA_WIDTH-1:0] resultOut; // outputs
    logic valid;

    // expected results
    real expectedMacResult;
    logic expectedValid;

    // error checking and reporting
	logic [NUM_TESTS-1:0] errors;
	logic isAnError;
	integer noOfErrors, testNumber;
    
    top topInstance (
        .clk(clk),
        .rstN(rstN),
        .clrC(clrC),
        .coeffWriteEn(coeffWriteEn),
        .coeffAddress(coeffAddress),
        .coeffsIn(coeffsIn),
        .accelerateEn(accelerateEn),
        .rawSensorVal(sensorIn),
        .macResult(resultOut),
        .resultIsValid(valid)
    );

    // HELPER FUNCTIONS & TASKS
    function automatic logic signed [DATA_WIDTH-1:0] r2f(real val); // real to fixed point
    	return int'(val * SCALE + (val >= 0 ? 0.5 : -0.5));
    endfunction  
    function automatic logic signed [DATA_WIDTH-1:0] i2f(int val); // integer to fixed-point
        return val << Q_FORMAT;
    endfunction
    function automatic real f2r(logic signed [DATA_WIDTH-1:0] fixed); // fixed-point to real
    	return real'(fixed) / SCALE;
    endfunction

    task loadCoeffs(
        input real coeffVal,
        ref logic signed [DATA_WIDTH-1:0] coeffsIn,
        ref logic [2:0] coeffAddress,
        ref logic coeffWriteEn );

        coeffWriteEn=1; // start with coeff write enabled to load coefs into memory
        coeffAddress=3'b000; // start writting to address 000

        for (integer i=0; i<NUM_REGS; i++) begin
            coeffsIn=r2f(coeffVal); 
            coeffAddress++;   
            pulse(clk); // after each clock pulse the coef   
            $display("WROTE 0.2 TO COEFF %d...",i);    
        end
        coeffWriteEn=0;
    endtask

    initial begin

        noOfErrors=0;
        isAnError=0;
        testNumber=0;
        
        expectedMacResult=0;
        clrC=0;
        clk=0; // start clock low
        rstN=1; // start reset high (active low input)
        accelerateEn=1; // start enable high (active high input)
        
        $display("\n\n-----");
        loadCoeffs(0.2,coeffsIn, coeffAddress, coeffWriteEn); // first load coeffs into reg file

        $monitor("TIME: %d SENSORIN: %d RESULT: %f VALIDITY: %b A_ENABLE: %b RSTN: %b",
          $time, f2r(sensorIn), f2r(resultOut), valid, accelerateEn, rstN);

        sensorIn=i2f($urandom_range(1,5)); pulse(clk); // test inserting sensor values
        sensorIn=i2f($urandom_range(1,5)); pulse(clk);
        sensorIn=i2f($urandom_range(1,5)); pulse(clk);
        sensorIn=i2f($urandom_range(1,5)); pulse(clk);
        sensorIn=i2f($urandom_range(1,5)); pulse(clk);
        sensorIn=i2f($urandom_range(1,5)); pulse(clk);
        sensorIn=i2f($urandom_range(1,5)); pulse(clk);
        sensorIn=i2f($urandom_range(1,5)); pulse(clk);
        sensorIn=i2f($urandom_range(1,5)); pulse(clk);
        sensorIn=i2f($urandom_range(1,5)); pulse(clk);
        sensorIn=i2f($urandom_range(1,5)); pulse(clk);
        sensorIn=i2f($urandom_range(1,5)); pulse(clk);
        sensorIn=i2f($urandom_range(1,5)); pulse(clk);
        sensorIn=i2f($urandom_range(1,5)); pulse(clk);
        sensorIn=i2f($urandom_range(1,5)); pulse(clk);
        sensorIn=i2f($urandom_range(1,5)); pulse(clk);
        sensorIn=i2f($urandom_range(1,5)); pulse(clk);

        accelerateEn=0; // test enable

        sensorIn=i2f($urandom_range(1,5)); pulse(clk);
        sensorIn=i2f($urandom_range(1,5)); pulse(clk);
        sensorIn=i2f($urandom_range(1,5)); pulse(clk);

        accelerateEn=1; 
      
        sensorIn=i2f($urandom_range(1,5)); pulse(clk);
        sensorIn=i2f($urandom_range(1,5)); pulse(clk);
        sensorIn=i2f($urandom_range(1,5)); pulse(clk);
      
        pulse(rstN); // test reset  (high to low pulse)

        sensorIn=i2f($urandom_range(1,5)); pulse(clk);
        sensorIn=i2f($urandom_range(1,5)); pulse(clk);
        sensorIn=i2f($urandom_range(1,5)); pulse(clk);
        
        $display("-----\n\n");
        $finish;        
    end
endmodule














