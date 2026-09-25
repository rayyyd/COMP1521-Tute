	.text
# code goes here
SQUARE_MAX = 46340

main:
	# let $t0 = x
	# let %t1 = y

	li	$v0, 4
	la	$a0, enter             #printf("Enter a number: ")
	syscall

	li	$v0, 5                 #scanf("%d", &x)
	syscall
	#x is in $v0

	move	$t0, $v0      #move the value into x.


	#opp. cond, end of scope.
	ble	$t0, SQUARE_MAX, main__else
	
	li	$v0, 4               #tells what to do (print string)
	la	$a0, too_big           # what string to print
	syscall                       # executes the command found in $v0.

	b	main__else_end
	

main__else:

	mul	$t1, $t0, $t0

	#printf("%d\n", y)
	li	$v0, 1
	move	$a0, $t1
	syscall

	li	$v0, 11
	li	$a0, '\n'
	syscall

main__else_end:
	li	$v0, 0
	jr	$ra                #return

	.data
enter:
	.asciiz "Enter a number"
too_big:
	.asciiz "square too big for 32 bits\n"
# global variables and string literals go
# structured memory goes here (e.g. arrays)
