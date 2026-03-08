#pragma once

#include <stdint.h>

/* CRC driver interface — STM32H5 family implementation */

void     CRC_Init(void);
uint32_t CRC_Calculate(const uint8_t *data, unsigned int len);
uint32_t CRC_Accumulate(const uint8_t *data, unsigned int len);
