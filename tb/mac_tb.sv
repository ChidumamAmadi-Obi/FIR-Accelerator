`include "helpers.svh"

module mac_tb;
    localparam DATA_WIDTH = `DATA_WIDTH;
	localparam Q_FORMAT = `Q_FORMAT;
    localparam SCALE = `SCALE;  // 65536
	localparam NUM_REGS = `NUM_REGS;
    localparam ACC_WIDTH = `ACC_WIDTH;
	localparam NUM_TESTS = 4;

    logic signed [DATA_WIDTH-1:0] pDataIn [0:NUM_REGS-1];
    logic signed [DATA_WIDTH-1:0] coefs [0:NUM_REGS-1];
    logic signed [DATA_WIDTH-1:0] macResult;
    real expectedMacResult;

    // error checking and reporting
	logic [NUM_TESTS-1:0] errors;
	logic isAnError;
	integer noOfErrors, testNumber=0;

	mac macInstance (
		.pDataIn(pDataIn),
		.coefs(coefs),
		.macResult(macResult)
	);
  
    // HELPER FUNCTIONS & TASKS
    function automatic logic signed [DATA_WIDTH-1:0] r2f(real val);
    	return int'(val * SCALE + (val >= 0 ? 0.5 : -0.5));
    endfunction
    function automatic logic signed [DATA_WIDTH-1:0] i2f(int val); // integer to fixed-point
        return val << Q_FORMAT;
    endfunction
    function automatic real f2r(logic signed [DATA_WIDTH-1:0] fixed); // fixed-point to real
    	return real'(fixed) / SCALE;
    endfunction
    function automatic real verifMac( // calculate expected mac result
        logic signed [DATA_WIDTH-1:0] pDataIn_array [0:NUM_REGS-1],
        logic signed [DATA_WIDTH-1:0] coefs_array [0:NUM_REGS-1] );
        logic signed [ACC_WIDTH-1:0] accumulator = 0;
        logic signed [ACC_WIDTH-1:0] accumulatorScaled;
        logic signed [DATA_WIDTH-1:0] result;
        
        for(integer i=0; i<NUM_REGS; i++) begin
            accumulator += (coefs_array[i]) * (pDataIn_array[i]);
        end
        
        accumulatorScaled = accumulator + (1 << (Q_FORMAT-1));
        result = accumulatorScaled[ACC_WIDTH-1:Q_FORMAT];
        return f2r(result);
    endfunction
  
    task automatic randomPData( // get random values for p data
      ref logic signed [DATA_WIDTH-1:0] pData_array [0:NUM_REGS-1],
      input int min,
      input int max );
        for (integer i=0; i<NUM_REGS; i++) begin
            pData_array[i] = i2f($urandom_range(min, max));
        end
    endtask
    task automatic writeCoefs(
      ref logic signed [DATA_WIDTH-1:0] coefs [0:NUM_REGS-1],
      input value );
        if (value%1 == 0) begin // if value is an integer
            coefs[0]=i2f(value);
            coefs[1]=i2f(value);
            coefs[2]=i2f(value);
            coefs[3]=i2f(value);
            coefs[4]=i2f(value);
            coefs[5]=i2f(value);
            coefs[6]=i2f(value);
            coefs[7]=i2f(value); 
        end else begin 
            coefs[0]=r2f(value);
            coefs[1]=r2f(value);
            coefs[2]=r2f(value);
            coefs[3]=r2f(value);
            coefs[4]=r2f(value);
            coefs[5]=r2f(value);
            coefs[6]=r2f(value);
            coefs[7]=r2f(value);
        end
    endtask
    task trackErrors( 
        ref logic [NUM_TESTS-1:0] errors, 
        ref integer testNumber,
        input logic signed [DATA_WIDTH-1:0] macResult,
        input real expectedMacResult );
		
        real macResultReal;        
        macResultReal = f2r(macResult);// onvert macResult to real for comparison
        
        // compare with tolerance for floating-point comparisons
        if ($abs(macResultReal - expectedMacResult) > 0.0001) begin 
            errors = errors | (1 << testNumber);
            $display("Test %0d FAILED: Expected %f, Got %f (Difference: %f)", 
                     testNumber, expectedMacResult, macResultReal, 
                     macResultReal - expectedMacResult);
        end else begin
            $display("Test %0d PASSED: Expected %f, Got %f", 
                     testNumber, expectedMacResult, macResultReal);
        end
        testNumber++;
    endtask
    task reportErrors();
        noOfErrors = 0;
        
        for (integer i=0; i<testNumber; i++) begin
            isAnError = (errors >> i) & 1; // check errors in each test by checking if each bit is set
            if (isAnError) begin
                $display("FAILED TEST NUMBER %0d", i);
                noOfErrors++;
            end
        end

        if (errors == 0) begin
            $display("TEST SUCCESSFUL, NO ERRORS FOUND");
        end else begin 
            $display("TEST FAILED, TOTAL NUMBER OF ERRORS IS %0d", noOfErrors);
        end
    endtask
    
    initial begin
        $display("\n\n-----");
        $monitor("DATA IN: %d %d %d %d %d %d %d %d, MACRESULT: %f EXPECTED MACRESULT: %f", 
            f2r(pDataIn[0]), f2r(pDataIn[1]), f2r(pDataIn[2]), f2r(pDataIn[3]),
            f2r(pDataIn[4]), f2r(pDataIn[5]), f2r(pDataIn[6]), f2r(pDataIn[7]),
            f2r(macResult), expectedMacResult);
        
        errors = 0;
        testNumber = 0;
            
        // Test 1: Random values with coefs = 1
        writeCoefs(1);
        randomPData(pDataIn,1,5);
        expectedMacResult=verifMac(pDataIn,coefs);
        #10;
        trackErrors(errors, testNumber, macResult, expectedMacResult);
        
        // Test 2: Random values with coefs = 0.2
        writeCoefs(0.2);
        randomPData(pDataIn,1,20);
        expectedMacResult=verifMac(pDataIn,coefs);
        #10; 
        trackErrors(errors, testNumber, macResult, expectedMacResult);

        // Test 3: Random values (including negative) with coefs = 0.2
        writeCoefs(0.2);
        randomPData(pDataIn,-20,20);
        expectedMacResult=verifMac(pDataIn,coefs);
        #10;
        trackErrors(errors, testNumber, macResult, expectedMacResult);

        // Test 4: Random values with coefs = 0.1
        writeCoefs(0.1);
        randomPData(pDataIn,1,50);
        expectedMacResult=verifMac(pDataIn,coefs);
        #10; 
        trackErrors(errors, testNumber, macResult, expectedMacResult);

        #10;
        $display("\n\n-----");
        reportErrors();
        $display("\n\n-----");
        $finish;
    end
endmodule