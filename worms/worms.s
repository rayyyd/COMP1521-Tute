#######################################################################################
########################## COMP1521 26T3 ASSIGNMENT 1: Worms ##########################
##                                                                                   ##
## !!! IMPORTANT !!!                                                                 ##
## Before starting work on the assignment, make sure you set your tab-width to 8!    ##
## It is also suggested to indent with tabs only.                                    ##
## Instructions to configure your text editor can be found here:                     ##
##   https://cgi.cse.unsw.edu.au/~cs1521/current/resources/mips-editors.html         ##
## !!! IMPORTANT !!!                                                                 ##
##                                                                                   ##
## This program was written by YOUR-NAME-HERE (z55555555)                            ##
## on INSERT-DATE-HERE                                                               ##
##                                                                                   ##
## Leave this header comment incomplete at your PERIL!	                             ##
##                                                                                   ##
## Note: the use of AI to generate code is NOT PERMITTED for this assignment!!!      ##

#
#
#
########################################################
## DO NOT MODIFY PROVIDED CONSTANTS!!!!!!!            ##
## DO NOT MODIFY OR ADD TO PROVIDED DATA SECTION!!!!! ##
########################################################
#                       ^
#                       |
#                       +- PLEASE READ THIS!!!


###############
## CONSTANTS ##
###############

MIN_WORMS = 2
MAX_WORMS = 4

RED = 0
GREEN = 1
BLUE = 2
YELLOW = 3

MIN_TERRAINS = 4
MAX_TERRAINS = 8

WIDTH = 60
HEIGHT = 20

SUCCESS = 0
ERROR = -1

INPUT_AIM_CLOCKWISE = 'e'
INPUT_AIM_ANTICLOCKWISE = 'q'
INPUT_FIRE = 'f'
INPUT_MOVE_LEFT = 'a'
INPUT_MOVE_RIGHT = 'd'
INPUT_SURRENDER = 's'
INPUT_STRENGTH_UP = ']'
INPUT_STRENGTH_DOWN = '['

LEFT = 1
RIGHT = 2

CLOCKWISE = 1
ANTICLOCKWISE = 2

NO_TERRAIN = -1
MIN_TERRAIN_HEIGHT = 2
MAX_TERRAIN_HEIGHT = 4

MIN_TERRAIN_WIDTH = 5
MAX_TERRAIN_WIDTH = 10

TRUE = 1
FALSE = 0

COLLIDED = 1
DID_NOT_COLLIDE = 0

BACKGROUND_CHAR = ' '
TERRAIN_CHAR = '#'
WORM_CHAR = 'I'
PROJECTILE_CHAR = 'X'
PROJECTILE_ABOVE_CHAR = '^'
TRAIL_CHAR = '.'

ALLOW_LOW_WORM_THRESHOLD = 16

NUM_AIM_OFFSETS = 7
NUM_AIM_OFFSET_MULTIPLIERS = 4

MAX_AIM_VALUE = (NUM_AIM_OFFSETS * NUM_AIM_OFFSET_MULTIPLIERS) - 4 - 1

X_INDEX = 0
Y_INDEX = 1

TRAIL_LENGTH = 4

MOVE_RENDER_THRESHOLD = TRAIL_LENGTH / 2

GRAVITY = 67

X_TO_UNITS = 2000
Y_TO_UNITS = 4000

PHYSICS_SCALING = 10

MAX_STRENGTH = 5
DEFAULT_STRENGTH = 1

MAX_IMPACTS = 64
IMPACT_POINTS = 4
IMPACT_WIDTH = 5
IMPACT_HEIGHT = 3

SIZEOF_INT = 4
SIZEOF_UINT = 4
SIZEOF_PTR = 4
SIZEOF_CHAR = 1

POINT_X_OFFSET = 0
POINT_Y_OFFSET = POINT_X_OFFSET + SIZEOF_INT
SIZEOF_POINT = POINT_Y_OFFSET + SIZEOF_INT

TERRAIN_TOP_LEFT_OFFSET = 0
TERRAIN_WIDTH_OFFSET = TERRAIN_TOP_LEFT_OFFSET + SIZEOF_POINT
TERRAIN_HEIGHT_OFFSET = TERRAIN_WIDTH_OFFSET + SIZEOF_INT
SIZEOF_TERRAIN = TERRAIN_HEIGHT_OFFSET + SIZEOF_INT

WORM_POS_OFFSET = 0
WORM_AIM_OFFSET = WORM_POS_OFFSET + SIZEOF_POINT
WORM_ALIVE_OFFSET = WORM_AIM_OFFSET + SIZEOF_INT
SIZEOF_WORM = WORM_ALIVE_OFFSET + SIZEOF_INT

PROJECTILE_POS_OFFSET = 0
PROJECTILE_POS_UNIT_X_OFFSET = PROJECTILE_POS_OFFSET + SIZEOF_POINT
PROJECTILE_POS_UNIT_Y_OFFSET = PROJECTILE_POS_UNIT_X_OFFSET + SIZEOF_INT
PROJECTILE_ORIGIN_OFFSET = PROJECTILE_POS_UNIT_Y_OFFSET + SIZEOF_INT
PROJECTILE_TRAIL_OFFSET = PROJECTILE_ORIGIN_OFFSET + SIZEOF_POINT
PROJECTILE_TRAIL_LENGTH_OFFSET = PROJECTILE_TRAIL_OFFSET + SIZEOF_POINT * TRAIL_LENGTH
PROJECTILE_DX_OFFSET = PROJECTILE_TRAIL_LENGTH_OFFSET + SIZEOF_INT
PROJECTILE_DY_OFFSET = PROJECTILE_DX_OFFSET + SIZEOF_INT
SIZEOF_PROJECTILE = PROJECTILE_DY_OFFSET + SIZEOF_INT

	.data

###################################
## struct projectile projectile; ##
###################################
	.align 2
projectile:
	.space SIZEOF_PROJECTILE

#################################
## struct projectile aim_guide ##
#################################
	.align 2
aim_guide:
	.space SIZEOF_PROJECTILE

###################################
## struct worm worms[MAX_WORMS]; ##
###################################
	.align 2
worms:
	.space SIZEOF_WORM * MAX_WORMS

#################
## int nworms; ##
#################
	.align 2
nworms:
	.space SIZEOF_INT


############################################
## struct terrain terrains[MAX_TERRAINS]; ##
############################################
	.align 2
terrains:
	.space SIZEOF_TERRAIN * MAX_TERRAINS

####################
## int nterrains; ##
####################
	.align 2
nterrains:
	.space SIZEOF_INT

########################################
## struct point impacts[MAX_IMPACTS]; ##
########################################
	.align 2
impacts:
	.space SIZEOF_POINT * MAX_IMPACTS

###################
## int nimpacts; ##
###################
	.align 2
nimpacts:
	.space SIZEOF_INT

######################
## int active_worm; ##
######################
	.align 2
active_worm:
	.space SIZEOF_INT

##########################
## unsigned int random; ##
##########################
	.align 2
random:
	.space SIZEOF_UINT

#################################
## char screen[HEIGHT][WIDTH]; ##
#################################
screen:
	.space SIZEOF_CHAR * HEIGHT * WIDTH

############################################
## int worm_already_placed[MAX_TERRAINS]; ##
############################################
worm_already_placed:
	.space SIZEOF_INT * MAX_TERRAINS

##############################
## int strength[MAX_WORMS]; ##
##############################
strength:
	.space SIZEOF_INT * MAX_WORMS

########################
## char *ansii_clear; ##
########################
ansii_clear:
	.byte 0x1b, '[', '3', 'J', 0x1b, '[', 'H', 0x1b, '[', '2', 'J', 0x00

################################################
## struct point aim_offsets[NUM_AIM_OFFSETS]; ##
###############################################3
	.align 2
aim_offsets:
	.word 0, 2
	.word 1, 2
	.word 2, 2
	.word 2, 1
	.word 3, 1
	.word 4, 1
	.word 4, 0

################################################################
## int aim_offset_multipliers[NUM_AIM_OFFSET_MULTIPLIERS][2]; ##
################################################################
	.align 2
aim_offset_multipliers:
	.word 1, -1
	.word 1, 1
	.word -1, 1
	.word -1, -1

###################################################################
## int aim_dir_reversed_in_quadrant[NUM_AIM_OFFSET_MULTIPLIERS]; ##
###################################################################
	.align 2
aim_dir_reversed_in_quadrant:
	.word FALSE, TRUE, FALSE, TRUE

####################################
## char *msg_for_worm[MAX_WORMS]; ##
####################################
msg_for_worm_0:
	.asciiz "RED wins!   "
msg_for_worm_1:
	.asciiz "GREEN wins! "
msg_for_worm_2:
	.asciiz "BLUE wins!  "
msg_for_worm_3:
	.asciiz "YELLOW wins!"

	.align 2
msg_for_worm:
	.word msg_for_worm_0, msg_for_worm_1, msg_for_worm_2, msg_for_worm_3

#############
## STRINGS ##
#############

setup_str_1:
	.asciiz "Welcome to worms\n"

setup_str_2:
	.asciiz "Enter a random seed: "

setup_str_3:
	.asciiz "How many worms (players)? "

setup_str_4:
	.asciiz "error: bad number of worms\n"

setup_str_5:
	.asciiz "How many terrain blocks? "

setup_str_6:
	.asciiz "error: bad number of terrains\n"

print_rgb_str_1:
	.byte 0x1b, '[', '3', '8', ';', '2', ';', 0x00

print_rgb_str_2:
	.byte 0x1b, '[', '0', 'm', 0x00

fire_str_1:
	.asciiz "error: out of memory\n"

do_something_str_1:
	.asciiz "invalid input '"

do_something_str_2:
	.asciiz "'\n"

player_input_str_1:
	.asciiz "firing strength: "

player_input_str_2:
	.asciiz "> "

render_end_screen_str_1:
	.asciiz "Game Over!"

render_end_screen_str_2:
	.asciiz "NOONE wins! "

wait_for_input_str_1:
	.asciiz "... "

#
#
#
########################################################
## DO NOT MODIFY PROVIDED CONSTANTS!!!!!!!            ##
## DO NOT MODIFY OR ADD TO PROVIDED DATA SECTION!!!!! ##
########################################################
#                       ^
#                       |
#                       +- PLEASE READ THIS!!!



############################################################
####                                                    ####
####   Your journey begins here, intrepid adventurer!   ####
####                                                    ####
############################################################

	.text

##############
## SUBSET 0 ##
##############

################################################################################
# .TEXT <main>
	.text
