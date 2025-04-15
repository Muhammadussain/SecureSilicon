#include "defs.h"
#include "stub.c"

#define BASE_ADDRESS    0x30000000
#define DIGEST_ADDR  BASE_ADDRESS       // 128-bit, 4 writes
#define DATA_ADDR        (BASE_ADDRESS + 32) // 256-bit, 8 writes

void send_data(uint32_t data[2]) {
    volatile uint32_t *data_ptr;
    for (int i = 0; i <2; i++) {
        data_ptr = (volatile uint32_t *)(DATA_ADDR + (i * 4));  
        *data_ptr = data[i];  
    }
}


void read_digest(uint32_t result[8]) {
    volatile uint32_t *digest_ptr;
    for (int i = 0; i < 4; i++) {
        digest_ptr = (volatile uint32_t *)(DIGEST_ADDR + (i * 4));  
        result[i] = *digest_ptr;
    }
}

int main() {
    uint32_t pt[2] = {0x33221100, 0x77665544};
    uint32_t dt[8];
    reg_spi_enable = 1;
    reg_wb_enable = 1;
   
        send_data(pt);
        
         read_digest(dt);


    return 0;
}
