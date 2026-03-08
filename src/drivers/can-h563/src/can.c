#include "can.h"

/* STM32H5 CAN driver implementation — replace with your own. */

void CAN_Init(void) { }

void CAN_Send(unsigned int can, const uint8_t *data, unsigned int len)
{
    (void)can; (void)data; (void)len;
}

unsigned CAN_Receive(unsigned int can, uint8_t *data, unsigned int len)
{
    (void)can; (void)data; (void)len;
    return 0;
}
