	.text
MAP_SIZE = 5
N_POINTS = 4

ROW_OFFSET = 0
COL_OFFSET = 4
POINT2D_SIZE = 8
main:

main__for_start:
	li	$t0, 0
main__for_cond:
	bge	$t0, N_POINTS, main__for_end
main__for_body:
function_name__description:
	# int row = my_points[i].row;
	mul	$t1, $t0, POINT2D_SIZE     #mul i by element size
	add	$t1, $t1, ROW_OFFSET      # add struct offset
	lw	$t2, my_points($t1)

	#	
	mul	$t1, $t0, POINT2D_SIZE
	add	$t1, $t1, COL_OFFSET
	lw	$t3, my_points($t1)

	# row = $t2
	# col = $t3
	# convert 2d to 1d offset
	# (row * total_cols + cols    ) * element_size
	mul	$t4, $t2, MAP_SIZE
	add	$t4, $t4, $t3
	mul	$t4, $t4, 4             #int array

	lw	$t4, topography_grid($t4)
	#$t4 = height
	li	$v0, 4
	la	$a0, height_str
	syscall

	li	$v0, 1
	move	$a0, $t2
	syscall

	li	$v0, 11
	li	$a0, ','
	syscall

	li	$v0, 1
	move	$a0, $t3
	syscall

	li	$v0, 11
	li	$a0, '='
	syscall

	li	$v0, 1
	move	$a0, $t4
	syscall

	li	$v0, 11
	li	$a0, '\n'
	syscall

main__for_incr:
	add	$t0, $t0, 1
	b	main__for_cond
main__for_end:
	li	$v0, 0
	jr	$ra

	.data
topography_grid:
	.word	0, 1, 1, 2, 3
	.word	1, 1, 2, 3, 4
	.word	1, 2, 3, 5, 7
	.word	3, 3, 4, 5, 6
	.word	3, 4, 5, 6, 7

# Points of interest to print heights for, as a 1D array of point2D_t structs.
# Note the memory layout of this array: each element requires 8 bytes, not 4.
my_points:
	.word	1, 2
	.word	2, 3
	.word	0, 0
	.word	4, 4

height_str: .asciiz "Height at "


















# my_point[i].countries[j]

# 1. my_point[i]
# 2. + countries
# 3. + [j] -> 