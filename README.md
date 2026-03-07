# STM32 CMake Template

A minimal CMake template for STM32 projects using CMake presets to select the
target family and chip. Selecting a preset brings in only that family's HAL
submodule and the matching chip linker script.

## Supported presets

| Preset       | Device       | Core       | Flash  | RAM    |
|--------------|--------------|------------|--------|--------|
| `stm32g071`  | STM32G071xx  | Cortex-M0+ | 128 KB | 36 KB  |
| `stm32g0b1`  | STM32G0B1xx  | Cortex-M0+ | 512 KB | 144 KB |
| `stm32h563`  | STM32H563xx  | Cortex-M33 | 512 KB | 256 KB |

## Quick start

```sh
# Clone with only the submodule you need
git submodule update --init libs/STM32CubeG0   # for G0 chips
git submodule update --init libs/STM32CubeH5   # for H5 chips

# Configure and build
cmake --preset stm32g0b1
cmake --build --preset stm32g0b1
```

The build output (`stm32-app.elf`, `.hex`, `.bin`) lands in `build/<preset>/src/`.

## Repository layout

```
├── CMakeLists.txt              # Root – includes cmake/stm32.cmake, adds src/
├── CMakePresets.json           # One preset per chip variant
├── cmake/
│   ├── toolchain-arm-none-eabi.cmake   # Cross-compiler setup
│   ├── stm32.cmake                     # Dispatches to the selected family
│   └── families/
│       ├── g0.cmake            # CPU flags, HAL library, chip linker script
│       └── h5.cmake
├── src/
│   ├── CMakeLists.txt          # Application target
│   ├── main.c
│   ├── stm32g0xx_hal_conf.h    # HAL module enables for G0
│   └── stm32h5xx_hal_conf.h    # HAL module enables for H5
├── linker/
│   ├── family/
│   │   ├── g0.ld               # SECTIONS shared by all G0 chips
│   │   └── h5.ld               # SECTIONS shared by all H5 chips
│   └── chips/
│       ├── stm32g071xx.ld      # MEMORY for G071 + INCLUDE family/g0.ld
│       ├── stm32g0b1xx.ld      # MEMORY for G0B1 + INCLUDE family/g0.ld
│       └── stm32h563xx.ld      # MEMORY for H563 + INCLUDE family/h5.ld
└── libs/
    ├── STM32CubeG0/            # git submodule
    └── STM32CubeH5/            # git submodule
```

## How it works

### Family selection

`CMakePresets.json` sets two cache variables:

```json
"cacheVariables": {
    "STM32_FAMILY": "G0",
    "STM32_DEVICE": "STM32G0B1xx"
}
```

`cmake/stm32.cmake` reads `STM32_FAMILY` and `include()`s the matching file
from `cmake/families/`. That file sets CPU flags, creates the `stm32_hal`
static library from the submodule sources, and selects the chip linker script.
The other family's submodule is never referenced.

### Linker script overlay

Each chip script in `linker/chips/` defines only the `MEMORY` block for that
chip, then delegates section layout to the shared family script via `INCLUDE`:

```ld
/* stm32g0b1xx.ld */
MEMORY
{
    FLASH (rx)  : ORIGIN = 0x08000000, LENGTH = 512K
    RAM   (xrw) : ORIGIN = 0x20000000, LENGTH = 144K
}

INCLUDE family/g0.ld
```

`-L${linker_dir}` is passed to the linker so `INCLUDE` resolves `family/g0.ld`
relative to the `linker/` directory.

Adding a new chip is just a new file in `linker/chips/` with the correct
`MEMORY` block and an `INCLUDE` line.

## Adding a new chip (same family)

1. Add `linker/chips/stm32g0c1xx.ld` with the correct `MEMORY` and `INCLUDE family/g0.ld`.
2. Add a preset to `CMakePresets.json` with `STM32_DEVICE: "STM32G0C1xx"`.

## Adding a new family

1. Add the STM32Cube submodule under `libs/`.
2. Create `cmake/families/<family>.cmake` following the existing examples.
3. Create `linker/family/<family>.ld` with the SECTIONS layout.
4. Add chip scripts in `linker/chips/` for each supported device.
5. Add presets to `CMakePresets.json`.
