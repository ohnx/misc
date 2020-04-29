# chroot_tools

A few tools to help with setting up a chroot.

I usually prefer chroots over containers/etc. when I am the only user on a system,
so I made this.

All tools are made to run as root.

* `setup.sh`: Set up a new chroot, with access to most of the additional required
  "special" filesystems that allow for near-normal use of the system
* `remove.sh`: Completely remove a chroot from the system, including deleting all
  files.
* `start_in_chroot.c`: Start a program, as a specific user, in a chroot. `chroot`
  supports starting arbitrary programs, but the home directory of the user does
  not appear to work correctly, so I made this simple C script.
