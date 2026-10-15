#include <stdio.h>

#define MIN_WORMS 2
#define MAX_WORMS 4

#define RED 0
#define GREEN 1
#define BLUE 2
#define YELLOW 3

#define MIN_TERRAINS 4
#define MAX_TERRAINS 8

#define WIDTH 60
#define HEIGHT 20

#define SUCCESS 0
#define ERROR -1

#define INPUT_AIM_CLOCKWISE 'e'
#define INPUT_AIM_ANTICLOCKWISE 'q'
#define INPUT_FIRE 'f'
#define INPUT_MOVE_LEFT 'a'
#define INPUT_MOVE_RIGHT 'd'
#define INPUT_SURRENDER 's'

#define INPUT_STRENGTH_UP ']'
#define INPUT_STRENGTH_DOWN '['

#define LEFT 1
#define RIGHT 2

#define CLOCKWISE 1
#define ANTICLOCKWISE 2

#define NO_TERRAIN -1

#define MIN_TERRAIN_HEIGHT 2
#define MAX_TERRAIN_HEIGHT 4

#define MIN_TERRAIN_WIDTH 5
#define MAX_TERRAIN_WIDTH 10

#define TRUE 1
#define FALSE 0

#define COLLIDED 1
#define DID_NOT_COLLIDE 0

#define BACKGROUND_CHAR ' '
#define TERRAIN_CHAR '#'
#define WORM_CHAR 'I'
#define PROJECTILE_CHAR 'X'
#define PROJECTILE_ABOVE_CHAR '^'
#define TRAIL_CHAR '.'

#define ALLOW_LOW_WORM_THRESHOLD 16

#define NUM_AIM_OFFSETS 7
#define NUM_AIM_OFFSET_MULTIPLIERS 4

/* 0-indexed (-1), naive multiplication double counts [+-4, 0] and [0, +- 4] (-4) */
#define MAX_AIM_VALUE (NUM_AIM_OFFSETS * NUM_AIM_OFFSET_MULTIPLIERS) - 4 - 1

#define X_INDEX 0
#define Y_INDEX 1

#define TRAIL_LENGTH 4

/* vertical acceleration, in units
 * positive because vertical indicies are not
 * in the intuitive order (0 is at the top)
 */
#define GRAVITY 67
/* units per pixel/char */
#define X_TO_UNITS 2000
#define Y_TO_UNITS 4000

/* for better collision checking */
#define PHYSICS_SCALING 10

/* multiplier of initial rise/run from worm to aiminig reticle position
 * calculated as (dx / MAX_STRENGTH - strength + 2)
 * ie. initial velocity ranges from dx / 7 to dx / 2
 */
#define MAX_STRENGTH 5
#define DEFAULT_STRENGTH 1

/* pixel movements before rending new projectile position */
#define MOVE_RENDER_THRESHOLD TRAIL_LENGTH / 2

#define MAX_IMPACTS 64
#define IMPACT_POINTS 4
#define IMPACT_WIDTH 5
#define IMPACT_HEIGHT 3

struct point {
    int x; /* 0 -> WIDTH - 1 */
    int y; /*     0 
            *     |  
            *     v
            * HEIGHT - 1
            */
};

struct terrain {
    struct point top_left;
    int width;
    int height;
};

struct worm {
    struct point pos; 
    /*
     * aim=0 represents aiming directly upwards
     * adding one to aim moves the aim direction clockwise around the "aiming reticle",
     * which has 24 total aiming directions (so aim ranges 0-23)
     */      
    int aim;
    int alive;
};

struct projectile {
    struct point pos;

    /* more precise coordinates for better animation (1 char/pixel => 2000x4000 units)*/
    int pos_unit_x;
    int pos_unit_y;

    struct point origin;
    struct point trail[TRAIL_LENGTH];
    int trail_length;

    /* both in units, not char/pixels */
    int dx;
    int dy;
};

struct projectile projectile;
struct projectile aim_guide;

struct worm worms[MAX_WORMS];
int nworms;

struct terrain terrains[MAX_TERRAINS];
int nterrains;

struct point impacts[MAX_IMPACTS];
int nimpacts;

int active_worm;

unsigned int random;

char screen[HEIGHT][WIDTH];

int worm_already_placed[MAX_TERRAINS];

/* fire strength for each worm */
int strength[MAX_WORMS];

