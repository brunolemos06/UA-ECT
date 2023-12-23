#pragma once
#include <esp_log.h>

esp_err_t i2c_master_init(void);

void lcd_send_data(char data);

void lcd_send_cmd(char cmd);

void lcd_init(void);

void lcd_put_cur(int row, int col);

void lcd_send_string(char *str);

void lcd_clear(void);

