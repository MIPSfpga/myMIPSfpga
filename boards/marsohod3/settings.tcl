# Create a Quartus II project for simple flashing LEDs demo
# on the Marsohod2 board.
#
# Arg 1: Project name
# Arg 2: Source directory

if { $::argc != 2 } {
    puts "Error: Insufficient or invalid options passed to script \"[file tail $argv0]\"."
    exit 1
}

set proj [lindex $::argv 0]
# FIXME
set boarddir [lindex $::argv 1]
set family "MAX 10"
set part   "10M50SAE144C8GES"
set top    "Top"

# Create a new project
project_new -family $family -part $part $proj
set_global_assignment -name TOP_LEVEL_ENTITY $top

source ../scripts/marsohodx_list.tcl

marsohodx_list $boarddir $boarddir/LIST
# FIXME
marsohodx_list ../rtl/rtl_up ../rtl/LIST_rtl_up
marsohodx_list ../rtl/mipsfpga-plus ../rtl/LIST_mipsfpga-plus
marsohodx_list ../rtl/uart16550-1.5 ../rtl/LIST_ahb_uart

set_global_assignment -name FLOW_ENABLE_POWER_ANALYZER Off

#set_global_assignment -name GENERATE_CONFIG_SVF_FILE ON
#set_global_assignment -name GENERATE_SVF_FILE ON

set_global_assignment -name USE_CONFIGURATION_DEVICE OFF

# Pin constraints
set_global_assignment -name FLOW_ENABLE_IO_ASSIGNMENT_ANALYSIS ON

set_location_assignment PIN_26 -to CLK100MHZ

#set_location_assignment PIN_130 -to KEY0
#set_instance_assignment -name IO_STANDARD "3.3 V SCHMITT TRIGGER" -to KEY0
#set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to KEY0

set_location_assignment PIN_25 -to KEY1
set_instance_assignment -name IO_STANDARD "3.3 V SCHMITT TRIGGER" -to KEY1
#set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to KEY1

# the nCONFIG, nSTATUS, and CONF_DONE pins are disabled when the device
# operates in user mode and is available as a user I/O pin.
set_global_assignment -name ENABLE_CONFIGURATION_PINS OFF

# the CONFIG_SEL pin are disabled
# when the device operates in user mode and is available as a user I/O pin.
#set_global_assignment -name ENABLE_BOOT_SEL_PIN OFF

set_location_assignment PIN_81 -to LED[7]
set_location_assignment PIN_82 -to LED[6]
set_location_assignment PIN_83 -to LED[5]
set_location_assignment PIN_84 -to LED[4]
set_location_assignment PIN_85 -to LED[3]
set_location_assignment PIN_86 -to LED[2]
set_location_assignment PIN_87 -to LED[1]
set_location_assignment PIN_88 -to LED[0]

set_location_assignment PIN_89 -to IO[0]
set_location_assignment PIN_90 -to IO[1]
set_location_assignment PIN_91 -to IO[2]
set_location_assignment PIN_92 -to IO[3]
set_location_assignment PIN_93 -to IO[4]
set_location_assignment PIN_96 -to IO[5]
set_location_assignment PIN_97 -to IO[6]
set_location_assignment PIN_98 -to IO[7]

set_location_assignment PIN_141 -to FTDI_BD0
set_location_assignment PIN_140 -to FTDI_BD1
set_location_assignment PIN_138 -to FTDI_BD2
set_location_assignment PIN_136 -to FTDI_BD3

#set_global_assignment -name RESERVE_ALL_UNUSED_PINS_WEAK_PULLUP "AS INPUT TRI-STATED"

set_global_assignment -name STRATIX_DEVICE_IO_STANDARD "3.3-V LVTTL"
set_global_assignment -name VCCA_USER_VOLTAGE 3.3V
set_global_assignment -name USE_CONFIGURATION_DEVICE OFF
set_global_assignment -name CYCLONEII_RESERVE_NCEO_AFTER_CONFIGURATION "USE AS REGULAR IO"
set_global_assignment -name RESERVE_DATA0_AFTER_CONFIGURATION "USE AS REGULAR IO"
set_global_assignment -name RESERVE_DATA1_AFTER_CONFIGURATION "USE AS REGULAR IO"
set_global_assignment -name RESERVE_FLASH_NCE_AFTER_CONFIGURATION "USE AS REGULAR IO"
set_global_assignment -name RESERVE_DCLK_AFTER_CONFIGURATION "USE AS REGULAR IO"
set_global_assignment -name OUTPUT_IO_TIMING_NEAR_END_VMEAS "HALF VCCIO" -rise
set_global_assignment -name OUTPUT_IO_TIMING_NEAR_END_VMEAS "HALF VCCIO" -fall
set_global_assignment -name OUTPUT_IO_TIMING_FAR_END_VMEAS "HALF SIGNAL SWING" -rise
set_global_assignment -name OUTPUT_IO_TIMING_FAR_END_VMEAS "HALF SIGNAL SWING" -fall
set_global_assignment -name CYCLONEII_OPTIMIZATION_TECHNIQUE BALANCED
set_global_assignment -name SYNTH_TIMING_DRIVEN_SYNTHESIS ON
set_global_assignment -name SYNCHRONIZER_IDENTIFICATION OFF
set_global_assignment -name TIMEQUEST_DO_CCPP_REMOVAL ON
#set_global_assignment -name ENABLE_OCT_DONE ON
#set_global_assignment -name EXTERNAL_FLASH_FALLBACK_ADDRESS 00000000
#set_global_assignment -name INTERNAL_FLASH_UPDATE_MODE "SINGLE IMAGE WITH ERAM"
