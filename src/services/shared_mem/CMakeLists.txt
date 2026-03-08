# Shared memory overlay module.
# Places SharedMem_t in the .shared_mem NOLOAD section so values
# survive soft resets without being touched by startup zero-init.

add_library(shared_mem OBJECT
    src/shared_mem.c
)

target_include_directories(shared_mem PUBLIC include)