main:
	# Subset:   0
	#
	# Frame:	[...]   <-- FILL THESE OUT!
	# Uses:		[...]
	# Clobbers: 	[...]
	#
	# Locals:		<-- FILL THIS OUT!
	#   - ...
	#
	# Structure:		<-- FILL THIS OUT!
	#   main
	#   -> [prologue]
	#	   -> body
	#   -> [epilogue]
main__prologue:
main__body:
main__epilogue:
	jr	$ra


################################################################################
# .TEXT <in_bounds>
	.text
in_bounds:
	# Subset:   0
	#
	# Frame:	[...]   <-- FILL THESE OUT!
	# Uses:		[...]
	# Clobbers: 	[...]
	#
	# Locals:		<-- FILL THIS OUT!
	#   - ...
	#
	# Structure:		<-- FILL THIS OUT!
	#   in_bounds
	#   -> [prologue]
	#	   -> body
	#   -> [epilogue]
in_bounds__prologue:
in_bounds__body:
in_bounds__epilogue:
	jr	$ra




################################################################################
# .TEXT <get_input>
	.text
get_input:
	# Subset:   0
	#
	# Frame:	[...]   <-- FILL THESE OUT!
	# Uses:		[...]
	# Clobbers: 	[...]
	#
	# Locals:		<-- FILL THIS OUT!
	#   - ...
	#
	# Structure:		<-- FILL THIS OUT!
	#   play
	#   -> [prologue]
	#	   -> body
	#   -> [epilogue]
get_input__prologue:
get_input__body:
get_input__epilogue:
	jr	$ra

################################################################################
# .TEXT <play>
	.text
play:
	# Subset:   0
	#
	# Frame:	[...]   <-- FILL THESE OUT!
	# Uses:		[...]
	# Clobbers: 	[...]
	#
	# Locals:		<-- FILL THIS OUT!
	#   - ...
	#
	# Structure:		<-- FILL THIS OUT!
	#   play
	#   -> [prologue]
	#	   -> body
	#   -> [epilogue]
play__prologue:
play__body:
play__epilogue:
	jr	$ra


##############
## SUBSET 1 ##
##############


################################################################################
# .TEXT <render_background>
	.text
render_background:
	# Subset:   1
	#
	# Frame:	[...]   <-- FILL THESE OUT!
	# Uses:		[...]
	# Clobbers: 	[...]
	#
	# Locals:		<-- FILL THIS OUT!
	#   - ...
	#
	# Structure:		<-- FILL THIS OUT!
	#   render_background
	#   -> [prologue]
	#	   -> body
	#   -> [epilogue]
render_background__prologue:
render_background__body:
render_background__epilogue:
	jr	$ra

################################################################################
# .TEXT <game_over>
	.text
game_over:
	# Subset:   1
	#
	# Frame:	[...]   <-- FILL THESE OUT!
	# Uses:		[...]
	# Clobbers: 	[...]
	#
	# Locals:		<-- FILL THIS OUT!
	#   - ...
	#
	# Structure:		<-- FILL THIS OUT!
	#   game_over
	#   -> [prologue]
	#	   -> body
	#   -> [epilogue]
game_over__prologue:
game_over__body:
game_over__epilogue:
	jr	$ra

################################################################################
# .TEXT <aim>
	.text
aim:
	# Subset:   1
	#
	# Frame:	[...]   <-- FILL THESE OUT!
	# Uses:		[...]
	# Clobbers: 	[...]
	#
	# Locals:		<-- FILL THIS OUT!
	#   - ...
	#
	# Structure:		<-- FILL THIS OUT!
	#   aim
	#   -> [prologue]
	#	   -> body
	#   -> [epilogue]
aim__prologue:
aim__body:
aim__epilogue:
	jr	$ra


################################################################################
# .TEXT <render_worms>
	.text
render_worms:
	# Subset:   1
	#
	# Frame:	[...]   <-- FILL THESE OUT!
	# Uses:		[...]
	# Clobbers: 	[...]
	#
	# Locals:		<-- FILL THIS OUT!
	#   - ...
	#
	# Structure:		<-- FILL THIS OUT!
	#   render_worms
	#   -> [prologue]
	#	   -> body
	#   -> [epilogue]
render_worms__prologue:
render_worms__body:
render_worms__epilogue:
	jr	$ra

##############
## SUBSET 2 ##
##############

################################################################################
# .TEXT <overlaps_with_terrain>
	.text
overlaps_with_terrain:
	# Subset:   2
	#
	# Frame:	[...]   <-- FILL THESE OUT!
	# Uses:		[...]
	# Clobbers: 	[...]
	#
	# Locals:		<-- FILL THIS OUT!
	#   - ...
	#
	# Structure:		<-- FILL THIS OUT!
	#   overlaps_with_terrain
	#   -> [prologue]
	#	   -> body
	#   -> [epilogue]
overlaps_with_terrain__prologue:
overlaps_with_terrain__body:
overlaps_with_terrain__epilogue:
	jr	$ra

################################################################################
# .TEXT <move>
	.text
move:
	# Subset:   2
	#
	# Frame:	[...]   <-- FILL THESE OUT!
	# Uses:		[...]
	# Clobbers: 	[...]
	#
	# Locals:		<-- FILL THIS OUT!
	#   - ...
	#
	# Structure:		<-- FILL THIS OUT!
	#   move
	#   -> [prologue]
	#	   -> body
	#   -> [epilogue]
move__prologue:
move__body:
move__epilogue:
	jr	$ra



################################################################################
# .TEXT <render_projectile>
	.text
render_projectile:
	# Subset:   2
	#
	# Frame:	[...]   <-- FILL THESE OUT!
	# Uses:		[...]
	# Clobbers: 	[...]
	#
	# Locals:		<-- FILL THIS OUT!
	#   - ...
	#
	# Structure:		<-- FILL THIS OUT!
	#   render_projectile
	#   -> [prologue]
	#	   -> body
	#   -> [epilogue]
render_projectile__prologue:
render_projectile__body:
render_projectile__epilogue:
	jr	$ra





##############
## SUBSET 3 ##
##############

################################################################################
# .TEXT <fire>
	.text
fire:
	# Subset:   3
	#
	# Frame:	[...]   <-- FILL THESE OUT!
	# Uses:		[...]
	# Clobbers: 	[...]
	#
	# Locals:		<-- FILL THIS OUT!
	#   - ...
	#
	# Structure:		<-- FILL THIS OUT!
	#   fire
	#   -> [prologue]
	#	   -> body
	#   -> [epilogue]
fire__prologue:
fire__body:
fire__epilogue:
	jr	$ra


################################################################################
# .TEXT <render_end_screen>
	.text
render_end_screen:
	# Subset:   3
	#
	# Frame:	[...]   <-- FILL THESE OUT!
	# Uses:		[...]
	# Clobbers: 	[...]
	#
	# Locals:		<-- FILL THIS OUT!
	#   - ...
	#
	# Structure:		<-- FILL THIS OUT!
	#   render_end_screen
	#   -> [prologue]
	#	   -> body
	#   -> [epilogue]
render_end_screen__prologue:
render_end_screen__body:
render_end_screen__epilogue:
	jr	$ra

################################################################################
# .TEXT <print_rgb>
	.text
print_rgb:
	# Subset:   3
	#
	# Frame:	[...]   <-- FILL THESE OUT!
	# Uses:		[...]
	# Clobbers: 	[...]
	#
	# Locals:		<-- FILL THIS OUT!
	#   - ...
	#
	# Structure:		<-- FILL THIS OUT!
	#   print_rgb
	#   -> [prologue]
	#	   -> body
	#   -> [epilogue]
print_rgb__prologue:
print_rgb__body:
print_rgb__epilogue:
	jr	$ra


##############
## PROVIDED ##
##############

################################################################################
# .TEXT <offset_multiplier_index_for_aim>
	.text
offset_multiplier_index_for_aim:
	#
	# Frame:	[]
	# Uses:		[$t0, $t1]
	# Clobbers: 	[$t0, $t1]
	#
	# Locals:
	#   - $t0: int a
	#   - $t1: int skipped
	#
	# Structure:
	#   surrender
	#   -> [prologue]
	#	   -> body
	#   -> [epilogue]
offset_multiplier_index_for_aim__prologue:
offset_multiplier_index_for_aim__body:
	lw	$t0, active_worm		# int a = worms[active_worm].aim;
	mul	$t0, $t0, SIZEOF_WORM		#
	lw	$t0, worms + WORM_AIM_OFFSET($t0)
						#

	li	$t1, NUM_AIM_OFFSETS - 1	# int skipped - a / (NUM_AIM_OFFSETS - 1):
	div	$t1, $t0, $t1			#

	add	$t0, $t0, $t1			# return (a + skipped) / NUM_AIM_OFFSETS;
	div	$t0, $t0, NUM_AIM_OFFSETS	#
	move	$v0, $t0			#
offset_multiplier_index_for_aim__epilogue:
	jr	$ra

################################################################################
# .TEXT <surrender>
	.text
surrender:
	# Subset:   PROVIDED
	#
	# Frame:	[$ra]
	# Uses:		[$t0, $a0]
	# Clobbers: 	[$t0, $a0]
	#
	# Locals:
	#   - $t0: &worms[active_worm].alive
	#   - $a0: TRUE
	#
	# Structure:
	#   surrender
	#   -> [prologue]
	#	   -> body
	#   -> [epilogue]
surrender__prologue:
	push	$ra
surrender__body:
	lw	$t0, active_worm	#  worms[active_worm].alive = FALSE;
	mul	$t0, $t0, SIZEOF_WORM	#
	sw	$zero, worms + WORM_ALIVE_OFFSET($t0)
					#

	jal	next_turn		# next_turn();

	li	$a0, TRUE		# render(TRUE);
	jal	render			#

	jal	display			# display();
surrender__epilogue:
	pop	$ra
	jr	$ra

################################################################################
# .TEXT <move_projectile>
	.text
move_projectile:
	# Subset:   PROVIDED
	#
	# Frame:	[$ra, $s0, $s1, $s2, $s3]
	# Uses:		[$a0, $a1, $t0, $t1, $t2, $t3, $t4, $t5, $t6, $s0, $s1, $s2, $s3]
	# Clobbers: 	[$a0, $a1, $t0, $t1, $t2, $t3, $t4, $t5, $t6]
	#
	# Locals:
	#   - $s0: struct projectile *p
	#   - $s1: int new_x
	#   - $s2: int new_y
	#   - $s3: int moved
	#   - $t0: int old_x
	#   - $t1: int old_y
	#   - $t3: int i
	#
	#
	# Structure:
	#   move_projectile
	#   -> [prologue]
	#   	   -> body
	#          -> [moving]
	#            -> cond
	#              -> collided
	#              -> no_collision
	#              -> moved
	#                -> big_enough
	#                -> [move_trail]
	#                  -> init
	#                  -> cond
	#                  -> body
	#                  -> step
	#                  -> end
	#              -> did_not_move
	#            -> end
	#   -> [epilogue]
