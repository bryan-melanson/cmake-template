#include "gpio.h"

/* STM32H5 GPIO driver implementation — replace with your own. */

void GPIO_Init(void) { }

void GPIO_WritePin(void *port, unsigned int pin, GPIO_PinState state)
{
    (void)port; (void)pin; (void)state;
}

GPIO_PinState GPIO_ReadPin(void *port, unsigned int pin)
{
    (void)port; (void)pin;
    return GPIO_PIN_RESET;
}
