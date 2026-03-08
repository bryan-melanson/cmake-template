/* Shared memory overlay linker fragment.
 * Injected as an additional -T script by the shared_mem CMake target.
 * NOLOAD: startup code never clears it, so values survive soft resets
 * as long as RAM power is maintained. */

SECTIONS
{
    .shared_mem (NOLOAD) :
    {
        . = ALIGN(4);
        _sshared_mem = .;
        *(.shared_mem)
        . = ALIGN(4);
        _eshared_mem = .;
    } > RAM
}
