
@A simple calculator

.global main
.func main

main:
	B _loop1

_loop1:
	BL _scan_n
	PUSH {R0}
	BL _scanf
	PUSH {R0}
	BL _scan_n
	MOV R6,R0
	POP {R0}
	MOV R5,R0
	POP {R0}
	MOV R4,R0
	B _check

_check:
	CMP R5,#'+'
	BEQ _add
	CMP R5,#'-'
	BEQ _difference
	CMP R5,#'*'
	BEQ _product
	CMP R5,#'M'
	BEQ _max
	CMP R5,#'0'
	BEQ _exit

_add:
	ADD R1,R4,R6
	LDR R0, =num2
	BL printf
	B _loop1

_difference:
	SUB R1,R4,R6
	LDR R0, =num2
	BL printf
	B _loop1

_product:
	MUL R1,R4,R6
	LDR R0, =num2
	BL printf
	B _loop1

_max:
	CMP R4,R6
	BGE _max2
	MOV R1,R6
	LDR R0, =num2
	BL printf
	B _loop1

_max2:
	MOV R1,R4
	LDR R0, =num2
	BL printf
	B _loop1
	
_exit:
	LDR R0, =exit_prompt
	BL printf
	MOV R7,#1
	SWI 0

_scan_n:
	PUSH {LR}
	LDR R0, =num
	SUB SP,SP,#4
	MOV R1,SP
	BL scanf
	LDR R0,[SP]
	ADD SP,SP,#4
	POP {PC}

_scanf:
	MOV R7, #3
	MOV R0, #0
	LDR R1, =t  
	MOV R2, #1
	SWI 0
	LDR R0,[R1]
	MOV PC, LR

_printf:
	PUSH {LR}
	LDR R0, =t
	BL printf
	POP {PC}

.data
exit_prompt:	.ascii	"Exiting...\n"
num:	.asciz	"%d"
num2:	.asciz	"%d\n"
t:	.asciz	" "