move_projectile__prologue:
	push	$ra
	push	$s0
	push	$s1
	push	$s2
	push	$s3
move_projectile__body:

	move	$s0, $a0

	li	$s3, 0			# int moved = 0;
move_projectile__moving_cond:
	bge	$s3, MOVE_RENDER_THRESHOLD, move_projectile__moving_end
					# while (moved < MOVE_RENDER_THRESHOLD) {

	lw	$t0, PROJECTILE_POS_OFFSET + POINT_X_OFFSET($s0)
					#     int old_x = p->pos.x;
	lw	$t1, PROJECTILE_POS_OFFSET + POINT_Y_OFFSET($s0)
					#     int old_y = p->pos.y;

	lw	$t2, PROJECTILE_DX_OFFSET($s0)
					#     p->pos_unit_x += (p->dx / PHYSICS_SCALING);
	div	$t2, $t2, PHYSICS_SCALING
					#
	lw	$t3, PROJECTILE_POS_UNIT_X_OFFSET($s0)
					#
	add	$t3, $t3, $t2		#
	sw	$t3, PROJECTILE_POS_UNIT_X_OFFSET($s0)
					#

	lw	$t2, PROJECTILE_DY_OFFSET($s0)
					#     p->pos_unit_y += (p->dy / PHYSICS_SCALING);
	div	$t2, $t2, PHYSICS_SCALING
					#
	lw	$t3, PROJECTILE_POS_UNIT_Y_OFFSET($s0)
					#
	add	$t3, $t3, $t2		#
	sw	$t3, PROJECTILE_POS_UNIT_Y_OFFSET($s0)
					#

	li	$t2, GRAVITY		#     p->dy += (GRAVITY / PHYSICS_SCALING);
	div	$t2, $t2, PHYSICS_SCALING
					#
	lw	$t3, PROJECTILE_DY_OFFSET($s0)
					#
	add	$t3, $t3, $t2		#
	sw	$t3, PROJECTILE_DY_OFFSET($s0)
					#

	lw	$s1, PROJECTILE_POS_UNIT_X_OFFSET($s0)
					#     int new_x = p->pos_unit_x / X_TO_UNITS;
	div	$s1, $s1, X_TO_UNITS	#

	lw	$s2, PROJECTILE_POS_UNIT_Y_OFFSET($s0)
					#     int new_y = p->pos_unit_x / Y_TO_UNITS;
	div	$s2, $s2, Y_TO_UNITS	#

	bltz	$s1, move_projectile__collided
					#     if (new_x < 0 ...
	bge	$s1, WIDTH, move_projectile__collided
					#     || new_x >= WIDTH) {
	bge	$s2, HEIGHT, move_projectile__collided
					#     if (new_y >= HEIGHT) {
	b	move_projectile__no_collision

move_projectile__collided:
	li	$v0, COLLIDED		#         return COLLIDED;
	b	move_projectile__epilogue
					#
move_projectile__no_collision:		#     }

	bne	$t0, $s1, move_projectile__moved
					#     if (new_x != old_x ...
	bne	$t1, $s2, move_projectile__moved
					#     || new_y != old_y) {
	b	move_projectile__did_not_move
					#

move_projectile__moved:
	add	$s3, $s3, 1		#         moved++;

	sw	$s1, PROJECTILE_POS_OFFSET + POINT_X_OFFSET($s0)
					#         p->pos.x = new_x;
	sw	$s2, PROJECTILE_POS_OFFSET + POINT_Y_OFFSET($s0)
					#         p->pos.y = new_y;

	lw	$t2, PROJECTILE_TRAIL_LENGTH_OFFSET($s0)
					#         if (p->tail_length < TRAIL_LENGTH) {
	bge	$t2, TRAIL_LENGTH, move_projectile__big_enough
					#

	add	$t2, $t2, 1		#             p->trail_length++;
	sw	$t2, PROJECTILE_TRAIL_LENGTH_OFFSET($s0)
					#

move_projectile__big_enough:		#         }

move_projectile__move_trail_init:
	lw	$t3, PROJECTILE_TRAIL_LENGTH_OFFSET($s0)
					#         int i = p->trail_length - 2;
	add	$t3, $t3, -2		#
move_projectile__move_trail_cond:
	bltz	$t3, move_projectile__move_trail_end
					#         while (i >= 0) {

move_projectile__move_trail_body:
	mul	$t4, $t3, SIZEOF_POINT	#             p->trail[i + 1] = p->trail[i];
	add	$t4, $t4, $s0		#
	add	$t5, $t4, SIZEOF_POINT	#
	lw	$t6, PROJECTILE_TRAIL_OFFSET + POINT_X_OFFSET($t4)
					#
	sw	$t6, PROJECTILE_TRAIL_OFFSET + POINT_X_OFFSET($t5)
					#
	lw	$t6, PROJECTILE_TRAIL_OFFSET + POINT_Y_OFFSET($t4)
					#
	sw	$t6, PROJECTILE_TRAIL_OFFSET + POINT_Y_OFFSET($t5)
					#

move_projectile__move_trail_step:
	add	$t3, $t3, -1		#             i--;
	b	move_projectile__move_trail_cond
move_projectile__move_trail_end:	#         }

	sw	$t0, PROJECTILE_TRAIL_OFFSET + POINT_X_OFFSET($s0)
					#         p->trail[0].x = old_x;
	sw	$t1, PROJECTILE_TRAIL_OFFSET + POINT_Y_OFFSET($s0)
					#         p->trail[0].y = old_y;

move_projectile__did_not_move:		#     }

	move	$a0, $s1		#     if (in_bounds(new_x, new_y) ...
	move	$a1, $s2		#
	jal	in_bounds		#
	beqz	$v0, move_projectile__no_collision_2
					#

	move	$a0, $s1		#     && (collides_with_terrain(new_x, new_y) != NEW_TERRAIN ...
	move	$a1, $s2		#
	jal	collides_with_terrain	#
	beq	$v0, NO_TERRAIN, move_projectile__maybe_no_collision_2
					#
	b	move_projectile__collision_2
					#
move_projectile__maybe_no_collision_2:
	mul	$t0, $s2, WIDTH		#     || screen[new_y][new_x] == WORM_CHAR)) {
	add	$t0, $t0, $s1		#
	lb	$t1, screen($t0)	#
	bne	$t1, WORM_CHAR, move_projectile__no_collision_2
					#
move_projectile__collision_2:
	li	$v0, COLLIDED		#         return COLLIDED;
	b	move_projectile__epilogue

move_projectile__no_collision_2:	#     }

	b	move_projectile__moving_cond
move_projectile__moving_end:		# }

	li	$v0, DID_NOT_COLLIDE	# return DID_NOT_COLLIDE;
move_projectile__epilogue:
	pop	$s3
	pop	$s2
	pop	$s1
	pop	$s0
	pop	$ra
	jr	$ra


################################################################################
# .TEXT <setup>
	.text
setup:
	# Subset:   PROVIDED
	#
	# Frame:	[$ra, $s0]
	# Uses:		[$a0, $v0, $t0, $t1, $s0]
	# Clobbers: 	[$a0, $v0, $t0, $t1]
	#
	# Locals:
	#   - $s0: int input
	#   - $t0: int i
	#
	# Structure:
	#   setup
	#   -> [prologue]
	#	   -> body
	#          -> [worms_input]
	#            -> bad
	#            -> ok
	#         -> [terrain_input]
	#           -> bad
	#           -> ok
	#         -> [strength]
	#           -> init
	#           -> cond
	#           -> body
	#           -> step
	#           -> end
	#   -> [epilogue]
setup__prologue:
	push	$ra
	push	$s0
setup__body:
	la	$a0, setup_str_1	# printf("Welcome to worms\n");
	li	$v0, 4			#
	syscall				#

	la	$a0, setup_str_2	# input = get_input("Enter a random seed: );
	jal	get_input		#
	move	$s0, $v0		#

	move	$a0, $s0		# seed_random(input)
	jal	seed_random		#

	la	$a0, setup_str_3	# input = get_input("How many worms (players)? "):
	jal	get_input		#
	move	$s0, $v0		#

	blt	$s0, MIN_WORMS, setup__worms_input_bad
					# if (input < MIN_WORMS ...
	bgt	$s0, MAX_WORMS, setup__worms_input_bad
					# ... || input > MAX_WORMS) {
	b	setup__worms_input_ok
setup__worms_input_bad:			#
	la	$a0, setup_str_4	#     printf("error: bad number of worms\n");
	li	$v0, 4			#
	syscall				#

	li	$v0, ERROR		#     return ERROR;
	j	setup__epilogue		#
setup__worms_input_ok:			# }

	sw	$s0, nworms		# nworms = input;

	la	$a0, setup_str_5	# input = get_input("How many terrain blocks? ");
	jal	get_input		#
	move	$s0, $v0		#

	blt	$s0, MIN_TERRAINS, setup__terrain_input_bad
					# if (input < MIN_TERRAINS ...
	bgt	$s0, MAX_TERRAINS, setup__terrain_input_bad
					# ... || input > MAX_TERRAINS) {
	b	setup__terrain_input_ok

setup__terrain_input_bad:		#

	la	$a0, setup_str_6	#     printf("error: bad number of terrains");
	li	$v0, 4			#
	syscall				#

	li	$v0, ERROR		#     return ERROR;
	b	setup__epilogue		#

setup__terrain_input_ok:		# }

	sw	$s0, nterrains		# nterrains = input;
	sw	$zero, nimpacts		# nimpacts = 0;
	sw	$zero, active_worm	# active_worm = 0;

	jal	setup_terrains		# setup_terrains();
	jal	setup_worms		# setup_worms();



setup__strength_init:
	li	$t0, 0			# int i = 0;
setup__strength_cond:
	lw	$t1, nworms		# while (i < nworms) {
	bge	$t0, $t1, setup__strength_end
					#
setup__strength_body:
	mul	$t1, $t0, SIZEOF_INT	#      strength[i] = DEFAULT_STRENGTH;
	li	$t2, DEFAULT_STRENGTH	#
	sw	$t2, strength($t1)	#
setup__strength_step:
	add	$t0, $t0, 1		# i++;
	b	setup__strength_cond	# }
