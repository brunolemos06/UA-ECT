#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <esp_http_client.h>
#include <inttypes.h> // Include this header for PRIu64
#include "api.h"
#include "buffertags.h"
#include <esp_log.h>
#include <server.h>

bool isUser = false;

void api_adduser(uint64_t rfid) {
    char link[100];
    snprintf(link, sizeof(link), "%s/users?rfid=%" PRIu64, get_url_api(), rfid);
    esp_http_client_config_t config_get = {
        .url = link,
        .method = HTTP_METHOD_POST,
        .cert_pem = NULL,
        };
        
    esp_http_client_handle_t client = esp_http_client_init(&config_get);
    esp_http_client_perform(client);
    esp_http_client_cleanup(client);
}

void api_deluser(uint64_t rfid) {
    char payload[100];
    snprintf(payload, sizeof(payload), "%s/users?rfid=%" PRIu64, get_url_api(), rfid);
        esp_http_client_config_t config_get = {
        .url = link,
        .method = HTTP_METHOD_DELETE,
        .cert_pem = NULL,
        };
        
    esp_http_client_handle_t client = esp_http_client_init(&config_get);
    esp_http_client_perform(client);
    esp_http_client_cleanup(client);
}

esp_err_t client_event_get_handler_apiuser(esp_http_client_event_handle_t evt)
{
    switch (evt->event_id)
    {
    case HTTP_EVENT_ON_DATA:
        // verify if evt->data with data_len is "true" or "false"
        if (strncmp((char *)evt->data, "true", evt->data_len) == 0)
        {
            isUser = true;
        }
        else
        {
            isUser = false;
        }
        break;
    default:
        break;
    }
    return ESP_OK;
}

bool api_isuser(uint64_t rfid) {
    char link[100];
    snprintf(link, sizeof(link), "%s/users?rfid=%" PRIu64, get_url_api(), rfid);
    esp_http_client_config_t config_get = {
        .url = link,
        .method = HTTP_METHOD_GET,
        .cert_pem = NULL,
        .event_handler = client_event_get_handler_apiuser
    };
        
    esp_http_client_handle_t client = esp_http_client_init(&config_get);
    esp_http_client_perform(client);
    esp_http_client_cleanup(client);

    return isUser;
}

void api_addlogs(char *data,char *hora,char *rfid,char *status){
    char payload[100];
    snprintf(payload, sizeof(payload), "%s/logs?data=%s&hora=%s&rfid=%s&status=%s", get_url_api(), data, hora, rfid, status);
    esp_http_client_config_t config_get = {
        .url = payload,
        .method = HTTP_METHOD_POST,
        .cert_pem = NULL,
        };
    esp_http_client_handle_t client = esp_http_client_init(&config_get);
    esp_http_client_perform(client);
    esp_http_client_cleanup(client);
}

esp_err_t client_event_get_handler_gelallowedtags(esp_http_client_event_handle_t evt)
{
    switch (evt->event_id)
    {
    case HTTP_EVENT_ON_DATA:
        printf("HTTP_EVENT_ON_DATA: %.*s\n", evt->data_len, (char *)evt->data);
        char *token = strtok((char *)evt->data, " ");
        // stop when token is "finish"
        while (token != NULL){
            // convert to uint64_t
            if (strlen(token) > 0) {
                uint64_t tag = strtoull(token, NULL, 10);
                printf("tag: %" PRIu64 "\n", tag);
                addallowed_tag(tag);
                token = strtok(NULL, " ");
            }
        }
        break;
    default:
        break;
    }
    return ESP_OK;
}

void api_getallowedtags(){
    char link[100];
    snprintf(link, sizeof(link), "%s/users", get_url_api());
    esp_http_client_config_t config_get = {
        .url = link,
        .method = HTTP_METHOD_GET,
        .cert_pem = NULL,
        .event_handler = client_event_get_handler_gelallowedtags};
        
    esp_http_client_handle_t client = esp_http_client_init(&config_get);
    esp_http_client_perform(client);
    esp_http_client_cleanup(client);
}