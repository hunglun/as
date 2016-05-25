# Build:
# as --32 pow32.s -o pow32.o
# ld -m elf_i386 pow32.o -o pow32
#
# PURPOSE: Program to illustrate how functions work.
#    This program will compute the value of 2^3 + 5^2

#Everything in the main program is stored in registeres,
#    so the data section does not have anything.

.section .data
.section .text
.globl _start
_start:
    # first function call
    pushl $3 
    pushl $2 #push first argument, the base
    call power #push the address of next instruction to stack
               #set %eip to the address of power function.
    addl $8, %esp #pop the 2 arguments from stack.

    # save the first answer, before calling power again
    pushl %eax # 1 byte instruction encoded as pushl %eax in 32 bits

 
    # second function call
    pushl $2 #push second argument, the power
    pushl $5 #push first argument, the base
    call power #push the address of next instruction to stack
               #set %eip to the address of power function.
    addl $8, %esp #pop the 2 arguments from stack.

    # save the second answer to ebx
    popl %ebx # same as popl %ebx

    addl %eax, %ebx # add both answers and save the result to %ebx

    # exit
    movl $1, %eax
    int $0x80

.type power, @function

power:
    pushl %ebp   # save old base pointer
    movl %esp, %ebp # save the stack pointer in the base pointer
    subl $4, %esp # get room for local storage

    movl 8(%ebp), %ebx #put first argument in %ebx
    movl 12(%ebp), %ecx #put second argument in %ecx

    movl %ebx, -4(%ebp) #store current result
power_loop_start:
    cmpl $1, %ecx  #if the power is 1, we are done
    je end_power
    movl -4(%ebp),%eax #move the current result into %eax
    imull %ebx, %eax #multiply the current result by base number.
    movl %eax, -4(%ebp) #store the current result
    decl %ecx #decrement the power
    jmp power_loop_start # next iteration

end_power:
    movl -4(%ebp),%eax # return value goes in %eax
    movl %ebp, %esp #restore stack pointer
    popl %ebp   #restore base pointer    
    ret			# pop a value from stack and set %eip to the value
