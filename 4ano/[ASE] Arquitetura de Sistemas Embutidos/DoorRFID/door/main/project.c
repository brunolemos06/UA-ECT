#include <esp_log.h>
#include <inttypes.h>
#include "driver/gpio.h"
#include "driver/i2c.h"
#include "driver/uart.h"
#include "esp_console.h"
#include "esp_log.h"
#include "esp_system.h"
#include "esp_wifi.h"
#include "esp_event.h"
#include "nvs_flash.h"

// own libraries
#include "rc522.h"
#include "leds.h"
#include "buzzer.h"
#include "server.h"
#include "lcd.h"
#include <time.h>
#include "buffertags.h"
#include "api.h"
#include "uart.h"

// Global variables to store SSID and password
char ssid[32];
char password[64];

static const char* TAG = "MAIN";
static rc522_handle_t scanner;

bool acess = false;
bool hasVariables = false;  // Variable to track if all variables are obtained

// Semaphore to control the access to the system
SemaphoreHandle_t mySemaphore;
char rfid[32];  // Assuming the string length is sufficient for the number

void startAplication(){
    int counter = 0;

    while (counter < 4) {
        // blink leds every 500ms to show that the program is running
        turn_on_led(LED_RED);
        turn_on_led(LED_GREEN);
        turn_on_led(LED_BLUE);
        play_sound(5000,500);
        vTaskDelay(100 / portTICK_PERIOD_MS);
        turn_off_led(LED_RED);
        turn_off_led(LED_GREEN);
        turn_off_led(LED_BLUE);
        vTaskDelay(100/ portTICK_PERIOD_MS);
        counter++;
    }
    play_sound(7500,2000);
}

void config(){
    // Get ESP_WIFI_SSID and ESP_WIFI_PASS from the terminal

    printf("Enter SSID: ");
    uart_read_bytes(UART_NUM_1, (uint8_t*)ssid, sizeof(ssid)-1, portMAX_DELAY);
    vTaskDelay(pdMS_TO_TICKS(100));  // Delay for 100 milliseconds
    ssid[sizeof(ssid)-1] = '\0';  // Null-terminate the string
    printf("SSID: %s\n", ssid);
}

void allow_tag(bool allow, uint64_t tag_id){
    if (allow) {
        lcd_put_cur(1, 0);
        lcd_send_string("access granted  ");
        ESP_LOGI(TAG, "Access granted with (%" PRIu64 ")", tag_id );
        turn_on_led(LED_GREEN);
        play_sound(3000,1000);
        turn_off_led(LED_GREEN);
        vTaskDelay(1000 / portTICK_PERIOD_MS);
        lcd_put_cur(1, 0);
        lcd_send_string("Status: scan  ");
    } else {
        lcd_put_cur(1, 0);
        lcd_send_string("access denied   ");
        ESP_LOGW(TAG, "Access denied with (%" PRIu64 ")", tag_id);
        turn_on_led(LED_RED);
        play_sound(1000,1000);
        turn_off_led(LED_RED);
        vTaskDelay(1000 / portTICK_PERIOD_MS);
        lcd_put_cur(1, 0);
        lcd_send_string("Status: scan ");
    }
}

static void rc522_handler(void* arg, esp_event_base_t base, int32_t event_id, void* event_data)
{
    rc522_event_data_t* data = (rc522_event_data_t*) event_data;
    // when config_status == 1, the system is in configuration mode but just for an 10 seconds
    // after that, the system will be in normal mode
    switch(event_id) {
        case RC522_EVENT_TAG_SCANNED: {
            rc522_tag_t* tag = (rc522_tag_t*) data->ptr;
            if(config_status == 1){
                if(addallowed_tag(tag->serial_number)){
                    ESP_LOGI(TAG, "Tag added with (%" PRIu64 ")", tag->serial_number);
                    char param[20];
                    sprintf(param, "%" PRIu64, tag->serial_number);
                    addLog(param, "Added");
                    lcd_put_cur(1, 0);
                    lcd_send_string("Status: conf ");
                }else{
                    ESP_LOGW(TAG, "Tag not added with (%" PRIu64 ")", tag->serial_number);
                    char param[20];
                    sprintf(param, "%" PRIu64, tag->serial_number);
                    addLog(param, "Add_again");
                    lcd_put_cur(1, 0);
                    lcd_send_string("Status: conf ");
                }
            }else if(config_status == 0){
                if (is_allowed_tag(tag->serial_number)) {
                    allow_tag(true, tag->serial_number);
                    sprintf(rfid, "%" PRIu64, tag->serial_number);
                    addLog(rfid, "Accepted");
                } else {
                    allow_tag(false, tag->serial_number);
                    sprintf(rfid, "%" PRIu64, tag->serial_number);
                    addLog(rfid, "Declined");
                }
            }
            break;
        }
        default:
            break;
    }   
}

