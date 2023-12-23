#pragma once
#include <stdint.h>
#include <esp_http_client.h>


void api_adduser(uint64_t rfid);

void api_deluser(uint64_t rfid);

bool api_isuser(uint64_t rfid);

esp_err_t client_event_get_handler_apiuser(esp_http_client_event_handle_t evt);

void api_addlogs(char *data,char *hora,char *rfid,char *status);

void client_event_get_handler_logs(esp_http_client_event_handle_t evt);