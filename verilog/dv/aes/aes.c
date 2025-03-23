#include "defs.h"
#include "stub.c"

#define BASE_ADDRESS    0x30000000
#define PLAINTEXT_ADDR  BASE_ADDRESS       // 128-bit, 4 writes
#define KEY_ADDR        (BASE_ADDRESS + 16) // 256-bit, 8 writes
#define CIPHERTEXT_ADDR (BASE_ADDRESS + 48) // 128-bit, 4 reads
#define BUTTON_ADDR     (BASE_ADDRESS + 64) // Trigger encryption

void send_plaintext(uint32_t data[4]) {
    volatile uint32_t *plaintext_ptr;
    for (int i = 0; i < 4; i++) {
        plaintext_ptr = (volatile uint32_t *)(PLAINTEXT_ADDR + (i * 4));  
        *plaintext_ptr = data[i];  
    }
}

void send_key(uint32_t key_data[8]) {
    volatile uint32_t *key_ptr;
    for (int i = 0; i < 8; i++) {
        key_ptr = (volatile uint32_t *)(KEY_ADDR + (i * 4));  
        *key_ptr = key_data[i];  
    }
}

void read_ciphertext(uint32_t result[4]) {
    volatile uint32_t *ciphertext_ptr;
    for (int i = 0; i < 4; i++) {
        ciphertext_ptr = (volatile uint32_t *)(CIPHERTEXT_ADDR + (i * 4));  
        result[i] = *ciphertext_ptr;
    }
}

int main() {
    uint32_t pt[4] = {0x00112233, 0x44556677, 0x8899aabb, 0xccddeeff};
    uint32_t key[8] = {0x00010203, 0x04050607, 0x08090a0b, 0x0c0d0e0f,
                       0x10111213, 0x14151617, 0x18191a1b, 0x1c1d1e1f};
    uint32_t ct[4];
    reg_spi_enable = 1;
    reg_wb_enable = 1;
   
        send_plaintext(pt);
         send_key(key);
         read_ciphertext(ct);


    return 0;
}
