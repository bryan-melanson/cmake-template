cmake_minimum_required(VERSION 3.25)

project(stm32-app C ASM)

include(cmake/stm32.cmake)

# Generate .vscode/tasks.json from the active preset
file(MAKE_DIRECTORY ${CMAKE_SOURCE_DIR}/.vscode)
configure_file(cmake/tasks.json.in ${CMAKE_SOURCE_DIR}/.vscode/tasks.json @ONLY)

# Generic drivers (platform-agnostic; depend on targets set up by stm32.cmake)
add_subdirectory(drivers/led)

add_executable(${PROJECT_NAME} main.c)

target_link_libraries(${PROJECT_NAME} PRIVATE led)

add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_SIZE} $<TARGET_FILE:${PROJECT_NAME}>)

add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O ihex   $<TARGET_FILE:${PROJECT_NAME}> ${PROJECT_NAME}.hex
    COMMAND ${CMAKE_OBJCOPY} -O binary $<TARGET_FILE:${PROJECT_NAME}> ${PROJECT_NAME}.bin)
