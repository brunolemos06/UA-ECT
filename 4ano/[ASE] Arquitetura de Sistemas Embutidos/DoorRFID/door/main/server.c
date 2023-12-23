#include <stdio.h>
#include <stdlib.h>
#include <string.h> //Requires by memset
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "esp_system.h"
#include "esp_spi_flash.h"
#include <esp_http_server.h>

#include "esp_wifi.h"
#include "esp_event.h"
#include "freertos/event_groups.h"
#include "esp_log.h"
#include "nvs_flash.h"
#include "esp_netif.h"
#include "driver/gpio.h"
#include <lwip/sockets.h>
#include <lwip/sys.h>
#include <lwip/api.h>
#include <lwip/netdb.h>
#include "lwip/apps/sntp.h"
#include <time.h>
#include <esp_http_client.h>



#include "server.h"
#include "leds.h"
#include "buffertags.h"
#include "lcd.h"
#include "config.h"
#include "api.h"
#include "buzzer.h"
extern SemaphoreHandle_t mySemaphore;

// Global variables to store SSID and password

static EventGroupHandle_t s_wifi_event_group;
static int s_retry_num = 0;
static const char *TAG = "Server"; // TAG for debug
int page_state = 0;
int config_status = 2;
int start = 1;

static char url_api[100];


void addLog(char *rfid, char *access) {

    ESP_LOGI("LOGS", "Added log");
    if(start == 1){
      setenv("TZ", "WET0WEST,M3.5.0/1,M10.5.0/2", 1);
      tzset();
      sntp_setoperatingmode(SNTP_OPMODE_POLL);
      sntp_setservername(0, "pool.ntp.org");
      sntp_init();
      start = 0;
    }

    // Wait for time to be set
    time_t now = 0;
    struct tm timeinfo = { 0 };
    while (timeinfo.tm_year < (2016 - 1900)) {
        vTaskDelay(1000 / portTICK_PERIOD_MS);
        time(&now);
        localtime_r(&now, &timeinfo);
    }

    // Format the hour as "17h30"
    static char hour[6];  // Buffer to hold the formatted hour
    strftime(hour, sizeof(hour), "%Hh%M", &timeinfo);

    // Format the day as "12-12-2020"
    static char day[11];  // Buffer to hold the formatted day
    strftime(day, sizeof(day), "%d-%m-%Y", &timeinfo);



    api_addlogs(day, hour, rfid, access);
}

static void event_handler(void *arg, esp_event_base_t event_base,int32_t event_id, void *event_data)
{
    if (event_base == WIFI_EVENT && event_id == WIFI_EVENT_STA_START)
    {
        esp_wifi_connect();
    }
    else if (event_base == WIFI_EVENT && event_id == WIFI_EVENT_STA_DISCONNECTED)
    {
        if (s_retry_num < EXAMPLE_ESP_MAXIMUM_RETRY)
        {
            esp_wifi_connect();
            s_retry_num++;
            ESP_LOGI(TAG, "retry to connect to the AP");
        }
        else
        {
            // force restart
            esp_restart();
            xEventGroupSetBits(s_wifi_event_group, WIFI_FAIL_BIT);

            
        }
        ESP_LOGI(TAG, "connect to the AP fail");
    }
    else if (event_base == IP_EVENT && event_id == IP_EVENT_STA_GOT_IP)
    {
        ip_event_got_ip_t *event = (ip_event_got_ip_t *)event_data;
        // ESP_LOGI(TAG, "got ip:" IPSTR, IP2STR(&event->ip_info.ip));
        lcd_put_cur(0, 0);
        lcd_send_string("IP:");
        // convert to char
        char ip[32];
        sprintf(ip, IPSTR, IP2STR(&event->ip_info.ip));
        lcd_send_string(ip);
        s_retry_num = 0;
        xEventGroupSetBits(s_wifi_event_group, WIFI_CONNECTED_BIT);
    }
}

