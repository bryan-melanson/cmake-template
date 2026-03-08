# Shared memory overlay service.
# Places SharedMem_t in the .shared_mem NOLOAD section so values
# survive soft resets without being touched by startup zero-init.
# The linker fragment (linker/shared_mem.ld) is included by the family
# linker scripts; its search path is propagated via INTERFACE link options.

add_library(shared_mem OBJECT
    src/shared_mem.c
)

target_include_directories(shared_mem PUBLIC include)

target_link_options(shared_mem INTERFACE
    -L${CMAKE_CURRENT_SOURCE_DIR}/linker
)
