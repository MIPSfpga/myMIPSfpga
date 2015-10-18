#!/bin/bash

set -x
set -e

TOP=$(pwd)

VFILES=""

for i in $(cat rtl/LIST_mipsfpga-plus); do
	VFILES="$VFILES $TOP/rtl/mipsfpga-plus/$i"
done

for i in $(cat rtl/LIST_rtl_up); do
	VFILES="$VFILES $TOP/rtl/rtl_up/$i"
done

for i in $(cat rtl/LIST_ahb_uart); do
	VFILES="$VFILES $TOP/rtl/uart16550-1.5/$i"
done

pushd testbench

rm -f ./a.out mipsfpga_icarus.vcd mfp_testbench.vcd

iverilog -v \
	-o mfp_testbench \
	$VFILES \
	mfp_testbench.v \
	-I $TOP/testbench \
	-I $TOP/rtl/rtl_up \
	-I $TOP/rtl/mipsfpga-plus \
	-DPRESCALER_PRESET_HARD \
	-DPRESCALER_HIGH_PRESET=0 \
	-DPRESCALER_LOW_PRESET=2 \
	-I $TOP/rtl/uart16550-1.5/rtl/verilog \
	-s mfp_testbench

time ./mfp_testbench
gtkwave mfp_testbench.vcd

popd
