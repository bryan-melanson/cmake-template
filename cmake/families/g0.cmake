# ── STM32G0 family ───────────────────────────────────────────────────────────
# Cortex-M0+, no FPU
set(CPU_FLAGS -mcpu=cortex-m0plus -mthumb -mfloat-abi=soft)

add_compile_options(${CPU_FLAGS} -fdata-sections -ffunction-sections)

# -L adds the linker search path so chip scripts can INCLUDE family/g0.ld
string(TOLOWER "${STM32_DEVICE}" DEVICE_LOWER)
add_link_options(${CPU_FLAGS} -Wl,--gc-sections -specs=nosys.specs
    -L${CMAKE_SOURCE_DIR}/linker
    -T${CMAKE_SOURCE_DIR}/linker/chips/${DEVICE_LOWER}.ld)

# ── Submodule paths ───────────────────────────────────────────────────────────
set(CUBE_DIR     ${CMAKE_SOURCE_DIR}/libs/STM32CubeG0)
set(HAL_DIR      ${CUBE_DIR}/Drivers/STM32G0xx_HAL_Driver)
set(CMSIS_DEV    ${CUBE_DIR}/Drivers/CMSIS/Device/ST/STM32G0xx)
set(CMSIS_CORE   ${CUBE_DIR}/Drivers/CMSIS/Include)
set(STARTUP_FILE ${CMSIS_DEV}/Source/Templates/gcc/startup_${DEVICE_LOWER}.s)

if(NOT EXISTS ${HAL_DIR})
    message(FATAL_ERROR "STM32CubeG0 submodule not found.\n"
        "Run: git submodule update --init libs/STM32CubeG0")
endif()

# ── HAL static library ────────────────────────────────────────────────────────
file(GLOB HAL_SOURCES ${HAL_DIR}/Src/*.c)

add_library(stm32_hal STATIC ${HAL_SOURCES} ${STARTUP_FILE})

target_include_directories(stm32_hal PUBLIC
    ${HAL_DIR}/Inc
    ${CMSIS_DEV}/Include
    ${CMSIS_CORE}
    ${CMAKE_SOURCE_DIR}/src   # hal_conf header lives here
)

target_compile_definitions(stm32_hal PUBLIC
    ${STM32_DEVICE}
    USE_HAL_DRIVER
)
