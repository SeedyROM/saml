#pragma once

#include <stddef.h>

typedef struct {
  size_t line, col;
} saml_scanner_pos;

typedef struct {
  saml_scanner_pos pos;
} saml_scanner;