# STM32 CMake Template

A minimal CMake template for STM32 projects using CMake presets to select the
target family. Selecting a preset brings in only that family's HAL submodule.

## Supported families

| Preset      | Device      | Core       |
|-------------|-------------|------------|
| `stm32g0`   | STM32G071xx | Cortex-M0+ |
| `stm32h5`   | STM32H563xx | Cortex-M33 |

## Adding a new family

1. Add the STM32Cube submodule under `libs/`.
2. Create `cmake/families/<family>.cmake` following the existing examples.
3. Add a configure preset to `CMakePresets.json`.

## Quick start

```sh
# Clone with submodules for the family you need
git submodule update --init libs/STM32CubeG0   # for G0
git submodule update --init libs/STM32CubeH5   # for H5

# Configure and build
cmake --preset stm32g0
cmake --build --preset stm32g0
```

The build output (`stm32-app.elf`, `.hex`, `.bin`) lands in `build/stm32g0/src/`.

## Repository layout

```
├── CMakeLists.txt              # Root – includes cmake/stm32.cmake, adds src/
├── CMakePresets.json           # One preset per family
├── cmake/
│   ├── toolchain-arm-none-eabi.cmake   # Cross-compiler setup
│   ├── stm32.cmake                     # Dispatches to the selected family
│   └── families/
│       ├── g0.cmake            # CPU flags, HAL library, linker script
│       └── h5.cmake
├── src/
│   ├── CMakeLists.txt          # Application target
│   ├── main.c
│   ├── stm32g0xx_hal_conf.h    # HAL module enables for G0
│   └── stm32h5xx_hal_conf.h    # HAL module enables for H5
├── linker/
│   ├── stm32g071xx.ld
│   └── stm32h563xx.ld
└── libs/
    ├── STM32CubeG0/            # git submodule
    └── STM32CubeH5/            # git submodule
```

## How it works

`CMakePresets.json` sets two cache variables:

```json
"cacheVariables": {
    "STM32_FAMILY": "G0",
    "STM32_DEVICE": "STM32G071xx"
}
```

`cmake/stm32.cmake` reads `STM32_FAMILY` and `include()`s the matching file
from `cmake/families/`. That file sets CPU flags, creates an `stm32_hal` static
library from the submodule sources, and sets the linker script. The other
family's submodule is never touched.

`src/CMakeLists.txt` links the application against `stm32_hal`, which
propagates all include paths and compile definitions automatically.
