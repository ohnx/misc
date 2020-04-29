/* to recompile use gcc start_in_chroot.c -ansi -pedantic -Wall -Werror -o sic */
#define _DEFAULT_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <string.h>
#include <pwd.h>

int main(int argc, char **argv, char **env) {
    int r;
    const char *m;
    char *new_root;
    char *dest_str, *dso = "HOME=/home/";
    struct passwd *pwd;

    if (argc < 4) {
        printf("usage: %s [chroot location] [user name] [program]\n", argv[0]);
        return 1;
    }

    /* get new root location */
    new_root = argv[1];

    /* try chdir to new root */
    if ((r = chdir(new_root)) != 0) { m = "failed to locate new root"; goto fail; }

    /* try to chroot */
    if ((r = chroot(new_root)) != 0) { m = "failed to change root"; goto fail; }

    /* try to fetch user id */
    if ((pwd = getpwnam(argv[2])) == NULL) { m = "failed to look up username"; goto fail; }

    /* try to change to user */
    if ((setuid(pwd->pw_uid)) != 0) { m = "failed to change to user"; goto fail; }

    /* change home directory */
    r = strlen(dso) + strlen(argv[2]);
    dest_str = malloc(r+1);
    *dest_str = '\0';
    strcat(dest_str, dso);
    strcat(dest_str, argv[2]);
    if ((putenv(dest_str)) != 0) { printf("failed to change home directory\n"); }

    /* try running program */
    if ((execve(argv[3], argv+3, env)) != 0) { m = "failed to run program in chroot"; goto fail; }

fail:
    perror(m);
    return 1;
}
