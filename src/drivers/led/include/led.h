#pragma once

#include "gpio.h"

/* Generic LED service built on top of the gpio driver interface.
 * The active GPIO port and pin are supplied at init time, allowing
 * the application (or a higher-level board config) to decide the
 * mapping without recompiling this module. */

typedef struct {
    void        *port;
    unsigned int pin;
} LED_Handle;

void LED_Init(LED_Handle *led, void *port, unsigned int pin);
void LED_On(LED_Handle *led);
void LED_Off(LED_Handle *led);
void LED_Toggle(LED_Handle *led);
