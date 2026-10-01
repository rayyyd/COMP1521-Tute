# // A short program that reverses an array by swapping elements.

#define N_SIZE 10
#define N_SIZE_M_1 N_SIZE - 1
#define N_SIZE_D_2 N_SIZE / 2

#include <stdio.h>

# int main(void) {
#     int i;
#     int numbers[N_SIZE] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};

#     i = 0;
#     while (i < N_SIZE_D_2) {
#         int x = numbers[i];
#         int y = numbers[N_SIZE_M_1 - i];

#         numbers[i] = y;
#         numbers[N_SIZE_M_1 - i] = x;

#         i++;
#     }
# }

	.text


N_SIZE = 10
N_SIZE_M_1 = 9
N_SIZE_D_2 = 5

main:

	# $T0 = I

	li	$t0, 0
main__while_cond:
function_name__some_description:
	bge	$t0, N_SIZE_D_2, end

	# address = base address + index * element_size
	mul	$t1, $t0, 4     # (index ($t0)) * elementisze (4)
	lw	$t3, numbers($t1)    # add base address


	#         int y = numbers[N_SIZE_M_1 - i];
	sub	$t2, N_SIZE_M_1, $t0
	mul	$t2, $t2, 4
	lw	$t4, numbers($t2)

	#$t3 = x
	#$t4 = y
	#$t1 = [i] offset
	#$t2 = [NSIZE_M1 -1] offset

        # numbers[i] = y;
	sw	$t4, numbers($t1)
	sw	$t3, numbers($t2)

	addi	$t0, $t0, 1

	b	main__while_cond

end:

	jr	$ra

	.data
numbers:
	.word   0, 1, 2, 3, 4, 5, 6, 7, 8, 9