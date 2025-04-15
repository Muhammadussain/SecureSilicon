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
// void read_ciphertext(uint32_t result[4]) {
//     volatile uint32_t *ciphertext_ptr;
//     for (int i = 0; i < 4; i++) {
//         ciphertext_ptr = (volatile uint32_t *)(CIPHERTEXT_ADDR + (i * 4));  
//         result[i] = *ciphertext_ptr;
//     }
// }
void read_encryptedtext(uint32_t result[32]) {
    volatile uint32_t *encryptedtext_ptr;
    for (int i = 0; i < 32; i++) {
        encryptedtext_ptr = (volatile uint32_t *)(CIPHERTEXT_ADDR + (i * 4));  
        result[i] = *encryptedtext_ptr;
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

    // handle remaining bytes
    uint8_t *d8 = (uint8_t *)d32;
    const uint8_t *s8 = (const uint8_t *)s32;
    size_t n8 = n % 4;

    while (n8--) {
        *d8++ = *s8++;
    }

    return dest;
}


// int main() {
//     reg_spi_enable = 1;
//     reg_wb_enable = 1;
//     // uint32_t iv[4] = {0x33221100, 0x77665544, 0xbbaa9988, 0xffeeddcc};
//     // uint32_t key[8] = {0x03020100, 0x07060504, 0x0b0a0908, 0x0f0e0d0c,
//     //                    0x13121110, 0x17161514, 0x1b1a1918, 0x1f1e1d1c};
//     // uint32_t plaintext[32] = {
//     //     0xD22DB070, 0x9729E679, 0x160A8B41, 0x285F0779, 
//     //     0x766D7F6D, 0x7AF92982, 0x65CFE723, 0x9554C574,
//     //     0x2E9B36F6, 0x2EEBA8CF, 0x81485972, 0x70872E74,
//     //     0x2C092A14, 0x554C3201, 0x3C451BC4, 0xD2F314F5,
//     //     0xBA9CC254, 0xA8B36753, 0xE1D0E2B3, 0xE63AC718,
//     //     0x069956E2, 0x6F5E22BD, 0xD8D18DB4, 0xF4341201,
//     //     0x03A531E7, 0xEA1C4A0F, 0x30E80827, 0x1BCC00F6,
//     //     0x506322B8, 0x4BECADAD, 0x642CDAC8, 0xDBF1D806
//     // };
//     // uint32_t encryptedtext[32];
//     // Sample AES Input
//     // uint32_t pt[4] = {0x33221100, 0x77665544, 0xbbaa9988, 0xffeeddcc};
//     // uint32_t key[8] = {
//     //     0x03020100, 0x07060504, 0x0b0a0908, 0x0f0e0d0c,
//     //     0x13121110, 0x17161514, 0x1b1a1918, 0x1f1e1d1c
//     // };
//     // uint32_t ct[4];

//     // Sample SHA Input
//     uint32_t data[2] = {0x00000000, 0x00000000};
//     uint32_t digest[8];

//     // ---- Run AES ----
// //     send_plaintext(pt);
// //     send_key(key);
// //    trigger_aes();         // Only triggers AES
// //     read_ciphertext(ct);
//     // send_iv(iv);         // Writing IV
//     // send_plaintext(plaintext);  // Writing plaintext
//     // send_key(key);       // Writing key
//     // read_encryptedtext(encryptedtext); 
//     // ---- Run SHA ----
//   //  send_data(data);
//    trigger_aes();  
//   //  trigger_sha();         // Only triggers SHA
//   //  read_digest(digest);

//     return 0;
// }
int main() {
    reg_spi_enable = 1;
    reg_wb_enable = 1;
    
    // uint32_t data[2] = {0x00000000, 0x00000000};
    // uint32_t digest[8];
    // send_data(data);
    // trigger_sha(); 
     uint32_t iv[4] = {0x33221100, 0x77665544, 0xbbaa9988, 0xffeeddcc};
    uint32_t key[8] = {
        0x03020100, 0x07060504, 0x0b0a0908, 0x0f0e0d0c,
        0x13121110, 0x17161514, 0x1b1a1918, 0x1f1e1d1c
    };
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
    uint32_t local_buffer[32];
    
    // fill local_buffer with values, then:
    memcpy(local_buffer, plaintext, sizeof(uint32_t) * 32);
    
//     uint32_t encryptedtext[32];
    
     send_iv(iv);
     send_key(key);
     send_plaintext(plaintext);
     trigger_aes();
  
   // read_encryptedtext(encryptedtext);
return 0;
  
}