/* clear terminal: print each time displaying a new screen */
char *ansii_clear = "\x1b[3J\x1b[H\x1b[2J";

/* for aiming positions */
struct point aim_offsets[NUM_AIM_OFFSETS] = {{0, 2}, {1, 2}, {2, 2}, {2, 1}, {3, 1}, {4, 1}, {4, 0}};
int aim_offset_multipliers[NUM_AIM_OFFSET_MULTIPLIERS][2] = {{1, -1}, {1, 1}, {-1, 1}, {-1, -1}};
int aim_dir_reversed_in_quadrant[NUM_AIM_OFFSET_MULTIPLIERS] = {FALSE, TRUE, FALSE, TRUE};

/* for end screen message */
char *msg_for_worm[MAX_WORMS] = {"RED wins!   ", "GREEN wins! ", "BLUE wins!  ", "YELLOW wins!"};

extern void *memcpy(void *dst, const void *src, unsigned long len);
extern void exit(int status);

int setup(void);
void setup_worms(void);
void setup_terrains(void);
int get_input(char *prompt);

int overlaps_with_terrain(int x, int y, int width, int height);

void play(void);
int game_over(void);

void wait_for_input(void);

void do_something(void);
void next_turn(void);
void surrender(void);

int player_input(void);

void move(int direction);

int offset_multiplier_index_for_aim(void);
int offset_index_for_aim(int offset_multiplier_index);

void aim(int direction);

void fire();
void init_projectile(struct projectile *p);
int move_projectile(struct projectile *p);

void let_worms_fall(void);
int worm_is_on_terrain(int worm);

int value_in_range(int value, int range_1, int range_2);
int collides_with_terrain(int x, int y);

void render(int show_aim_guide);
void render_background(void);
void render_terrain(void);
void render_worms(void);
void render_aim_guide(void);
void render_aiming(int worm);
void render_hud(int worm);
void render_projectile(struct projectile *p);
void render_impacts(void);
void render_end_screen(void);
void display(void);

int in_bounds(int x, int y);

void seed_random(int seed);
unsigned int random_in_range(int min, int max);

//////////////
// SUBSET 0 //
//////////////

int main(void) {
    if (setup() == ERROR) {
        return 1;
    }

    play();

    return 0;
}

int in_bounds(int x, int y) {
    if (x >= 0 && x < WIDTH && y >= 0 && y < HEIGHT) {
        return TRUE;
    }

    return FALSE;
}

int get_input(char *prompt) {
    int input;
    printf("%s", prompt);
    scanf("%d", &input);
    return input;
}

void play(void) {
    while (!game_over()) {
        do_something();
    }

    render_end_screen();
    display();
    return;
}

//////////////
// SUBSET 1 //
//////////////


void render_background(void) {
    for (int x = 0; x < WIDTH; x++) {
        for (int y = 0; y < HEIGHT; y++) {
            screen[y][x] = BACKGROUND_CHAR;
        }
    }

    return;
}

int game_over(void) {
    int alive_worms = 0;
    for (int i = 0; i < nworms; i++) {
        if (worms[i].alive) {
            alive_worms++;
        }
    }

    if (alive_worms <= 1) {
        return TRUE;
    }

    return FALSE;
}

void aim(int direction) {
    if (direction == CLOCKWISE) {
        worms[active_worm].aim++;
    } else {
        worms[active_worm].aim--;
    }

    if (worms[active_worm].aim > MAX_AIM_VALUE) {
        worms[active_worm].aim = 0;
    } else if (worms[active_worm].aim < 0) {
        worms[active_worm].aim = MAX_AIM_VALUE;
    }

    render(TRUE);
    display();
}

void render_worms(void) {
    for (int i = 0; i < nworms; i++) {
        if (worms[i].alive) {
            screen[worms[i].pos.y][worms[i].pos.x] = WORM_CHAR;
        }
    }

    return;
}


//////////////
// SUBSET 2 //
//////////////


int overlaps_with_terrain(int x, int y, int width, int height) {
    /* inefficient brute force check */
    for (int check_x = x; check_x - x < width; check_x++) {
        for (int check_y = y; check_y - y < height; check_y++) {
            if (collides_with_terrain(check_x, check_y) != NO_TERRAIN) {
                return TRUE;
            }
        }
    }

    return FALSE;
}

