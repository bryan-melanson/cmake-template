#include "shared_mem.h"

/* Single instance placed in the dedicated .shared_mem linker section. */
static SharedMem_t shared_mem __attribute__((section(".shared_mem")));

void SharedMem_SetStatus(uint32_t value)    { shared_mem.status     = value; }
uint32_t SharedMem_GetStatus(void)          { return shared_mem.status;      }

void SharedMem_SetErrorCode(uint32_t value) { shared_mem.error_code = value; }
uint32_t SharedMem_GetErrorCode(void)       { return shared_mem.error_code;  }

void SharedMem_SetCounter(uint32_t value)   { shared_mem.counter    = value; }
uint32_t SharedMem_GetCounter(void)         { return shared_mem.counter;     }
