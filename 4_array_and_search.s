@a program to store inputs in an array and search

.global main
.func main

main:
	MOV R0,#0	@set i=0
	BL _create_array

_create_array:
	CMP R0,#10	@for i<10
	MOVEQ R0,#0	
	BEQ _print_array
	LSL R2,R0,#2	@shift i by 2
	LDR R1, =a	@get address of a
	ADD R2,R2,R1	@get address of a[i]
	PUSH {R0}
	PUSH {R2}
	BL _scanf	@get input from user input
	POP {R2}
	STR R0,[R2]	@store input in a[i]
	POP {R0}
	ADD R0,R0,#1	@i++
	B _create_array

_print_array:
	CMP R0,#10	@for i<10	
	BEQ _search
	LSL R2,R0,#2	@shift i by 2
	LDR R1, =a	@get address of a
	ADD R2,R2,R1	@get address of a[i]
	LDR R1,[R2]	@R1 = value at a[i]
	PUSH {R0}
	BL _printf
	POP {R0}	
	ADD R0,R0,#1	@i++
	B _print_array

_search:
	BL _printf2
	BL _scanf
	MOV R1,#0	@set i=0
	MOV R2,#0	@set check=0
	B _search_loop

_search_loop:	@R0 = search value, R1=i=0, R2=check=0
	PUSH {R0}
	PUSH {R2}	@backing up check variable
	PUSH {R1}	@backing up R1 to be modified
	CMP R1,#10	@for i<10
	BEQ _result
	LSL R3,R1,#2	@loading a[i]
	LDR R1, =a
	ADD R3,R3,R1
	LDR R1,[R3]	@R1 = value at a[i]
	CMP R0,R1
	BLEQ _print_val
	POP {R1}
	POP {R2}
	POP {R0}
	ADD R1,R1,#1
	B _search_loop

_result:	@R2 = check
	CMP R2,#0
	BLEQ _printf3
	B _exit
	
	
_print_val:	@R0 & R1 =value of a[i]	
	POP {R0}	@get i from stack
	POP {R2}
	PUSH {LR}
	PUSH {R2}
	PUSH {R0}
	BL _printf
	POP {R0}
	POP {R2}
	POP {LR}
	MOV R2,#1
	PUSH {R2}
	PUSH {R0}
	MOV PC,LR

_exit:
	MOV R7,#1
	SWI 0
	
_printf:	@R0 = i, R1=value of a[i] 
	PUSH {LR}
	MOV R2,R1
	MOV R1,R0
	LDR R0, =print1
	BL printf
	POP {PC}

_printf2:	 
	PUSH {LR}
	MOV R2,R1
	MOV R1,R0
	LDR R0, =print2
	BL printf
	POP {PC}

_printf3:	 
	PUSH {LR}
	LDR R0, =print3
	BL printf
	POP {PC}

_scanf:
	PUSH {LR}
	SUB SP,SP,#4
	LDR R0, =scan1
	MOV R1, SP
	BL scanf
	LDR R0, [SP]
	ADD SP,SP,#4
	POP {PC}

.data	
.balign 4
a:	.skip	40
scan1:	.asciz	"%d"
print1: .asciz	"array_a[%d] = %d\n" 
print2:	.asciz 	"ENTER A SEARCH VALUE: "
print3: .asciz	"That value does not exist in the array!\n"
