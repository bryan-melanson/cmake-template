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

# ── Optional driver submodules ────────────────────────────────────────────────
foreach(_drv GPIO I2C UART SPI DMA CAN)
    set(_dir "${_drv}_DRIVER_DIR")
    if(DEFINED ${_dir})
        if(NOT EXISTS "${${_dir}}/CMakeLists.txt")
            message(FATAL_ERROR "${_drv} driver submodule not found at ${${_dir}}.\n"
                "Run: git submodule update --init ${${_dir}}")
        endif()
        string(TOLOWER "${_drv}" _drv_lower)
        add_subdirectory("${${_dir}}" "${_drv_lower}-driver")
    endif()
endforeach()
