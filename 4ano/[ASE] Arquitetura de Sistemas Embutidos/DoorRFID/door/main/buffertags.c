#include <esp_log.h>
#include <inttypes.h>
#include "driver/gpio.h"
#include "lcd.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "config.h"
#include "buzzer.h"
#include "api.h"


// array with allowed tag serial numbers
const char* TAG = "Buffertags";

bool is_allowed_tag(uint64_t serial_number){
    return api_isuser(serial_number);
}

bool addallowed_tag(uint64_t tag_id){
    // verify if the tag is already in the array
    if (tag_id == 0) {
        return false;
    }
    if(is_allowed_tag(tag_id)){
        play_sound(5000,500);
        ESP_LOGW(TAG, "Tag already in the array");
        lcd_put_cur(1, 0);
        lcd_send_string("Already in   ");
        vTaskDelay(1000 / portTICK_PERIOD_MS);
        lcd_put_cur(1, 0);
        lcd_send_string("Status: conf ");
        return false;
    }else{
        api_adduser(tag_id);
    }
    play_sound(3000,500);
    lcd_put_cur(1, 0);
    lcd_send_string("Tag added    ");
    return true;
}

bool removeTag(uint64_t tag_id){
    api_deluser(tag_id);
    return true;
}