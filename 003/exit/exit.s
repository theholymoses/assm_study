# PURPOSE:
#		Simple program that exits and returns a status code back to the Linux kernel.
#
#	INPUT:
#		None.
#
#	OUTPUT:
#		Returns a status code which can be seen by typing "echo $?"
#
#	VARIABLES:
#		%eax	holds the system call number
#		%ebx	holds the return status

.section .data

.section .text

.globl _start

_start:
	movl $1, %eax						# 1 is the linux kernel command number (system call) for exiting a program
	movl $0, %ebx						# 0 is the status number we will return to the operating system

	# ^ immediate addressing mode is used

	int $0x80								# interrupt signal

