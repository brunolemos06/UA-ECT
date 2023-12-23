#pragma once

#include <stdint.h>

void uart_init(void);

void get_char(bool echo);

void get_string(char *data,bool echo);
