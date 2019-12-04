	@ BSS section
	.bss
	
	@ DATA SECTION
	.data
	data1: .asciz "Enter n to obtain nth fibonacci number\n"

	Input:
		N: .word 0
	output: .word 0
	
	Printmsg: .asciz "Nth Fibonnaci number is: "
	@ TEXT section
	.text
.globl _main

_main:

mov r0, #1                                   
ldr r1, =data1
swi 0x69

ldr r0, =IntRead                             
ldr r0, [r0]                                 
swi 0x6c
mov r1, r0                                   
ldr r0, =N
str r1, [r0]

mov r2, #1                                   
mov r3, #1


bl fibonacci                                      
ldr r5, =output                              
mov r9, r0                                   
str r9, [r5]                                 

mov r0, #1
ldr r1, =Printmsg                       
swi 0x69
mov r0,#1
mov r1, r9                                   
swi 0x6b
swi 0x11


fibonacci:                                        
	stmfd sp!,{r1,lr}                        
	mov r4, #1                               
	
build_stack_recursively:
    cmp r4, r1                               
	beq compute_recursively_fibonacci_num             
	cmp r4, #1                               
	beq init_first                           
	cmp r4, #2                               
	beq init_second                          
	pop {r5}                                 
	pop {r6}
	add r7, r5, r6                           
                                            
											 
	push {r5}                                
	push {r7}                                
	add r4, #1                               
	b build_stack_recursively                  

	init_first:                              
	PUSH {r2}
	add r4, #1
	b build_stack_recursively
	init_second:                             
	PUSH {r3}
	add r4, #1
	b build_stack_recursively

	
	compute_recursively_fibonacci_num:                
	mov r0, #1
	cmp r1, #1
	beq return_back                          
	cmp r1, #2
	beq pop_return_back                      
	
	
	pop {r5}                                 
	pop {r6}                                 
	add r7, r5, r6                           

	push {r5}                                
	push {r7}
	mov r0, r7                               
	pop {r7}                                 
	pop {r5}
	
	return_back:
	ldmfd sp!,{r1,pc}

	pop_return_back:
	pop {r5}
	ldmfd sp!,{r1,pc}
		
IntRead: .word 0