#!/bin/bash

set -eu
set -o pipefail

SDPATH="$(dirname "${BASH_SOURCE[0]}")"
if [[ ! -d "${SDPATH}" ]]; then SDPATH="${PWD}"; fi
readonly SDPATH="$(cd -P "${SDPATH}" && pwd)"

# shellcheck source=./conf.sh
source "${SDPATH}/conf.sh"

export PICO_SDK_PATH=${PRJ_ROOT_PATH}/external/raspberrypi-pico-sdk/package
# export BOOST_ROOT=${PRJ_ROOT_PATH}/external/boost/dist

export PICO_TOOLCHAIN_PATH=${TOOLCHAIN_PATH}

# export CMAKE_C_COMPILER=${TOOLCHAIN_PATH}/bin/arm-none-eabi-gcc
# export CMAKE_CXX_COMPILER=${TOOLCHAIN_PATH}/bin/arm-none-eabi-g++

echo
CMD=(mkdir -vp "${BLD_PATH}")
echo + "${CMD[@]}" && "${CMD[@]}"

cd "${BLD_PATH}"; echo + cd "${PWD}"

echo
CMD=(cmake)
CMD+=("-DPICO_PLATFORM=rp2040")
CMD+=("-DPICO_BOARD=pico_w")
# CMD+=("-DWIFI_SSID=Your_Network")
# CMD+=("-DWIFI_PASSWORD=Your_Password")
CMD+=("-DPICO_STDIO_UART=false")
CMD+=("-DPICO_STDIO_USB=true")
CMD+=("-DCMAKE_EXPORT_COMPILE_COMMANDS=true")
CMD+=("-DCMAKE_VERBOSE_MAKEFILE=true")
CMD+=(${PRJ_ROOT_PATH})
echo + "${CMD[@]}" && "${CMD[@]}"
