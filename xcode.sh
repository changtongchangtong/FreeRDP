#!/bin/bash
# Xcode generated files directory
XCODE_PROJ_DIR=xcode
# MacFreeRDP client directory
CLIENT_MAC_DIR=./client/Mac/
pushd .

GEN='Xcode'

# Build settings
ARCH=-DCMAKE_OSX_ARCHITECTURES="${CMAKE_OSX_ARCHITECTURES:-x86_64}"
BUILDTYPE=-DCMAKE_BUILD_TYPE="${CMAKE_BUILD_TYPE:Debug;Release}"
MANPAGES=-DWITH_MANPAGES="${WITHMANPAGES:NO}"
CUPS=-DWITH_CUPS="${WITHCUPS:NO}"

# Run cmake for FreeRDP and MacFreeRDP
mkdir ${XCODE_PROJ_DIR} >/dev/null 2>&1 
pushd ${XCODE_PROJ_DIR}
cmake ${BUILDTYPE} -G "$GEN" ${ARCH} ../
popd
mkdir ${CLIENT_MAC_DIR}/${XCODE_PROJ_DIR} >/dev/null 2>&1 
pushd ${CLIENT_MAC_DIR}/${XCODE_PROJ_DIR}
cmake ${BUILDTYPE} -G "$GEN" ${ARCH} ../
popd

# Check for errors; otherwise, ask for compile.
if [ "$?" -ne 0 ]; then
    echo "CMake failed. Please check error messages"
    popd > /dev/null
    exit
else
    popd
    while true
	do
		echo -n "Compile FreeRDP? (y or n) - (y recommended for MacFreeRDP compilation):"
	read CONFIRM
	case $CONFIRM in
	y|Y|YES|yes|Yes)
		pushd ./${XCODE_PROJ_DIR}
		xcodebuild || exit 1
		popd
		break ;;
	n|N|no|NO|No)
		echo OK - you entered $CONFIRM
		break
	;;
	*) echo Please enter only y or n
	esac
	done
	
	echo "SUCCESS!" 
	while true
	do
	echo -n "Open Xcode projects now? (y or n):"
	read CONFIRM
	case $CONFIRM in
	y|Y|YES|yes|Yes)
		open ${CLIENT_MAC_DIR}/${XCODE_PROJ_DIR}/MacFreeRDP.xcodeproj
		open ./${XCODE_PROJ_DIR}/FreeRDP.xcodeproj
		break ;;
	n|N|no|NO|No)
		echo OK - $CONFIRM
		break
	;;
	*) echo Please enter only y or n
	esac
	done

	echo -n "NOTE: Dragging FreeRDP project from finder onto the MacFreeRDP project in Xcode
      will enable code stepping from MacFreeRDP into FreeRDP.
"
fi
