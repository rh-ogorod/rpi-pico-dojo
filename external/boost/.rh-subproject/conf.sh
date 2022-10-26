#!/bin/bash
# shellcheck disable=SC2219,SC2034

readonly SRC_BRANCH=@rh-ogorod/boost-1.80.0

# readonly NPROC=$(let m=$(nproc)-1; ((m > 0)) && echo $m || echo 1)
readonly NPROC=$(nproc)

PRJ_PATH="${SDPATH}"
readonly PRJ_PATH="$(cd "${PRJ_PATH}" && pwd)"

PRJ_ROOT_PATH="${SDPATH}/.."
readonly PRJ_ROOT_PATH="$(cd "${PRJ_ROOT_PATH}" && pwd)"

readonly BLD_PATH="${PRJ_ROOT_PATH}/build"
readonly SRC_PATH="${PRJ_ROOT_PATH}/package"
readonly DST_PATH="${PRJ_ROOT_PATH}/dist"

readonly ARM_NONE_EABI_TOOLCHAIN=`
  `"../../../tools/arm-gnu-toolchain-11.3.rel1-x86_64-arm-none-eabi"
export ARM_NONE_EABI_TOOLCHAIN

BOOST_BUILD_CMD=(headers)
# BOOST_BUILD_CMD+=(stage)
BOOST_BUILD_CMD+=(install)
BOOST_BUILD_CMD+=(-d+2 -q)
BOOST_BUILD_CMD+=("-j${NPROC}")
BOOST_BUILD_CMD+=("--prefix=${DST_PATH}")
# BOOST_BUILD_CMD+=("--prefix=/usr/local/stow/${STOW_NAME}")
# BOOST_BUILD_CMD+=("--build-type=complete")
BOOST_BUILD_CMD+=("--build-dir=${BLD_PATH}")
BOOST_BUILD_CMD+=("--layout=versioned")
# BOOST_BUILD_CMD+=("toolset=gcc-11~c++17")
# BOOST_BUILD_CMD+=("toolset=gcc-11~c++20")
BOOST_BUILD_CMD+=("toolset=gcc-11~arm_none_eabi_c++20")
BOOST_BUILD_CMD+=("variant=release")
BOOST_BUILD_CMD+=("threading=single")
BOOST_BUILD_CMD+=("link=static")
BOOST_BUILD_CMD+=("runtime-link=static")
BOOST_BUILD_CMD+=("--with-system")
BOOST_BUILD_CMD+=("--with-headers")