void move(int direction) {
    int dx = direction == LEFT ? -1 : 1;
    int new_x = worms[active_worm].pos.x + dx;
    if (new_x < 0 || new_x >= WIDTH) {
        return;
    }

    if (collides_with_terrain(new_x, worms[active_worm].pos.y) != NO_TERRAIN) {
        if (worms[active_worm].pos.y > 0 && collides_with_terrain(new_x, worms[active_worm].pos.y - 1) == NO_TERRAIN) {
            worms[active_worm].pos.y--;
        } else {
            return;
        }
    }

    worms[active_worm].pos.x = new_x;

    let_worms_fall();

    render(TRUE);
    display();
    return;
}


void render_projectile(struct projectile *p) {
    /* projectile is permitted to be above map (y < 0), but otherwise is guaranteed in bounds */
    if (p->pos.y >= 0) {
        screen[p->pos.y][p->pos.x] = p == &aim_guide ? TRAIL_CHAR : PROJECTILE_CHAR;
    } else {
        /* if above, render a different char to make this obvious to player */
        if (p != &aim_guide) {
            screen[0][p->pos.x] = PROJECTILE_ABOVE_CHAR;
        }
    }

    /* render trail */
    for (int i = 0; i < p->trail_length; i++) {
        if (!in_bounds(p->trail[i].x, p->trail[i].y)) {
            continue;
        }

        screen[p->trail[i].y][p->trail[i].x] = TRAIL_CHAR;
    }
}

//////////////
// SUBSET 3 //
//////////////


void fire(void) {
    init_projectile(&projectile);

   do {
        render(FALSE);
        render_projectile(&projectile);
        display();
        wait_for_input();
    } while (move_projectile(&projectile) != COLLIDED);

    if (nimpacts == MAX_IMPACTS) {
        printf("error: out of memory\n");
        exit(1);
    }

    impacts[nimpacts++] = projectile.pos;

    /* show collision */
    render(FALSE);
    display();
    int turn = active_worm;
    let_worms_fall();

    /* if we didn't lose, we need to move turn forwards */
    if (turn == active_worm) {
        next_turn();
    }

    /* show next player aim guide */
    render(TRUE);
    display();
}

void render_end_screen(void) {
    render_background();

    int winner;
    for (winner = 0; winner < nworms; winner++) {
        if (worms[winner].alive) {
            break;
        }
    }

    /* see `man 3 memcpy` to understand what the code below does. you'll need to write some equivalent MIPS code 
     * which does NOT call any functions, but instead performs exactly the memory copy that memcpy() performs
     * in this C implementation
     */
    memcpy(&screen[HEIGHT / 2][WIDTH / 2 - 5], "Game Over!", 10);
    memcpy(&screen[HEIGHT / 2 + 2][WIDTH / 2 - 5], winner == nworms ? "NOONE wins! " : msg_for_worm[winner], 12);
}

void print_rgb(char c, int r, int g, int b) {
    /* 
     * r, g, b must be formatted and printed as 3-digit decimal numbers 
     * (0-padded on the left)
     *
     * adding new helper functions to the MIPS code is permitted for the implementation of this
     * function only
     */
    printf("\x1b[38;2;%03d;%03d;%03dm%c\x1b[0m", r, g, b, c);
}

//////////////
// PROVIDED //
//////////////

int offset_multiplier_index_for_aim(void) {
    int a = worms[active_worm].aim;

    /* each "quadrant" double counts the last coordinate (since the following quadrant will also begin with it)*/
    int skipped = a / (NUM_AIM_OFFSETS - 1);

    /* which quadrant does this aim lie in? */
    return (a + skipped) / NUM_AIM_OFFSETS;
}

void surrender(void) {
    worms[active_worm].alive = FALSE;
    next_turn();
    render(TRUE);
    display();
}

/* tuned so projectile typically moves sub-pixel (ie does not move char, but unit coordinates update)
 * this allows us to guarantee a smooth trail
 * so the player does not need to press enter too much, we only render
 * after moving a set number of actual pixels (chars)
 */
