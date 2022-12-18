# PURPOSE:
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
	movl $0, %edi											# start reading from 0 index
	movl data_items(,%edi,4), %eax		#	load the first byte of data to %eax
	movl %eax, %ebx										# the first item is biggest

start_loop:
	cmpl $0, %eax											# check if we hit the end
		je loop_exit

	incl %edi													# increment %edi value
	movl data_items(,%edi,4), %eax		# load next value
	cmpl %ebx, %eax										# compare values
		jle start_loop									# jump to the beggining if the new values isn't bigger

	movl %eax, %ebx										# current value is bigger
	jmp start_loop

loop_exit:
	# status code will be a maximum number of the data_items
	movl $1, %eax
	int $0x80


