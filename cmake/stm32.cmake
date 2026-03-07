if(NOT DEFINED STM32_FAMILY)
    message(FATAL_ERROR "STM32_FAMILY is not set. Configure with a preset:\n"
        "  cmake --preset stm32g0\n"
        "  cmake --preset stm32h5")
endif()

string(TOUPPER "${STM32_FAMILY}" STM32_FAMILY)
string(TOUPPER "${STM32_DEVICE}" STM32_DEVICE)

if(STM32_FAMILY STREQUAL "G0")
    include(cmake/families/g0.cmake)
elseif(STM32_FAMILY STREQUAL "H5")
    include(cmake/families/h5.cmake)
else()
    message(FATAL_ERROR "Unsupported STM32_FAMILY: ${STM32_FAMILY}. Add a file in cmake/families/.")
endif()