setup__strength_end:

	li	$a0, TRUE		# render(TRUE);
	jal	render			# 
	jal	display			# display();

	li	$v0, SUCCESS		# return SUCCESS;
setup__epilogue:
	pop	$s0
	pop	$ra
	jr	$ra


################################################################################
# .TEXT <setup_terrains>
	.text
setup_terrains:
	# Subset:   PROVIDED
	#
	# Frame:	[$ra, $s0, $s1, $s2, $s3, $s4]
	# Uses:		[$a0, $a1, $a2, $a3, $t0, $t1, $t2, $t3, $t4, $s0, $s1, $s2, $s3, $s4]
	# Clobbers: 	[$a0, $a1, $a2, $a3, $t0, $t1, $t2, $t3, $t4]
	#
	# Locals:
	#   - $t0: int i
	#   - $s0: int i
	#   - $s1: int random_x
	#   - $s2: int random_y
	#   - $s3: int terrain_width
	#   - $s4: int terrain_height
	#   - $t0: left
	#   - $t1: right
	#   - $t2: top
	#   - $t3: bottom
	#
	# Structure:
	#   setup_terrains
	#   -> [prologue]
	#	   -> body
	#          -> [invalidate]
	#            -> init
	#            -> cond
	#            -> body
	#            -> step
	#            -> end
	#          -> [make]
	#            -> init
	#            -> cond
	#            -> body
	#              -> no_overlap
	#              -> right_okay
	#              -> bottom_okay
	#            -> step
	#            -> end
	#   -> [epilogue]
setup_terrains__prologue:
	push	$ra
	push	$s0
	push	$s1
	push	$s2
	push	$s3
	push	$s4
setup_terrains__body:

setup_terrains__invalidate_init:
	li	$t0, 0			# int i = 0;
setup_terrains__invalidate_cond:
	lw	$t1, nterrains		# while (i < nterrains) {
	bge	$t0, $t1, setup_terrains__invalidate_end
					#
setup_terrains__invalidate_body:
	mul	$t1, $t0, SIZEOF_TERRAIN#     terrains[i].width = 0;
	sw	$zero, terrains + TERRAIN_WIDTH_OFFSET($t1)
					#

	sw	$zero, terrains + TERRAIN_HEIGHT_OFFSET($t1)
					#     terrains[i].height = 0;

	add	$t1, $t1, POINT_X_OFFSET#     terrains[i].top_left.x = 0;
	sw	$zero, terrains + TERRAIN_TOP_LEFT_OFFSET($t1)
					#
	
	sub	$t1, $t1, POINT_X_OFFSET#     terrains[i].top_left.y = 0;
	add	$t1, $t1, POINT_Y_OFFSET#
	sw	$zero, terrains + TERRAIN_TOP_LEFT_OFFSET($t1)
					#
setup_terrains__invalidate_step:
	add	$t0, $t0, 1		#     i++;
	b	setup_terrains__invalidate_cond
					#
setup_terrains__invalidate_end:		# }

setup_terrains__make_init:
	li	$s0, 0			# int i = 0;
setup_terrains__make_cond:
	lw	$t0, nterrains		# while (i < nterrains) {
	bge	$s0, $t0, setup_terrains__make_end
					#
setup_terrains__make_body:		#     do {
	li	$a0, 0			#         int random_x = random_in_range(0, WIDTH - 1);
	li	$a1, WIDTH - 1		#
	jal	random_in_range		#
	move	$s1, $v0		#

	li	$a0, 1			#         int random_y = random_in_range(1, HEIGHT - 1);
	li	$a1, HEIGHT - 1		#
	jal	random_in_range		#
	move	$s2, $v0		#

	move	$a0, $s1		#     } while (collides_with_terrain(random_x, random_y) != NO_TERRAIN);
	move	$a1, $s2		#
	jal	collides_with_terrain	#
	bne	$v0, NO_TERRAIN, setup_terrains__make_body
					#


	li	$a0, MIN_TERRAIN_WIDTH	#     int terrain_width = random_in_range(MIN_TERRAIN_WIDTH, MAX_TERRAIN_WIDTH);
	li	$a1, MAX_TERRAIN_WIDTH	#
	jal	random_in_range		#
	move	$s3, $v0		#

	li	$a0, MIN_TERRAIN_HEIGHT	#     int terrain_height = random_in_range(MIN_TERRAIN_HEIGHT, MAX_TERRAIN_HEIGHT);
	li	$a1, MAX_TERRAIN_HEIGHT	#
	jal	random_in_range		#
	move	$s4, $v0		#

	move	$a0, $s1		#     if (overlaps_with_terrain(random_x, random_y, terrain_width, terrain_height)) {
	move	$a1, $s2		#
	move	$a2, $s3		#
	move	$a3, $s4		#
	jal	overlaps_with_terrain	#
	beqz	$v0, setup_terrains__no_overlap
					#

	sub	$s0, $s0, 1		#         i--;
	b	setup_terrains__make_step
					#         continue;

setup_terrains__no_overlap:		#     }

	move	$t0, $s1		#     int left = random_x;

	add	$t1, $t0, $s3		#     int right = random_x + terrain_width - 1;
	add	$t1, $t1, -1		#

	move	$t2, $s2		#     int top = random_y;

	add	$t3, $t2, $s4		#     int bottom = random_y + terrain_height - 1;
	add	$t3, $t3, -1		#

	blt	$t1, WIDTH, setup_terrains__right_ok
					#     if (right >= WIDTH) {

	sub	$s0, $s0, 1		#         i--;
	b	setup_terrains__make_step
					#         continue;

setup_terrains__right_ok:		#     }

	blt	$t3, HEIGHT, setup_terrains__bottom_okay
					#     if (bottom >= HEIGHT) {

	sub	$s0, $s0, 1		#         i--;
	b	setup_terrains__make_step
					#         continue;

setup_terrains__bottom_okay:		#     }

	mul	$t4, $s0, SIZEOF_TERRAIN#     terrains[i].top_left.y = top;
	add	$t4, $t4, POINT_Y_OFFSET#
	sw	$t2, terrains + TERRAIN_TOP_LEFT_OFFSET($t4)
					#

	sub	$t4, $t4, POINT_Y_OFFSET#     terrains[i].top_left.x = left;
	add	$t4, $t4, POINT_X_OFFSET#
	sw	$t0, terrains + TERRAIN_TOP_LEFT_OFFSET($t4)
					#

	sub	$t4, $t4, POINT_X_OFFSET#     terrains[i].width = terrain_width;
	sw	$s3, terrains + TERRAIN_WIDTH_OFFSET($t4)
					#

	sw	$s4, terrains + TERRAIN_HEIGHT_OFFSET($t4)
					#     terrains[i].height = terrain_height;


setup_terrains__make_step:
	add	$s0, $s0, 1		#     i++;
	b	setup_terrains__make_cond
					#
setup_terrains__make_end:

setup_terrains__epilogue:
	pop	$s4
	pop	$s3
	pop	$s2
	pop	$s1
	pop	$s0
	pop	$ra
	jr	$ra


################################################################################
# .TEXT <setup_worms>
	.text
setup_worms:
	# Subset:   PROVIDED
	#
	# Frame:	[$s0, $s1, $s2, $s3, $s4, $s5]
	# Uses:		[$a0, $a1, $t0, $t1, $s0, $s1, $s2, $s3, $s4, $s5]
	# Clobbers: 	[$a0, $a1, $t0, $t1]
	#
	# Locals:
	#   - $t0: int i
	#   - $s5: int worm_too_Low
	#   - $s0: int i
	#   - $s1: int random_terrain
	#   - $s2: struct terrain *t
	#   - $s3: int x
	#   - $s4: int y
	#
	# Structure:
	#   setup_worms
	#   -> [prologue]
	#	   -> body
	#          -> [unplaced]
	#            -> init
	#            -> cond
	#            -> body
	#            -> step
	#            -> end
	#          -> [place]
	#            -> init
	#            -> cond
	#            -> body
	#              -> not_already_placed
	#              -> not_in_terrain
	#              -> top_half_ok
	#            -> step
	#            -> end
	#   -> [epilogue]
setup_worms__prologue:
	push	$ra
	push	$s0
	push	$s1
	push	$s2
	push	$s3
	push	$s4
	push	$s5
setup_worms__body:

setup_worms__unplaced_init:
	li	$t0, 0			# int i = 0;
setup_worms__unplaced_cond:
	lw	$t1, nterrains		# while (i < nterrains) {
	bge	$t0, $t1, setup_worms__unplaced_end
					#
setup_worms__unplaced_body:
	mul	$t1, $t0, SIZEOF_INT	#     worms_already_placed[i] = FALSE;
	sw	$zero, worm_already_placed($t1)
					#
setup_worms__unplaced_step:
	add	$t0, $t0, 1		#     i++;
	b	setup_worms__unplaced_cond
					# }
setup_worms__unplaced_end:

	li	$s5, 0			# int worm_too_low = 0;

setup_worms__place_init:
	li	$s0, 0			# int i = 0;
setup_worms__place_cond:
	lw	$t0, nworms		# while (i < nworms) {
	bge	$s0, $t0, setup_worms__place_end
					#
setup_worms__place_body:

	mul	$t0, $s0, SIZEOF_WORM	#     worms[i].aim = 0;
	sw	$zero, WORM_AIM_OFFSET + worms($t0)
					#

	li	$t1, TRUE		#     worms[i].alive = TRUE;
	sw	$t1, WORM_ALIVE_OFFSET + worms($t0)
					#

	li	$a0, 0			#     int random_terrain = random_in_range(0, nterrains - 1);
	lw	$a1, nterrains		#
	add	$a1, $a1, -1		#
	jal	random_in_range		#
	move	$s1, $v0		#

	mul	$t0, $s1, SIZEOF_TERRAIN#     struct terrain *t  = &terrains[random_terrain];
	la	$s2, terrains($t0)	#

	li	$t0, TERRAIN_TOP_LEFT_OFFSET
					#     int x = t->top_left.x + t->width / 2
	add	$t0, $t0, $s2		#
	lw	$s3, POINT_X_OFFSET($t0)#
	lw	$t1, TERRAIN_WIDTH_OFFSET($s2)
					#
	div	$t1, $t1, 2		#
	add	$s3, $s3, $t1		#

	lw	$s4, POINT_Y_OFFSET($t0)#     int y = t->top_left.y - 1;
	sub	$s4, $s4, 1		#

	mul	$t0, $s1, SIZEOF_INT	#     if (worm_already_placed[random_terrain) {
	lw	$t0, worm_already_placed($t0)
					#
	beqz	$t0, setup_worms__not_already_placed
					#

	sub	$s0, $s0, 1		#         i--;
	b	setup_worms__place_step	#         continue;

