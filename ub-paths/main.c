#include <limits.h>
#include <stdio.h>

void some_func_with_undefined_behavior(void) {
    int x = INT_MAX;
    x += 1; // Integer overflow here
    printf("x = %i\n", x);
}

int main(int argc, const char * argv[]) {
    some_func_with_undefined_behavior();
    return 0;
}
