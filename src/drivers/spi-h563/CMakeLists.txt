# SPI driver for the STM32H563xx.
# Exposes the 'spi' interface target consumed by the application.

add_library(spi OBJECT
    src/spi.c
)

target_include_directories(spi PUBLIC include)

target_compile_definitions(spi PUBLIC STM32H563xx)
