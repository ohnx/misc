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
        
        buf = malloc(length);
        
        if (buf) fread(buf, 1, length, f);
        
        fclose(f);
    } else {
        *length = 0;
    }
    return buf;
}

unsigned char crc8_block(unsigned char *bytes, long byteLen) {
    
}

int main(int argc, char *argv[]) {
    long byteLen;
    unsigned char *bytes;
    unsigned char crc8; /* crc8 is 1 byte */
    
    /* TODO: Stream bytes instead of taking them all at once */
    if (argc != 2) {
        printf("Usage: %s <input filename>.\n");
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
    
    crc8 = crc8_block(bytes, byteLen);
    
    /* clean up heap */
    free(bytes);
    
    return 0;
}
