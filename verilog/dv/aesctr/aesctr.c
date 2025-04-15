#include "defs.h"
#include "stub.c"
#include "string.h"
#include "stdint.h"
#define BASE_ADDRESS    0x30000000
#define IV_ADDR         BASE_ADDRESS       // 128-bit, 4 writes
#define KEY_ADDR        (BASE_ADDRESS + 16) // 256-bit, 8 writes
#define PLAINTEXT_ADDR  (BASE_ADDRESS + 48) // 1024-bit, 32 writes
#define ENCRYPTEDTEXT_ADDR (BASE_ADDRESS + 176) // 1024-bit, 32 reads

void send_iv(uint32_t data[4]) {
    volatile uint32_t *iv_ptr;
    for (int i = 0; i < 4; i++) {
        iv_ptr = (volatile uint32_t *)(IV_ADDR + (i * 4));  
        *iv_ptr = data[i];  
    }
}

void send_key(uint32_t key_data[8]) {
    volatile uint32_t *key_ptr;
    for (int i = 0; i < 8; i++) {
        key_ptr = (volatile uint32_t *)(KEY_ADDR + (i * 4));  
        *key_ptr = key_data[i];  
    }
}

void send_plaintext(uint32_t pt_data[32]) {
    volatile uint32_t *pt_ptr;
    for (int i = 0; i < 32; i++) {
        pt_ptr = (volatile uint32_t *)(PLAINTEXT_ADDR + (i * 4));  
        *pt_ptr = pt_data[i];  
    }
}

void read_encryptedtext(uint32_t result[32]) {
    volatile uint32_t *encryptedtext_ptr;
    for (int i = 0; i < 32; i++) {
        encryptedtext_ptr = (volatile uint32_t *)(ENCRYPTEDTEXT_ADDR + (i * 4));  
        result[i] = *encryptedtext_ptr;
    }
}
void *memcpy(void *dest, const void *src, size_t n) {
    char *d = dest;
    const char *s = src;
    while (n--) {
        *d++ = *s++;
    }
    return dest;
}

int main() {
    uint32_t iv[4] = {0x33221100, 0x77665544, 0xbbaa9988, 0xffeeddcc};
    uint32_t key[8] = {0x03020100, 0x07060504, 0x0b0a0908, 0x0f0e0d0c,
                       0x13121110, 0x17161514, 0x1b1a1918, 0x1f1e1d1c};
    uint32_t plaintext[32] = {
        0xD22DB070, 0x9729E679, 0x160A8B41, 0x285F0779, 
        0x766D7F6D, 0x7AF92982, 0x65CFE723, 0x9554C574,
        0x2E9B36F6, 0x2EEBA8CF, 0x81485972, 0x70872E74,
        0x2C092A14, 0x554C3201, 0x3C451BC4, 0xD2F314F5,
        0xBA9CC254, 0xA8B36753, 0xE1D0E2B3, 0xE63AC718,
        0x069956E2, 0x6F5E22BD, 0xD8D18DB4, 0xF4341201,
        0x03A531E7, 0xEA1C4A0F, 0x30E80827, 0x1BCC00F6,
        0x506322B8, 0x4BECADAD, 0x642CDAC8, 0xDBF1D806
    };
    uint32_t encryptedtext[32];

    reg_spi_enable = 1;
    reg_wb_enable = 1;
    
    send_iv(iv);         // Writing IV
    send_plaintext(plaintext);  // Writing plaintext
    send_key(key);       // Writing key
    read_encryptedtext(encryptedtext); // Reading encrypted text

    return 0;
}
