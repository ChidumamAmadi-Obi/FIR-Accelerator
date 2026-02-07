/* TOP WRAPPER FOR CONNECTION TO VIA X-HEEP
*/

`include "top.sv"

module fir_accelerator(
    input logic clk_i,
    input logic rst_ni,

    input reg_pkg::reg_req_t reg_req_i, // x-heep Register interface
    output reg_pkg::reg_rsp_t reg_rsp_o    
);

top accelerator (
    .clk(clk_i),
    .rstN(rst_ni),
    .clrC(),
    .accelerateEn(),
    .coeffWriteEn(),
    .coeffAddress(),
    .rawSensorVal(),
    .coeffIn(),
    .macResult(),
    .resultIsValid(),
    .busy()
);

endmodule