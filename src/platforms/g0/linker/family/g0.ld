/* G0 family SECTIONS — MEMORY must be defined by the chip linker script.
 * Chip scripts INCLUDE this file after their MEMORY block.              */

ENTRY(Reset_Handler)

SECTIONS
{
    .text :
    {
        KEEP(*(.isr_vector))
        *(.text*)
        *(.rodata*)
        KEEP(*(.init))
        KEEP(*(.fini))
        _etext = .;
    } > FLASH

    /* Shared memory overlay: NOLOAD so startup code never clears it.
     * Values are preserved across soft resets while RAM power is maintained. */
    .shared_mem (NOLOAD) :
    {
        . = ALIGN(4);
        _sshared_mem = .;
        *(.shared_mem)
        . = ALIGN(4);
        _eshared_mem = .;
    } > RAM

    /* Initialized data: stored in FLASH, copied to RAM at startup */
    _sidata = LOADADDR(.data);
    .data :
    {
        _sdata = .;
        *(.data*)
        _edata = .;
    } > RAM AT > FLASH

    .bss (NOLOAD) :
    {
        _sbss = .;
        *(.bss*)
        *(COMMON)
        _ebss = .;
    } > RAM

    /* Stack grows downward from the top of RAM */
    _estack = ORIGIN(RAM) + LENGTH(RAM);
}
