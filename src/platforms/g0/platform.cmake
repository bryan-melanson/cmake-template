# ── STM32G0 family platform ───────────────────────────────────────────────────
# Cortex-M0+, no FPU
# STM32_DEVICE selects the chip linker script from linker/chips/.

set(CPU_FLAGS -mcpu=cortex-m0plus -mthumb -mfloat-abi=soft)

add_compile_options(${CPU_FLAGS} -fdata-sections -ffunction-sections)

string(TOLOWER "${STM32_DEVICE}" DEVICE_LOWER)
set(LINKER_DIR ${CMAKE_CURRENT_LIST_DIR}/linker)
add_link_options(${CPU_FLAGS} -Wl,--gc-sections
    -L${LINKER_DIR}
    -T${LINKER_DIR}/chips/${DEVICE_LOWER}.ld)

# ── CMSIS device headers ──────────────────────────────────────────────────────
if(DEFINED CMSIS_DIR)
    add_library(device_headers INTERFACE)
    target_include_directories(device_headers INTERFACE
        "${CMSIS_DIR}/Include"
        "${CMSIS_DIR}/Device/ST/STM32G0xx/Include"
    )
    target_compile_definitions(device_headers INTERFACE ${STM32_DEVICE})
endif()

# ── Optional services ─────────────────────────────────────────────────────────
if(DEFINED SHARED_MEM)
    add_subdirectory(${CMAKE_SOURCE_DIR}/src/services/shared_mem shared_mem)
endif()

# ── Optional driver submodules ────────────────────────────────────────────────
foreach(_drv GPIO I2C UART SPI DMA CAN CRC)
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
