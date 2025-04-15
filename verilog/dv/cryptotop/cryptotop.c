#include "defs.h"
#include "stub.c"
#include "string.h"
#include "stdint.h"
#include <stddef.h>
// AES Memory Map
#define BASE_ADDRESS         0x30000000

// AES-related
#define IV_ADDR              (BASE_ADDRESS )       // 128-bit = 16 bytes = 4 writes
#define KEY_ADDR             (BASE_ADDRESS + 16)      // 256-bit = 32 bytes = 8 writes
#define PLAINTEXT_ADDR       (BASE_ADDRESS + 48)      // 1024-bit = 128 bytes = 32 writes
#define CIPHERTEXT_ADDR      (BASE_ADDRESS + 176)     // 1024-bit = 128 bytes = 32 reads
#define AES_BUTTON_ADDR      (BASE_ADDRESS + 304)     // Trigger AES encryption

// SHA-related
#define SHA_BUTTON_ADDR      (BASE_ADDRESS + 308)     // Trigger SHA3 hash
#define DIGEST_ADDR          (BASE_ADDRESS + 312)     // 256-bit = 32 bytes = 8 reads
#define DATA_ADDR            (BASE_ADDRESS + 344)     // 2496-bit = 312 bytes = 78 writes

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
void send_ciphertext(uint32_t et_data[32]) {
    volatile uint32_t *encryptedtext_ptr;
    for (int i = 0; i < 32; i++) {
        encryptedtext_ptr = (volatile uint32_t *)(CIPHERTEXT_ADDR + (i * 4));  
        *encryptedtext_ptr = et_data[i];  
    }
}

void trigger_aes() {
    volatile uint32_t *trigger_ptr = (volatile uint32_t *)(AES_BUTTON_ADDR);
    *trigger_ptr = 1;  // Writing any value triggers the encryption
}

// -------------------- SHA FUNCTIONS --------------------
void send_data(uint32_t data[2]) {
    volatile uint32_t *data_ptr;
    for (int i = 0; i <2; i++) {
        data_ptr = (volatile uint32_t *)(DATA_ADDR + (i * 4));  
        *data_ptr = data[i];  
    }
}

void read_digest(uint32_t result[8]) {
    volatile uint32_t *digest_ptr;
    for (int i = 0; i < 8; i++) {
        digest_ptr = (volatile uint32_t *)(DIGEST_ADDR + (i * 4));  
        result[i] = *digest_ptr;
    }
}

void trigger_sha() {
    volatile uint32_t *trigger_ptr = (volatile uint32_t *)(SHA_BUTTON_ADDR);
    *trigger_ptr = 1;  // Writing any value triggers the encryption
}
void *memcpy(void *dest, const void *src, size_t n) {
    uint32_t *d32 = (uint32_t *)dest;
    const uint32_t *s32 = (const uint32_t *)src;
    size_t n32 = n / 4;

    while (n32--) {
        *d32++ = *s32++;
    }
    uint8_t *d8 = (uint8_t *)d32;
    const uint8_t *s8 = (const uint8_t *)s32;
    size_t n8 = n % 4;

    while (n8--) {
        *d8++ = *s8++;
    }

    return dest;
}

int main() {
    reg_spi_enable = 1;
    reg_wb_enable = 1;
    
//     uint32_t data[2] = {0x00000000, 0x00000000};
//    // uint32_t digest[8];
//     send_data(data);
//     trigger_sha(); 
     uint32_t iv[4] = {0x33221100, 0x77665544, 0xbbaa9988, 0xffeeddcc};
    uint32_t key[8] = {
        0x03020100, 0x07060504, 0x0b0a0908, 0x0f0e0d0c,
        0x13121110, 0x17161514, 0x1b1a1918, 0x1f1e1d1c
    };
    uint32_t plaintext[32] = {
    0xDBF1D806, 0x642CDAC8, 0x4BECADAD, 0x506322B8, 
    0x1BCC00F6, 0x30E80827, 0xEA1C4A0F, 0x03A531E7, 
    0xF4341201, 0xD8D18DB4, 0x6F5E22BD, 0x069956E2, 
    0xE63AC718, 0xE1D0E2B3, 0xA8B36753, 0xBA9CC254, 
    0xD2F314F5, 0x3C451BC4, 0x554C3201, 0x2C092A14, 
    0x70872E74, 0x81485972, 0x2EEBA8CF, 0x2E9B36F6, 
    0x9554C574, 0x65CFE723, 0x7AF92982, 0x766D7F6D, 
    0x285F0779, 0x160A8B41, 0x9729E679, 0xD22DB070
};
    uint32_t encryption_buffer[32];
    
    // // fill local_buffer with values, then:
    memcpy(encryption_buffer, plaintext, sizeof(uint32_t) * 32);
    // uint32_t ciphertext[32] = {
    //     0x11467a88, 0xdb69bd99, 0xdba55147, 0xd9036bf3, 
    //     0x45b1ae77, 0x43573066, 0x9b946002, 0x0f68f319, 
    //     0xa43b430e, 0x1d448406, 0x34b53dce, 0xa9d79e76, 
    //     0xa0ee974e, 0x9961222a, 0x4e54829b, 0x03e38936, 
    //     0x9cd65d1c, 0x17cf81eb, 0xdc89760a, 0x84e0980e, 
    //     0x0389a310, 0x7fa44940, 0x4ce449fe, 0xe05e970d, 
    //     0xa4bd2eda, 0x74e18efc, 0xcdf1e6c1, 0x90c300ca, 
    //     0x0dd4bf6b, 0xa7173904, 0xf65ec80a, 0x29e41b63
    // };
    // uint32_t decryption_buffer[32];
    
    // // fill local_buffer with values, then:
    // memcpy(decryption_buffer, ciphertext, sizeof(uint32_t) * 32);
     send_iv(iv);
     send_key(key);
    //  send_ciphertext(ciphertext);
        send_plaintext(plaintext);
      trigger_aes();
  
return 0;
  
}