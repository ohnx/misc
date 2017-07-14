#include <alloca.h>
#include <dlfcn.h>
#include <stdio.h>
#include <stdlib.h>

void hexDump (char *desc, void *addr, int len) {
    int i;
    unsigned char buff[17];
    unsigned char *pc = (unsigned char*)addr;

    // Output description if given.
    if (desc != NULL)
        printf ("%s:\n", desc);

    if (len == 0) {
        printf("  ZERO LENGTH\n");
        return;
    }
    if (len < 0) {
        printf("  NEGATIVE LENGTH: %i\n",len);
        return;
    }

    // Process every byte in the data.
    for (i = 0; i < len; i++) {
        // Multiple of 16 means new line (with line offset).

        if ((i % 16) == 0) {
            // Just don't print ASCII for the zeroth line.
            if (i != 0)
                printf ("  %s\n", buff);

            // Output the offset.
            printf ("  %04x ", i);
        }

        // Now the hex code for the specific character.
        printf (" %02x", pc[i]);

        // And store a printable ASCII character for later.
        if ((pc[i] < 0x20) || (pc[i] > 0x7e))
            buff[i % 16] = '.';
        else
            buff[i % 16] = pc[i];
        buff[(i % 16) + 1] = '\0';
    }

    // Pad out last line if not exactly 16 characters.
    while ((i % 16) != 0) {
        printf ("   ");
        i++;
    }

    // And print the final ASCII bit.
    printf ("  %s\n", buff);
}


double test_func(double a, double b, double c) {
    return a + b + c;
}

/*
 * call a x86-64 cdecl function
 * 
 * cdecl specifies that the first few program args are, in order:
 * `rdi, rsi, rdx, rcx, r8, r9`.
 * further args are passed in the stack.
 */
double call_function_code_dbl(void *f, size_t argc, double *argv) {
    double ret;

    asm __volatile__ (
        /* create new stack frame */
        "pushq %%rbp"                                   "\n\t"
        "mov %%rsp, %%rsp"                              "\n\t"
        
        /* push the right items */
        "mov $3, %%rdi" /* pointer */"\n\t"
        "mov $5, %%rsi" /* a */      "\n\t"
        "mov $4, %%rdx" /* b */      "\n\t"

        /* call function */
        "call *%1"              "\n\t"
        "movq %%xmm0, %0"       "\n\t"
        
        /* cleanup */
        
        
        /* restore old stack frame */
        "popq %%rbp"            "\n\t"
        : "=r"(ret)
        : "r"(f)
        : "rax", "rbx", "rdi", "rsi", "rdx", "r8", "r9", "xmm0"
    );

    return ret;
}

double runfunc_dbl(const char *name, int arg_s, const void *arg_v) {
    void *handle, *func;
    double result = 0;
    
    double test[] = {1.1f, 2.2f, 3.3f};

    /* open libm */
    handle = dlopen(NULL, RTLD_LAZY);
    if (!handle) { /* verify success */
        fprintf(stderr, "Failed to open self: %s\n", dlerror());
        exit(1);
    }

    /* find the address of function */
    func = dlsym(handle, name);
    if (func == NULL) {
        fprintf(stderr, "Failed to find function `%s`: %s\n", name, dlerror());
        exit(1);
    }

    printf("Hello friends, I am calling function now. Address is %p, arg#%d, arg value start is %p\n", func, arg_s, arg_v);

    result = call_function_code_dbl(func, 3, test);

    /* cleanup */
    dlclose(handle);
    return result;
}

/* debug code - to use, compile with
 * `gcc runfunc.c -Iinclude/ -Wall -ldl -Werror -g -D__RUNFUNC_DEBUG -rdynamic` */
#ifdef __RUNFUNC_DEBUG
#include <stdio.h>

struct __attribute__((__packed__)) funcargs {
    char *str;
    int a;
    int b;
};

int main() {
    double test;
    
    test = test_func(1.0f, 2.0f, 3.3f);
    
    printf("lmao %g\n", test);
    return 0;
}
#endif
