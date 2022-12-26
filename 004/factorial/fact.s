#	PURPOSE:
#		Given a number, find its factorial
#		This program shows how to call function recursively
#
############################## main program

.section .data
#	No global data

.section .text

.global _start
.globl factorial

_start:
	pushl $4
	call factorial
	addl $4, %esp

	movl %eax, %ebx
	movl $1, %eax
	int $0x80

############################## factorial function
.type factorial, @function
factorial:
	pushl %ebp
	movl %esp, %ebp
	movl 8(%ebp), %eax

	cmpl $1, %eax
		je end_factorial

	decl %eax
	pushl %eax
	call factorial
	movl 8(%ebp), %ebx
	imull %ebx, %eax

end_factorial:
	movl %ebp, %esp
	popl %ebp
	ret

