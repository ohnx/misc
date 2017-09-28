/**
 * Test file for hashmap
 * 
 * To use, run:
 * 
 * $ gcc hashmap.c test.c -I. -o hashmap 
 * $ ./hashmap
 */

#include <stdio.h>
#include "hashmap.h"

int main() {
    char buf[16];
    hashmap *hm;
    int i;
    int n = 1337;

    hm = hashmap_new();

    hashmap_put(hm, "test", hm);

    for (int i = 0; i < 1000; i++) {
        sprintf(buf, "-%d-", i);
        hashmap_put(hm, buf, &n);
    }

    hashmap_remove(hm, "test");

    for (int i = 0; i < 1000; i++) {
        sprintf(buf, "-%d-", i);
        if (n != *(int *)hashmap_get(hm, buf)) {
            printf("Test failed!!!\n");
            return -1;
        }
    }
    
    hashmap_destroy(hm);
    return 0;
}