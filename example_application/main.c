/* FIR ACCELERATOR EXAMPLE PROGRAM

*/

#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>

#include "core_v_mini_mcu.h"
#include "terminal_colors.h"
#include "fir_accelerator_driver.h" 

#define NUM_SENSOR_VALUES 20 // number of values to be filtered by fir accelerator (needs to be > 8)

FIRAcceleratorStatus errorCode;

float sensorValues(uint32_t max){ // emulate incoming sensor values by generating random numbers
    return (float)(rand() % (max + 1)); // gen random values between max and 0
}

int main(int argc, char *argv[]){
    COLOR_BOLD_YELLOW // change color output so i can see
    printf("\n\n FIR ACCELERATOR EXAMPLE PROGRAM \n");
    COLOR_YELLOW

    // **********************************************************************

    firInit();
    if (errorCode != NONE) printf("ERROR, FAILED TO INITIALIZE ACCELERATOR");
    float coefficients[8] = {0.1, 0.2, 0.3, 0.4, 0.3, 0.2, 0.1, 0.05};
    float incomingSensorValue=0;
    float filteredSensorValue=0;
    firLoadCoefficientBatch(coefficients);

    for (int i=0; i<NUM_SENSOR_VALUES; i++) {
        incomingSensorValue=sensorValues(10);
        firSendData(incomingSensorValue);
        errorCode = firReadResult(&filteredSensorValue);

        if (errorCode != NONE) printf("ERROR, NULL POINTER PASSES INTO DRIVER");

        printf("Incoming Sensor Value: %f Filtered Sensor Value: %f\n");
    }
    COLOR_RESET
    return EXIT_SUCCESS;
}