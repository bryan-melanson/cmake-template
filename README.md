# STM32 CMake Template

A minimal CMake template for STM32 projects. Selecting a preset pulls in only
that chip's platform configuration and driver submodule — other chips are
untouched.

## Supported presets

| Preset       | Device       | Core       | Flash  | RAM    | Driver              |
|--------------|--------------|------------|--------|--------|---------------------|
| `stm32g0b1`  | STM32G0B1xx  | Cortex-M0+ | 512 KB | 144 KB | `drivers/gpio-g0b1` |
| `stm32h563`  | STM32H563xx  | Cortex-M33 | 512 KB | 256 KB | `drivers/gpio-h563` |

## Quick start

```sh
# Pull only the submodules you need
git submodule update --init drivers/gpio-g0b1 platforms/stm32g0b1

# Configure and build
cmake --preset stm32g0b1
cmake --build --preset stm32g0b1
```

Output (`stm32-app.elf`, `.hex`, `.bin`) lands in `build/stm32g0b1/`.

## Repository layout

```
├── CMakeLists.txt              # Defines executable, links against 'gpio'
├── CMakePresets.json           # Includes preset files from each platform submodule
├── main.c                      # Application entry point
├── cmake/
│   ├── toolchain-arm-none-eabi.cmake
│   └── stm32.cmake             # include(${STM32_PLATFORM_DIR}/platform.cmake)
├── drivers/                    # One submodule per chip
│   ├── gpio-g0b1/
│   │   ├── CMakeLists.txt      # defines 'gpio' target
│   │   ├── include/gpio.h
│   │   └── src/gpio.c
│   └── gpio-h563/
│       ├── CMakeLists.txt      # defines 'gpio' target
│       ├── include/gpio.h
│       └── src/gpio.c
├── platforms/                  # One submodule per chip
│   ├── stm32g0b1/
│   │   ├── CMakePresets.json   # stm32g0b1 preset
│   │   ├── platform.cmake      # CPU flags, add_subdirectory(drivers/gpio-g0b1), linker
│   │   └── linker/
│   │       ├── family/g0.ld    # SECTIONS shared across G0 chips
│   │       └── chips/stm32g0b1xx.ld  # MEMORY + INCLUDE family/g0.ld
│   └── stm32h563/
│       ├── CMakePresets.json   # stm32h563 preset
│       ├── platform.cmake
│       └── linker/
│           ├── family/h5.ld
│           └── chips/stm32h563xx.ld
├── services/                   # Higher-level services (add submodules here)
└── utilities/                  # Shared utilities (add submodules here)
```

## How it works

`CMakePresets.json` includes preset files from each platform submodule:

```json
{ "version": 6, "include": ["platforms/stm32g0b1/CMakePresets.json", ...] }
```

The selected preset sets two cache variables:

```json
"cacheVariables": {
    "STM32_PLATFORM_DIR": "${sourceDir}/platforms/stm32g0b1",
    "STM32_DEVICE":       "STM32G0B1xx"
}
```

`cmake/stm32.cmake` delegates to the platform:

```cmake
include(${STM32_PLATFORM_DIR}/platform.cmake)
```

`platform.cmake` does three things:
1. Sets CPU compile and link flags
2. Calls `add_subdirectory` on the chip's driver submodule
3. Selects the chip linker script via `-T`

The driver exposes a `gpio` target. `CMakeLists.txt` links against it
unconditionally — no family conditionals needed in the application layer.

### Linker script overlay

Each chip file defines only its `MEMORY` and delegates `SECTIONS` to the
shared family file:

```ld
/* stm32g0b1xx.ld */
MEMORY { FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 512K
         RAM  (xrw) : ORIGIN = 0x20000000, LENGTH = 144K }
INCLUDE family/g0.ld
```

## Adding a new chip

1. Create `platforms/<chip>/` with `CMakePresets.json`, `platform.cmake`, and
   `linker/chips/<chip>.ld`. If the family is new, add `linker/family/<family>.ld`.
2. Create `drivers/gpio-<chip>/` with a `CMakeLists.txt` exposing a `gpio` target.
3. Register both in `.gitmodules`.
4. Add the platform preset file to the root `CMakePresets.json` include list.

## Converting to proper submodules

`platforms/` and `drivers/` are tracked as regular files. Once you host the
repos, convert them:

```sh
git rm -r platforms/stm32g0b1 drivers/gpio-g0b1
git submodule add https://github.com/YOUR_ORG/stm32-platform-g0b1 platforms/stm32g0b1
git submodule add https://github.com/YOUR_ORG/gpio-g0b1           drivers/gpio-g0b1
```
