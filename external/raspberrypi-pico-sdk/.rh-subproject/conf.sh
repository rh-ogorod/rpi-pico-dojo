#!/bin/bash

readonly NPROC=$(let m=$(nproc)-1; ((m > 0)) && echo $m || echo 1)

PRJ_PATH="${SDPATH}"
readonly PRJ_PATH="$(cd "${PRJ_PATH}" && pwd)"

PRJ_ROOT_PATH="${SDPATH}/.."
readonly PRJ_ROOT_PATH="$(cd "${PRJ_ROOT_PATH}" && pwd)"

readonly BLD_PATH="${PRJ_ROOT_PATH}/build"
readonly SRC_PATH="${PRJ_ROOT_PATH}/package"
readonly DST_PATH="${PRJ_ROOT_PATH}/dist"
