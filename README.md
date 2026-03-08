# STM32 CMake Template

A minimal CMake template for STM32 projects. Selecting a preset pulls in only
that chip's platform configuration and driver submodules — other chips are
untouched.

## Supported presets

| Preset       | Device       | Core       | Flash  | RAM    |
|--------------|--------------|------------|--------|--------|
| `stm32g0b1`  | STM32G0B1xx  | Cortex-M0+ | 512 KB | 144 KB |
| `stm32h563`  | STM32H563xx  | Cortex-M33 | 512 KB | 256 KB |

## Quick start

```sh
# Configure and build
cmake --preset stm32g0b1
cmake --build --preset stm32g0b1
```

Output (`stm32-app.elf`, `.hex`, `.bin`) lands in `build/stm32g0b1/`.

## Repository layout

```
├── CMakeLists.txt              # Defines executable, links against driver targets
├── CMakePresets.json           # Root presets: platform includes + driver dir presets
├── main.c                      # Application entry point
├── src/
│   ├── cmake/
│   │   ├── toolchain-arm-none-eabi.cmake
│   │   └── stm32.cmake         # include(${STM32_PLATFORM_DIR}/platform.cmake)
│   ├── drivers/                # One directory per peripheral per chip
│   │   ├── led/                # Platform-agnostic LED service (depends on 'gpio')
│   │   ├── gpio-g0b1/          # STM32G0B1 GPIO driver placeholder
│   │   ├── gpio-h563/          # STM32H563 GPIO driver placeholder
│   │   ├── uart-g0b1/          # (and uart, i2c, spi, dma, can, crc for each chip)
│   │   └── ...
│   └── platforms/
│       ├── g0/
│       │   ├── CMakePresets.json   # stm32g0b1 preset (chip vars + driver dir nulls)
│       │   ├── platform.cmake      # CPU flags, CMSIS headers, optional drivers
│       │   └── linker/
│       │       ├── family/g0.ld    # SECTIONS shared across G0 chips
│       │       └── chips/stm32g0b1xx.ld  # MEMORY + INCLUDE family/g0.ld
│       └── h5/
│           ├── CMakePresets.json   # stm32h563 preset
│           ├── platform.cmake
│           └── linker/
│               ├── family/h5.ld
│               └── chips/stm32h563xx.ld
```

## How it works

`CMakePresets.json` at the root includes each platform's preset file and
defines hidden driver-dir presets for every peripheral/chip combination:

```json
{
  "include": ["src/platforms/g0/CMakePresets.json", ...],
  "configurePresets": [
    { "name": "gpio-g0b1", "hidden": true,
      "cacheVariables": { "GPIO_DRIVER_DIR": "${sourceDir}/src/drivers/gpio-g0b1" } },
    ...
  ]
}
```

The chip preset sets the platform directory and device macro, with all driver
dirs defaulting to `null` (disabled):

```json
"cacheVariables": {
    "STM32_PLATFORM_DIR": "${sourceDir}/src/platforms/g0",
    "STM32_DEVICE":       "STM32G0B1xx",
    "CMSIS_DIR":          null,
    "GPIO_DRIVER_DIR":    null,
    ...
}
```

To activate a driver, inherit from its preset in your own preset:

```json
{
  "name": "my-build",
  "inherits": ["stm32g0b1", "gpio-g0b1", "uart-g0b1"]
}
```

`platform.cmake` does three things:
1. Sets CPU compile and link flags for the family
2. Optionally exposes CMSIS device headers (see below)
3. Calls `add_subdirectory` on each driver whose `*_DRIVER_DIR` is set

### CMSIS device headers

Setting `CMSIS_DIR` to your STM32Cube `Drivers/CMSIS` folder makes peripheral
register definitions available without building any HAL sources:

```json
"CMSIS_DIR": "/path/to/STM32CubeG0/Drivers/CMSIS"
```

The platform creates a `device_headers` INTERFACE target exposing:
- `CMSIS/Include/` — ARM core headers (`core_cm0plus.h`, etc.)
- `CMSIS/Device/ST/STM32{G0,H5}xx/Include/` — chip register structs

Drivers opt in per-target:

```cmake
target_link_libraries(uart PRIVATE device_headers)
```

No HAL `.c` files are ever added to the build.

### Linker script overlay

Each chip file defines only its `MEMORY` and delegates `SECTIONS` to the
shared family file:

```ld
/* stm32g0b1xx.ld */
MEMORY { FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 512K
         RAM  (xrw) : ORIGIN = 0x20000000, LENGTH = 144K }
INCLUDE family/g0.ld
```

## Adding a new peripheral driver

1. Create `src/drivers/<peripheral>-<chip>/` with:
   - `CMakeLists.txt` — `add_library(<peripheral> OBJECT src/<peripheral>.c)`
   - `include/<peripheral>.h` — driver interface
   - `src/<peripheral>.c` — implementation
2. Add a hidden preset to the root `CMakePresets.json`:
   ```json
   { "name": "<peripheral>-<chip>", "hidden": true,
     "cacheVariables": { "<PERIPHERAL>_DRIVER_DIR": "${sourceDir}/src/drivers/<peripheral>-<chip>" } }
   ```
3. Add `<PERIPHERAL>_DRIVER_DIR: null` to the chip preset's `cacheVariables`.
4. Add `"<PERIPHERAL>"` to the `foreach` loop in `platform.cmake`.

## Adding a new chip

1. Create `src/platforms/<family>/` with `CMakePresets.json`, `platform.cmake`,
   and `linker/chips/<chip>.ld`. If the family is new, add `linker/family/<family>.ld`.
2. Add driver placeholder directories under `src/drivers/` for each peripheral.
3. Add the platform preset file to the root `CMakePresets.json` include list.
4. Add hidden driver-dir presets to the root `CMakePresets.json`.

## Converting to submodules

`src/platforms/` and `src/drivers/` are tracked as regular files. Once you
host the repos, convert them:

```sh
git rm -r src/platforms/g0 src/drivers/gpio-g0b1
git submodule add https://github.com/YOUR_ORG/stm32-platform-g0   src/platforms/g0
git submodule add https://github.com/YOUR_ORG/gpio-g0b1           src/drivers/gpio-g0b1
```
