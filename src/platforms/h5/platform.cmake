# ── STM32H5 family platform ───────────────────────────────────────────────────
# Cortex-M33, FPU, TrustZone (TZ disabled here)
# STM32_DEVICE selects the chip linker script from linker/chips/.

set(CPU_FLAGS -mcpu=cortex-m33 -mthumb -mfpu=fpv5-sp-d16 -mfloat-abi=hard)

add_compile_options(${CPU_FLAGS} -fdata-sections -ffunction-sections)

string(TOLOWER "${STM32_DEVICE}" DEVICE_LOWER)
set(LINKER_DIR ${CMAKE_CURRENT_LIST_DIR}/linker)
add_link_options(${CPU_FLAGS} -Wl,--gc-sections
    -specs=nano.specs -specs=nosys.specs
    -L${LINKER_DIR}
    -T${LINKER_DIR}/chips/${DEVICE_LOWER}.ld)

# ── GPIO driver submodule ─────────────────────────────────────────────────────
if(NOT DEFINED GPIO_DRIVER_DIR)
    message(FATAL_ERROR "GPIO_DRIVER_DIR is not set. Set it in your board preset.")
endif()

if(NOT EXISTS ${GPIO_DRIVER_DIR}/CMakeLists.txt)
    message(FATAL_ERROR "GPIO driver submodule not found at ${GPIO_DRIVER_DIR}.\n"
        "Run: git submodule update --init ${GPIO_DRIVER_DIR}")
endif()

add_subdirectory(${GPIO_DRIVER_DIR} gpio-driver)
