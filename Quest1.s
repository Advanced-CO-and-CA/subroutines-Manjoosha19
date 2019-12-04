	@ BSS section
	.bss
	
	@ DATA SECTION
	.data
	data1: .asciz "enter size of array\n"
	data2: .asciz "enter elements of array\n"
	data3: .asciz "enter element to be searched\n"

	Input:
		elems: .word 0          
		num: .skip 80                  
	SEARCH_ELEM:
		N: .word 0                   
	output: .word -1                 
	
	
	Printmsg: .asciz "position of element(output) is: "
	@ TEXT section
	  .text	

.globl _main
.text	

_main:

mov r0, #1                                         
ldr r1, =data1
swi 0x69

ldr r0, =IntRead                                   
ldr r0, [r0]                                       
swi 0x6c
mov r2, r0                                         
ldr r0, =elems
str r2, [r0]


mov r0, #1                                         
ldr r1, =data2
swi 0x69

mov r4, r2                                         
ldr r1, =num                                         
loop_through_input:                              
ldr r0, =IntRead
ldr r0, [r0]
swi 0x6c
str r0, [r1], #4
subs r4, r4, #1
bgt loop_through_input


mov r0, #1                                         
ldr r1, =data3
swi 0x69

ldr r0, =IntRead                                   
ldr r0, [r0]                                       
swi 0x6c
mov r3, r0                                         
ldr r0, =N
str r3, [r0]

ldr r1, =num
mov r4, r2                                         
bl SEARCH                                          
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

.text	
SEARCH:
	stmfd sp!,{r1,r2,r3,r4,lr}                     

	loop: 
	ldr r6, [r1], #4                               
	cmp r6, r3                                     
	beq OUTPUT_INDEX                               
	subs r4, r4, #1                                
	bgt loop                                       
    b NOT_FOUND                                    

    OUTPUT_INDEX:                                  
	mov r0, r2                                     
	sub r0, r4                                     
	                                               
	add r0, #1                                     
	ldmfd sp!,{r1,r2,r3,r4,pc}                     

	NOT_FOUND:                                     
	mov r0, #-1                                    
	ldmfd sp!,{r1,r2,r3,r4,pc}                     

IntRead: .word 0