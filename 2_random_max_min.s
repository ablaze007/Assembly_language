@a program to create an array of random numbers and print min and max

.global main
.func main

main:
	BL _seed_rand
	MOV R0,#0	@set i=0
	BL _get_array	@to get an array with random number
		
_seed_rand:
	PUSH {LR}
	MOV R0,#0
	BL time
	BL srand
	POP {PC}

_get_array:
	CMP R0,#10	@for i<10
	BEQ _done1
	LSL R2,R0,#2	@shift i by 2
	LDR R1,=a	@get address of a
	ADD R2,R2,R1	@get address of a[i]
	PUSH {R0}	
	PUSH {R2}
	BL _get_rand	@get a rand value
	BL _set_rand	@get rand in range 0-999
	POP {R2}	
	STR R0,[R2]	@store the rand value in a[i]
	MOV R1,R0	@store value in R1
	POP {R0}	@get back i in R0
	BL _check	@check for max and min
	BL _print_arr	@print a[i]
	ADD R0,R0,#1	@i++
	B _get_array
	
_get_rand:
	PUSH {LR}
	BL rand
	POP {PC}

_set_rand:		@R0=value
	PUSH {LR}
	MOV R1,#1000	
	BL _get_mod
	POP {PC}
	
_get_mod:		@R0=value,R1=1000,find R0%R1
	PUSH {LR}	
	_get_mod_check:		@subtract R1 from R0 until R1<R0
		CMP R0,R1
		POPLO {PC}
		SUB R0,R0,R1
		B _get_mod_check 

_check:			@R0=i, R1=value of a[i]
	CMP R0,#0	@for i=0
	PUSHEQ {R1}	@set R1 as min
	PUSHEQ {R1}	@set R2 as max
	MOVEQ PC,LR	
	POP {R2}	@get current max in R2
	POP {R3}	@get current min in R3
	CMP R1,R3	
	MOVLO R3,R1	@update min
	PUSH {R3}
	CMP R1,R2
	MOVHS R2,R1	@update max
	PUSH {R2}
	MOV PC,LR 

_print_arr:		@R0=i, R1=a[i] value
	PUSH {LR}
	PUSH {R0}
	PUSH {R1}
	MOV R2,R1
	MOV R1,R0
	LDR R0,=print_prompt1
	BL printf
	POP {R1}
	POP {R0}
	POP {PC}
	
_done1:
	POP {R2}	@get max from stack
	POP {R1}	@get min from stack
	LDR R0, =print_prompt2
	BL printf
	B _exit

_exit:
	@LDR R0,=exit_prompt
	@BL printf
	MOV R7,#1
	SWI 0

.data
.balign 4
a:	.skip	40
print_prompt2:	.asciz	"MINIMUM VALUE = %d\nMAXIMUM VALUE = %d\n\n"
exit_prompt:	.ascii	"Exiting..."
print_prompt1:	.asciz	"a[%d] = %d\n"
