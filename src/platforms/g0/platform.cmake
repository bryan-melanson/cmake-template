# ── STM32G0 family platform ───────────────────────────────────────────────────
# Cortex-M0+, no FPU
# STM32_DEVICE selects the chip linker script from linker/chips/.

set(CPU_FLAGS -mcpu=cortex-m0plus -mthumb -mfloat-abi=soft)

add_compile_options(${CPU_FLAGS} -fdata-sections -ffunction-sections)

string(TOLOWER "${STM32_DEVICE}" DEVICE_LOWER)
set(LINKER_DIR ${CMAKE_CURRENT_LIST_DIR}/linker)
add_link_options(${CPU_FLAGS} -Wl,--gc-sections
    -L${LINKER_DIR}
    -T${LINKER_DIR}/chips/${DEVICE_LOWER}.ld
    -lnosys)

# ── GPIO driver submodule ─────────────────────────────────────────────────────
set(GPIO_DRIVER_DIR ${CMAKE_SOURCE_DIR}/src/drivers/gpio-g0b1)

if(NOT EXISTS ${GPIO_DRIVER_DIR}/CMakeLists.txt)
    message(FATAL_ERROR "gpio-g0b1 driver submodule not found.\n"
        "Run: git submodule update --init src/drivers/gpio-g0b1")
endif()

add_subdirectory(${GPIO_DRIVER_DIR} gpio-g0b1)
