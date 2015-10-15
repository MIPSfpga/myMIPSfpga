#!/bin/sh

###############################################################################
# make_project.sh
#
# Create the Quartus-II project files for simple flashing LEDs demo
# on the Marsohod2 FPGA board (http://marsohod.org/index.php/prodmarsohod2).
#
# After running this script, use the Makefile in the new project directory to
# build the project and configure the FPGA.
#
###############################################################################

BOARDS=$(ls -1 boards)

if [ "$1" = "" -o ! -f "boards/$1/settings.tcl" ]; then
	echo "Usage:"
	echo "    make_project.sh <board> [<project dir>]"
	echo
	echo "Available boards:"
	for i in $BOARDS; do
		echo "  $i"
	done
	exit
fi

BOARD=$1

PROJECT_NAME="mips-fpga"

# Default relative path to the (future) project directory
PROJECT_PATH=proj
if [ "$2" != "" ]; then
	PROJECT_PATH=$2
fi

# Relative path to the (existing) source directory
SOURCE_PATH=boards/$BOARD

# Relative path and name of the project settings script
SETTINGS_SCRIPT=$SOURCE_PATH/settings.tcl

MAKEFILE_TEMPLATE=scripts/Makefile.template

# We can skip adding quartus/bin/ dir to $PATH.
# Just redefine QUARTUS variable
#QUARTUS=/opt/altera/13.1/quartus/bin/quartus_
QUARTUS=quartus_

BITS="--64bit"

#-------------------------------------------------------#

# Determine how to move between project and source paths
CURRENT_PATH_CAN=$(readlink -m .)
PROJECT_PATH_CAN=$(readlink -m $PROJECT_PATH)
PATH_DIFF=${PROJECT_PATH_CAN#$CURRENT_PATH_CAN}
PATH_LVLS=$(echo $PATH_DIFF | tr -dc '/' | wc -m)
PATH_BACK=$(printf '../%.0s' {1..$PATH_LVLS})

# Fill in the path to the BRAM memory contents file
#sed "s|TODO_INIT_FILE_STRING_TODO|$PATH_BACK$SOURCE_PATH/BRAM/Memory_Contents.mif|g" \
#    $SOURCE_PATH/BRAM/BRAM_64KB/BRAM_64KB.v.template > \
#    $SOURCE_PATH/BRAM/BRAM_64KB/BRAM_64KB.v

# Create the project
mkdir -p $PROJECT_PATH
cd $PROJECT_PATH
${QUARTUS}sh $BITS -t "$PATH_BACK$SETTINGS_SCRIPT" "$PROJECT_NAME" "$PATH_BACK$SOURCE_PATH"
cd $PATH_BACK

# Create the Makefile
sed -e "s|TODO_PROJECT_TODO|$PROJECT_NAME|g" \
    -e "s|TODO_SOURCES_TODO|$PATH_BACK$SOURCE_PATH|g" \
    -e "s|TODO_QUARTUS_TODO|$QUARTUS|g" \
    $MAKEFILE_TEMPLATE > $PROJECT_PATH/Makefile

#
# Suppress some warnings
#   Warning (20028): Parallel compilation is not licensed and has been disabled
#   Warning (292013): Feature LogicLock is only available with a valid subscription license. You can purchase a software subscription to gain full access to this feature.
#

cat <<EOF > $PROJECT_PATH/${PROJECT_NAME}.srf
{ "" "" "" "*" {  } {  } 0 20028 "" 0 0 "Quartus II" 0 -1 0 ""}
{ "" "" "" "*" {  } {  } 0 292013 "" 0 0 "Quartus II" 0 -1 0 ""}
EOF
