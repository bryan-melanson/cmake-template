# CAN driver for the STM32G0B1xx.
# Exposes the 'can' interface target consumed by the application.

add_library(can OBJECT
    src/can.c
)

target_include_directories(can PUBLIC include)

target_compile_definitions(can PUBLIC STM32G0B1xx)
