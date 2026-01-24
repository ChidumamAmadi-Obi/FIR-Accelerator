`include "constants.svh"

module mac_tb;
    localparam Q_FORMAT = 16;
    localparam SCALE = 1 << Q_FORMAT;  // 65536
    logic signed [`DATA_WIDTH-1:0] pDataIn [0:`NUM_REGS-1];
    logic signed [`DATA_WIDTH-1:0] coefs [0:`NUM_REGS-1];
    logic signed [`DATA_WIDTH-1:0] macResult;
    
	mac dut (
		.pDataIn(pDataIn),
		.coefs(coefs),
		.macResult(macResult)
	);

	// helpter functions
	function automatic logic signed [`DATA_WIDTH-1:0] r2f(real val); // real number to interger
		return int'(val * SCALE + (val >= 0 ? 0.5 : -0.5));
	endfunction

	function automatic logic signed [`DATA_WIDTH-1:0] i2f(int val); // interger to real number
		return val << Q_FORMAT;
	endfunction
	
	function automatic real f2r(logic signed [`DATA_WIDTH-1:0] fixed); // fixed-point to real
		return real'(fixed) / SCALE;
	endfunction
	
	initial begin
		$monitor("DATA IN: %d %d %d %d %d %d %d %d, MACRESULT: %f", pDataIn[0],pDataIn[1],pDataIn[2],pDataIn[3],pDataIn[4],pDataIn[5],pDataIn[6],pDataIn[7],f2r(macResult));
		
		#10
		pDataIn[0]=i2f(1);     coefs[0]=i2f(1);
		pDataIn[1]=i2f(1);     coefs[1]=i2f(1);
		pDataIn[2]=i2f(1);     coefs[2]=i2f(1);
		pDataIn[3]=i2f(1);     coefs[3]=i2f(1);
		pDataIn[4]=i2f(1);     coefs[4]=i2f(1);
		pDataIn[5]=i2f(1);     coefs[5]=i2f(1);
		pDataIn[6]=i2f(1);     coefs[6]=i2f(1);
		pDataIn[7]=i2f(1);     coefs[7]=i2f(1); // macresult = 8
		#10;
		
		pDataIn[0]=i2f(2);     coefs[0]=r2f(0.2);
		pDataIn[1]=i2f(1);     coefs[1]=r2f(0.2);
		pDataIn[2]=i2f(1);     coefs[2]=r2f(0.2);
		pDataIn[3]=i2f(4);     coefs[3]=r2f(0.2);
		pDataIn[4]=i2f(1);     coefs[4]=r2f(0.2);
		pDataIn[5]=i2f(5);     coefs[5]=r2f(0.2);
		pDataIn[6]=i2f(2);     coefs[6]=r2f(0.2);
		pDataIn[7]=i2f(1);     coefs[7]=r2f(0.2); // mac result = 3.4
		#10;
		
		pDataIn[0]=i2f(19);    coefs[0]=i2f(1);
		pDataIn[1]=i2f(14);    coefs[1]=i2f(1);
		pDataIn[2]=i2f(14);    coefs[2]=i2f(1);
		pDataIn[3]=i2f(7);     coefs[3]=i2f(1);
		pDataIn[4]=i2f(16);    coefs[4]=i2f(1);
		pDataIn[5]=i2f(11);    coefs[5]=i2f(1);
		pDataIn[6]=i2f(15);    coefs[6]=i2f(1);
		pDataIn[7]=i2f(12);    coefs[7]=i2f(1); // mac result = 108
		#10;

		$finish;
	end
endmodule