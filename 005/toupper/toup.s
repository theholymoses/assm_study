#	PURPOSE:
#		This program converts an input file to an output file with all letters converted to uppercase.
#
#	PROCESSING:
#		1) Open the input file
#		2) Open the output file
#		3) While not at an end of an input file:
#			a) read part of a file into a memory buffer
#			b) go through each byte of memory
#				if byte is lowercase - convert to uppercase
#			c) write the memory buffer to output file
#
############################## SECTION DATA
.section .data
##### CONSTANTS:
.equ SYS_OPEN, 5
.equ SYS_WRITE, 4
.equ SYS_READ, 3
.equ SYS_CLOSE, 6
.equ SYS_EXIT, 1

##### OPTIONS
.equ O_RDONLY, 0
.equ O_CREAT_WRONLY_TRUNC, 03101

##### STANDART FILE DESCRIPTORS
.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2

##### MISC
.equ LINUX_SYSCALL, 0x80

.equ END_OF_FILE, 0

.equ NUMBER_ARGUMENTS, 2

############################## SECTION BSA
.section .bss

.equ BUFFER_SIZE, 500
.lcomm BUFFER_DATA, BUFFER_SIZE

############################## SECTION TEXT
.section .text

##### STACK POSITIONS
.equ ST_SIZE_RESERVE, 8
.equ ST_FD_IN, -4
.equ ST_FD_OUT, -8
.equ ST_ARGC, 0
.equ ST_ARGV_0, 4
.equ ST_ARGV_1, 8
.equ ST_ARGV_2, 12

.globl _start
_start:
	movl %esp, %ebp
	subl $ST_SIZE_RESERVE, %esp

open_files:
open_fd_in:
	# open input file
	movl $SYS_OPEN, %eax
	movl ST_ARGV_1(%ebp), %ebx
	movl $O_RDONLY, %ecx
	movl $0666, %edx
	int $LINUX_SYSCALL

store_fd_in:
	# save file descriptor
	movl %eax, ST_FD_IN(%ebp)

open_fd_out:
	# open output file
	movl $SYS_OPEN, %eax
	movl ST_ARGV_2(%ebp), %ebx
	movl $O_CREAT_WRONLY_TRUNC, %ecx
	movl $0666, %edx
	int $LINUX_SYSCALL

store_fd_out:
	# save file descriptor
	movl %eax, ST_FD_OUT(%ebp)

read_loop_begin:
	movl $SYS_READ, %eax
	movl ST_FD_IN(%ebp), %ebx
	movl $BUFFER_DATA, %ecx
	movl $BUFFER_SIZE, %edx
	int $LINUX_SYSCALL

	cmpl $END_OF_FILE, %eax
		jle end_loop

continue_read_loop:
	pushl $BUFFER_DATA
	pushl %eax
	call convert_to_upper
	popl %eax
	addl $4, %esp

	movl %eax, %edx
	movl $SYS_WRITE, %eax
	movl ST_FD_OUT(%ebp), %ebx
	movl $BUFFER_DATA, %ecx
	int $LINUX_SYSCALL

	jmp read_loop_begin

end_loop:
	movl $SYS_CLOSE, %eax
	movl ST_FD_OUT(%ebp), %ebx
	int $LINUX_SYSCALL

	movl $SYS_CLOSE, %eax
	movl ST_FD_IN(%ebp), %ebx
	int $LINUX_SYSCALL

	movl $SYS_EXIT, %eax
	movl $0, %ebx
	int $LINUX_SYSCALL

############################## toupper
#	PURPOSE:
#		This function does the conversion to upper case for a block
#
#	INPUT:
#		1st parameter - location of the block of memory to convert
#		2nd parameter - length of the buffer
#
#	VARIABLES:
#		%eax - buffer start
#		%ebx - buffer length
#		%edi - current buffer offset
#		%cl  - current byte examined(first part of %ecx)
#

##### CONSTANTS
.equ LOWERCASE_A, 'a'
.equ LOWERCASE_Z, 'z'

.equ UPPER_CONVERSION, 'A' - 'a'

##### STACK STUFF
.equ ST_BUFFER_LEN, 8
.equ ST_BUFFER, 12

convert_to_upper:
	pushl %ebp
	movl %esp, %ebp

	# set up variables
	movl ST_BUFFER(%ebp), %eax
	movl ST_BUFFER_LEN(%ebp), %ebx
	movl $0, %edi

	cmpl $0, %ebx
		je end_convert_loop

convert_loop:
	movb (%eax,%edi,1), %cl
	
	cmpb $LOWERCASE_A, %cl
	jl next_byte
	cmpb $LOWERCASE_Z, %cl
	jg next_byte

	addb $UPPER_CONVERSION, %cl
	movb %cl, (%eax,%edi,1)

next_byte:
	incl %edi
	cmpl %edi, %ebx
		jne convert_loop

end_convert_loop:
	movl %ebp, %esp
	popl %ebp
	ret

