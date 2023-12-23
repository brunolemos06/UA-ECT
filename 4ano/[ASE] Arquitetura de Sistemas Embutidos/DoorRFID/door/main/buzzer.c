#include <freertos/FreeRTOS.h>
#include <freertos/task.h>
#include <esp_system.h>
#include <esp_log.h>
#include <string.h>
#include "driver/gpio.h"
#include "buzzer.h"

#define BUZZER_PIN GPIO_NUM_12

void play_sound(int freq,int cycles) {
    for (int i = 0; i < cycles; i++) {
        gpio_set_level(BUZZER_PIN, 1);
        esp_rom_delay_us(1000000 / freq / 2);
        gpio_set_level(BUZZER_PIN, 0);
        esp_rom_delay_us(1000000 / freq / 2);
    }
}

void configure_buzzer(){
    // configure buzzer
    gpio_reset_pin(BUZZER_PIN);
    gpio_set_direction(BUZZER_PIN, GPIO_MODE_OUTPUT);
}