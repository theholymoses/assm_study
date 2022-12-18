#	PURPOSE:
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
	#	move 1 (system call number for exit) into "eax"
	#	move 0 return status to "ebx"
	movl $1, %eax
	movl $0, %ebx

	# ^ immediate addressing mode is used

	int $0x80

#	System call number should be contained in the %eax register. Return status - in the %ebx register.
#	When 0x80 interrupt signal is sent, system runs the system call specified in an %eax register.

