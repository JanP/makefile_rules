#include <stdio.h>

void
hello_so_c(void) {
    fprintf(stdout, "Hello from %s\n", __FILE__);
}
