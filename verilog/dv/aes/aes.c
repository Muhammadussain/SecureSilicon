#include "defs.h"
#include "stub.c"

#define BASE_ADDRESS    0x30000000
#define PLAINTEXT_ADDR  BASE_ADDRESS       // 128-bit, 4 writes
#define KEY_ADDR        (BASE_ADDRESS + 16) // 256-bit, 8 writes
#define CIPHERTEXT_ADDR (BASE_ADDRESS + 48) // 128-bit, 4 reads
#define BUTTON_ADDR     (BASE_ADDRESS + 64) // Trigger encryption
#define CIPHERTEXT_SAVE_ADDR (BASE_ADDRESS + 80)  // Safe, writable region

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
void trigger_encryption() {
    volatile uint32_t *trigger_ptr = (volatile uint32_t *)(BUTTON_ADDR);
    *trigger_ptr = 1;  // Writing any value triggers the encryption
}
int main() {
    uint32_t pt[4] = {0x33221100, 0x77665544, 0xbbaa9988, 0xffeeddcc};
    uint32_t key[8] = {0x03020100, 0x07060504, 0x0b0a0908, 0x0f0e0d0c ,
                       0x13121110, 0x17161514, 0x1b1a1918, 0x1f1e1d1c};
    uint32_t ct[4];
    reg_spi_enable = 1;
    reg_wb_enable = 1;
   
        send_plaintext(pt);
         send_key(key);
         trigger_encryption();
         read_ciphertext(ct);


    return 0;
}
