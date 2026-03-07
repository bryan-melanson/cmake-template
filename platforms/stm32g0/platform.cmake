# ── STM32G0 platform ─────────────────────────────────────────────────────────
# Cortex-M0+, no FPU

set(CPU_FLAGS -mcpu=cortex-m0plus -mthumb -mfloat-abi=soft)

add_compile_options(${CPU_FLAGS} -fdata-sections -ffunction-sections)

string(TOLOWER "${STM32_DEVICE}" DEVICE_LOWER)
set(LINKER_DIR ${CMAKE_CURRENT_LIST_DIR}/linker)
add_link_options(${CPU_FLAGS} -Wl,--gc-sections -specs=nosys.specs
    -L${LINKER_DIR}
    -T${LINKER_DIR}/chips/${DEVICE_LOWER}.ld)

# ── GPIO driver submodule ─────────────────────────────────────────────────────
set(GPIO_DRIVER_DIR ${CMAKE_SOURCE_DIR}/libs/gpio-g0)

if(NOT EXISTS ${GPIO_DRIVER_DIR}/CMakeLists.txt)
    message(FATAL_ERROR "gpio-g0 driver submodule not found.\n"
        "Run: git submodule update --init libs/gpio-g0")
endif()

add_subdirectory(${GPIO_DRIVER_DIR} gpio-g0)
