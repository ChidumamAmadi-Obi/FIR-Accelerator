/* TOP APB WRAPPER TO CONNECT TO THE CV32E40X
*/

`include "constants.svh"
`include "top.sv"

module firAccelerator_wrapper #(
    parameter DATA_WIDTH = `DATA_WIDTH,
    parameter NUM_REGS = `NUM_REGS,
    parameter APB_ADDR_WIDTH = 32, // has to be 32 bits
    parameter APB_DATA_WIDTH = 32 // has to be 32 bits
)(
    // APB interface
    input  logic                      clk_i,
    input  logic                      rst_ni,
    input  logic [APB_ADDR_WIDTH-1:0] paddr_i,
    input  logic                      psel_i,
    input  logic                      penable_i,
    input  logic                      pwrite_i,
    input  logic [APB_DATA_WIDTH-1:0] pwdata_i,
    output logic [APB_DATA_WIDTH-1:0] prdata_o,
    output logic                      pready_o,
    output logic                      pslverr_o,
    
    //direct accelerator interface
    output logic [DATA_WIDTH-1:0]     macResultOut,
    output logic                      resultValidOut
);


    // Control register bits (write this to control reg)
    localparam CTRL_ENABLE_BIT = 0;
    localparam CTRL_COEFF_WR_BIT = 1;
    localparam CTRL_CLEAR_BIT = 2;
    localparam CTRL_START_BIT = 3;

    // Status register bits
    localparam STATUS_VALID_BIT = 0;
    localparam STATUS_BUSY_BIT = 1;

    // Address map, might be changed later
    localparam ADDR_CONTROL  = 8'h00;
    localparam ADDR_STATUS   = 8'h04;
    localparam ADDR_DATA_IN  = 8'h08;
    localparam ADDR_COEFF    = 8'h0C; // can only be 3 bit address need to fix later
    localparam ADDR_RESULT   = 8'h10;

    // nternal signals
    logic accelerateEn;
    logic coeffWriteEn;
    logic [2:0] coeffAddr;
    logic [DATA_WIDTH-1:0] coeffIn;
    logic [DATA_WIDTH-1:0] sensorValIn;
    logic clrCoeffs;

    // reg file for APB access
    logic [DATA_WIDTH-1:0] controlReg;
    logic [DATA_WIDTH-1:0] statusReg;
    logic [DATA_WIDTH-1:0] dataInReg;
    logic [DATA_WIDTH-1:0] coeffRegs [0:NUM_REGS-1];
    logic [DATA_WIDTH-1:0] resultReg;

     // APB state machine
    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin // clear registers
            controlReg <= '0;
            dataInReg <= '0;
            resultReg <= '0;
            for (int i = 0; i < NUM_REGS; i++) begin
                coeffRegs[i] <= '0;
            end
        end else if (psel_i && penable_i && pwrite_i) begin
            case (paddr_i[7:0])
                ADDR_CONTROL: controlReg <= pwdata_i;
                ADDR_DATA_IN: dataInReg <= pwdata_i;
                ADDR_COEFF: begin
                    if (coeffAddr < NUM_REGS) begin
                        coeffRegs[coeffAddr] <= pwdata_i;
                    end
                end
            endcase
        end
    end

    // Read logic
    always_comb begin
        prdata_o = '0;
        if (psel_i && !pwrite_i) begin
            case (paddr_i[7:0])
                ADDR_CONTROL: prdata_o = controlReg;
                ADDR_STATUS:  prdata_o = statusReg;
                ADDR_DATA_IN: prdata_o = dataInReg;
                ADDR_RESULT:  prdata_o = resultReg;
                default:      prdata_o = '0;
            endcase
        end
    end

    // Control signal generation
    assign accelerateEn = controlReg[CTRL_START_BIT];
    assign coeffWriteEn = controlReg[CTRL_COEFF_WR_BIT];
    assign clrCoeffs    = controlReg[CTRL_CLEAR_BIT];
    assign coeffAddr    = paddr_i[4:2]; // Use address bits for coefficient index
    assign sensorValIn  = dataInReg;
    assign coeffIn      = pwdata_i;

    // instantiate top module
    top topModuleInstance(
        .clk(clk_i),
        .rstN(rst_ni),
        .clrC(clrCoeffs),
        .accelerateEn(accelerateEn),
        .coeffWriteEn(coeffWriteEn),
        .coeffAddress(coeffAddr),
        .rawSensorVal(sensorValIn),
        .coeffIn(coeffIn),
        .macResult(resultReg),
        .resultIsValid(statusReg[STATUS_VALID_BIT])
    );

    // APB response
    assign pready_o = 1'b1;  // Always ready
    assign pslverr_o = 1'b0; // No errors
    
    // direct outputs
    assign macResultOut = resultReg;
    assign resultValidOut = statusReg[STATUS_VALID_BIT];


endmodule
