#!/bin/bash
# shellcheck disable=SC2219,SC2034

readonly TOOLCHAIN_NAME=arm-gnu-toolchain-11.3.rel1-x86_64-arm-none-eabi
readonly TOOLCHAIN_ARC=${TOOLCHAIN_NAME}.tar.xz

PRJ_ROOT_PATH="${SDPATH}/.."
readonly PRJ_ROOT_PATH="$(cd "${PRJ_ROOT_PATH}" && pwd)"

TOOLCHAIN_PATH=${PRJ_ROOT_PATH}/../../tools/${TOOLCHAIN_NAME}
readonly TOOLCHAIN_PATH="$(cd "${TOOLCHAIN_PATH}" && pwd)"

PICO_SDK_PATH=${PRJ_ROOT_PATH}/../../external/raspberrypi-pico-sdk/package
readonly PICO_SDK_PATH="$(cd "${PICO_SDK_PATH}" && pwd)"

readonly PICO_TOOLCHAIN_PATH=${TOOLCHAIN_PATH}

readonly BLD_PATH="${PRJ_ROOT_PATH}/build"
readonly DST_PATH="${PRJ_ROOT_PATH}/dist"

NPROC=$(nproc)
