
#include "fir_accelerator_driver.h"

void firEnable(bool en){ // set/clear enable bit in control register
    FIR_ACC_PERIPH->CTRL = (en) ? FIR_ACC_PERIPH->CTRL | (1 << FIR_ACCELERATOR_CONTROL_ACCELERATE_EN_BIT) : FIR_ACC_PERIPH->CTRL &~(1 << FIR_ACCELERATOR_CONTROL_ACCELERATE_EN_BIT);
}
void firCWEnable(bool en){ // set/clear coeff write enable bit in control register
    FIR_ACC_PERIPH->CTRL = (en) ? FIR_ACC_PERIPH->CTRL | (1 << FIR_ACCELERATOR_CONTROL_COEFF_WRITE_EN_BIT) : FIR_ACC_PERIPH->CTRL &~(1 << FIR_ACCELERATOR_CONTROL_COEFF_WRITE_EN_BIT);
}
void firRst(){ //  reset accelerator
    firEnable(false);
    firEnable(true);
    firCClear();
    firRClear();
}
void firCClear(){ // clear coefficient register
    FIR_ACC_PERIPH->CTRL |= ( 1 << FIR_ACCELERATOR_CONTROL_CLR_C_BIT );
    for (int i=0; i<CLEAR_DELAY_US; i++) { /* delay before clearing bit */ asm volatile("nop"); }
    FIR_ACC_PERIPH->CTRL &= ~( 1 << FIR_ACCELERATOR_CONTROL_CLR_C_BIT );
}
void firRClear(){ // clear writeable registers
    FIR_ACC_PERIPH->CDATA=0;
    FIR_ACC_PERIPH->CADDR=0;
}
void firSendData(float dataIn){ // convert data in to fixed point and input into accelerator
    FIR_ACC_PERIPH->DATAI = FL2FP(dataIn);
}
void firLoadCoefficientBatch(float coeffsIn[NUM_COEFF_REGS]) { // write to all coeff registers at once
    firCClear();
    firCWEnable(true);

    for (uint32_t i=0; i<NUM_COEFF_REGS; i++) {
        FIR_ACC_PERIPH->CADDR = i;
        FIR_ACC_PERIPH->CDATA = FL2FP(coeffsIn[i]) ;
    }

    firCWEnable(false);
}

FIRAcceleratorStatus firInit(){ // initiallize accelerator
    firEnable(true); 
    firCWEnable(false);
    firCClear();
    firRClear();

    uint8_t countTimer=0;
    while (!(FIR_ACC_PERIPH->STATUS & ( 1 << FIR_ACCELERATOR_STATUS_RESULT_VALID_BIT))) {
        if (countTimer==TIMEOUT_COUNT) return TIME_OUT; // end with error
        asm volatile("nop");
        countTimer++;
        /*
        wait until valid bit is set
        if timeout return error
        */
    }
    return NONE; // end with no errors
}
FIRAcceleratorStatus firLoadCoefficient(uint8_t coeffAddr, float coeffIn){ // load coefficient into coefficient register file
    // check if invalid address
    if (coeffAddr < C_0 || coeffAddr > C_7) return OUT_OF_BOUNDS;

    firCWEnable(true);

    FIR_ACC_PERIPH->CADDR = (uint32_t)coeffAddr; // input coeff addr
    FIR_ACC_PERIPH->CDATA = FL2FP(coeffIn); // convert to fixed point and input into chosen address

    firCWEnable(false);

    return NONE; // no errors
}
FIRAcceleratorStatus firReadResult(float*dataOut){ // read result in data out register
    if (dataOut == NULL) return INVALID;

    uint8_t countTimer=0;
    while (!(FIR_ACC_PERIPH->STATUS & ( 1 << FIR_ACCELERATOR_STATUS_RESULT_VALID_BIT))) {
        if (countTimer==TIMEOUT_COUNT) return TIME_OUT;
        asm volatile("nop");
        countTimer++;
        /*
        wait until valid bit is set
        if timeout return error
        */
    }

    *dataOut = FP2FL(FIR_ACC_PERIPH->DATAO); // convert fixed point to float before storing
    return NONE;
}