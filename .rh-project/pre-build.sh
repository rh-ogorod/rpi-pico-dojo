#!/bin/bash

set -eu
set -o pipefail

SDPATH="$(dirname "${BASH_SOURCE[0]}")"
if [[ ! -d "${SDPATH}" ]]; then SDPATH="${PWD}"; fi
readonly SDPATH="$(cd -P "${SDPATH}" && pwd)"

# shellcheck source=./conf.sh
source "${SDPATH}/conf.sh"

cd "${PRJ_ROOT_PATH}"; echo + cd "${PWD}"

CMD=(./external/boost/.rh-subproject/b2.sh)
echo + "${CMD[@]}" && "${CMD[@]}"

echo
CMD=(./external/range-v3/.rh-subproject/cmake-all.sh)
echo + "${CMD[@]}" && "${CMD[@]}"
