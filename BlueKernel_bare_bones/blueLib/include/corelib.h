//this is the file for the main custom made library of BlueKernel and BlueOs
//this is the include file if you need to check the corelib you have to open the corelib.c file found in the src folder

#include <stddef.h>
#include <stdint.h>

#ifndef CORELIB_H
#define CORELIB_H

#define VGA_WIDTH 80
#define VGA_HEIGHT 25
#define VGA_MEMORY 0xB8000

extern size_t terminal_row;
extern size_t terminal_column;
extern uint8_t terminal_color;


//new line
void nl(void);
void nl_n(int n);

//terminal graphics
void terminal_scroll(void);
void clear_row(size_t row);
void copy_row(size_t src, size_t dest);

#endif