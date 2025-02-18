#include <stdio.h>
#include <string.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
    // Change the name of the process
    snprintf(argv[0], strlen(argv[0]), "apeshit");

    // Simulate the daemon's task
    while (1) {
        sleep(1000);
    }

    return 0;
}
