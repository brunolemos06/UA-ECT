#include <esp_log.h>
#include <inttypes.h>
#include "driver/gpio.h"
#include "driver/i2c.h"
#include "esp_system.h"

#include "freertos/FreeRTOS.h"
#include "freertos/task.h"

#include "lcd.h"

static const char *TAG = "LCD";

esp_err_t i2c_master_init(void)
{
    i2c_config_t conf = {
        .mode = I2C_MODE_MASTER,
        .sda_io_num = GPIO_NUM_21,
        .scl_io_num = GPIO_NUM_22,
        .sda_pullup_en = GPIO_PULLUP_ENABLE,
        .scl_pullup_en = GPIO_PULLUP_ENABLE,

        .master.clk_speed = 100000,
    };

    i2c_param_config(I2C_NUM_0, &conf);

    return i2c_driver_install(I2C_NUM_0, conf.mode, 0, 0, 0);
}

void lcd_send_data (char data)

{

      esp_err_t err;

      char data_u, data_l;

      uint8_t data_t[4];

      data_u = (data&0xf0);

      data_l = ((data <<4)&0xf0);

      data_t[0] = data_u|0x0D;  //en=1, rs=1

      data_t[1] = data_u|0x09;  //en=0, rs=1

      data_t[2] = data_l|0x0D;  //en=1, rs=1

      data_t[3] = data_l|0x09;  //en=0, rs=1

 

      err=i2c_master_write_to_device (I2C_NUM_0, 0x27, data_t, 4, 1000);

      if (err !=0) ESP_LOGI(TAG, "Error no. %d in data", err);

}

void lcd_send_cmd (char cmd)
{
	esp_err_t err;
	char data_u, data_l;
	uint8_t data_t[4];
	data_u = (cmd&0xf0);
	data_l = ((cmd<<4)&0xf0);
	data_t[0] = data_u|0x0C;  //en=1, rs=0
	data_t[1] = data_u|0x08;  //en=0, rs=0
	data_t[2] = data_l|0x0C;  //en=1, rs=0
	data_t[3] = data_l|0x08;  //en=0, rs=0

	err= i2c_master_write_to_device (I2C_NUM_0, 0x27, data_t, 4, true);
	if (err != 0) ESP_LOGI(TAG, "Error no. %d in command", err);
}

void lcd_init (void)
{
	// 4 bit initialisation
	esp_rom_delay_us(50000);  // wait for >40ms
	lcd_send_cmd (0x30);
	esp_rom_delay_us(4500);  // wait for >4.1ms
	lcd_send_cmd (0x30);
	esp_rom_delay_us(200);  // wait for >100us
	lcd_send_cmd (0x30);
	esp_rom_delay_us(200);
	lcd_send_cmd (0x20);  // 4bit mode
	esp_rom_delay_us(200);

  // dislay initialisation
	lcd_send_cmd (0x28); // Function set --> DL=0 (4 bit mode), N = 1 (2 line display) F = 0 (5x8 characters)
	esp_rom_delay_us(1000);
	lcd_send_cmd (0x08); //Display on/off control --> D=0,C=0, B=0  ---> display off
	esp_rom_delay_us(1000);
	lcd_send_cmd (0x01);  // clear display
	esp_rom_delay_us(1000);
	esp_rom_delay_us(1000);
	lcd_send_cmd (0x06); //Entry mode set --> I/D = 1 (increment cursor) & S = 0 (no shift)
	esp_rom_delay_us(1000);
	lcd_send_cmd (0x0C); //Display on/off control --> D = 1, C and B = 0. (Cursor and blink, last two bits)
	esp_rom_delay_us(2000);
}

void lcd_put_cur(int row, int col)
{
    switch (row)
    {
        case 0:
            col |= 0x80;
            break;
        case 1:
            col |= 0xC0;
            break;
    }

    lcd_send_cmd (col);
}

void lcd_send_string (char *str)
{
    while (*str) lcd_send_data (*str++);
}

void lcd_clear (void)
{
	lcd_send_cmd (0x01);  // clear display
	esp_rom_delay_us(1000);
	esp_rom_delay_us(1000);
}