#pragma once

#include <stdint.h>

/* UART driver interface — STM32H5 family implementation */

void     UART_Init(void);
void     UART_Write(unsigned int uart, const uint8_t *data, unsigned int len);
unsigned UART_Read(unsigned int uart, uint8_t *data, unsigned int len);
