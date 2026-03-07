# STM32 CMake Template

A minimal CMake template for STM32 projects. Selecting a preset pulls in only
that platform's configuration and HAL submodule — other families are untouched.

## Supported presets

| Preset       | Device       | Core       | Flash  | RAM    |
|--------------|--------------|------------|--------|--------|
| `stm32g071`  | STM32G071xx  | Cortex-M0+ | 128 KB | 36 KB  |
| `stm32g0b1`  | STM32G0B1xx  | Cortex-M0+ | 512 KB | 144 KB |
| `stm32h563`  | STM32H563xx  | Cortex-M33 | 512 KB | 256 KB |

## Quick start

```sh
# Pull only the submodules you need
git submodule update --init libs/STM32CubeG0    # for G0 chips
git submodule update --init platforms/stm32g0

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
│   ├── CMakeLists.txt
│   ├── main.c
│   ├── stm32g0xx_hal_conf.h
│   └── stm32h5xx_hal_conf.h
├── platforms/                  # One submodule per STM32 family
│   ├── stm32g0/
│   │   ├── CMakePresets.json   # stm32g071 and stm32g0b1 presets
│   │   ├── platform.cmake      # CPU flags, HAL library target, linker wiring
│   │   └── linker/
│   │       ├── family/g0.ld    # SECTIONS shared by all G0 chips
│   │       └── chips/
│   │           ├── stm32g071xx.ld   # MEMORY + INCLUDE family/g0.ld
│   │           └── stm32g0b1xx.ld
│   └── stm32h5/
│       ├── CMakePresets.json   # stm32h563 preset
│       ├── platform.cmake
│       └── linker/
│           ├── family/h5.ld
│           └── chips/stm32h563xx.ld
└── libs/                       # STM32Cube HAL repos (one per family)
    ├── STM32CubeG0/            # git submodule
    └── STM32CubeH5/            # git submodule
```

## How it works

### Preset → platform → chip

`CMakePresets.json` simply includes the preset files from each platform submodule:

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

`platform.cmake` sets CPU flags, builds `stm32_hal` from the correct STM32Cube
submodule, and points to the chip-specific linker script — all using
`CMAKE_CURRENT_LIST_DIR` so paths are self-contained within the platform repo.

### Linker script overlay

Each chip file defines only its `MEMORY` block and delegates the `SECTIONS`
layout to the shared family file:

```ld
/* stm32g0b1xx.ld */
MEMORY { FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 512K
         RAM  (xrw) : ORIGIN = 0x20000000, LENGTH = 144K }
INCLUDE family/g0.ld
```

`-L${LINKER_DIR}` is passed at link time so the `INCLUDE` resolves correctly.

## Adding a new chip (same family)

1. Add `platforms/stm32g0/linker/chips/stm32g0c1xx.ld` with the correct `MEMORY`.
2. Add a preset to `platforms/stm32g0/CMakePresets.json` with `STM32_DEVICE: "STM32G0C1xx"`.

## Adding a new family

1. Create a new platform repo with `platform.cmake`, `CMakePresets.json`, and `linker/`.
2. Add the STM32Cube repo under `libs/`.
3. Register both in `.gitmodules`.
4. Add `"platforms/<family>/CMakePresets.json"` to the root `CMakePresets.json` include list.

## Hosting platform repos as proper submodules

The `platforms/` directories are currently tracked as regular files. To convert
them to proper submodules once you have hosted repos:

```sh
git rm -r platforms/stm32g0
git submodule add https://github.com/YOUR_ORG/stm32-platform-g0 platforms/stm32g0
# update .gitmodules URL accordingly
```
