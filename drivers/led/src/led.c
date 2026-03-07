#include "led.h"

void LED_Init(LED_Handle *led, void *port, unsigned int pin)
{
    led->port = port;
    led->pin  = pin;
    GPIO_Init();
    GPIO_WritePin(led->port, led->pin, GPIO_PIN_RESET);
}

void LED_On(LED_Handle *led)
{
    GPIO_WritePin(led->port, led->pin, GPIO_PIN_SET);
}

void LED_Off(LED_Handle *led)
{
    GPIO_WritePin(led->port, led->pin, GPIO_PIN_RESET);
}

void LED_Toggle(LED_Handle *led)
{
    GPIO_PinState state = GPIO_ReadPin(led->port, led->pin);
    GPIO_WritePin(led->port, led->pin,
                  (state == GPIO_PIN_SET) ? GPIO_PIN_RESET : GPIO_PIN_SET);
}
