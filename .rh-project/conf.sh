#!/bin/bash
# shellcheck disable=SC2219,SC2034

PRJ_ROOT_PATH="${SDPATH}/.."
readonly PRJ_ROOT_PATH="$(cd "${PRJ_ROOT_PATH}" && pwd)"

readonly TOOLCHAIN_NAME=arm-gnu-toolchain-11.3.rel1-x86_64-arm-none-eabi
readonly TOOLCHAIN_ARC=${TOOLCHAIN_NAME}.tar.xz

# shellcheck disable=SC2155
readonly TOOLCHAIN_URL=https://developer.arm.com/-/media/Files/downloads/gnu/`
  `11.3.rel1/binrel/${TOOLCHAIN_ARC}

readonly TOOLCHAIN_PATH=${PRJ_ROOT_PATH}/tools/${TOOLCHAIN_NAME}

readonly PICO_SDK_PATH=${PRJ_ROOT_PATH}/external/raspberrypi-pico-sdk/package
readonly PICO_TOOLCHAIN_PATH=${TOOLCHAIN_PATH}

readonly BLD_PATH="${PRJ_ROOT_PATH}/build"

readonly NPROC=$(nproc)
