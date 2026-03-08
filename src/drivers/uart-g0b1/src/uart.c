#include "uart.h"

/* STM32G0 UART driver implementation — replace with your own. */

void UART_Init(void) { }

void UART_Write(unsigned int uart, const uint8_t *data, unsigned int len)
{
    (void)uart; (void)data; (void)len;
}

unsigned UART_Read(unsigned int uart, uint8_t *data, unsigned int len)
{
    (void)uart; (void)data; (void)len;
    return 0;
}
