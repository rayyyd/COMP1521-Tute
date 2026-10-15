a: 0b 1100 1010
b: 0b 1000 1111

| : write
& : read
& ~ : delete
^ : toggle

a)
a | b

1100 1010         subject
1000 1111         mask
---------------      |
1100 1111

write 1's into the subject whereever mask is 1.

b) 
1100 1010         subject
1000 1111         mask
---------------      &
1000 1010

c)
1100 1010         subject
1000 1111         mask
---------------      ^
0100 0101

toggle value when our mask is 1, otherwise don't touch it.

d)
1100 1010         subject
1000 1111         mask
---------------      subject & (~mask)
0100 0000

3)
1100 1010 << 6
--------------
1000 0000