setup_worms__not_already_placed:	#     }

	move	$a0, $s3		#     if (collides_with_terrain(x, y) != NO_TERRAIN) {
	move	$a1, $s4		#
	jal	collides_with_terrain	#
	beq	$v0, NO_TERRAIN, setup_worms__not_in_terrain	
					#

	sub	$s0, $s0, 1		#         i--;
	b	setup_worms__place_step	#         continue;

setup_worms__not_in_terrain:		#     }

	li	$t0, HEIGHT		#     if (y > HEIGHT / 2 ...
	div	$t0, $t0, 2		#
	ble	$s4, $t0, setup_worms__top_half_ok
					#     ... && worm_to_low < ALLOW_LOW_WORM_THRESHOLD) {
	bge	$s5, ALLOW_LOW_WORM_THRESHOLD, setup_worms__top_half_ok
					#

	sub	$s0, $s0, 1		#         i--;
	add	$s5, $s5, 1		#         worm_too_low++;
	b	setup_worms__place_step	#         continue;

setup_worms__top_half_ok:		#     }

	li	$t0, TRUE		#     worm_already_placed[random_terrain] = TRUE;
	mul	$t1, $s1, SIZEOF_INT	#
	sw	$t0, worm_already_placed($t1)
					#

	mul	$t1, $s0, SIZEOF_WORM	#     worms[i].pos.x = x;
	add	$t1, $t1, WORM_POS_OFFSET
					#     worms[i].pos.y = y;

	sw	$s3, worms + POINT_X_OFFSET($t1)
					#
	sw	$s4, worms + POINT_Y_OFFSET($t1)
					#

setup_worms__place_step:
	add	$s0, $s0, 1		#     i++;
	b	setup_worms__place_cond	#
setup_worms__place_end:			# }

setup_worms__epilogue:
	pop	$s5
	pop	$s4
	pop	$s3
	pop	$s2
	pop	$s1
	pop	$s0
	pop	$ra
	jr	$ra

################################################################################
# .TEXT <seed_random>
	.text
seed_random:
	# Subset:   PROVIDED
	#
	# Frame:	[]
	# Uses:		[]
	# Clobbers: 	[]
	#
	# Locals:
	#
	# Structure:
	#   seed_random
	#   -> [prologue]
	#	   -> body
	#   -> [epilogue]
seed_random__prologue:
seed_random__body:
	sw	$a0, random		# random = (unsigned int) seed;
seed_random__epilogue:
	jr	$ra

################################################################################
# .TEXT <random_in_range>
	.text
random_in_range:
	# Subset:   PROVIDED
	#
	# Frame:	[]
	# Uses:		[$t0, $t1, $t2]
	# Clobbers: 	[$t0, $t1, $t2]
	#
	# Locals:
	#   - $t0: int a
	#   - $t1: int m
	#
	# Structure:
	#   random_in_range
	#   -> [prologue]
	#	   -> body
	#   -> [epilogue]
random_in_range__prologue:
random_in_range__body:
	li	$t0, 16807		# int a = 16807;
	li	$t1, 2147483647		# int m = 2147483647;

	lw	$t2, random		# random = (a * random) % m;
	mul	$t2, $t2, $t0		#
	remu	$t2, $t2, $t1		#
	sw	$t2, random		#

	sub	$a1, $a1, $a0		# return min + random % (max - min + 1);
	add	$a1, $a1, 1		#
	remu	$t2, $t2, $a1		#
	add	$v0, $t2, $a0		#
random_in_range__epilogue:
	jr	$ra

################################################################################
# .TEXT <collides_with_terrain>
	.text
collides_with_terrain:
	# Subset:   PROVIDED
	#
	# Frame:	[]
	# Uses:		[$t0, $t1, $t2, $t3, $t4]
	# Clobbers: 	[$t0, $t1, $t2, $t3, $t4]
	#
	# Locals:
	#   - $t0: int i
	#   - $t2: int left, right, bottom, top
	#
	# Structure:
	#   collides_with_terrain
	#   -> [prologue]
	#	   -> body
	#          -> [impact]
	#            -> init
	#            -> cond
	#            -> body
	#              -> no_impact
	#            -> step
	#            -> end
	#          -> [check]
	#            -> init
	#            -> cond
	#            -> body
	#              -> not_here
	#            -> step
	#            -> end
	#   -> [epilogue]
collides_with_terrain__prologue:
collides_with_terrain__body:

collides_with_terrain__impact_init:
	li	$t0, 0			# i = 0;
collides_with_terrain__impact_cond:
	lw	$t1, nimpacts		# while (i < nimpacts) {
	bge	$t0, $t1, collides_with_terrain__impact_end
					#
collides_with_terrain__impact_body:
	mul	$t1, $t0, SIZEOF_POINT	#     if (x >= left ...
	lw	$t2, impacts + POINT_X_OFFSET($t1)#
	li	$t1, IMPACT_WIDTH	#
	div	$t1, $t1, 2		#
	sub	$t2, $t2, $t1		#
	blt	$a0, $t2, collides_with_terrain__no_impact
					#

	add	$t2, $t2, IMPACT_WIDTH - 1
					#     && x <= right ...
	bgt	$a0, $t2, collides_with_terrain__no_impact
					#

	mul	$t1, $t0, SIZEOF_POINT	#     && y >= top ...
	lw	$t2, impacts + POINT_Y_OFFSET($t1)#
	li	$t1, IMPACT_HEIGHT	#
	div	$t1, $t1, 2		#
	sub	$t2, $t2, $t1		#
	blt	$a1, $t2, collides_with_terrain__no_impact
					#

	add	$t2, $t2, IMPACT_HEIGHT - 1
					#     && y <= bottom) {
	bgt	$a1, $t2, collides_with_terrain__no_impact
					#
	li	$v0, NO_TERRAIN		#         return NO_TERRAIN;
	b	collides_with_terrain__epilogue
					#

collides_with_terrain__no_impact:	# }

collides_with_terrain__impact_step:
	add	$t0, $t0, 1
	b	collides_with_terrain__impact_cond
collides_with_terrain__impact_end:

collides_with_terrain__check_init:
	li	$t0, 0			# int i = 0;
collides_with_terrain__check_cond:
	lw	$t1, nterrains		# while (i < nterrains) {
	bge	$t0, $t1, collides_with_terrain__check_end
					#
collides_with_terrain__check_body:
	mul	$t1, $t0, SIZEOF_TERRAIN

	lw	$t3, terrains + TERRAIN_WIDTH_OFFSET($t1)
	lw	$t4, terrains + TERRAIN_HEIGHT_OFFSET($t1)

	add	$t1, $t1, TERRAIN_TOP_LEFT_OFFSET

	lw	$t2, terrains + POINT_X_OFFSET($t1)
					#     if (x >= left ...
	blt	$a0, $t2, collides_with_terrain__not_here
					#

	add	$t2, $t2, $t3		#     && x <= right ...
	sub	$t2, $t2, 1		#
	bgt	$a0, $t2, collides_with_terrain__not_here
					#

	lw	$t2, terrains + POINT_Y_OFFSET($t1)
					#     && y >= top ...
	blt	$a1, $t2, collides_with_terrain__not_here
					#

	add	$t2, $t2, $t4		#     && y <= bottom) {
	sub	$t2, $t2, 1		#
	bgt	$a1, $t2, collides_with_terrain__not_here
					#

	move	$v0, $t0		#         return i;
	b	collides_with_terrain__epilogue
					#
collides_with_terrain__not_here:	#     }

	add	$t0, $t0, 1		#     i++;
	b	collides_with_terrain__check_cond
					#
collides_with_terrain__check_end:	# }

	li	$v0, NO_TERRAIN		# return NO_TERRAIN;
collides_with_terrain__epilogue:
	jr	$ra

################################################################################
# .TEXT <render>
	.text
render:
	# Subset:   PROVIDED
	#
	# Frame:	[$ra, $a0]
	# Uses:		[]
	# Clobbers: 	[]
	#
	# Locals:
	#
	# Structure:
	#   render
	#   -> [prologue]
	#	   -> body
	#            -> no_aim_guide
	#   -> [epilogue]
render__prologue:
	push	$ra
	push	$a0			# don't mind this unconventional use of push/pop
render__body:
	jal	render_background	# render_background();
	jal	render_terrain		# render_terrain();
	jal	render_impacts		# render_impacts();

	pop	$a0			# if (show_aim_guide) {
	beqz	$a0, render__no_aim_guide
					#

	jal	render_aim_guide	#     render_aim_guide();

render__no_aim_guide:			# }

	jal	render_worms		# render_worms();
render__epilogue:
	pop	$ra
	jr	$ra

################################################################################
# .TEXT <render_terrain>
	.text
render_terrain:
	# Subset:   PROVIDED
	#
	# Frame:	[$ra, $s0, $s1]
	# Uses:		[$a0, $a1, $t0, $t1, $s0, $s1]
	# Clobbers: 	[$a0, $a1, $t0, $t1]
	#
	# Locals:
	#   - $s0: int x
	#   - $s1: int y
	#
	# Structure:
	#   render_terrain
	#   -> [prologue]
	#	   -> body
	#          -> [x]
	#           -> init
	#           -> cond
	#           -> body
	#             -> [y]
	#               -> init
	#               -> cond
	#               -> body
	#               -> step
	#               -> end
	#           -> step
	#           -> end
	#   -> [epilogue]
render_terrain__prologue:
	push	$ra
	push	$s0
	push	$s1
render_terrain__body:
render_terrain__x_init:
	li	$s0, 0			# int x = 0;
render_terrain__x_cond:
	bge	$s0, WIDTH, render_terrain__x_end
					# while (x < WIDTH) {
render_terrain__x_body:

render_terrain__y_init:
	li	$s1, 0			#     int y = 0;
render_terrain__y_cond:
	bge	$s1, HEIGHT, render_terrain__y_end
					#     while (y < HEIGHT) {
render_terrain__y_body:
	move	$a0, $s0		#         if (collides_with_terrain(x, y) != NO_TERRAIN) {
	move	$a1, $s1		#
	jal	collides_with_terrain	#
	beq	$v0, NO_TERRAIN, render_terrain__y_step
					#

	mul	$t0, $s1, WIDTH		#             screen[y][x] = TERRAIN_CHAR;
	add	$t0, $t0, $s0		#
	li	$t1, TERRAIN_CHAR	#
	sb	$t1, screen($t0)	#

