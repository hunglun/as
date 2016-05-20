# signal to the assembler that it is a 32bit code.
#.code32
#PURPOSE: Program to illustrate how functions work.
#    This program will compute the value of 2^3 + 5^2

#Everything in the main program is stored in registeres,
#    so the data section does not have anything.

.section .data
.section .text
.globl _start
_start:
    # first function call
    pushq $3 
    pushq $2 #push first argument, the base
    call power #push the address of next instruction to stack
               #set %eip to the address of power function.
    addq $16, %rsp #pop the 2 arguments from stack.

    # save the first answer, before calling power again
    pushq %rax # 1 byte instruction encoded as pushl %eax in 32 bits


    # second function call
    pushq $2 #push second argument, the power
    pushq $5 #push first argument, the base
    call power #push the address of next instruction to stack
               #set %eip to the address of power function.
    addq $16, %rsp #pop the 2 arguments from stack.

    # save the second answer to ebx
    popq %rbx # same as popl %ebx

    addl %eax, %ebx # add both answers and save the result to %ebx

    # exit
    movl $1, %eax
    int $0x80

.type power, @function

power:
    movl $2, %eax
    ret			# pop a value from stack and set %eip to the value
