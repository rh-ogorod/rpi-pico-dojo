#!/bin/bash

set -eu
set -o pipefail

SDPATH="$(dirname "${BASH_SOURCE[0]}")"
if [[ ! -d "${SDPATH}" ]]; then SDPATH="${PWD}"; fi
readonly SDPATH="$(cd -P "${SDPATH}" && pwd)"

# shellcheck source=./conf.sh
source "${SDPATH}/conf.sh"

export PICO_SDK_PATH=../../raspberrypi-pico-sdk/package
export PICO_TOOLCHAIN_PATH=../../../tools/arm-gnu-toolchain-11.3.rel1-x86_64-arm-none-eabi

echo
CMD=(mkdir -vp "${BLD_PATH}")
echo + "${CMD[@]}" && "${CMD[@]}"

cd "${BLD_PATH}"; echo + cd "${PWD}"

echo
CMD=(cmake)
CMD+=("-DCMAKE_INSTALL_PREFIX=${DST_PATH}")
CMD+=("-DPICO_BOARD=pico_w")
CMD+=("-DPICO_STDIO_UART=false")
CMD+=("-DPICO_STDIO_USB=true")
CMD+=("-DCMAKE_EXPORT_COMPILE_COMMANDS=true")
CMD+=("-DCMAKE_VERBOSE_MAKEFILE=true")
CMD+=(../package)
echo + "${CMD[@]}" && "${CMD[@]}"
