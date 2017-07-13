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


double test_func(const char *s, int a, int b) {
    printf("s: `%p`; a: %d; b: %d\n", s, a, b);
    return 10.0f;
}

/* call a cdecl function */
double call_function_code_dbl(void *f, size_t arg_s, const void *arg_v) {
#if 0
    asm __volatile__ (
        "pushq %%rbp"           "\n\t"
        "mov %%rsp, %%rsp"      "\n\t"
        /* for loop */
        
        
    );
#endif
    size_t i, arg_sa;
    double ret = 0;


    /* at this point, we can no longer call external functions */
    arg_sa = arg_s / 2;

    /* make new call frame */
    asm __volatile__ (
        "pushq %%rbp"              "\n\t"
        "mov %%rsp, %%rbp"
        : /* no output */
        : /* no input */
        : /* technically ebp gets clobbered but we don't mention it to gcc ;) */
    );

    /* Copy all the parameters into the stack */
    for (i = 0; i < arg_sa; i++) {
        asm __volatile__ (
            /* push a word of data (8 bits) */
            "push %0"              "\n\t"
            : /* no output */
            : "r"(*(((short *) arg_v) + i)) /* value of this byte */
        );
    }

    /* Call the function */
    asm __volatile__ (
        /* call the function */
        "call *%1"           "\n\t"
        /* copy value of rax (64-bit return value) to ret */
        "movq %%xmm0, %0"    "\n\t"
        : "=r"(ret) /* store returned value xmm0 (output for SSE/floating-point) in ret */
        : "r"(f) /* input function location stored in rax (input) */
        : "xmm0"
    );

    /* Clean up */
    /* pop all parameters from stack */
    for (i = 0; i < arg_sa; i++) {
        asm __volatile__ (
            /* push a word of data (8 bits) */
            "pop %%ax"              "\n\t"
            : /* no output */
            : /* no input */
            : "ax"
        );
    }
    
    asm __volatile (
        /* restore old call frame */
        "popq %%rbp"           "\n\t"
        :::
    );

    return ret;
}

double runfunc_dbl(const char *name, int arg_s, const void *arg_v) {
    void *handle, *func;
    double result = 0;

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

    result = call_function_code_dbl(func, arg_s, arg_v);

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
    struct funcargs args;
    double test;
    char *strarg = "Hello World!";

    args.str = strarg;
    args.a = 10;
    args.b = 13;

    printf("funcargs is %ld large. strarg is at %p\n", sizeof(struct funcargs), &strarg);
    hexDump("strarg", &args, sizeof(args));
    test = test_func(args.str, args.a, args.b);
    
    test = runfunc_dbl("test_func", sizeof(struct funcargs), &args);
    hexDump("number", &test, sizeof(test));
    printf("lmao %g\n", test);
    return 0;
}
#endif
