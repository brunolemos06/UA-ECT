#pragma once

#define LED_RED 18
#define LED_GREEN 5
#define LED_BLUE 17

void configure_leds(void);

void blink_led(int pin, int delay_ms);

void turn_on_led(int pin);

void turn_off_led(int pin);