# ── STM32H5 family platform ───────────────────────────────────────────────────
# Cortex-M33, FPU, TrustZone (TZ disabled here)
# STM32_DEVICE selects the chip linker script from linker/chips/.

set(CPU_FLAGS -mcpu=cortex-m33 -mthumb -mfpu=fpv5-sp-d16 -mfloat-abi=hard)

add_compile_options(${CPU_FLAGS} -fdata-sections -ffunction-sections)

string(TOLOWER "${STM32_DEVICE}" DEVICE_LOWER)
set(LINKER_DIR ${CMAKE_CURRENT_LIST_DIR}/linker)
add_link_options(${CPU_FLAGS} -Wl,--gc-sections
    -L${LINKER_DIR}
    -T${LINKER_DIR}/chips/${DEVICE_LOWER}.ld
    -lnosys)

# ── GPIO driver submodule ─────────────────────────────────────────────────────
set(GPIO_DRIVER_DIR ${CMAKE_SOURCE_DIR}/drivers/gpio-h563)

if(NOT EXISTS ${GPIO_DRIVER_DIR}/CMakeLists.txt)
    message(FATAL_ERROR "gpio-h563 driver submodule not found.\n"
        "Run: git submodule update --init drivers/gpio-h563")
endif()

add_subdirectory(${GPIO_DRIVER_DIR} gpio-h563)
