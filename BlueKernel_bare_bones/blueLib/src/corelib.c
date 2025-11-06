//this is the file for the main custom made library of BlueKernel and BlueOs
//this is the src file if you need to check the include of corelib you have to open the corelib.h file found in the include folder

#include "corelib.h" //include the corelib.h 

//library needed to make the code work
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

static uint16_t* terminal_buffer = (uint16_t*)VGA_MEMORY;

//new line function code
void nl_n(int n)
{	
	for (int i = 0; i < n; i++)
	{
		terminal_row++;
		terminal_column = 0;
	}
}
void nl(void)
{	
	nl_n(1);
}

//terminal graphics functions code

void copy_row(size_t src, size_t dest) {
    for (size_t col = 0; col < VGA_WIDTH; col++) {
        terminal_buffer[dest * VGA_WIDTH + col] =
            terminal_buffer[src * VGA_WIDTH + col];
    }
}

void clear_row(size_t row) {
    for (size_t col = 0; col < VGA_WIDTH; col++) {
        terminal_buffer[row * VGA_WIDTH + col] =
            (uint16_t)' ' | ((uint16_t)terminal_color << 8);
    }
}

void terminal_scroll(void) {
    for (size_t row = 1; row < VGA_HEIGHT; row++) {
        copy_row(row, row - 1);
    }
    clear_row(VGA_HEIGHT - 1);
}
