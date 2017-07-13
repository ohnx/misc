	.file	"runfunc.c"
	.text
.Ltext0:
	.section	.rodata
.LC0:
	.string	"%s:\n"
.LC1:
	.string	"  ZERO LENGTH"
.LC2:
	.string	"  NEGATIVE LENGTH: %i\n"
.LC3:
	.string	"  %s\n"
.LC4:
	.string	"  %04x "
.LC5:
	.string	" %02x"
.LC6:
	.string	"   "
	.text
	.globl	hexDump
	.type	hexDump, @function
hexDump:
.LFB2:
	.file 1 "runfunc.c"
	.loc 1 6 0
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$80, %rsp
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movl	%edx, -68(%rbp)
	.loc 1 6 0
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	.loc 1 9 0
	movq	-64(%rbp), %rax
	movq	%rax, -40(%rbp)
	.loc 1 12 0
	cmpq	$0, -56(%rbp)
	je	.L2
	.loc 1 13 0
	movq	-56(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC0, %edi
	movl	$0, %eax
	call	printf
.L2:
	.loc 1 15 0
	cmpl	$0, -68(%rbp)
	jne	.L3
	.loc 1 16 0
	movl	$.LC1, %edi
	call	puts
	.loc 1 17 0
	jmp	.L1
.L3:
	.loc 1 19 0
	cmpl	$0, -68(%rbp)
	jns	.L5
	.loc 1 20 0
	movl	-68(%rbp), %eax
	movl	%eax, %esi
	movl	$.LC2, %edi
	movl	$0, %eax
	call	printf
	.loc 1 21 0
	jmp	.L1
.L5:
	.loc 1 25 0
	movl	$0, -44(%rbp)
	jmp	.L6
.L12:
	.loc 1 28 0
	movl	-44(%rbp), %eax
	andl	$15, %eax
	testl	%eax, %eax
	jne	.L7
	.loc 1 30 0
	cmpl	$0, -44(%rbp)
	je	.L8
	.loc 1 31 0
	leaq	-32(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC3, %edi
	movl	$0, %eax
	call	printf
.L8:
	.loc 1 34 0
	movl	-44(%rbp), %eax
	movl	%eax, %esi
	movl	$.LC4, %edi
	movl	$0, %eax
	call	printf
.L7:
	.loc 1 38 0
	movl	-44(%rbp), %eax
	movslq	%eax, %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	movl	%eax, %esi
	movl	$.LC5, %edi
	movl	$0, %eax
	call	printf
	.loc 1 41 0
	movl	-44(%rbp), %eax
	movslq	%eax, %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$31, %al
	jbe	.L9
	.loc 1 41 0 is_stmt 0 discriminator 1
	movl	-44(%rbp), %eax
	movslq	%eax, %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$126, %al
	jbe	.L10
.L9:
	.loc 1 42 0 is_stmt 1
	movl	-44(%rbp), %eax
	cltd
	shrl	$28, %edx
	addl	%edx, %eax
	andl	$15, %eax
	subl	%edx, %eax
	cltq
	movb	$46, -32(%rbp,%rax)
	jmp	.L11
.L10:
	.loc 1 44 0
	movl	-44(%rbp), %eax
	cltd
	shrl	$28, %edx
	addl	%edx, %eax
	andl	$15, %eax
	subl	%edx, %eax
	movl	%eax, %ecx
	movl	-44(%rbp), %eax
	movslq	%eax, %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %edx
	movslq	%ecx, %rax
	movb	%dl, -32(%rbp,%rax)
.L11:
	.loc 1 45 0 discriminator 2
	movl	-44(%rbp), %eax
	cltd
	shrl	$28, %edx
	addl	%edx, %eax
	andl	$15, %eax
	subl	%edx, %eax
	addl	$1, %eax
	cltq
	movb	$0, -32(%rbp,%rax)
	.loc 1 25 0 discriminator 2
	addl	$1, -44(%rbp)
.L6:
	.loc 1 25 0 is_stmt 0 discriminator 1
	movl	-44(%rbp), %eax
	cmpl	-68(%rbp), %eax
	jl	.L12
	.loc 1 49 0 is_stmt 1
	jmp	.L13
.L14:
	.loc 1 50 0
	movl	$.LC6, %edi
	movl	$0, %eax
	call	printf
	.loc 1 51 0
	addl	$1, -44(%rbp)
.L13:
	.loc 1 49 0
	movl	-44(%rbp), %eax
	andl	$15, %eax
	testl	%eax, %eax
	jne	.L14
	.loc 1 55 0
	leaq	-32(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC3, %edi
	movl	$0, %eax
	call	printf
.L1:
	.loc 1 56 0
	movq	-8(%rbp), %rax
	xorq	%fs:40, %rax
	je	.L16
	call	__stack_chk_fail
.L16:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	hexDump, .-hexDump
	.section	.rodata
.LC7:
	.string	"s: %p `%s`; a: %d; b: %d\n"
	.text
	.globl	test_func
	.type	test_func, @function
test_func:
.LFB3:
	.loc 1 59 0
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movl	%edx, -16(%rbp)
	.loc 1 60 0
	movl	-16(%rbp), %esi
	movl	-12(%rbp), %ecx
	movq	-8(%rbp), %rdx
	movq	-8(%rbp), %rax
	movl	%esi, %r8d
	movq	%rax, %rsi
	movl	$.LC7, %edi
	movl	$0, %eax
	call	printf
	.loc 1 61 0
	movsd	.LC8(%rip), %xmm0
	.loc 1 62 0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	test_func, .-test_func
	.section	.rodata
.LC9:
	.string	"test string"
	.text
	.globl	call_function_code_dbl
	.type	call_function_code_dbl, @function
call_function_code_dbl:
.LFB4:
	.loc 1 65 0
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	.cfi_offset 3, -24
	movq	%rdi, -32(%rbp)
	movq	%rsi, -40(%rbp)
	movq	%rdx, -48(%rbp)
	.loc 1 66 0
	movq	$.LC9, -24(%rbp)
	.loc 1 69 0
	movq	-32(%rbp), %rdx
	movq	-24(%rbp), %rcx
#APP
# 69 "runfunc.c" 1
	pushq %rbp
	mov %rsp, %rsp
	pushq %rcx
	pushq $5
	pushq $4
	call *%rdx
	movq %xmm0, %rdx
	addq $24, %rsp
	popq %rbp
	
# 0 "" 2
#NO_APP
	movq	%rdx, -16(%rbp)
	.loc 1 93 0
	movsd	-16(%rbp), %xmm0
	.loc 1 94 0
	popq	%rbx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	call_function_code_dbl, .-call_function_code_dbl
	.section	.rodata
.LC11:
	.string	"Failed to open self: %s\n"
	.align 8
.LC12:
	.string	"Failed to find function `%s`: %s\n"
	.align 8
.LC13:
	.string	"Hello friends, I am calling function now. Address is %p, arg#%d, arg value start is %p\n"
	.text
	.globl	runfunc_dbl
	.type	runfunc_dbl, @function
runfunc_dbl:
.LFB5:
	.loc 1 96 0
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%rdi, -40(%rbp)
	movl	%esi, -44(%rbp)
	movq	%rdx, -56(%rbp)
	.loc 1 98 0
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -24(%rbp)
	.loc 1 101 0
	movl	$1, %esi
	movl	$0, %edi
	call	dlopen
	movq	%rax, -16(%rbp)
	.loc 1 102 0
	cmpq	$0, -16(%rbp)
	jne	.L22
	.loc 1 103 0
	call	dlerror
	movq	%rax, %rdx
	movq	stderr(%rip), %rax
	movl	$.LC11, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	.loc 1 104 0
	movl	$1, %edi
	call	exit
.L22:
	.loc 1 108 0
	movq	-40(%rbp), %rdx
	movq	-16(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	dlsym
	movq	%rax, -8(%rbp)
	.loc 1 109 0
	cmpq	$0, -8(%rbp)
	jne	.L23
	.loc 1 110 0
	call	dlerror
	movq	%rax, %rcx
	movq	stderr(%rip), %rax
	movq	-40(%rbp), %rdx
	movl	$.LC12, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	.loc 1 111 0
	movl	$1, %edi
	call	exit
.L23:
	.loc 1 114 0
	movq	-56(%rbp), %rcx
	movl	-44(%rbp), %edx
	movq	-8(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC13, %edi
	movl	$0, %eax
	call	printf
	.loc 1 116 0
	movl	-44(%rbp), %eax
	movslq	%eax, %rcx
	movq	-56(%rbp), %rdx
	movq	-8(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	call_function_code_dbl
	movq	%xmm0, %rax
	movq	%rax, -24(%rbp)
	.loc 1 119 0
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	dlclose
	.loc 1 120 0
	movsd	-24(%rbp), %xmm0
	.loc 1 121 0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	runfunc_dbl, .-runfunc_dbl
	.section	.rodata
.LC14:
	.string	"Hello World!"
	.align 8
.LC15:
	.string	"funcargs is %ld large. strarg is at %p\n"
.LC16:
	.string	"strarg"
.LC17:
	.string	"test_func"
.LC18:
	.string	"number"
.LC19:
	.string	"lmao %g\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB6:
	.loc 1 134 0
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	.loc 1 134 0
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	.loc 1 137 0
	movq	$.LC14, -40(%rbp)
	.loc 1 139 0
	movq	-40(%rbp), %rax
	movq	%rax, -32(%rbp)
	.loc 1 140 0
	movl	$10, -24(%rbp)
	.loc 1 141 0
	movl	$13, -20(%rbp)
	.loc 1 143 0
	leaq	-40(%rbp), %rax
	movq	%rax, %rdx
	movl	$16, %esi
	movl	$.LC15, %edi
	movl	$0, %eax
	call	printf
	.loc 1 144 0
	leaq	-32(%rbp), %rax
	movl	$16, %edx
	movq	%rax, %rsi
	movl	$.LC16, %edi
	call	hexDump
	.loc 1 145 0
	movl	-20(%rbp), %edx
	movl	-24(%rbp), %ecx
	movq	-32(%rbp), %rax
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	test_func
	movq	%xmm0, %rax
	movq	%rax, -48(%rbp)
	.loc 1 147 0
	leaq	-32(%rbp), %rax
	movq	%rax, %rdx
	movl	$16, %esi
	movl	$.LC17, %edi
	call	runfunc_dbl
	movq	%xmm0, %rax
	movq	%rax, -48(%rbp)
	.loc 1 148 0
	leaq	-48(%rbp), %rax
	movl	$8, %edx
	movq	%rax, %rsi
	movl	$.LC18, %edi
	call	hexDump
	.loc 1 149 0
	movq	-48(%rbp), %rax
	movq	%rax, -56(%rbp)
	movsd	-56(%rbp), %xmm0
	movl	$.LC19, %edi
	movl	$1, %eax
	call	printf
	.loc 1 150 0
	movl	$0, %eax
	.loc 1 151 0
	movq	-8(%rbp), %rcx
	xorq	%fs:40, %rcx
	je	.L27
	call	__stack_chk_fail
.L27:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	main, .-main
	.section	.rodata
	.align 8
.LC8:
	.long	0
	.long	1076101120
	.text
.Letext0:
	.file 2 "/usr/lib/gcc/x86_64-linux-gnu/5/include/stddef.h"
	.file 3 "/usr/include/x86_64-linux-gnu/bits/types.h"
	.file 4 "/usr/include/libio.h"
	.file 5 "/usr/include/stdio.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.long	0x4d6
	.value	0x4
	.long	.Ldebug_abbrev0
	.byte	0x8
	.uleb128 0x1
	.long	.LASF68
	.byte	0xc
	.long	.LASF69
	.long	.LASF70
	.quad	.Ltext0
	.quad	.Letext0-.Ltext0
	.long	.Ldebug_line0
	.uleb128 0x2
	.long	.LASF7
	.byte	0x2
	.byte	0xd8
	.long	0x38
	.uleb128 0x3
	.byte	0x8
	.byte	0x7
	.long	.LASF0
	.uleb128 0x3
	.byte	0x1
	.byte	0x8
	.long	.LASF1
	.uleb128 0x3
	.byte	0x2
	.byte	0x7
	.long	.LASF2
	.uleb128 0x3
	.byte	0x4
	.byte	0x7
	.long	.LASF3
	.uleb128 0x3
	.byte	0x1
	.byte	0x6
	.long	.LASF4
	.uleb128 0x3
	.byte	0x2
	.byte	0x5
	.long	.LASF5
	.uleb128 0x4
	.byte	0x4
	.byte	0x5
	.string	"int"
	.uleb128 0x3
	.byte	0x8
	.byte	0x5
	.long	.LASF6
	.uleb128 0x2
	.long	.LASF8
	.byte	0x3
	.byte	0x83
	.long	0x69
	.uleb128 0x2
	.long	.LASF9
	.byte	0x3
	.byte	0x84
	.long	0x69
	.uleb128 0x3
	.byte	0x8
	.byte	0x7
	.long	.LASF10
	.uleb128 0x5
	.byte	0x8
	.uleb128 0x6
	.byte	0x8
	.long	0x95
	.uleb128 0x3
	.byte	0x1
	.byte	0x6
	.long	.LASF11
	.uleb128 0x7
	.long	.LASF41
	.byte	0xd8
	.byte	0x4
	.byte	0xf1
	.long	0x219
	.uleb128 0x8
	.long	.LASF12
	.byte	0x4
	.byte	0xf2
	.long	0x62
	.byte	0
	.uleb128 0x8
	.long	.LASF13
	.byte	0x4
	.byte	0xf7
	.long	0x8f
	.byte	0x8
	.uleb128 0x8
	.long	.LASF14
	.byte	0x4
	.byte	0xf8
	.long	0x8f
	.byte	0x10
	.uleb128 0x8
	.long	.LASF15
	.byte	0x4
	.byte	0xf9
	.long	0x8f
	.byte	0x18
	.uleb128 0x8
	.long	.LASF16
	.byte	0x4
	.byte	0xfa
	.long	0x8f
	.byte	0x20
	.uleb128 0x8
	.long	.LASF17
	.byte	0x4
	.byte	0xfb
	.long	0x8f
	.byte	0x28
	.uleb128 0x8
	.long	.LASF18
	.byte	0x4
	.byte	0xfc
	.long	0x8f
	.byte	0x30
	.uleb128 0x8
	.long	.LASF19
	.byte	0x4
	.byte	0xfd
	.long	0x8f
	.byte	0x38
	.uleb128 0x8
	.long	.LASF20
	.byte	0x4
	.byte	0xfe
	.long	0x8f
	.byte	0x40
	.uleb128 0x9
	.long	.LASF21
	.byte	0x4
	.value	0x100
	.long	0x8f
	.byte	0x48
	.uleb128 0x9
	.long	.LASF22
	.byte	0x4
	.value	0x101
	.long	0x8f
	.byte	0x50
	.uleb128 0x9
	.long	.LASF23
	.byte	0x4
	.value	0x102
	.long	0x8f
	.byte	0x58
	.uleb128 0x9
	.long	.LASF24
	.byte	0x4
	.value	0x104
	.long	0x251
	.byte	0x60
	.uleb128 0x9
	.long	.LASF25
	.byte	0x4
	.value	0x106
	.long	0x257
	.byte	0x68
	.uleb128 0x9
	.long	.LASF26
	.byte	0x4
	.value	0x108
	.long	0x62
	.byte	0x70
	.uleb128 0x9
	.long	.LASF27
	.byte	0x4
	.value	0x10c
	.long	0x62
	.byte	0x74
	.uleb128 0x9
	.long	.LASF28
	.byte	0x4
	.value	0x10e
	.long	0x70
	.byte	0x78
	.uleb128 0x9
	.long	.LASF29
	.byte	0x4
	.value	0x112
	.long	0x46
	.byte	0x80
	.uleb128 0x9
	.long	.LASF30
	.byte	0x4
	.value	0x113
	.long	0x54
	.byte	0x82
	.uleb128 0x9
	.long	.LASF31
	.byte	0x4
	.value	0x114
	.long	0x25d
	.byte	0x83
	.uleb128 0x9
	.long	.LASF32
	.byte	0x4
	.value	0x118
	.long	0x26d
	.byte	0x88
	.uleb128 0x9
	.long	.LASF33
	.byte	0x4
	.value	0x121
	.long	0x7b
	.byte	0x90
	.uleb128 0x9
	.long	.LASF34
	.byte	0x4
	.value	0x129
	.long	0x8d
	.byte	0x98
	.uleb128 0x9
	.long	.LASF35
	.byte	0x4
	.value	0x12a
	.long	0x8d
	.byte	0xa0
	.uleb128 0x9
	.long	.LASF36
	.byte	0x4
	.value	0x12b
	.long	0x8d
	.byte	0xa8
	.uleb128 0x9
	.long	.LASF37
	.byte	0x4
	.value	0x12c
	.long	0x8d
	.byte	0xb0
	.uleb128 0x9
	.long	.LASF38
	.byte	0x4
	.value	0x12e
	.long	0x2d
	.byte	0xb8
	.uleb128 0x9
	.long	.LASF39
	.byte	0x4
	.value	0x12f
	.long	0x62
	.byte	0xc0
	.uleb128 0x9
	.long	.LASF40
	.byte	0x4
	.value	0x131
	.long	0x273
	.byte	0xc4
	.byte	0
	.uleb128 0xa
	.long	.LASF71
	.byte	0x4
	.byte	0x96
	.uleb128 0x7
	.long	.LASF42
	.byte	0x18
	.byte	0x4
	.byte	0x9c
	.long	0x251
	.uleb128 0x8
	.long	.LASF43
	.byte	0x4
	.byte	0x9d
	.long	0x251
	.byte	0
	.uleb128 0x8
	.long	.LASF44
	.byte	0x4
	.byte	0x9e
	.long	0x257
	.byte	0x8
	.uleb128 0x8
	.long	.LASF45
	.byte	0x4
	.byte	0xa2
	.long	0x62
	.byte	0x10
	.byte	0
	.uleb128 0x6
	.byte	0x8
	.long	0x220
	.uleb128 0x6
	.byte	0x8
	.long	0x9c
	.uleb128 0xb
	.long	0x95
	.long	0x26d
	.uleb128 0xc
	.long	0x86
	.byte	0
	.byte	0
	.uleb128 0x6
	.byte	0x8
	.long	0x219
	.uleb128 0xb
	.long	0x95
	.long	0x283
	.uleb128 0xc
	.long	0x86
	.byte	0x13
	.byte	0
	.uleb128 0x6
	.byte	0x8
	.long	0x289
	.uleb128 0xd
	.long	0x95
	.uleb128 0x3
	.byte	0x8
	.byte	0x5
	.long	.LASF46
	.uleb128 0x3
	.byte	0x8
	.byte	0x7
	.long	.LASF47
	.uleb128 0x6
	.byte	0x8
	.long	0x2a2
	.uleb128 0xe
	.uleb128 0x7
	.long	.LASF48
	.byte	0x10
	.byte	0x1
	.byte	0x80
	.long	0x2d0
	.uleb128 0xf
	.string	"str"
	.byte	0x1
	.byte	0x81
	.long	0x8f
	.byte	0
	.uleb128 0xf
	.string	"a"
	.byte	0x1
	.byte	0x82
	.long	0x62
	.byte	0x8
	.uleb128 0xf
	.string	"b"
	.byte	0x1
	.byte	0x83
	.long	0x62
	.byte	0xc
	.byte	0
	.uleb128 0x10
	.long	.LASF63
	.byte	0x1
	.byte	0x6
	.quad	.LFB2
	.quad	.LFE2-.LFB2
	.uleb128 0x1
	.byte	0x9c
	.long	0x342
	.uleb128 0x11
	.long	.LASF49
	.byte	0x1
	.byte	0x6
	.long	0x8f
	.uleb128 0x3
	.byte	0x91
	.sleb128 -72
	.uleb128 0x11
	.long	.LASF50
	.byte	0x1
	.byte	0x6
	.long	0x8d
	.uleb128 0x3
	.byte	0x91
	.sleb128 -80
	.uleb128 0x12
	.string	"len"
	.byte	0x1
	.byte	0x6
	.long	0x62
	.uleb128 0x3
	.byte	0x91
	.sleb128 -84
	.uleb128 0x13
	.string	"i"
	.byte	0x1
	.byte	0x7
	.long	0x62
	.uleb128 0x2
	.byte	0x91
	.sleb128 -60
	.uleb128 0x14
	.long	.LASF51
	.byte	0x1
	.byte	0x8
	.long	0x342
	.uleb128 0x2
	.byte	0x91
	.sleb128 -48
	.uleb128 0x13
	.string	"pc"
	.byte	0x1
	.byte	0x9
	.long	0x352
	.uleb128 0x2
	.byte	0x91
	.sleb128 -56
	.byte	0
	.uleb128 0xb
	.long	0x3f
	.long	0x352
	.uleb128 0xc
	.long	0x86
	.byte	0x10
	.byte	0
	.uleb128 0x6
	.byte	0x8
	.long	0x3f
	.uleb128 0x15
	.long	.LASF53
	.byte	0x1
	.byte	0x3b
	.long	0x39e
	.quad	.LFB3
	.quad	.LFE3-.LFB3
	.uleb128 0x1
	.byte	0x9c
	.long	0x39e
	.uleb128 0x12
	.string	"s"
	.byte	0x1
	.byte	0x3b
	.long	0x283
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0x12
	.string	"a"
	.byte	0x1
	.byte	0x3b
	.long	0x62
	.uleb128 0x2
	.byte	0x91
	.sleb128 -28
	.uleb128 0x12
	.string	"b"
	.byte	0x1
	.byte	0x3b
	.long	0x62
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.byte	0
	.uleb128 0x3
	.byte	0x8
	.byte	0x4
	.long	.LASF52
	.uleb128 0x16
	.long	.LASF54
	.byte	0x1
	.byte	0x41
	.long	0x39e
	.quad	.LFB4
	.quad	.LFE4-.LFB4
	.uleb128 0x1
	.byte	0x9c
	.long	0x40b
	.uleb128 0x12
	.string	"f"
	.byte	0x1
	.byte	0x41
	.long	0x8d
	.uleb128 0x2
	.byte	0x91
	.sleb128 -48
	.uleb128 0x11
	.long	.LASF55
	.byte	0x1
	.byte	0x41
	.long	0x2d
	.uleb128 0x2
	.byte	0x91
	.sleb128 -56
	.uleb128 0x11
	.long	.LASF56
	.byte	0x1
	.byte	0x41
	.long	0x29c
	.uleb128 0x2
	.byte	0x91
	.sleb128 -64
	.uleb128 0x14
	.long	.LASF57
	.byte	0x1
	.byte	0x42
	.long	0x283
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.uleb128 0x13
	.string	"ret"
	.byte	0x1
	.byte	0x43
	.long	0x39e
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.byte	0
	.uleb128 0x15
	.long	.LASF58
	.byte	0x1
	.byte	0x60
	.long	0x39e
	.quad	.LFB5
	.quad	.LFE5-.LFB5
	.uleb128 0x1
	.byte	0x9c
	.long	0x482
	.uleb128 0x11
	.long	.LASF59
	.byte	0x1
	.byte	0x60
	.long	0x283
	.uleb128 0x2
	.byte	0x91
	.sleb128 -56
	.uleb128 0x11
	.long	.LASF55
	.byte	0x1
	.byte	0x60
	.long	0x62
	.uleb128 0x2
	.byte	0x91
	.sleb128 -60
	.uleb128 0x11
	.long	.LASF56
	.byte	0x1
	.byte	0x60
	.long	0x29c
	.uleb128 0x3
	.byte	0x91
	.sleb128 -72
	.uleb128 0x14
	.long	.LASF60
	.byte	0x1
	.byte	0x61
	.long	0x8d
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0x14
	.long	.LASF61
	.byte	0x1
	.byte	0x61
	.long	0x8d
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0x14
	.long	.LASF62
	.byte	0x1
	.byte	0x62
	.long	0x39e
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.byte	0
	.uleb128 0x17
	.long	.LASF64
	.byte	0x1
	.byte	0x86
	.long	0x62
	.quad	.LFB6
	.quad	.LFE6-.LFB6
	.uleb128 0x1
	.byte	0x9c
	.long	0x4ce
	.uleb128 0x14
	.long	.LASF65
	.byte	0x1
	.byte	0x87
	.long	0x2a3
	.uleb128 0x2
	.byte	0x91
	.sleb128 -48
	.uleb128 0x14
	.long	.LASF66
	.byte	0x1
	.byte	0x88
	.long	0x39e
	.uleb128 0x2
	.byte	0x91
	.sleb128 -64
	.uleb128 0x14
	.long	.LASF67
	.byte	0x1
	.byte	0x89
	.long	0x8f
	.uleb128 0x2
	.byte	0x91
	.sleb128 -56
	.byte	0
	.uleb128 0x18
	.long	.LASF72
	.byte	0x5
	.byte	0xaa
	.long	0x257
	.byte	0
	.section	.debug_abbrev,"",@progbits
.Ldebug_abbrev0:
	.uleb128 0x1
	.uleb128 0x11
	.byte	0x1
	.uleb128 0x25
	.uleb128 0xe
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x1b
	.uleb128 0xe
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x10
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x2
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x3
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x8
	.byte	0
	.byte	0
	.uleb128 0x5
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x9
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xb
	.uleb128 0x1
	.byte	0x1
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xc
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xd
	.uleb128 0x26
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xe
	.uleb128 0x26
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0xf
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x10
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2116
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x11
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x12
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x13
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x14
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x15
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2116
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x16
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2117
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x17
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2116
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x18
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_aranges,"",@progbits
	.long	0x2c
	.value	0x2
	.long	.Ldebug_info0
	.byte	0x8
	.byte	0
	.value	0
	.value	0
	.quad	.Ltext0
	.quad	.Letext0-.Ltext0
	.quad	0
	.quad	0
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF8:
	.string	"__off_t"
.LASF13:
	.string	"_IO_read_ptr"
.LASF25:
	.string	"_chain"
.LASF67:
	.string	"strarg"
.LASF7:
	.string	"size_t"
.LASF31:
	.string	"_shortbuf"
.LASF57:
	.string	"test_str"
.LASF19:
	.string	"_IO_buf_base"
.LASF47:
	.string	"long long unsigned int"
.LASF50:
	.string	"addr"
.LASF66:
	.string	"test"
.LASF46:
	.string	"long long int"
.LASF4:
	.string	"signed char"
.LASF51:
	.string	"buff"
.LASF26:
	.string	"_fileno"
.LASF14:
	.string	"_IO_read_end"
.LASF54:
	.string	"call_function_code_dbl"
.LASF6:
	.string	"long int"
.LASF12:
	.string	"_flags"
.LASF20:
	.string	"_IO_buf_end"
.LASF29:
	.string	"_cur_column"
.LASF52:
	.string	"double"
.LASF28:
	.string	"_old_offset"
.LASF33:
	.string	"_offset"
.LASF64:
	.string	"main"
.LASF68:
	.string	"GNU C11 5.4.0 20160609 -mtune=generic -march=x86-64 -g -fstack-protector-strong"
.LASF42:
	.string	"_IO_marker"
.LASF3:
	.string	"unsigned int"
.LASF0:
	.string	"long unsigned int"
.LASF17:
	.string	"_IO_write_ptr"
.LASF59:
	.string	"name"
.LASF69:
	.string	"runfunc.c"
.LASF44:
	.string	"_sbuf"
.LASF2:
	.string	"short unsigned int"
.LASF21:
	.string	"_IO_save_base"
.LASF32:
	.string	"_lock"
.LASF27:
	.string	"_flags2"
.LASF39:
	.string	"_mode"
.LASF70:
	.string	"/home/cloud9/workspace/misc/c_utils/runfunc"
.LASF63:
	.string	"hexDump"
.LASF10:
	.string	"sizetype"
.LASF49:
	.string	"desc"
.LASF18:
	.string	"_IO_write_end"
.LASF71:
	.string	"_IO_lock_t"
.LASF41:
	.string	"_IO_FILE"
.LASF48:
	.string	"funcargs"
.LASF45:
	.string	"_pos"
.LASF24:
	.string	"_markers"
.LASF1:
	.string	"unsigned char"
.LASF5:
	.string	"short int"
.LASF58:
	.string	"runfunc_dbl"
.LASF30:
	.string	"_vtable_offset"
.LASF11:
	.string	"char"
.LASF61:
	.string	"func"
.LASF43:
	.string	"_next"
.LASF9:
	.string	"__off64_t"
.LASF15:
	.string	"_IO_read_base"
.LASF23:
	.string	"_IO_save_end"
.LASF34:
	.string	"__pad1"
.LASF35:
	.string	"__pad2"
.LASF36:
	.string	"__pad3"
.LASF37:
	.string	"__pad4"
.LASF38:
	.string	"__pad5"
.LASF40:
	.string	"_unused2"
.LASF72:
	.string	"stderr"
.LASF22:
	.string	"_IO_backup_base"
.LASF53:
	.string	"test_func"
.LASF60:
	.string	"handle"
.LASF65:
	.string	"args"
.LASF55:
	.string	"arg_s"
.LASF16:
	.string	"_IO_write_base"
.LASF56:
	.string	"arg_v"
.LASF62:
	.string	"result"
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.4) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
