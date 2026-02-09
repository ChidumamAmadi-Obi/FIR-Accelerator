#pragma once

#include <stdio.h>  // Add this for printf

#define COLOR_RED printf("\x1b[31m");
#define COLOR_GREEN printf("\x1b[32m");
#define COLOR_YELLOW printf("\x1b[33m");
#define COLOR_BOLD_RED printf("\x1b[1;31m");    
#define COLOR_BOLD_GREEN printf("\x1b[1;32m"); 
#define COLOR_BOLD_WHITE printf("\x1b[1;37m"); 
#define COLOR_BOLD_YELLOW printf("\x1b[1;33m");
#define COLOR_RESET printf("\x1b[0m");