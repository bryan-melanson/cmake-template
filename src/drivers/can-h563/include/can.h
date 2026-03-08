#pragma once

#include <stdint.h>

/* CAN driver interface — STM32H5 family implementation */

void     CAN_Init(void);
void     CAN_Send(unsigned int can, const uint8_t *data, unsigned int len);
unsigned CAN_Receive(unsigned int can, uint8_t *data, unsigned int len);
