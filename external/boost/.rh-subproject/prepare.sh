#!/bin/bash

set -eu
set -o pipefail

SDPATH="$(dirname "${BASH_SOURCE[0]}")"
if [[ ! -d "${SDPATH}" ]]; then SDPATH="${PWD}"; fi
readonly SDPATH="$(cd -P "${SDPATH}" && pwd)"

# shellcheck source=./conf.sh
source "${SDPATH}/conf.sh"

cd "${SRC_PATH}"; echo + cd "${PWD}"

echo
CMD=(echo)
# CMD+=('"using mpi : : <find-shared-library>impi ;"')
CMD+=('"using mpi ;"')
CMD+=("> tools/build/src/user-config.jam")
echo + "${CMD[@]}" && eval "${CMD[@]}"

CMD=(echo)
CMD+=('"using gcc : 11~c++17 : g++-11 : <cxxflags>\"-std=c++17 -fpermissive\" ;"')
CMD+=(">> tools/build/src/user-config.jam")
echo + "${CMD[@]}" && eval "${CMD[@]}"

CMD=(echo)
CMD+=('"using gcc : 11~c++20 : g++-11 : <cxxflags>-std=c++20 ;"')
CMD+=(">> tools/build/src/user-config.jam")
echo + "${CMD[@]}" && eval "${CMD[@]}"

CMD=(echo -e)
CMD+=('"\nimport os ;"')
CMD+=(">> tools/build/src/user-config.jam")
echo + "${CMD[@]}" && eval "${CMD[@]}"

CMD=(echo -e)
CMD+=('"\nlocal ARM_NONE_EABI_TOOLCHAIN = `
  `[ os.environ ARM_NONE_EABI_TOOLCHAIN ] ;"')
CMD+=(">> tools/build/src/user-config.jam")
echo + "${CMD[@]}" && eval "${CMD[@]}"

CMD=(echo -e)
CMD+=('"\nusing gcc : 11~arm_none_eabi_c++20 :\n`
  `\$(ARM_NONE_EABI_TOOLCHAIN)/bin/arm-none-eabi-g++ :\n`
  `<cxxflags>-std=c++20 ;"')
CMD+=(">> tools/build/src/user-config.jam")
echo + "${CMD[@]}" && eval "${CMD[@]}"