render_terrain__y_step:			#         }
	add	$s1, $s1, 1		#         y++;
	b	render_terrain__y_cond	#
render_terrain__y_end:			#     }

render_terrain__x_step:
	add	$s0, $s0, 1		#     x++;
	b	render_terrain__x_cond	# }
render_terrain__x_end:

render_terrain__epilogue:
	pop	$s1
	pop	$s0
	pop	$ra
	jr	$ra

################################################################################
# .TEXT <offset_index_for_aim>
	.text
offset_index_for_aim:
	# Subset:   PROVIDED
	#
	# Frame:	[]
	# Uses:		[$a0, $t0, $t1]
	# Clobbers: 	[$a0, $t0, $t1]
	#
	# Locals:
	#   - $t0: int a, offset_index
	#   - $t1: int skipped
	#
	# Structure:
	#   offset_index_for_aim
	#   -> [prologue]
	#	   -> body
	#            -> no_reverse
	#   -> [epilogue]
offset_index_for_aim__prologue:
offset_index_for_aim__body:
	lw	$t0, active_worm	# int a = worms[active_worm].aim;
	mul	$t0, $t0, SIZEOF_WORM	#
	lw	$t0, worms + WORM_AIM_OFFSET($t0)

	li	$t1, NUM_AIM_OFFSETS - 1# int skipped = a / (NUM_AIM_OFFSETS - 1);
	div	$t1, $t0, $t1		#

	add	$t0, $t0, $t1		# int offset_index = (a + skipped) % NUM_AIM_OFFSETS;
	rem	$t0, $t0, NUM_AIM_OFFSETS
					#

	mul	$a0, $a0, SIZEOF_INT	# if (aim_dir_reversed_in_quadrant[offset_multiplier_index]) {
	lw	$a0, aim_dir_reversed_in_quadrant($a0)
					#
	beqz	$a0, offset_index_for_aim__no_reverse
					#

	li	$t1, NUM_AIM_OFFSETS - 1#     offset_index = NUM_AIM_OFFSETS - offset_index - 1;
	sub	$t0, $t1, $t0		#

offset_index_for_aim__no_reverse:	# }

	move	$v0, $t0		# return offset_index;

offset_index_for_aim__epilogue:
	jr	$ra

################################################################################
# .TEXT <render_aim_guide>
	.text
render_aim_guide:
	# Subset:   PROVIDED
	#
	# Frame:	[$ra]
	# Uses:		[$a0]
	# Clobbers: 	[$a0]
	#
	# Locals:
	#   - $a0: &aim_guide
	#
	# Structure:
	#   render_aim_guide
	#   -> [prologue]
	#	   -> body
	#   -> [epilogue]
render_aim_guide__prologue:
	push	$ra
render_aim_guide__body:
	la	$a0, aim_guide		# init_projectile(&aim_guide);
	jal	init_projectile		#

	la	$a0, aim_guide		# move_projectile(&aim_guide):
	jal	move_projectile		#

	la	$a0, aim_guide		# render_projectile(&aim_guide);
	jal	render_projectile	#

	la	$a0, aim_guide		# move_projectile(&aim_guide);
	jal	move_projectile		#

	la	$a0, aim_guide		# render_projectile(&aim_guide);
	jal	render_projectile	#
render_aim_guide__epilogue:
	pop	$ra
	jr	$ra

################################################################################
# .TEXT <print_worm_char>
	.text
print_worm_char:
	# Subset:   PROVIDED
	#
	# Frame:	[$ra, $s0, $s1, $s2]
	# Uses:		[$a0, $a1, $a2, $a3, $t0, $t1, $s0, $s1, $s2]
	# Clobbers: 	[$a0, $a1 ,$a2, $a3, $t0, $t1]
	#
	# Locals:
	#   - $s0: int x
	#   - $s1: int y
	#   - $s2: int i
	#
	# Structure:
	#   print_worm_char
	#   -> [prologue]
	#	   -> body
	#            -> [worm]
	#              -> init
	#              -> cond
	#              -> body
	#                -> print_red
	#                -> print_green
	#                -> print_blue
	#                -> print_yellow
	#                -> print_done
	#              -> step
	#              -> end
	#   -> [epilogue]
print_worm_char__prologue:
	push	$ra
	push	$s0
	push	$s1
	push	$s2
print_worm_char__body:
	move	$s0, $a0
	move	$s1, $a1

print_worm_char__worm_init:
	li	$s2, 0			# int i = 0;
print_worm_char__worm_cond:
	lw	$t0, nworms		# while (i < nworms) {
	bge	$s2, $t0, print_worm_char__worm_end
					#
print_worm_char__worm_body:
	mul	$t0, $s2, SIZEOF_WORM
	add	$t0, $t0, WORM_POS_OFFSET

	lw	$t1, worms + POINT_X_OFFSET($t0)
					#     if (worms[i].pos.x == x ...
	bne	$t1, $s0, print_worm_char__worm_step
					# 

	lw	$t1, worms + POINT_Y_OFFSET($t0)
					#     && worms[i].pos.y == y ...
	bne	$t1, $s1, print_worm_char__worm_step
					#

	sub	$t0, $t0, WORM_POS_OFFSET
					#     && worms[i].alive) {
	lw	$t1, worms + WORM_ALIVE_OFFSET($t0)
					#
	beqz	$t1, print_worm_char__worm_step
					#

	li	$a0, WORM_CHAR
	li	$a1, 0
	li	$a2, 0
	li	$a3, 0

	beq	$s2, RED, print_worm_char__print_red
	beq	$s2, GREEN, print_worm_char__print_green
	beq	$s2, BLUE, print_worm_char__print_blue
	beq	$s2, YELLOW, print_worm_char__print_yellow
	b	print_worm_char__print_done

print_worm_char__print_red:		#         if (i == RED) {
	li	$a1, 255		#             print_rgb(WORM_CHAR, 255, 0, 0);
	jal	print_rgb		#
	b	print_worm_char__print_done
					#
print_worm_char__print_green:		#         } else if (i == GREEN) {
	li	$a2, 255		#             print_rgb(WORM_CHAR, 0, 255, 0);
	jal	print_rgb		#
	b	print_worm_char__print_done
					#
print_worm_char__print_blue:		#         } else if (i == BLUE) {
	li	$a2, 255		#             print_rgb(WORM_CHAR, 0, 255, 255);
	li	$a3, 255		#
	jal	print_rgb		#
	b	print_worm_char__print_done
					#
print_worm_char__print_yellow:		#         } else if (i == YELLOW {
	li	$a1, 255		#             print_rgb(WORM_CHAR, 255, 255, 0);
	li	$a2, 255		#
	jal	print_rgb		#
print_worm_char__print_done:		#         }

print_worm_char__worm_step:		#     }
	add	$s2, $s2, 1		#     i++;
	b	print_worm_char__worm_cond
print_worm_char__worm_end:		# }

print_worm_char__epilogue:
	pop	$s2
	pop	$s1
	pop	$s0
	pop	$ra
	jr	$ra

################################################################################
# .TEXT <next_turn>
	.text
next_turn:
	# Subset:   PROVIDED
	#
	# Frame:	[]
	# Uses:		[$t0, $t1, $t2]
	# Clobbers: 	[$t0, $t1, $t2]
	#
	# Locals:
	#   - $t0: int old_worm
	#
	# Structure:
	#   next_turn
	#   -> [prologue]
	#	   -> body
	#            -> [worm]
	#              -> init
	#              -> cond
	#              -> body
	#              -> step
	#              -> end
	#   -> [epilogue]
next_turn__prologue:
next_turn__body:

	lw	$t0, active_worm	# int old_worm = active_worm;

	add	$t1, $t0, 1		# active_worm++;

	lw	$t2, nworms		# active_worm %= nworms;
	rem	$t1, $t1, $t2		#
	sw	$t1, active_worm	#

next_turn__worm_cond:			# while (!worms[active_worm].alive) {
	lw	$t1, active_worm	#
	mul	$t1, $t1, SIZEOF_WORM	#
	lw	$t1, worms + WORM_ALIVE_OFFSET($t1)
					#
	bnez	$t1, next_turn__worm_end#
next_turn__worm_body:
	lw	$t1, active_worm	#     active_worm++
	add	$t1, $t1, 1		#

	lw	$t2, nworms		#     active_worm %= nworms;
	rem	$t1, $t1, $t2		#
	sw	$t1, active_worm	#

	beq	$t0, $t1, next_turn__epilogue
					#     if (active_worm == old_worm) return;

next_turn__worm_step:
	b	next_turn__worm_cond	#
next_turn__worm_end:			# }

next_turn__epilogue:
	jr	$ra

################################################################################
# .TEXT <display>
	.text
display:
	# Subset:   PROVIDED
	#
	# Frame:	[$ra, $s0, $s1]
	# Uses:		[$a0, $v0, $t0, $s0, $s1]
	# Clobbers: 	[$a0, $v0, $t0]
	#
	# Locals:
	#   - $s0: int y
	#   - $s1: int x
	#
	# Structure:
	#   display
	#   -> [prologue]
	#	   -> body
	#            -> [y]
	#              -> init
	#              -> cond
	#              -> body
	#                -> [x]
	#                  -> init
	#                  -> cond
	#                  -> body
	#                    -> not_worm
	#                  -> step
	#                  -> end
	#              -> step
	#              -> end
	#   -> [epilogue]
display__prologue:
	push	$ra
	push	$s0
	push	$s1
display__body:
	la	$a0, ansii_clear	# fputs(ansii_clear, stdout);
	li	$v0, 4			#
	syscall				#

display__y_init:
	li	$s0, 0			# int y = 0;
display__y_cond:
	bge	$s0, HEIGHT, display__y_end
					# while (y < HEIGHT) {
display__y_body:

display__x_init:
	li	$s1, 0			#     int x = 0;
display__x_cond:
	bge	$s1, WIDTH, display__x_end
					#     while (x < WIDTH) {
display__x_body:
	mul	$t0, $s0, WIDTH		#         if (screen[y][x] == WORM_CHAR) {
	add	$t0, $t0, $s1		#
	lb	$t0, screen($t0)	#
	bne	$t0, WORM_CHAR, display__x_not_worm
					#

	move	$a0, $s1		#             print_worm_char(x, y);
	move	$a1, $s0		#
	jal	print_worm_char		#

	b	display__x_step
display__x_not_worm:			#         } else {
	move	$a0, $t0		#             putchar(screen[y][x]);
	li	$v0, 11			#
	syscall				#

display__x_step:			#         }
	add	$s1, $s1, 1		#         x++;
	b	display__x_cond