int move_projectile(struct projectile *p) {
    int moved = 0;

    while (moved < MOVE_RENDER_THRESHOLD) {
        int old_x = p->pos.x;
        int old_y = p->pos.y;

        /* do physics */
        p->pos_unit_x += (p->dx / PHYSICS_SCALING);
        p->pos_unit_y += (p->dy / PHYSICS_SCALING);
        p->dy += (GRAVITY / PHYSICS_SCALING);


        int new_x = p->pos_unit_x / X_TO_UNITS;
        int new_y = p->pos_unit_y / Y_TO_UNITS;


        /* collide if hits side of map */
        if (new_x < 0 || new_x >= WIDTH) {
            return COLLIDED;
        }

        /* colllide if hits bottom of map (but not top) */
        if (new_y >= HEIGHT) {
            return COLLIDED;
        }

        /* if it moved */
        if (new_x != old_x || new_y != old_y) {
            moved++;

            /* update projectile */
            p->pos.x = new_x;
            p->pos.y = new_y;

            /* update trail */
            if (p->trail_length < TRAIL_LENGTH) {
                p->trail_length++;
            }

            for (int i = p->trail_length - 2; i >= 0; i--) {
                p->trail[i + 1] = p->trail[i];
            }

            /* trail is at old projectile position */
            p->trail[0].x = old_x;
            p->trail[0].y = old_y;
        }

        /* collide, but after we moved it so player can see what it hit 
         * (for the case we hit terrain or another worm) 
         */
        if (in_bounds(new_x, new_y) 
            && (collides_with_terrain(new_x, new_y) != NO_TERRAIN 
                || screen[new_y][new_x] == WORM_CHAR)) {
            return COLLIDED;
        }
    }

    return DID_NOT_COLLIDE;
}

int setup(void) {
    int input;
    printf("Welcome to worms\n");

    input = get_input("Enter a random seed: ");
    seed_random(input);

    input = get_input("How many worms (players)? ");

    if (input < MIN_WORMS || input > MAX_WORMS) {
        printf("error: bad number of worms\n");
        return ERROR;
    }

    nworms = input;

    input = get_input("How many terrain blocks? ");

    if (input < MIN_TERRAINS || input > MAX_TERRAINS) {
        printf("error: bad number of terrains\n");
        return ERROR;
    }

    nterrains = input;
    nimpacts = 0;
    active_worm = 0;

    setup_terrains();
    setup_worms();


    for (int i = 0; i < nworms; i++) {
        strength[i] = DEFAULT_STRENGTH;
    }

    render(TRUE);
    display();

    return SUCCESS;
}



void setup_terrains(void) {
    /* invalidate terrains not yet set up */
    for (int i = 0; i < nterrains; i++) {
        terrains[i].width = 0;
        terrains[i].height = 0;
        terrains[i].top_left.x = 0;
        terrains[i].top_left.y = 0;
    }

    for (int i = 0; i < nterrains; i++) {
        /* choose any point not overlapping */
        int random_x = random_in_range(0, WIDTH - 1);
        int random_y = random_in_range(1, HEIGHT - 1);
        
        while (collides_with_terrain(random_x, random_y) != NO_TERRAIN) {
            random_x = random_in_range(0, WIDTH - 1);
            random_y = random_in_range(1, HEIGHT - 1);
        }

        /* the chosen point is the top left of our rectangle */
        int terrain_width = random_in_range(MIN_TERRAIN_WIDTH, MAX_TERRAIN_WIDTH);
        int terrain_height = random_in_range(MIN_TERRAIN_HEIGHT, MAX_TERRAIN_HEIGHT);

        /* the entire rectangle must not overlap with any existing terrain */
        if (overlaps_with_terrain(random_x, random_y, terrain_width, terrain_height)) {
            /* try again */
            i--;
            continue;
        }

        int left = random_x;
        int right = random_x + terrain_width - 1;
        int top = random_y;
        int bottom = random_y + terrain_height - 1;

        /* it's gotta all be in the map as well */
        if (right >= WIDTH) {
            i--;
            continue;
        }

        if (bottom >= HEIGHT) {
            i--;
            continue;
        }

        terrains[i].top_left.y = top;
        terrains[i].top_left.x = left;
        terrains[i].width = terrain_width;
        terrains[i].height = terrain_height;
    }
}

