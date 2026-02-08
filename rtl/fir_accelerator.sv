/* TOP WRAPPER FOR CONNECTION TO THE CPU VIA X-HEEP
*/

`include "top.sv"
`include "constants.svh"

module fir_accelerator(
    input logic clk_i,
    input logic rst_ni,
    input reg_pkg::reg_req_t reg_req_i,
    output reg_pkg::reg_rsp_t reg_rsp_o);

    // x-heep generates a register package for the peripheral
    // based on what is declared in fir_accelerator.hjson
    `include "fir_accelerator_reg_pkg.sv" // include reg package, it is not generated yet
    import fir_accelerator_reg_pkg::*;
    
    fir_accelerator_reg2hw_t reg2hw;  // CPU -> accelerator
    fir_accelerator_hw2reg_t hw2reg;  // accelerator -> CPU
    
    logic busy_wire; // wires
    logic result_valid_wire;
    logic [DATA_WIDTH-1:0] mac_result_wire;
    
    fir_accelerator_reg_top u_reg (
        .clk_i,
        .rst_ni,
        .reg_req_i,
        .reg_rsp_o,
        .reg2hw,
        .hw2reg,
        .devmode_i(1'b1)  // always in device mode
    );
    
    top accelerator ( //connect generated registers to top module
        .clk(clk_i),
        .rstN(rst_ni),
        .clrC(reg2hw.control.clr_c.q),         
        .accelerateEn(reg2hw.control.accelerate_en.q),
        .coeffWriteEn(reg2hw.control.coeff_write_en.q),
        .coeffAddress(reg2hw.coeff_addr.addr.q), 
        .rawSensorVal(reg2hw.sensor_data.sensor.q),
        .coeffIn(reg2hw.coeff_data.coeff.q),     
        .macResult(mac_result_wire),             
        .resultIsValid(result_valid_wire),       
        .busy(busy_wire)                         
    );
   
    assign hw2reg.control.busy.d = busy_wire; // Connect the busy to cntrl register
    assign hw2reg.control.busy.de = 1'b1; 
    assign hw2reg.result.result.d = mac_result_wire; // Connect to result register
    assign hw2reg.result.result.de = result_valid_wire; // Only update the answer when rdy
    assign hw2reg.status.result_valid.d = result_valid_wire; // Connect the ready to status register
    assign hw2reg.status.result_valid.de = 1'b1;
endmodule