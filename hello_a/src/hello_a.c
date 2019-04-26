#include <stdio.h>

void
hello_a_c(void) {
    fprintf(stdout, "Hello from %s\n", __FILE__);
}
