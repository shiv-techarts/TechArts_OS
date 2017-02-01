#include "types.h"

void printf(const char* str) {
    uint16_t* videoMemory = (uint16_t*) 0xb8000;
    
    for(int i = 0; str[i] != '\0'; i++) {
        videoMemory[i] = ( videoMemory[i] & 0xFF00 ) | str[i];
    }
    
}
