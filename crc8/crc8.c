#include <stdio.h>
#include <stdlib.h>

/* simple function to read in all the bytes in the file */
unsigned char *readAllBytes(const char *filename, long *length) {
    unsigned char *buf = NULL;
    FILE *f;
    
    f = fopen(filename, "rb");
    
    if (f) {
        fseek(f, 0, SEEK_END);
        *length = ftell(f);
        fseek(f, 0, SEEK_SET);
        
        buf = malloc(*length);
        
        if (buf) fread(buf, 1, *length, f);
        
        fclose(f);
    } else {
        *length = 0;
    }
    return buf;
}

/* :( copied from https://barrgroup.com/Embedded-Systems/How-To/CRC-Calculation-C-Code */
unsigned char table8[256];

#define TOPBIT (1 << 7)
#define POLYNOMIAL 0x9b

void crc8_init() {
    int dividend;
    unsigned char bit, remainder;
    
    /*
     * Compute the remainder of each possible dividend.
     */
    for (dividend = 0; dividend < 256; dividend++) {
        /*
         * Start with the dividend followed by zeros.
         */
        remainder = dividend;

        /*
         * Perform modulo-2 division, a bit at a time.
         */
        for (bit = 8; bit > 0; --bit) {
            /*
             * Try to divide the current data bit.
             */
            if (remainder & TOPBIT) {
                remainder = (remainder << 1) ^ POLYNOMIAL;
            } else {
                remainder = (remainder << 1);
            }
        }

        /*
         * Store the result into the table.
         */
        table8[dividend] = remainder;
    }

}

unsigned char crc8_block(const unsigned char *bytes, long byteLen) {
    long rpos = 0;
    unsigned char remainder = 0, data;
    
    /*
     * Divide the message by the polynomial, a byte at a time.
     */
    for (rpos = 0; rpos < byteLen; ++rpos) {
        data = bytes[rpos] ^ remainder;
        remainder = table8[data] ^ (remainder << 8);
    }

    /*
     * The final remainder is the CRC.
     */
    return (remainder);
}

int main(int argc, char *argv[]) {
    long byteLen;
    unsigned char *bytes;
    unsigned char crc8; /* crc8 is 1 byte */
    
    /* TODO: Stream bytes instead of taking them all at once */
    if (argc != 2) {
        printf("Usage: %s <input filename>.\n", argv[0]);
        return -1;
    } else {
        bytes = readAllBytes(argv[1], &byteLen);
        /* check for errors */
        if (bytes == NULL) {
            if (byteLen == 0) { /* file not found */
                printf("Input file %s not found\n", argv[1]);
            } else { /* file too big or not enough memory */
                printf("Not enough memory\n");
            }
            return -2;
        }
    }
    
    crc8_init();
    crc8 = crc8_block(bytes, byteLen);
    
    printf("0x%02X\n", crc8);
    
    /* clean up heap */
    free(bytes);
    
    return 0;
}
