#	PURPOSE:
#		Find a factorial of a given number (5)
#
############################## main program

.section .data

# No global data

.section .text

.globl _start
.globl factorial
_start:
	pushl $5
	call factorial
	addl $4, %esp
	
	movl %eax, %ebx
	movl $1, %eax
	int $0x80

############################## factorial
#	VARIABLES:
#		%eax - result
#		%ecx - next number
#
.type factorial, @function
factorial:
	pushl %ebp
	movl %esp, %ebp
	movl 8(%ebp), %eax
	movl 8(%ebp), %ecx

start_factorial:
	decl %ecx
	cmpl $1, %ecx
		je end_factorial

	imull %ecx, %eax
	jmp start_factorial

end_factorial:
	movl %ebp, %esp
	popl %ebp
	ret

