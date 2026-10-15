// # 6 bits of 1 in the middle
// &
#include <stdio.h>
#include <stdint.h>

int main() {
    uint32_t number = 0b00000000000001011010000000000000;
    // ans: 101101

    uint32_t mask = 0b111111 << 13;
    uint32_t out = number & mask;
    // right now the reading is still in the middle of the number
    // we gotta shift it backwards.
    out = out >> 13;
    printf("0b%b\n", out);  //print in binary (only works on GCC)
    //0b 0000000000011111100000000000000 // this would've worked asw. (assuming you counted right)
    return 0;
}