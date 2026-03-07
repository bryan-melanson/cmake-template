cmake_minimum_required(VERSION 3.25)

project(stm32-app C ASM)

include(cmake/stm32.cmake)

add_subdirectory(src)
