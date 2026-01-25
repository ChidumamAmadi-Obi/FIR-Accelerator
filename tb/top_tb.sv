// *tb stilll under development

`include "helpers.svh"

module top_tb;
	localparam DATA_WIDTH = `DATA_WIDTH;
	localparam NUM_REGS = `NUM_REGS;
    localparam SCALE = `SCALE;
    localparam Q_FORMAT = `Q_FORMAT;
    localparam NUM_TESTS = 0;

    logic clk; // inputs
    logic rstN;
    logic accelerateEn;
    logic [DATA_WIDTH-1:0] sensorIn;
    logic signed [DATA_WIDTH-1:0] coefs [0:NUM_REGS-1];

    logic signed [DATA_WIDTH-1:0] resultOut; // outputs
    logic valid;

    // expected results
    real expectedMacResult;
    logic expectedValid;

    // error checking and reporting
    logic [NUM_TESTS-1:0] errors;
	logic isAnError;
	integer noOfErrors, testNumber=0;
    
    top topInstance (
        .clk(clk),
        .rstN(rstN),
        .accelerateEn(accelerateEn),
        .rawSensorVal(sensorIn),
        .coefs(coefs),
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

    initial begin
        
        errors=0;
        testNumber=0;
        expectedMacResult=0;
        clk=0; // start clock low
        rstN=1; // start reset high (active low input)
        accelerateEn=1; // start enable high (active high input)
        
        coefs[0]=r2f(0.2); // start coefficients at 0.2
        coefs[1]=r2f(0.2);
        coefs[2]=r2f(0.2);
        coefs[3]=r2f(0.2);
        coefs[4]=r2f(0.2);
        coefs[5]=r2f(0.2);
        coefs[6]=r2f(0.2);
        coefs[7]=r2f(0.2);

      	$display("\n\n-----");
        $monitor("TIME: %d SENSORIN: %d RESULT: %f VALIDITY: %b", $time, sensorIn, f2r(resultOut), valid);

        sensorIn=i2f($urandom_range(1,5)); clkPulse(clk); // test inserting sensor values
        sensorIn=i2f($urandom_range(1,5)); clkPulse(clk);
        sensorIn=i2f($urandom_range(1,5)); clkPulse(clk);
        sensorIn=i2f($urandom_range(1,5)); clkPulse(clk);
        sensorIn=i2f($urandom_range(1,5)); clkPulse(clk);
        sensorIn=i2f($urandom_range(1,5)); clkPulse(clk);
        sensorIn=i2f($urandom_range(1,5)); clkPulse(clk);
        sensorIn=i2f($urandom_range(1,5)); clkPulse(clk);
        sensorIn=i2f($urandom_range(1,5)); clkPulse(clk);
        sensorIn=i2f($urandom_range(1,5)); clkPulse(clk);
        sensorIn=i2f($urandom_range(1,5)); clkPulse(clk);
        sensorIn=i2f($urandom_range(1,5)); clkPulse(clk);
        sensorIn=i2f($urandom_range(1,5)); clkPulse(clk);
        sensorIn=i2f($urandom_range(1,5)); clkPulse(clk);
        sensorIn=i2f($urandom_range(1,5)); clkPulse(clk);
        sensorIn=i2f($urandom_range(1,5)); clkPulse(clk);
        sensorIn=i2f($urandom_range(1,5)); clkPulse(clk);

        accelerateEn=0; // test enable

        sensorIn=i2f($urandom_range(1,5)); clkPulse(clk);
        sensorIn=i2f($urandom_range(1,5)); clkPulse(clk);
        sensorIn=i2f($urandom_range(1,5)); clkPulse(clk);

        accelerateEn=1; 
        clkPulse(rstN); // test reset  (high to low pulse)

        sensorIn=i2f($urandom_range(1,5)); clkPulse(clk);
        sensorIn=i2f($urandom_range(1,5)); clkPulse(clk);
        sensorIn=i2f($urandom_range(1,5)); clkPulse(clk);
        
        $display("\n\n-----");
        $finish;        
    end
endmodule


