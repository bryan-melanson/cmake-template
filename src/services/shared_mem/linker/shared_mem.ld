/* Shared memory overlay section.
 * NOLOAD: startup code never clears it, so values survive soft resets
 * as long as RAM power is maintained.
 * Placed before .data so it sits at the base of RAM at a fixed address. */

.shared_mem (NOLOAD) :
{
    . = ALIGN(4);
    _sshared_mem = .;
    *(.shared_mem)
    . = ALIGN(4);
    _eshared_mem = .;
} > RAM
