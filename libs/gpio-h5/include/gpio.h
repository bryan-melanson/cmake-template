#pragma once

/* GPIO driver interface — STM32H5 family implementation */

typedef enum { GPIO_PIN_RESET = 0, GPIO_PIN_SET } GPIO_PinState;

void GPIO_Init(void);
void GPIO_WritePin(void *port, unsigned int pin, GPIO_PinState state);
GPIO_PinState GPIO_ReadPin(void *port, unsigned int pin);