void setup_worms(void) {
    for (int i = 0; i < nterrains; i++) {
        worm_already_placed[i] = FALSE;
    }

    int worm_too_low = 0;

    for (int i = 0; i < nworms; i++) {
        worms[i].aim = 0;
        worms[i].alive = TRUE;

        int random_terrain = random_in_range(0, nterrains - 1);
        struct terrain *t = &terrains[random_terrain];

        /* try place worm approximately in centre of terrain */
        int x = t->top_left.x + t->width / 2;
        int y = t->top_left.y - 1;

        /* can't place them on the same terrain */
        if (worm_already_placed[random_terrain]) {
            i--;
            continue;
        }

        /* can't place worms inside terrain */
        if (collides_with_terrain(x, y) != NO_TERRAIN) {
            i--;
            continue;
        }

        /* prefer to place worms in top half of map, so they have somewhere to fall */
        if (y > HEIGHT / 2 && worm_too_low < ALLOW_LOW_WORM_THRESHOLD) {
            i--;
            worm_too_low++;
            continue;
        }

        /* actually set worm location */
        worm_already_placed[random_terrain] = TRUE;
        worms[i].pos.x = x;
        worms[i].pos.y = y;
        
    }

    return;
}



void seed_random(int seed) {
    random = (unsigned int) seed;
}

unsigned int random_in_range(int min, int max) {
    int a = 16807;
    int m = 2147483647;
    random = (a * random) % m;
    return min + random % (max - min + 1);
}

int collides_with_terrain(int x, int y) {
    for (int i = 0; i < nimpacts; i++) {
        struct point *ip = &impacts[i];

        int left = ip->x - (IMPACT_WIDTH / 2);
        int right = left + IMPACT_WIDTH - 1;
        int top = ip->y - (IMPACT_HEIGHT / 2);
        int bottom = top + IMPACT_HEIGHT - 1;

        if (x >= left && x <= right && y >= top && y <= bottom) {
            return NO_TERRAIN;
        }
    }

    for (int i = 0; i < nterrains; i++) {
        struct terrain *t = &terrains[i];

        int left = t->top_left.x;
        int top = t->top_left.y;
        int right = t->top_left.x + t->width - 1;
        int bottom = t->top_left.y + t->height - 1;

        if (x >= left && x <= right && y >= top && y <= bottom) {
            return i;
        }
    }

    return NO_TERRAIN;
}


void render(int show_aim_guide) {
    render_background();
    render_terrain();
    render_impacts();
    if (show_aim_guide) {
        render_aim_guide();
    }
    render_worms();
}



void render_terrain(void) {
    for (int x = 0; x < WIDTH; x++) {
        for (int y = 0; y < HEIGHT; y++) {
            if (collides_with_terrain(x, y) != NO_TERRAIN) {
                screen[y][x] = TERRAIN_CHAR;
            }
        }
    }

    return;
}





int offset_index_for_aim(int offset_multiplier_index) {
    int a = worms[active_worm].aim;

    /* each "quadrant" double counts the last coordinate (since the following quadrant will also begin with it)*/
    int skipped = a / (NUM_AIM_OFFSETS - 1);

    int offset_index = (a + skipped) % NUM_AIM_OFFSETS;

    /* i'm bad at maths, but the direction the aiming char moves while aiming is reversed
     * without this logic :( 
     */
    if (aim_dir_reversed_in_quadrant[offset_multiplier_index]) {
        offset_index = NUM_AIM_OFFSETS - offset_index - 1;
    }

    /* which specific offset doees this aim refer to? */
    return offset_index;
}

void render_aim_guide(void) {
    init_projectile(&aim_guide);
    move_projectile(&aim_guide);
    render_projectile(&aim_guide);
    move_projectile(&aim_guide);
    render_projectile(&aim_guide);
}



void print_worm_char(int x, int y) {
    for (int i = 0; i < nworms; i++) {
        if (worms[i].pos.x == x && worms[i].pos.y == y && worms[i].alive) {
            if (i == RED) {
                print_rgb(WORM_CHAR, 255, 0, 0);
            } else if (i == GREEN) {
                print_rgb(WORM_CHAR, 0, 255, 0);
            } else if (i == BLUE) {
                print_rgb(WORM_CHAR, 0, 255, 255);
            } else if (i == YELLOW) {
                print_rgb(WORM_CHAR, 255, 255, 0);
            }
        }
    }
}


void next_turn(void) {
    int old_worm = active_worm;
    active_worm++;
    active_worm %= nworms;

    while (!worms[active_worm].alive) {
        active_worm++;
        active_worm %= nworms;

        if (active_worm == old_worm) {
            return;
        }
    }
}

void display(void) {
    fputs(ansii_clear, stdout);
    for (int y = 0; y < HEIGHT; y++) {
        for (int x = 0; x < WIDTH; x++) {
            if (screen[y][x] == WORM_CHAR) {
                print_worm_char(x, y);
            } else {
                putchar(screen[y][x]);
            }
        }
        putchar(10);
    }
}

