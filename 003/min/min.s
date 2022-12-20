#	PURPOSE:
#		Find the minimal value in an array and return it as a return status.
#
#	VARIABLES:
#		%eax - current value examined
#		%edi - index
#		%ebx - minimal value so far
#
#		data_items - array of numbers
#

.section .data
data_items:
	.long 1,2,3,4,5,6,7,8,9,10,255

.section .text
.globl _start

_start:
	movl $0, %edi
	movl data_items(,%edi,4), %eax
	movl %eax, %ebx
	jmp loop

loop:
	cmpl $255, %eax
		je end

	incl %edi
	movl data_items(,%edi,4), %eax

	cmpl %ebx, %eax
		jge loop

	movl %eax, %ebx
	jmp loop

end:
	movl $1, %eax
	int $0x80

