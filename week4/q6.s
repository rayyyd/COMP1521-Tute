	.text
	# some simple test code which calls max
ONE = 1
max:
    # Frame:    [...]   <-- FILL THESE OUT!
    # Uses:     [...]
    # Clobbers: [...]
    #
    # Locals:           <-- FILL THIS OUT!
    #   - ...
    #
    # Structure:        <-- FILL THIS OUT!
    #   max
    #   -> [prologue]
    #       -> body
    #   -> [epilogue]
max__prologue:
	#array -> $a0
	# length -> $a1
	push	$ra
	push	$s0
max__body:
	lw	$s0, array

	bne	$a1, 1, max__else
	#return value is in $v0, return by b to epilogue
	move	$v0, $s0
	b	max__epilogue
max__else:
	# arguments go in to a0, a1 ,...
	move	$t1, $a0
	add	$a0, $t1, 4

	sub	$a1, $a1, 1

	jal	max
	ble	$s0, $v0, max__return_max_so_far
	move	$v0, $s0   #max_so_far = first_element
	
max__return_max_so_far:
	b	max__epilogue
max__epilogue:
	pop	$s0
	pop	$ra
	jr	$ra


main:
main__prologue:
	push	$ra

main__body:
	la	$a0, array
	li	$a1, 10
	jal	max			# result = max(array, 10)

	move	$a0, $v0
	li	$v0, 1			# syscall 1: print_int
	syscall				# printf("%d", result)

	li	$a0, '\n'
	li	$v0, 11			# syscall 11: print_char
	syscall				# printf("%c", '\n');

	li	$v0, 0

main__epilogue:
	pop	$ra
	jr	$ra			# return 0;


	.data
array:
	.word 1, 2, 3, 4, 5, 6, 4, 3, 2, 1