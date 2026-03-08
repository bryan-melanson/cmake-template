# I2C driver for the STM32G0B1xx.
# Exposes the 'i2c' interface target consumed by the application.

add_library(i2c OBJECT
    src/i2c.c
)

target_include_directories(i2c PUBLIC include)

target_compile_definitions(i2c PUBLIC STM32G0B1xx)
