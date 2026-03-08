#pragma once

#include <stdint.h>

/* Shared memory overlay — placed in the .shared_mem linker section.
 * Because the section is NOLOAD, it is never zero-initialised by the
 * startup code, so values persist across soft resets as long as RAM
 * power is maintained.
 *
 * All access goes through the getter/setter API below so that the
 * exact layout of SharedMem_t stays an implementation detail. */

typedef struct {
    uint32_t status;
    uint32_t error_code;
    uint32_t counter;
} SharedMem_t;

void     SharedMem_SetStatus(uint32_t value);
uint32_t SharedMem_GetStatus(void);

void     SharedMem_SetErrorCode(uint32_t value);
uint32_t SharedMem_GetErrorCode(void);

void     SharedMem_SetCounter(uint32_t value);
uint32_t SharedMem_GetCounter(void);
