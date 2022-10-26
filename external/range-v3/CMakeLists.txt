cmake_minimum_required(VERSION 3.12)

include(pico_sdk_import.cmake)

project(Range-v3-proxy C CXX ASM)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 20)

if (PICO_SDK_VERSION_STRING VERSION_LESS "1.3.0")
  message(FATAL_ERROR "Raspberry Pi Pico SDK version 1.3.0 (or later) required. Your version is ${PICO_SDK_VERSION_STRING}")
endif()

# Initialize the SDK
pico_sdk_init()

add_compile_options(-Wall
  -Wno-format          # int != int32_t as far as the compiler is concerned because gcc has int32_t as long int
  -Wno-unused-function # we have some for the docs that aren't called
  -Wno-maybe-uninitialized
  )

add_subdirectory(package)
