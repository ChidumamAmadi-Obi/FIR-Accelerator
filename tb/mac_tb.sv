`include "constants.svh"

module mac_tb;
  reg [`DATA_WIDTH-1:0] pDataIn [0:`NUM_REGS-1];
  reg [`DATA_WIDTH-1:0] coefs [0:`NUM_REGS-1];
  wire [`DATA_WIDTH-1:0] macResult;
  
  mac dut (
    .pDataIn(pDataIn),
    .coefs(coefs),
    .macResult(macResult)
  );
  
  initial begin
    $monitor("DATA IN: %d %d %d %d %d %d %d %d, MACRESULT: %d", pDataIn[0],pDataIn[1],pDataIn[2],pDataIn[3],pDataIn[4],pDataIn[5],pDataIn[6],pDataIn[7],macResult);
    
    #10
    pDataIn[0]=1;     coefs[0]=1;
    pDataIn[1]=1;     coefs[1]=1;
    pDataIn[2]=1;     coefs[2]=1;
    pDataIn[3]=1;     coefs[3]=1;
    pDataIn[4]=1;     coefs[4]=1;
    pDataIn[5]=1;     coefs[5]=1;
    pDataIn[6]=1;     coefs[6]=1;
    pDataIn[7]=1;     coefs[7]=1;
    #10;
    
    pDataIn[0]=2;     coefs[0]=1;
    pDataIn[1]=1;     coefs[1]=1;
    pDataIn[2]=1;     coefs[2]=1;
    pDataIn[3]=4;     coefs[3]=1;
    pDataIn[4]=1;     coefs[4]=1;
    pDataIn[5]=5;     coefs[5]=1;
    pDataIn[6]=2;     coefs[6]=1;
    pDataIn[7]=1;     coefs[7]=1;
    #10;
    
    pDataIn[0]=19;     coefs[0]=1;
    pDataIn[1]=14;     coefs[1]=1;
    pDataIn[2]=14;     coefs[2]=1;
    pDataIn[3]=7;      coefs[3]=1;
    pDataIn[4]=16;     coefs[4]=1;
    pDataIn[5]=11;     coefs[5]=1;
    pDataIn[6]=15;     coefs[6]=1;
    pDataIn[7]=12;     coefs[7]=1;
    #10;

    $finish;
  end
endmodule