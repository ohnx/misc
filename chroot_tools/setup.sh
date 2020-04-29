#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 [chroot name]"
    exit
fi

set -e

chroot_name=$1

mkdir $chroot_name
debootstrap sid $PWD/$chroot_name http://deb.debian.org/debian/

echo "" >> /etc/fstab
echo "# $chroot_name" >> /etc/fstab
echo "proc $PWD/$chroot_name/proc proc defaults 0 0" >> /etc/fstab
mount proc $PWD/$chroot_name/proc -t proc
echo "sysfs $PWD/$chroot_name/sys sysfs defaults 0 0" >> /etc/fstab
mount sysfs $PWD/$chroot_name/sys -t sysfs
echo "devpts $PWD/$chroot_name/dev/pts devpts defaults 0 0" >> /etc/fstab
mount devpts $PWD/$chroot_name/dev/pts -t devpts

echo "done!"