void connect_wifi(char *ssid, char *password)
{
    s_wifi_event_group = xEventGroupCreate();

    ESP_ERROR_CHECK(esp_netif_init());

    ESP_ERROR_CHECK(esp_event_loop_create_default());
    esp_netif_create_default_wifi_sta();

    wifi_init_config_t cfg = WIFI_INIT_CONFIG_DEFAULT();
    ESP_ERROR_CHECK(esp_wifi_init(&cfg));

    esp_event_handler_instance_t instance_any_id;
    esp_event_handler_instance_t instance_got_ip;

    ESP_ERROR_CHECK(esp_event_handler_instance_register(WIFI_EVENT,ESP_EVENT_ANY_ID,&event_handler,NULL,&instance_any_id));

    ESP_ERROR_CHECK(esp_event_handler_instance_register(IP_EVENT,IP_EVENT_STA_GOT_IP,&event_handler,NULL,&instance_got_ip));


    wifi_config_t wifi_config = {
        .sta = {
            .ssid = "",
            .password = "",
            .threshold.authmode = WIFI_AUTH_WPA2_PSK,
        },
    };

    strcpy((char *)wifi_config.sta.ssid, ssid);
    strcpy((char *)wifi_config.sta.password, password);

    ESP_ERROR_CHECK(esp_wifi_set_mode(WIFI_MODE_STA));
    ESP_ERROR_CHECK(esp_wifi_set_config(WIFI_IF_STA, &wifi_config));
    ESP_ERROR_CHECK(esp_wifi_start());

    ESP_LOGI(TAG, "wifi_init_sta finished.");


    EventBits_t bits = xEventGroupWaitBits(s_wifi_event_group,WIFI_CONNECTED_BIT | WIFI_FAIL_BIT,pdFALSE,pdFALSE,portMAX_DELAY);

    if (bits & WIFI_CONNECTED_BIT)
    {
        ESP_LOGI(TAG, "Connected to SSID");
    }
    else if (bits & WIFI_FAIL_BIT)
    {
        ESP_LOGI(TAG, "Failed to connect");
    }
    else
    {
        ESP_LOGE(TAG, "UNEXPECTED EVENT");
    }
    vEventGroupDelete(s_wifi_event_group);
}

esp_err_t config_handler(httpd_req_t *req)
{
    // url_api global variable
    // query
    char query[100];
    if (httpd_req_get_url_query_str(req, query, 100) == ESP_OK)
    {
        ESP_LOGI(TAG, "Query: %s", query);
        char param[32];
        if (httpd_query_key_value(query, "remove", param, sizeof(param)) == ESP_OK){
            // param to uint64_t
            uint64_t tag_id = strtoull(param, NULL, 10);
            if(removeTag(tag_id)){
                ESP_LOGI(TAG, "Tag removed");
                addLog(param, "Removed");
            }
        }else if(httpd_query_key_value(query, "start", param, sizeof(param)) == ESP_OK){
            if (config_status != 2){
                config_status = 1;
                turn_on_led(LED_PIN);
                lcd_put_cur(1, 0);
                lcd_send_string("Status: conf");
                // give semaphor just if there is one task waiting
                xSemaphoreGive(mySemaphore);
            }
        }else if(httpd_query_key_value(query, "connect", param, sizeof(param)) == ESP_OK){
            config_status = 0;
            turn_off_led(LED_PIN);
            lcd_put_cur(0, 0);
            lcd_send_string("  DOOR  ACCESS  ");
            lcd_put_cur(1, 0);
            lcd_send_string("Status: scan");
            // put url_api
            strcpy(url_api, "http://");
            strcat(url_api, param);
            ESP_LOGI(TAG, "URLAPI: %s", url_api);
            //music
            for (int i = 0; i < 3; i++){
                play_sound(1500, 800);
            }
            play_sound(9000, 2000);
        }else if(httpd_query_key_value(query, "disconnect", param, sizeof(param)) == ESP_OK){
            config_status = 2;
            turn_on_led(LED_PIN);
            lcd_put_cur(0, 0);
            lcd_send_string("  DOOR  ACCESS  ");
            lcd_put_cur(1, 0);
            lcd_send_string("Status: init");
            //music
            for (int i = 0; i < 3; i++){
                play_sound(1500, 800);
            }
            play_sound(500, 2000);
        }
    }

    ESP_LOGI(TAG, "Config init");
    page_state = 1;
    return ESP_OK;
}

httpd_uri_t uri_config = {
    .uri = "/config",
    .method = HTTP_GET,
    .handler = config_handler,
    .user_ctx = NULL
  };

httpd_handle_t setup_server(void)
{
    httpd_config_t config = HTTPD_DEFAULT_CONFIG();
    httpd_handle_t server = NULL;

    if (httpd_start(&server, &config) == ESP_OK)
    {
        httpd_register_uri_handler(server, &uri_config);
    }

    return server;
}

char* get_url_api(){
    return url_api;
}