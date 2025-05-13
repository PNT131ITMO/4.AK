	.data
buf: 				.byte	'0_______________________________'
input:				.word 	0x80
output:				.word 	0x84	

	
	.text
	.org 0x88
_start:
	lui			sp, %hi(0x256)
	addi		sp, sp, %lo(0x256)

	lui			t0, %hi(input)
	addi		t0, t0, %lo(input)
	lw			a0, 0(t0)			
	
	jal			ra, upper_case_pstr
	
	halt
	
	
upper_case_pstr:
	lui			t6, %hi(output)
	addi		t6, t6, %lo(output)
	lw 			t6, 0(t6) 			
	
	mv 			a1, zero	       	
	addi 		t0, zero, 32		
	addi 		t1, zero, 0xff		
	addi 		t2, zero, 10		
	addi 		t3, zero, 'A'
	lui			t5, %hi(buf)
	addi		t5, t5, %lo(buf)
	mv			s1, t5				
	addi		t5, t5, 1
	
	
while:
	lw 			a1, 0(a0)
	and			a1, a1, t1
	beq			a1, t2, store_length
	bgt			t3, a1, store_char
	
	addi 		sp, sp, -4
	sw			ra, 0(sp)
	jal 		ra, get_capital_letter
	lw			ra, 0(sp)
	addi		sp, sp, 4
	
store_char:
	sb			a1, 0(t5)
	beq			t5, t0, overflow
	addi		t5, t5, 1
	
	j			while
	
store_length:
	addi		t5, t5, -1
	sb			t5, 0(s1)
	
output_pstr:
	lw      t2, 0(s1)		  	
	and 	t2, t2, t1	
	addi 	s1, s1, 1
	
while_pstr:
	beqz    t2, return
	lw      t3, 0(s1)		  	
	and 	t3, t3, t1
    sb      t3, 0(t6)
    addi    s1, s1, 1
	addi    t2, t2, -1
    j 		while_pstr
	

get_capital_letter:
	addi		t4, zero, 'Z'
	ble			a1, t4, return
	addi		a1, a1, -32
    j           return
	
overflow:	
	lui 		t1, %hi(0xCCCC_CCCC)
	addi		t1, t1, %lo(0xCCCC_CCCC)
	
	sw			t1, 0(t6)
	
return:
	jr			ra