@a program for given recursive function

.global main
.func main

main:
	B _loop

_loop:
	BL _scanf
	PUSH {R0}
	BL _scanf
	MOV R2,R0
	POP {R1}
	PUSH {R1}
	PUSH {R2}
	BL _count_partitions
	MOV R1,R0
	POP {R3}
	POP {R2}
	BL _printf
	B _loop

_count_partitions:	@R1 = operand n, R2 = operand m
	PUSH {LR}
	CMP R1,#0
	MOVEQ R0,#1
	POPEQ {PC}
	MOVLT R0,#0
	POPLT {PC}
	CMP R2,#0
	MOVEQ R0,#0
	POPEQ {PC}
	PUSH {R1}
	PUSH {R2}
	SUB R1,R1,R2
	BL _count_partitions
	POP {R2}
	POP {R1}
	PUSH {R0}
	SUB R2,R2,#1
	BL _count_partitions
	MOV R1,R0
	POP {R0}
	ADD R0,R0,R1
	POP {PC}

_scanf:
	PUSH {LR}
	LDR R0,=num_scan
	SUB SP,SP,#4
	MOV R1,SP
	BL scanf
	LDR R0,[SP]
	ADD SP,SP,#4
	POP {PC}

_printf:	@arguments R1,R2,R3
	PUSH {LR}
	LDR R0,=num_print
	BL printf
	POP {PC}

.data
num_scan:	.asciz	"%d"
num_print:	.asciz	"There are %d partitions of %d using integers upto %d\n"
num_temp:	.asciz	"R1 = %d R2 = %d\n"
