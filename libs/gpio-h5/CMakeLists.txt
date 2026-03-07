# GPIO driver for the STM32H5 family.
# Exposes the 'gpio' interface target consumed by the application.

add_library(gpio STATIC
    src/gpio.c
)

target_include_directories(gpio PUBLIC include)

target_compile_definitions(gpio PUBLIC STM32H5)
