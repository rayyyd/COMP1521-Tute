	.text

FLAG_ROWS = 6
FLAG_COLS = 12

main:

main__outer_for_start:
	li	$t0, 0          #row is $t0
main__outer_for_cond:
	# opp cond, goto the end
	bge	$t0, FLAG_ROWS, main__outer_for_end
main__outer_for_body:

main__inner_for_start:
	li	$t1, 0		#col = 0
main__inner_for_cond:
	bge	$t1, FLAG_COLS, main__inner_for_end
main__inner_for_body:
	# todo printf("%c", flag[row][col]);

	# base addr
	la	$t2, flag    #redundant oops...

	#convert 2d idx to 1d offset
	mul	$t3, $t0, FLAG_COLS   # row * total_cols
	add	$t3, $t3, $t1         # + cols
	mul	$t3, $t3, 1        #redundant, but remember to mul by offset

	# load 
	lb	$a0, flag($t3)
	
	#print
	li	$v0, 11
	syscall





main__inner_for_incr:
	add	$t1, $t1, 1
	b	main__inner_for_cond
main__inner_for_end:

	li	$v0, 11
	li	$a0, '\n'
	syscall

main__outer_for_incr:
	add	$t0, $t0, 1
	b	main__outer_for_cond
main__outer_for_end:
	jr	$ra

	.data
# This label inside the data region refers to the bytes of the flag.
# Note that even thought the bytes are listed on separate lines,
# they are actually stored as a single contiguous chunk or 'string' in memory.
flag:
	.byte '#', '#', '#', '#', '#', '.', '.', '#', '#', '#', '#', '#'
	.byte '#', '#', '#', '#', '#', '.', '.', '#', '#', '#', '#', '#'
	.byte '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.'
	.byte '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.'
	.byte '#', '#', '#', '#', '#', '.', '.', '#', '#', '#', '#', '#'
	.byte '#', '#', '#', '#', '#', '.', '.', '#', '#', '#', '#', '#'