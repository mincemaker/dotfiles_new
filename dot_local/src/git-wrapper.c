#include <stdlib.h>
#include <unistd.h>
#include <string.h>

// Workaround: apm (PyInstaller) pollutes LD_LIBRARY_PATH with its bundled libs,
// causing /bin/sh (bash) to crash on libreadline when git spawns upload-pack.
// Strip it only when apm's bundle path is present.
int main(int argc, char *argv[]) {
    char *ld = getenv("LD_LIBRARY_PATH");
    if (ld && strstr(ld, "/apm/_internal"))
        unsetenv("LD_LIBRARY_PATH");
    execv("/usr/bin/git", argv);
    return 127;
}
