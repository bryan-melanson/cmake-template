#pragma once

#include <stdint.h>

/* SPI driver interface — STM32H5 family implementation */

void SPI_Init(void);
void SPI_Transfer(unsigned int spi, const uint8_t *tx, uint8_t *rx, unsigned int len);
