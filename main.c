#include "led.h"

/* Board-level pin mapping — adjust port/pin for your hardware. */
#define LED_PORT  ((void *)0x50000400)  /* e.g. GPIOA base address */
#define LED_PIN   5U

int main(void)
{
    LED_Handle led;
    LED_Init(&led, LED_PORT, LED_PIN);

    while (1)
    {
        LED_Toggle(&led);
    }
}
