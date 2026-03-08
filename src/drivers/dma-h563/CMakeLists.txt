# DMA driver for the STM32H563xx.
# Exposes the 'dma' interface target consumed by the application.

add_library(dma OBJECT
    src/dma.c
)

target_include_directories(dma PUBLIC include)

target_compile_definitions(dma PUBLIC STM32H563xx)
