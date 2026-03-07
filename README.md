# STM32 CMake Template

A minimal CMake template for STM32 projects. Selecting a preset pulls in only
that platform's configuration and GPIO driver submodule — other families are
untouched.

## Supported presets

| Preset       | Device       | Core       | Flash  | RAM    | GPIO driver      |
|--------------|--------------|------------|--------|--------|------------------|
| `stm32g071`  | STM32G071xx  | Cortex-M0+ | 128 KB | 36 KB  | `libs/gpio-g0`   |
| `stm32g0b1`  | STM32G0B1xx  | Cortex-M0+ | 512 KB | 144 KB | `libs/gpio-g0`   |
| `stm32h563`  | STM32H563xx  | Cortex-M33 | 512 KB | 256 KB | `libs/gpio-h5`   |

## Quick start

```sh
# Pull only the submodules you need
git submodule update --init libs/gpio-g0 platforms/stm32g0   # for G0
git submodule update --init libs/gpio-h5 platforms/stm32h5   # for H5

# Configure and build
cmake --preset stm32g0b1
cmake --build --preset stm32g0b1
```

Output (`stm32-app.elf`, `.hex`, `.bin`) lands in `build/<preset>/src/`.

## Repository layout

```
├── CMakeLists.txt              # Root: include(cmake/stm32.cmake), add_subdirectory(src)
├── CMakePresets.json           # Includes preset files from each platform submodule
├── cmake/
│   ├── toolchain-arm-none-eabi.cmake
│   └── stm32.cmake             # include(${STM32_PLATFORM_DIR}/platform.cmake)
├── src/
│   ├── CMakeLists.txt          # Links app against 'gpio' target
│   └── main.c
├── platforms/                  # One submodule per STM32 family
│   ├── stm32g0/
│   │   ├── CMakePresets.json   # stm32g071 and stm32g0b1 presets
│   │   ├── platform.cmake      # CPU flags, add_subdirectory(libs/gpio-g0), linker wiring
│   │   └── linker/
│   │       ├── family/g0.ld    # SECTIONS shared by all G0 chips
│   │       └── chips/
│   │           ├── stm32g071xx.ld
│   │           └── stm32g0b1xx.ld
│   └── stm32h5/
│       ├── CMakePresets.json   # stm32h563 preset
│       ├── platform.cmake      # CPU flags, add_subdirectory(libs/gpio-h5), linker wiring
│       └── linker/
│           ├── family/h5.ld
│           └── chips/stm32h563xx.ld
└── libs/                       # Driver repos — pull only the family you need
    ├── gpio-g0/                # git submodule: G0 GPIO driver
    │   ├── CMakeLists.txt      # defines 'gpio' target
    │   ├── include/gpio.h
    │   └── src/gpio.c
    └── gpio-h5/                # git submodule: H5 GPIO driver
        ├── CMakeLists.txt      # defines 'gpio' target
        ├── include/gpio.h
        └── src/gpio.c
```

## How it works

### Preset → platform → driver

`CMakePresets.json` includes preset files from each platform submodule:

```json
{ "version": 6, "include": ["platforms/stm32g0/CMakePresets.json", ...] }
```

Each platform preset sets two cache variables:

```json
"cacheVariables": {
    "STM32_PLATFORM_DIR": "${sourceDir}/platforms/stm32g0",
    "STM32_DEVICE":       "STM32G0B1xx"
}
```

`cmake/stm32.cmake` is a single line:

```cmake
include(${STM32_PLATFORM_DIR}/platform.cmake)
```

`platform.cmake` sets CPU flags, calls `add_subdirectory` on the correct GPIO
driver, and wires up the chip linker script. The other family's driver is never
referenced.

### Driver interface

Each driver exposes a `gpio` CMake target. The application links against it:

```cmake
target_link_libraries(${PROJECT_NAME} PRIVATE gpio)
```

Both driver repos share the same target name so the application `CMakeLists.txt`
needs no conditional logic.

### Linker script overlay

Each chip file defines only its `MEMORY` block and delegates `SECTIONS` to the
shared family script:

```ld
/* stm32g0b1xx.ld */
MEMORY { FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 512K
         RAM  (xrw) : ORIGIN = 0x20000000, LENGTH = 144K }
INCLUDE family/g0.ld
```

## Adding a new chip (same family)

1. Add `platforms/stm32g0/linker/chips/stm32g0c1xx.ld` with the correct `MEMORY`.
2. Add a preset to `platforms/stm32g0/CMakePresets.json` with `STM32_DEVICE: "STM32G0C1xx"`.

## Adding a new family

1. Create a platform repo with `platform.cmake`, `CMakePresets.json`, and `linker/`.
2. Create a driver repo exposing a `gpio` target.
3. Register both in `.gitmodules`.
4. Add the platform preset file to the root `CMakePresets.json` include list.

## Hosting platform/driver repos as proper submodules

The `platforms/` and `libs/` directories are currently tracked as regular files.
To convert them to proper submodules once you have hosted repos:

```sh
git rm -r platforms/stm32g0 libs/gpio-g0
git submodule add https://github.com/YOUR_ORG/stm32-platform-g0 platforms/stm32g0
git submodule add https://github.com/YOUR_ORG/gpio-g0           libs/gpio-g0
# update .gitmodules URLs accordingly
```
