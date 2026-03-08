#include "i2c.h"

/* STM32H5 I2C driver implementation — replace with your own. */

void I2C_Init(void) { }

void I2C_Write(unsigned int i2c, uint8_t addr, const uint8_t *data, unsigned int len)
{
    (void)i2c; (void)addr; (void)data; (void)len;
}

unsigned I2C_Read(unsigned int i2c, uint8_t addr, uint8_t *data, unsigned int len)
{
    (void)i2c; (void)addr; (void)data; (void)len;
    return 0;
}
