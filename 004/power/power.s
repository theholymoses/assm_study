#	PURPOSE:
#		Find the value of 2^0 + 2^0
#
############################## main program
.section .data

.section .text

.globl _start
_start:
	pushl $0
	pushl $2
	call power
	addl $8, %esp
	pushl %eax

	pushl $0
	pushl $2
	call power
	addl $8, %esp
	popl %ebx      # save second result

	addl %eax, %ebx

	movl $1, %eax
	int $0x80

############################## power function
#	PURPOSE:
#		Raises first argument to the power of second argument
#
#	INPUT:
#		First argument - base number (%ebx)
#		Second argument - the power to raise to (%ecx)
#		-4(%ebp) - current result
#		return value in %eax
##############################

.type power, @function
power:
	pushl %ebp
	movl %esp, %ebp
	subl $4, %esp
	
	movl 8(%ebp), %ebx
	movl 12(%ebp), %ecx
	movl %ebx, -4(%ebp)

##############################
power_loop_start:
	cmpl $1, %ecx
		je power_loop_end
	cmpl $0, %ecx
		je power_to_zero
	
	movl -4(%ebp), %eax
	imull %ebx, %eax
	
	movl %eax, -4(%ebp)
	decl %ecx
	jmp power_loop_start

##############################
power_to_zero:
	movl $1, -4(%ebp)

##############################
power_loop_end:
	movl -4(%ebp), %eax
	movl %ebp, %esp
	popl %ebp
	ret