display__x_end:				#     }

	li	$a0, 10			#     putchar(10);
	li	$v0, 11			#
	syscall				#
display__y_step:
	add	$s0, $s0, 1		#     y++;
	b	display__y_cond		#
display__y_end:				# }

display__epilogue:
	pop	$s1
	pop	$s0
	pop	$ra
	jr	$ra

################################################################################
# .TEXT <let_worms_fall>
	.text
let_worms_fall:
	# Subset:   PROVIDED
	#
	# Frame:	[$ra, $s0, $s1, $s2, $s3, $s4]
	# Uses:		[$a0, $a1, $t0, $t1, $s0, $s1, $s2, $s3, $s4]
	# Clobbers: 	[$a0, $a1, $t0, $t1]
	#
	# Locals:
	#   - $s0: int fell
	#   - $s1: int has_looped
	#   - $s2: int worm
	#   - $s3: int x
	#   - $s4: int y
	#
	# Structure:
	#   let_worms_fall
	#   -> [prologue]
	#	   -> body
	#            -> [fell]
	#              -> loop
	#                -> no_wait
	#                -> [worms]
	#                  -> init
	#                  -> cond
	#                  -> body
	#                    -> no_wait2
	#                    -> no_fall
	#                    -> no_wait3
	#                    -> not_dead
	#                    -> dont_display
	#                  -> step
	#                  -> end
	#       -> [epilogue]
let_worms_fall__prologue:
	push	$ra
	push	$s0
	push	$s1
	push	$s2
	push	$s3
	push	$s4
let_worms_fall__body:

	li	$s0, FALSE		# int fell = FALSE;
	li	$s1, FALSE		# int has_looped = FALSE;

let_worms_fall__fell_loop:		# do {

	beqz	$s1, let_worms_fall__no_wait
					#     if (has_looped) {

	jal	wait_for_input		#         wait_for_input();

let_worms_fall__no_wait:		#     }

	li	$s0, FALSE		#     fell = FALSE;

let_worms_fall__worms_init:
	li	$s2, 0			#     int worm = 0;
let_worms_fall__worms_cond:
	lw	$t0, nworms		#     while (worm < nworms) {
	bge	$s2, $t0, let_worms_fall__worms_end
					#
let_worms_fall__worms_body:

	mul	$t0, $s2, SIZEOF_WORM	#         if (!worms[worm].alive) continue;
	lw	$t0, worms + WORM_ALIVE_OFFSET($t0)
					#
	beqz	$t0, let_worms_fall__worms_step
					#

	mul	$t0, $s2, SIZEOF_WORM	#         int x = worms[worm].pos.x;
	add	$t0, $t0, WORM_POS_OFFSET
					#
	lw	$s3, worms + POINT_X_OFFSET($t0)
					#

	lw	$s4, worms + POINT_Y_OFFSET($t0)
					#         int y = worms[worm].pos.y;

	move	$a0, $s3		#         if (collides_with_terrain(x, y + 1) == NO_TERRAIN ...
	add	$a1, $s4, 1		#
	jal	collides_with_terrain	#
	bne	$v0, NO_TERRAIN, let_worms_fall__no_fall
					#

	bge	$s4, HEIGHT - 1, let_worms_fall__no_fall
					#         && y < HEIGHT - 1) {

	bnez	$s1, let_worms_fall__no_wait2
					#             if (!has_looped)

	li	$s1, TRUE		#                 has_looped = TRUE;
	jal	wait_for_input		#                 wait_for_input();

let_worms_fall__no_wait2:		#             }

	mul	$t0, $s2, SIZEOF_WORM	#             worms[worm].pos.y++;
	add	$t0, WORM_POS_OFFSET	#
	lw	$t1, worms + POINT_Y_OFFSET($t0)
					#
	add	$t1, $t1 , 1		#
	sw	$t1, worms + POINT_Y_OFFSET($t0)
					#

	li	$s0, TRUE		#             fell = TRUE;

let_worms_fall__no_fall:		#         }

	bne	$s4, HEIGHT - 1, let_worms_fall__not_dead
					#         if (y == HEIGHT - 1) {

	mul	$t0, $s2, SIZEOF_WORM	#             worms[worm].alive = FALSE;
	sw	$zero, worms + WORM_ALIVE_OFFSET($t0)
					#

	lw	$t0, active_worm	#             if (worm == active_worm) {
	bne	$s2, $t0, let_worms_fall__no_wait3
					#

	jal	next_turn		#                 next_turn();

let_worms_fall__no_wait3:		#            }

let_worms_fall__not_dead:		#         }

	beqz	$s1, let_worms_fall__dont_display
					#         if (has_looped) {

	li	$a0, FALSE		#             render(FALSE);
	jal	render			#

	jal	display			#             display();

let_worms_fall__dont_display:		#         }

let_worms_fall__worms_step:
	add	$s2, $s2, 1		#         worm++;
	b	let_worms_fall__worms_cond
let_worms_fall__worms_end:		#     }

	li	$s1, TRUE		#     has_looped = TRUE;
	bnez	$s0, let_worms_fall__fell_loop
					# } while (fell);

	li	$a0, TRUE		# render(TRUE);
	jal	render			#

	jal	display			# display();

let_worms_fall__epilogue:
	pop	$s4
	pop	$s3
	pop	$s2
	pop	$s1
	pop	$s0
	pop	$ra
	jr	$ra

################################################################################
# .TEXT <init_projectile>
	.text
init_projectile:
	# Subset:   PROVIDED
	#
	# Frame:	[$ra, $s0, $s1]
	# Uses:		[$a0, $t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7, $t8, $t9, $s0, $s1]
	# Clobbers: 	[$a0, $t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7, $t8, $t9]
	#
	# Locals:
	#   - $s0: struct projectile *p
	#   - $s1: int offset_multiplier_index
	#   - $t0: int offset_index
	#   - $t1: int wx
	#   - $t2: int wy
	#   - $t3: int omx
	#   - $t4: int omy
	#   - $t5: int ox
	#   - $t6: int oy
	#
	# Structure:
	#   init_projectile
	#   -> [prologue]
	#	   -> body
	#   -> [epilogue]
init_projectile__prologue:
	push	$ra
	push	$s0
	push	$s1
init_projectile__body:
	move	$s0, $a0		# int offset_multiplier_index = offset_multiplier_index_for_aim();
	jal	offset_multiplier_index_for_aim
					#
	move	$s1, $v0		#

	move	$a0, $s1		# int offset_index = offset_index_for_aim(offset_multiplier_index);
	jal	offset_index_for_aim	#
	move	$t0, $v0		#

	lw	$t9, active_worm	#
	mul	$t9, $t9, SIZEOF_WORM	#
	add	$t9, $t9, WORM_POS_OFFSET
					#

	lw	$t1, worms + POINT_X_OFFSET($t9)
					# int wx = worms[active_worm].pos.x;
	lw	$t2, worms + POINT_Y_OFFSET($t9)
					# int wy = worms[active_worm].pos.y;

	mul	$t9, $s1, 2		# int omx = aim_offset_multipliers[offset_multiplier_index][X_INDEX];
	add	$t9, $t9, X_INDEX	#
	mul	$t9, $t9, SIZEOF_INT	#
	lw	$t3, aim_offset_multipliers($t9)
					#

	mul	$t9, $s1, 2		# int omy = aim_offset_multipliers[offset_multiplier_index][Y_INDEX];
	add	$t9, $t9, Y_INDEX	#
	mul	$t9, $t9, SIZEOF_INT	#
	lw	$t4, aim_offset_multipliers($t9)
					#

	mul	$t9, $t0, SIZEOF_POINT	# int ox = aim_offsets[offset_index].x;
	lw	$t5, aim_offsets + POINT_X_OFFSET($t9)
					#
	lw	$t6, aim_offsets + POINT_Y_OFFSET($t9)
					# int oy = aim_offsets[offset_index].y;

	add	$t9, $s0, PROJECTILE_ORIGIN_OFFSET
					# p->origin.x = wx;
	sw	$t1, POINT_X_OFFSET($t9)#
	sw	$t2, POINT_Y_OFFSET($t9)# p->origin.y = wy;

	add	$t9, $s0, PROJECTILE_POS_OFFSET
					# p->pos = p->origin;
	sw	$t1, POINT_X_OFFSET($t9)#
	sw	$t2, POINT_Y_OFFSET($t9)#

	mul	$t9, $t1, X_TO_UNITS	# p->pos_unit_x = wx * X_TO_UNITS;
	sw	$t9, PROJECTILE_POS_UNIT_X_OFFSET($s0)
					#

	mul	$t9, $t2, Y_TO_UNITS	# p->pos_unit_y = wy * Y_TO_UNITS;
	sw	$t9, PROJECTILE_POS_UNIT_Y_OFFSET($s0)
					#

	sw	$zero, PROJECTILE_TRAIL_LENGTH_OFFSET($s0)
					# p->trail_length = 0;

	mul	$t9, $t3, $t5		# p->dx = ((ox * omx) * X_TO_UNITS) / (MAX_STRENGTH + 2 - strength[active_worm]);
	mul	$t9, $t9, X_TO_UNITS	#
	lw	$t8, active_worm	#
	mul	$t8, $t8, SIZEOF_INT	#
	lw	$t8, strength($t8)	#
	li	$t7, MAX_STRENGTH + 2	#
	sub	$t8, $t7, $t8		#
	div	$t9, $t9, $t8		#
	sw	$t9, PROJECTILE_DX_OFFSET($s0)
					#

	mul	$t9, $t4, $t6		# p->dy = ((oy * omy) * Y_TO_UNITS) / (MAX_STRENGTH + 2 - strength[active_worm]);
	mul	$t9, $t9, Y_TO_UNITS	#
	lw	$t8, active_worm	#
	mul	$t8, $t8, SIZEOF_INT	#
	lw	$t8, strength($t8)	#
	li	$t7, MAX_STRENGTH + 2	#
	sub	$t8, $t7, $t8		#
	div	$t9, $t9, $t8		#
	sw	$t9, PROJECTILE_DY_OFFSET($s0)
					#

init_projectile__epilogue:
	pop	$s1
	pop	$s0
	pop	$ra
	jr	$ra


################################################################################
# .TEXT <render_impacts>
	.text
