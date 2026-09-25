	.text

main:

main__for_init:
	li	$t0, 24
main__for_cond:
	bge	$t0, 42, main__for_end

main__for_body:
	li	$v0, 1   #int
	move	$a0, $t0
	syscall

	
	li	$v0, 11    #char
	li	$a0, '\n'
	syscall
main__for_incr:
	# int x = x + 3
	add	$t0, $t0, 3
	b	main__for_cond  #remmeber to loop back to the cond
main__for_end:
	jr	$ra




	.data