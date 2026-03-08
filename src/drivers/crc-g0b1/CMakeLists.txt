# CRC driver for the STM32G0B1xx.
# Exposes the 'crc' interface target consumed by the application.

add_library(crc OBJECT
    src/crc.c
)

target_include_directories(crc PUBLIC include)

target_compile_definitions(crc PUBLIC STM32G0B1xx)
