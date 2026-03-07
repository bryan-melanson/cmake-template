# Generic LED service.
# Platform-agnostic: depends on the 'gpio' target which is defined by
# whichever platform-specific gpio submodule the active preset selects.

add_library(led OBJECT
    src/led.c
)

target_include_directories(led PUBLIC include)

target_link_libraries(led PUBLIC gpio)
