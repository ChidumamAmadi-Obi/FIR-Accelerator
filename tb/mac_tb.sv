`include "helpers.svh"

module mac_tb;
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
  
    task automatic randomPData( // get random values for p data in
      ref logic signed [DATA_WIDTH-1:0] pData_array [0:NUM_REGS-1],
      input int min,
      input int max );
        for (integer i=0; i<NUM_REGS; i++) begin
            pData_array[i] = i2f($urandom_range(min, max));
        end
    endtask
    task automatic writeCoefs(
      ref logic signed [DATA_WIDTH-1:0] coefs [0:NUM_REGS-1],
      input real value );  // Declare as real type

        if (value == $floor(value)) begin // if value is an integer
            for (int i = 0; i < NUM_REGS; i++) begin
                coefs[i] = i2f(int'(value));  // Cast to int before conversion
            end
        end else begin 
            for (int i = 0; i < NUM_REGS; i++) begin
                coefs[i] = r2f(value);
            end
        end
    endtask
    task trackErrors( // track errors for mac module only
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
            
        // no 1: Random values with coefs = 1
        writeCoefs(coefs,1);
        randomPData(pDataIn,1,5);
        expectedMacResult=verifMac(pDataIn,coefs);
        #10;
        trackErrors(errors, testNumber, macResult, expectedMacResult);
        
        // no 2: Random values with coefs = 0.2
        writeCoefs(coefs,0.2);
        randomPData(pDataIn,1,20);
        expectedMacResult=verifMac(pDataIn,coefs);
        #10; 
        trackErrors(errors, testNumber, macResult, expectedMacResult);

        // no 3: Random values (including negative) with coefs = 0.2
        writeCoefs(coefs,0.2);
        randomPData(pDataIn,-20,20);
        expectedMacResult=verifMac(pDataIn,coefs);
        #10;
        trackErrors(errors, testNumber, macResult, expectedMacResult);

        // no 4: Random values with coefs = 0.1
        writeCoefs(coefs,0.1);
        randomPData(pDataIn,1,50);
        expectedMacResult=verifMac(pDataIn,coefs);
        #10; 
        trackErrors(errors, testNumber, macResult, expectedMacResult);

        #10;
        $display("\n-----");
        reportErrors();
         $display("-----\n\n");
        $finish;
    end
endmodule