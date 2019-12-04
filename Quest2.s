	@ BSS section
	.bss
	
	@ DATA SECTION
	.data
	data1: .asciz "enter size of array\n"
	data2: .asciz "enter array elements\n"
	data3: .asciz "enter element to search\n"

	Input:
		elems: .word 0
		A: .skip 80
	SEARCH_ELEM:
		N: .word 0
	OUTPUT: .word -1
	
	
	Printmsg: .asciz "position of element(output) is: "
	inputerrmsg: .asciz "input is not sorted"
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
mov r7, #0                       
ldr r1, =A                       
loop_through_array_input:
ldr r0, =IntRead
ldr r0, [r0]
swi 0x6c
cmp r7, r0                       
BGT err                   
str r0, [r1], #4
mov r7, r0
subs r4, r4, #1
bgt loop_through_array_input


mov r0, #1                       
ldr r1, =data3
swi 0x69

ldr r0, =IntRead                 
ldr r0, [r0]                     
swi 0x6c
mov r3, r0                       
ldr r0, =N
str r3, [r0]

mov r5, #4                       
bl binary_search_subroutine 
ldr r5, =OUTPUT                  
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
binary_search_subroutine:
	stmfd sp!,{r1,r2,r3,r4,lr}   

	mov r7, #1                   
	mov r8, r2                   

	loop:
	mov r4, r7                   
	add r4, r8
	asr r4, #1                   
	
	
	                             
	ldr r1, =A                   
	mul r5, r4                   
	                             
	add r1, r5                   
	sub r1, #4                   
	ldr r6, [r1]                 
	
	cmp r6, r3                   
	beq OUTPUT_INDEX             
	bgt update_array_max         
	                             
	b update_array_min           
	                             
    b NOT_FOUND                  

    OUTPUT_INDEX:                
    mov r0, r2                   
    sub r0, r4                   
    sub r0, r2, r0               
    ldmfd sp!,{r1,r2,r3,r4,pc}   

    update_array_min:          
	add r4, #1
	mov r7, r4
	mov r5, #4
	cmp r7, r8                 
	bgt NOT_FOUND
    b loop                     
	
    update_array_max:          
	mov r8, r4
	mov r5, #4
	cmp r7, r8                 
	bgt NOT_FOUND
	b loop                     

	NOT_FOUND:                   
	mov r0, #-1                  
	ldmfd sp!,{r1,r2,r3,r4,pc}   
	
	
IntRead: .word 0

err:                      
mov r0, #1
ldr r1, =inputerrmsg       
swi 0x69

swi 0x11