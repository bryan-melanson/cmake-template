#pragma once

#include <stdint.h>

/* I2C driver interface — STM32G0 family implementation */

void     I2C_Init(void);
void     I2C_Write(unsigned int i2c, uint8_t addr, const uint8_t *data, unsigned int len);
unsigned I2C_Read(unsigned int i2c, uint8_t addr, uint8_t *data, unsigned int len);