void tasknormalmode()
{
    // Add your task code here
    while (1) {
        // Task functionality
        if(config_status != 2){
            ESP_LOGI("TASK", "Waiting for semaphore ...");
            xSemaphoreTake(mySemaphore, portMAX_DELAY);
            vTaskDelay(100 / portTICK_PERIOD_MS);
            ESP_LOGI("TASK", "Semaphore taken!");
            for (int i = 10; i >= 0; i--) {
                ESP_LOGW("TASK", "Time to change to normal mode: %d", i);
                lcd_put_cur(1, 13);
                char str[2];
                if (i < 10) {
                    str[0] = '0';
                    str[1] = i + '0';
                } else {
                    str[0] = i / 10 + '0';
                    str[1] = i % 10 + '0';
                }
                lcd_send_string(str);
                lcd_put_cur(1, 15);
                lcd_send_string("s");
                play_sound(4000,200);
                vTaskDelay(1000 / portTICK_PERIOD_MS);
            }
            config_status = 0;
            acess = false;
            vTaskDelay(1000 / portTICK_PERIOD_MS);
            lcd_put_cur(1, 0);
            lcd_send_string("Status: scan     ");
            turn_off_led(LED_PIN);
            play_sound(7500,2000);
            
            // prevent the semaphore to be taken more than once
            UBaseType_t pendingTasks = uxSemaphoreGetCount(mySemaphore);
            if (pendingTasks == 1) xSemaphoreTake(mySemaphore, portMAX_DELAY);
        }
    }
}

void getCredentials(){
    printf("Enter SSID: ");
    get_string(ssid, true);
    printf("Enter password: ");
    get_string(password, false);
    printf("--------------------\n");
    printf("SSID: %s\n", ssid);
    printf("Password: %s\n", password);
    printf("--------------------\n");
}

void app_main()
{
    // configure uart
    uart_init();

    // configure LCD display with i2c
    i2c_master_init();
    ESP_LOGI(TAG, "I2C initialized successfully");
    lcd_init();
    lcd_clear();
    lcd_put_cur(0, 0);
    lcd_send_string("  DOOR  ACCESS  ");
    lcd_put_cur(1, 0);
    lcd_send_string("Status: init  ");

    
    // GPIO initialization
    gpio_reset_pin(LED_BLUE);
    gpio_set_direction(LED_BLUE, GPIO_MODE_OUTPUT);
    
    // configure buzzer
    configure_buzzer();
    
    // configure leds and turn on blue led
    configure_leds();
    turn_on_led(LED_BLUE);

    // configure rc522
    rc522_config_t config = {
        .spi.host = VSPI_HOST,
        .spi.miso_gpio = 25,
        .spi.mosi_gpio = 23,
        .spi.sck_gpio = 19,
        .spi.sda_gpio = 26,
    };
    rc522_create(&config, &scanner);
    rc522_register_events(scanner, RC522_EVENT_ANY, rc522_handler, NULL);
    rc522_start(scanner);

    // get credentials
    vTaskDelay(1000 / portTICK_PERIOD_MS);
    getCredentials();

    // configure server
    esp_err_t ret = nvs_flash_init();
    if (ret == ESP_ERR_NVS_NO_FREE_PAGES || ret == ESP_ERR_NVS_NEW_VERSION_FOUND)
    {
        ESP_ERROR_CHECK(nvs_flash_erase());
        ret = nvs_flash_init();
    }
    ESP_ERROR_CHECK(ret);

    printf("Starting server\n");
    connect_wifi(ssid, password);
    setup_server();

    // create task to change to normal mode
    mySemaphore = xSemaphoreCreateBinary();
    xTaskCreate(tasknormalmode, "tasknormalmode", 4096, NULL, 5, NULL);

    startAplication();
}