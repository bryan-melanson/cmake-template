#pragma once

#include <stdint.h>

/* DMA driver interface — STM32H5 family implementation */

void DMA_Init(void);
void DMA_Start(unsigned int channel, void *src, void *dst, unsigned int len);