render_impacts:
	# Subset:   PROVIDED
	#
	# Frame:	[$ra, $s0, $s1, $s2, $s3, $s4]
	# Uses:		[$a0, $a1, $t0, $t1, $s0, $s1, $s2, $s3, $s4]
	# Clobbers: 	[$a0, $a1, $t0, $t1]
	#
	# Locals:
	#   - $s0: int i
	#   - $s3: int left
	#   - $s4: int top
	#   - $s1: int y_off
	#   - $s2: int x_off
	#
	# Structure:
	#   render_impacts
	#   -> [prologue]
	#	   -> body
	#            -> [impacts]
	#              -> init
	#              -> cond
	#              -> body
	#                -> [y_off]
	#                  -> init
	#                  -> cond
	#                  -> body
	#                    -> [x_off]
	#                      -> init
	#                      -> cond
	#                      -> body
	#                      -> step
	#    		   -> end
	#                  -> step
	#                  -> end
	#              -> step
	#              -> end
	#   -> [epilogue]
render_impacts__prologue:
	push	$ra
	push	$s0
	push	$s1
	push	$s2
	push	$s3
	push	$s4
render_impacts__body:

render_impacts__impacts_init:
	li	$s0, 0			# int i = 0;
render_impacts__impacts_cond:
	lw	$t0, nimpacts		# while (i < nimpacts) {
	bge	$s0, $t0, render_impacts__impacts_end
					#
render_impacts__impacts_body:

	mul	$t0, $s0, SIZEOF_POINT	#     int left = impacts[i].x - (IMPACT_WDITH / 2);
	lw	$s3, impacts + POINT_X_OFFSET($t0)
					#
	li	$t1, IMPACT_WIDTH	#
	div	$t1, $t1, 2		#
	sub	$s3, $s3, $t1		#
	
	lw	$s4, impacts + POINT_Y_OFFSET($t0)
					#     int top = impacts[i].y - (IMPACT_HEIGHT / 2);
	li	$t1, IMPACT_HEIGHT	#
	div	$t1, $t1, 2		#
	sub	$s4, $s4, $t1		#

render_impacts__y_off_init:
	li	$s1, 0			#     int y_off = 0;
render_impacts__y_off_cond:
	bge	$s1, IMPACT_HEIGHT, render_impacts__y_off_end
					#     while (y_off < IMPACT_HEIGHT) {
render_impacts__y_off_body:

render_impacts__x_off_init:
	li	$s2, 0			#         int x_off = 0;
render_impacts__x_off_cond:
	bge	$s2, IMPACT_WIDTH, render_impacts__x_off_end
					#         while (x_off < IMPACT_WIDTH) {
render_impacts__x_off_body:

	add	$a0, $s2, $s3		#             if (in_bounds(left + x_off, top + y_off)) {
	add	$a1, $s1, $s4		#
	jal	in_bounds		#
	beqz	$v0, render_impacts__x_off_step
					#

	li	$t0, BACKGROUND_CHAR	#                 screen[top + y_off][left + x_off] = BACKGROUND_CHAR;
	add	$t1, $s4, $s1		#
	mul	$t1, $t1, WIDTH		#
	add	$t1, $t1, $s2		#
	add	$t1, $t1, $s3		#
	sb	$t0, screen($t1)	#

render_impacts__x_off_step:		#             }
	add	$s2, $s2, 1		#             i++;
	b	render_impacts__x_off_cond	
render_impacts__x_off_end:		#         }


render_impacts__y_off_step:
	add	$s1, $s1, 1		#         i++;
	b	render_impacts__y_off_end
render_impacts__y_off_end:		#     }

render_impacts__impacts_step:
	add	$s0, $s0, 1		#     i++;
	b	render_impacts__impacts_cond
render_impacts__impacts_end:		# }

render_impacts__epilogue:
	pop	$s4
	pop	$s3
	pop	$s2
	pop	$s1
	pop	$s0
	pop	$ra
	jr	$ra

################################################################################
# .TEXT <change_strength>
	.text
change_strength:
	# Subset:   PROVIDED
	#
	# Frame:	[$ra]
	# Uses:		[$a0, $t0, $t1]
	# Clobbers: 	[$a0, $t0, $t1]
	#
	# Locals:
	#
	# Structure:
	#   change_strength
	#   -> [prologue]
	#	   -> body
	#            -> not_too_low
	#            -> not_too_high
	#   -> [epilogue]
change_strength__prologue:
	push	$ra
change_strength__body:
	lw	$t0, active_worm	# strength[active_worm] += by;
	mul	$t0, $t0, SIZEOF_INT	#
	lw	$t1, strength($t0)	#
	add	$t1, $t1, $a0		#

	bgez	$t1, change_strength__not_too_low
					# if (strength[active_worm] < 0) {

	li	$t1, 0			#     strength[active_worm] = 0;

change_strength__not_too_low:		# }

	ble	$t1, MAX_STRENGTH, change_strength__not_too_high
					# if (strength[active_worm] > MAX_STRENGTH) {

	li	$t1, MAX_STRENGTH	#     strength[active_worm] = MAX_STRENGTH;

change_strength__not_too_high:		# }

	sw	$t1, strength($t0)	# ... update in memory

	li	$a0, TRUE		# render(TRUE);
	jal	render			#
	jal	display			# display();

change_strength__epilogue:
	pop	$ra
	jr	$ra

################################################################################
# .TEXT <do_something>
	.text
do_something:
	# Subset:   PROVIDED
	#
	# Frame:	[$ra]
	# Uses:		[$a0, $v0, $t0]
	# Clobbers: 	[$a0, $v0, $t0]
	#
	# Locals:
	#   - $t0: int ch
	#
	# Structure:
	#   do_something
	#   -> [prologue]
	#	   -> body
	#            -> move_left
	#            -> move_right
	#            -> aim_clockwise
	#            -> aim_anticlockwise
	#            -> fire
	#            -> strength_up
	#            -> strength_down
	#            -> surrender
	#            -> bad_input
	#            -> done
	#   -> [epilogue]
do_something__prologue:
	push	$ra
do_something__body:
	jal	player_input		# int ch = player_input();
	move	$t0, $v0		#

	beq	$t0, INPUT_MOVE_LEFT, do_something__move_left
	beq	$t0, INPUT_MOVE_RIGHT, do_something__move_right
	beq	$t0, INPUT_AIM_CLOCKWISE, do_something__aim_clockwise
	beq	$t0, INPUT_AIM_ANTICLOCKWISE, do_something__aim_anticlockwise
	beq	$t0, INPUT_FIRE, do_something__fire
	beq	$t0, INPUT_STRENGTH_UP, do_something__strength_up
	beq	$t0, INPUT_STRENGTH_DOWN, do_something__strength_down
	beq	$t0, INPUT_SURRENDER, do_something__surrender
	b	do_something__bad_input

do_something__move_left:		# if (ch == INPUT_MOVE_LEFT) {
	li	$a0, LEFT		#     move(LEFT);
	jal	move			#
	b	do_something__done
do_something__move_right:		# } else if (ch == INPUT_MOVE_RIGHT) {	
	li	$a0, RIGHT		#     move(RIGHT);
	jal	move			#
	b	do_something__done
do_something__aim_clockwise:		# } else if (ch == INPUT_AIM_CLOCKWISE) {
	li	$a0, CLOCKWISE		#     aim(CLOCKWISE);
	jal	aim			#
	b	do_something__done
do_something__aim_anticlockwise:	# } else if (ch == INPUT_AIM_ANTICLOCKWISE) {
	li	$a0, ANTICLOCKWISE	#     aim(ANTICLOCKWISE);
	jal	aim			#
	b	do_something__done
do_something__fire:			# } else if (ch == INPUT_FIRE) {
	jal	fire			#     fire();
	b	do_something__done
do_something__strength_up:		# } else if (ch == INPUT_STRENGTH_UP) {
	li	$a0, 1			#     change_strength(1);
	jal	change_strength		#
	b	do_something__done
do_something__strength_down:		# } else if (ch == INPUT_STRENGTH_DOWN) {
	li	$a0, -1			#     change_strength(-1);
	jal	change_strength		#
	b	do_something__done
do_something__surrender:		# } else if (ch == INPUT_SURRENDER);
	jal	surrender		#     surrender();
	b	do_something__done
do_something__bad_input:		# } else {
	la	$a0, do_something_str_1	#     printf("invalid input '%c'\n", ch);
	li	$v0, 4			#
	syscall				#
	move	$a0, $t0		#
	li	$v0, 11			#
	syscall				#
	la	$a0, do_something_str_2	#
	li	$v0, 4			#
	syscall				#

do_something__done:			# }

do_something__epilogue:
	pop	$ra
	jr	$ra

################################################################################
# .TEXT <player_input>
	.text
player_input:
	# Subset:   PROVIDED
	#
	# Frame:	[]
	# Uses:		[$a0, $v0]
	# Clobbers: 	[$a0, $v0]
	#
	# Locals:
	#   - $v0: int ch
	#
	# Structure:
	#   player_input
	#   -> [prologue]
	#	   -> body
	#            -> newline
	#   -> [epilogue]
player_input__prologue:
player_input__body:
	la	$a0, player_input_str_1	# printf("firing_strength: %d/%d\n", strength[active_worm], MAX_STRENGTH);
	li	$v0, 4			#
	syscall				#
	lw	$t0, active_worm	#
	mul	$t0, $t0, SIZEOF_INT	#
	lw	$a0, strength($t0)	#
	li	$v0, 1			#
	syscall				#
	li	$a0, '/'		#
	li	$v0, 11			#
	syscall				#
	li	$a0, MAX_STRENGTH	#
	li	$v0, 1			#
	syscall				#
	li	$a0, '\n'		#
	li	$v0, 11			#
	syscall				#

	la	$a0, player_input_str_2	# printf("> ");
	li	$v0, 4			#
	syscall				#

player_input__newline:			# while ((ch = getchar()) == '\n');
	li	$v0, 12			#
	syscall				#
	beq	$v0, '\n', player_input__newline
					#

					# ... ch is in $v0
player_input__epilogue:
	jr	$ra

################################################################################
# .TEXT <wait_for_input>
	.text
wait_for_input:
	# Subset:   PROVIDED
	#
	# Frame:	[]
	# Uses:		[$a0, $v0]
	# Clobbers: 	[$a0, $v0]
	#
	# Locals:
	#   - $v0: int ch
	#
	# Structure:
	#   wait_for_input
	#   -> [prologue]
	#	   -> body
	#            -> newline
	#   -> [epilogue]
wait_for_input__prologue:
wait_for_input__body:
	la	$a0, wait_for_input_str_1
					# printf("... ");
	li	$v0, 4			#
	syscall				#

wait_for_input__newline:		# while ((ch = getchar()) == '\n');
	li	$v0, 12			#
	syscall				#
	beq	$v0, '\n', wait_for_input__newline
					#

wait_for_input__epilogue:
	jr	$ra
