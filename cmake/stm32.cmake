if(NOT DEFINED STM32_PLATFORM_DIR)
    message(FATAL_ERROR "STM32_PLATFORM_DIR is not set. Configure with a preset:\n"
        "  cmake --preset stm32g071\n"
        "  cmake --preset stm32g0b1\n"
        "  cmake --preset stm32h563")
endif()

include(${STM32_PLATFORM_DIR}/platform.cmake)
