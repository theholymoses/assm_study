#	PURPOSE:
#		Find the maximum number in a set of data items.
#
#	VARIABLES:
#		%edi	holds the index of the data item being examined.
#		%ebx	holds the largest item found
#		%eax	current data item
#
#		data_items	contains the item data. 0 is used to terminate the data.
#

.section .data
data_items:
	.long	1,2,3,243,5,6,7,8,9,10,0

.section .text
.globl _start

_start:
	#	Load the first index into %edi
	#	Load the first value from data_items
	#	Since the first value is obviously the biggest - load it into %ebx register

	movl $0, %edi
	movl data_items(,%edi,4), %eax
	movl %eax, %ebx

start_loop:
	#	1) Check if current value examined isn't zero. If it is zero - end the loop.
	#	2) Increment the index by 1.
	#	3) Move value from data_item by specified index into %eax, currently examined value.
	#	4) If the new value in %eax isn't bigger than the current max value - jump to the start of the loop.
	#	   Otherwise - load %eax value to %ebx.

	cmpl $0, %eax
		je loop_exit

	incl %edi
	movl data_items(,%edi,4), %eax
	cmpl %ebx, %eax
		jle start_loop

	movl %eax, %ebx
	jmp start_loop

loop_exit:
	#	The max value will be used as a return status.

	movl $1, %eax
	int $0x80

