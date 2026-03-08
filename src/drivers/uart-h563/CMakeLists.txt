# UART driver for the STM32H563xx.
# Exposes the 'uart' interface target consumed by the application.

add_library(uart OBJECT
    src/uart.c
)

target_include_directories(uart PUBLIC include)

target_compile_definitions(uart PUBLIC STM32H563xx)
