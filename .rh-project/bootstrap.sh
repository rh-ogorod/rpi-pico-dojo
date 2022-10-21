#!/bin/bash

set -eu
set -o pipefail

SDPATH="$(dirname "${BASH_SOURCE[0]}")"
if [[ ! -d "${SDPATH}" ]]; then SDPATH="${PWD}"; fi
readonly SDPATH="$(cd -P "${SDPATH}" && pwd)"

cd "${SDPATH}"; echo cd "${PWD}"

# shellcheck source=./conf.sh
source "${SDPATH}/conf.sh"

CMD=(./git-populate-submodules.sh)
echo + "${CMD[@]}" && "${CMD[@]}"

wait

echo
cd "${PRJ_ROOT_PATH}"; echo cd "${PWD}"

echo
CMD=(mkdir -vp tools)
echo + "${CMD[@]}" && "${CMD[@]}"

echo
CMD=(mkdir -vp .cache)
echo + "${CMD[@]}" && "${CMD[@]}"

echo
cd "${PRJ_ROOT_PATH}/.cache"; echo cd "${PWD}"

echo
CMD=(wget "${TOOLCHAIN_URL}")
echo + "${CMD[@]}" && "${CMD[@]}"

cd "${PRJ_ROOT_PATH}/tools"; echo cd "${PWD}"

echo
CMD=(tar -xJf "${PRJ_ROOT_PATH}/.cache/${TOOLCHAIN_ARC}")
echo + "${CMD[@]}" && "${CMD[@]}"

echo
CMD=(rm "${PRJ_ROOT_PATH}/.cache/${TOOLCHAIN_ARC}")
echo + "${CMD[@]}" && "${CMD[@]}"
