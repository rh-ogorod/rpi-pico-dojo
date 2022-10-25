include_directories(${Boost_INCLUDE_DIRS})

add_executable(picow_blink
  src/picow_blink.c
  )

target_link_libraries(picow_blink
  # for core functionality
  pico_stdlib
  # we need Wifi to access the GPIO, but we don't need anything else
  pico_cyw43_arch_none
  Boost::headers
  Boost::system
  range-v3::range-v3
  )

# create map/bin/hex file etc.
pico_add_extra_outputs(picow_blink)

# add url via pico_set_program_url
# example_auto_set_url(picow_blink)
