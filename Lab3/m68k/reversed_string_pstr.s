	.data
buffer: 		.byte 0, '_______________________________'
input: 	.word 0x80
output:	.word 0x84

	.text
	.org 0x100

_start:
	movea.l 	0x512, A7 			; sp init
	movea.l		input, A0
	movea.l		(A0), A0
	movea.l		output, A1
	movea.l     (A1), A1
	
	jsr 		reverse_string_pstr

end:
	halt
	
reverse_string_pstr:
    link 		A6, 0               ; for correct overflow return
	move.l 		0, D4				; length
	move.l 		32, D5				; symbols limit for overflow check
	
while:	
	move.b		(A0), D0
	
	cmp.b 		0xA, D0				; new line code
	beq			store_length
	
	add.l 		1, D4
	cmp.l 		D5, D4
	beq			return_overflow
	
	move.b		D0, -(A7)			

	jmp			while
	
store_length:
    cmp.l       0, D4
    beq         reverse_string_pstr_return
	movea.l	 	buffer, A2
	move.b 		D4, (A2)+

move_symbols_from_stack_to_buffer:
	move.b 		(A7)+, (A2)+
    sub.l 		1, D4
    bne         move_symbols_from_stack_to_buffer

print_buffer:
	movea.l		buffer, A3
	move.b		(A3)+, D4			; length
	
print_buffer_while:	
	move.b		(A3)+, (A1)
    sub.l       1, D4
    bne         print_buffer_while

reverse_string_pstr_return:
    unlk        A6
	rts
	
return_overflow:
	move.l 		0xCCCC_CCCC, (A1)
    jmp         reverse_string_pstr_return