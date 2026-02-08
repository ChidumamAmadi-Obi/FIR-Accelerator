
echo "Generating RTL" # uses regtool and data/fir_accelerator.hjson to generate register package 
${PYTHON} ../../vendor/pulp_platform_register_interface/vendor/lowrisc_opentitan/util/regtool.py -r -t rtl data/fir_accelerator.hjson
echo "Generating SW" # uses regtool and data/fir_accelerator.hjson to generate c header that will be used in the peripheral driver
${PYTHON} ../../vendor/pulp_platform_register_interface/vendor/lowrisc_opentitan/util/regtool.py --cdefines -o ../../../sw/device/lib/drivers/fir_accelerator/fir_accelerator_regs.h data/fir_accelerator.hjson
