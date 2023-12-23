#pragma once
#include <stdint.h>

bool addallowed_tag(uint64_t tag_id);

bool is_allowed_tag(uint64_t serial_number);

bool removeTag(uint64_t tag_id);