void let_worms_fall(void) {
    int fell = FALSE;
    int has_looped = FALSE;
    do {
        if (has_looped) {
            wait_for_input();
        }

        fell = FALSE;

        for (int worm = 0; worm < nworms; worm++) {
            if (!worms[worm].alive) {
                continue;
            }

            int x = worms[worm].pos.x;
            int y = worms[worm].pos.y;

            if (collides_with_terrain(x, y + 1) == NO_TERRAIN && y < HEIGHT - 1) {
                if (!has_looped) {
                    has_looped = TRUE;
                    wait_for_input();
                }

                worms[worm].pos.y++;
                fell = TRUE;
            }

            if (y == HEIGHT - 1) {
                worms[worm].alive = FALSE;
                if (worm == active_worm) {
                    next_turn();
                }
            }

            if (has_looped) {
                render(FALSE);
                display();
            }

        }

        has_looped = TRUE;
    } while (fell);

    render(TRUE);
    display();
}

void init_projectile(struct projectile *p) {
    int offset_multiplier_index = offset_multiplier_index_for_aim();
    int offset_index = offset_index_for_aim(offset_multiplier_index);

    int wx = worms[active_worm].pos.x;
    int wy = worms[active_worm].pos.y;

    int omx = aim_offset_multipliers[offset_multiplier_index][X_INDEX];
    int omy = aim_offset_multipliers[offset_multiplier_index][Y_INDEX];

    int ox = aim_offsets[offset_index].x;
    int oy = aim_offsets[offset_index].y;

    p->origin.x = wx;
    p->origin.y = wy;

    p->pos = p->origin;
    p->pos_unit_x = wx * X_TO_UNITS;
    p->pos_unit_y = wy * Y_TO_UNITS;

    p->trail_length = 0;

    /* apply fire strength */
    p->dx = ((ox * omx) * X_TO_UNITS) / (MAX_STRENGTH + 2 - strength[active_worm]);
    p->dy = ((oy * omy) * Y_TO_UNITS) / (MAX_STRENGTH + 2 - strength[active_worm]);
}

void render_impacts(void) {
    for (int i = 0; i < nimpacts; i++) {
        int left = impacts[i].x - (IMPACT_WIDTH / 2);
        int top = impacts[i].y - (IMPACT_HEIGHT / 2);
        for (int y_off = 0; y_off < IMPACT_HEIGHT; y_off++) {
            for (int x_off = 0; x_off < IMPACT_WIDTH; x_off++) {
                if (in_bounds(left + x_off, top + y_off)) {
                    screen[top + y_off][left + x_off] = BACKGROUND_CHAR;
                }
            }
        }
    }    
}

void change_strength(int by) {
    strength[active_worm] += by;
    if (strength[active_worm] < 0) {
        strength[active_worm] = 0;
    }

    if (strength[active_worm] > MAX_STRENGTH) {
        strength[active_worm] = MAX_STRENGTH;
    }

    render(TRUE);
    display();
}


void do_something(void) {
    int ch = player_input();
    if (ch == INPUT_MOVE_LEFT) {
        move(LEFT);
    } else if (ch == INPUT_MOVE_RIGHT) {
        move(RIGHT);
    } else if (ch == INPUT_AIM_CLOCKWISE) {
        aim(CLOCKWISE);
    } else if (ch == INPUT_AIM_ANTICLOCKWISE) {
        aim(ANTICLOCKWISE);
    } else if (ch == INPUT_FIRE) {
        fire();
    } else if (ch == INPUT_STRENGTH_UP) {
        change_strength(1);
    } else if (ch == INPUT_STRENGTH_DOWN) {
        change_strength(-1);
    } else if (ch == INPUT_SURRENDER) {
        surrender();
    } else {
        printf("invalid input '%c'\n", ch);
    }

    return;
}

int player_input(void) {
    int ch;

    printf("firing strength: %d/%d\n", strength[active_worm], MAX_STRENGTH);

    /* prompt */
    printf("> "); 

    /* skip newlines */
    while ((ch = getchar()) == '\n');
    return ch;
}



void wait_for_input(void) {
    /* prompt */
    printf("... ");

    /* wait for any non-newline */
    while (getchar() == '\n');
}