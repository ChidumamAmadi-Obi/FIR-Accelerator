`include "helpers.svh"

module accelerator_tb;
    localparam NUM_TESTS = 0;      

	localparam DATA_WIDTH = `DATA_WIDTH;
    parameter APB_ADDR_WIDTH = 32; // has to be 32 bits
    parameter APB_DATA_WIDTH = 32;
  

    localparam CTRL_ENABLE_BIT = 0;
    localparam CTRL_COEFF_WR_BIT = 1;
    localparam CTRL_CLEAR_BIT = 2;
    localparam CTRL_START_BIT = 3;

    localparam STATUS_VALID_BIT = 0;
    localparam STATUS_BUSY_BIT = 1;

    localparam ADDR_CONTROL  = 8'h00;
    localparam ADDR_STATUS   = 8'h04;
    localparam ADDR_DATA_IN  = 8'h08;
    localparam ADDR_COEFF    = 8'h0C;
    localparam ADDR_RESULT   = 8'h10;

    // inputs
    logic clkIn;
    logic rstNIn;
    logic [APB_ADDR_WIDTH-1:0] paddrIn;
    logic pselIn;
    logic penableIn;
    logic pwriteIn;
    logic [APB_DATA_WIDTH-1:0] pwdataIn;

    // outputs
    logic [APB_DATA_WIDTH-1:0] prdataOut;
    logic preadyOut;
    logic pslverrOut;
    logic [DATA_WIDTH-1:0] macResultOut;
    logic resultValidOut;
    
    accelerator accelerateInstance(
        .clk_i(clkIn),
        .rst_ni(rstNIn),
        .paddr_i(paddrIn),
        .psel_i(pselIn),
        .penable_i(penableIn),
        .pwrite_i(pwriteIn),
        .pwdata_i(pwdataIn),
        .prdata_o(prdataOut),
        .pready_o(preadyOut),
        .pslverr_o(pslverrOut),
        .macResultOut(macResultOut),
        .resultValidOut(resultValidOut)
    );

    initial begin
        $monitor("T: %d PRDATA: %d PREADY: %d PSLVERR: %d MACRESULT OUT: %d RESULT VALID: %d ",
        $time,
        prdataOut, preadyOut, pslverrOut, macResultOut, resultIsValid);

        // testing and stuff to be done here later
        $finish;
    end
endmodule