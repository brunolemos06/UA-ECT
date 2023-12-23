// Description: This file contains the functions to configure and control the LEDs
#include <freertos/FreeRTOS.h>
#include <freertos/task.h>
#include <esp_system.h>
#include <esp_log.h>
#include <string.h>
#include "driver/gpio.h"
#include "leds.h"

void configure_leds(void)
{
    // configure RED with pin 18
    gpio_reset_pin(LED_RED);
    gpio_set_direction(LED_RED, GPIO_MODE_OUTPUT);

    // configure GREEN with pin 5
    gpio_reset_pin(LED_GREEN);
    gpio_set_direction(LED_GREEN, GPIO_MODE_OUTPUT);

    // configure BLUE with pin 17
    gpio_reset_pin(LED_BLUE);
    gpio_set_direction(LED_BLUE, GPIO_MODE_OUTPUT);
}

void blink_led(int pin, int delay_ms){
    gpio_set_level(pin, 1);
    vTaskDelay(delay_ms / portTICK_PERIOD_MS);
    gpio_set_level(pin, 0);
}

void turn_on_led(int pin){
    gpio_set_level(pin, 1);
}

void turn_off_led(int pin){
    gpio_set_level(pin, 0);
}