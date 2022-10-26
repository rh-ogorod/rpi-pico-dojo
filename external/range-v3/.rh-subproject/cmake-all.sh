#!/bin/bash

set -eu
set -o pipefail

SDPATH="$(dirname "${BASH_SOURCE[0]}")"
if [[ ! -d "${SDPATH}" ]]; then SDPATH="${PWD}"; fi
readonly SDPATH="$(cd -P "${SDPATH}" && pwd)"

cd "${SDPATH}"; echo + cd "${PWD}"

CMD=(./cmake.sh)
echo + "${CMD[@]}" && "${CMD[@]}"

echo
CMD=(./cmake-build.sh)
echo + "${CMD[@]}" && "${CMD[@]}"

echo
CMD=(./cmake-install.sh)
echo + "${CMD[@]}" && "${CMD[@]}"
