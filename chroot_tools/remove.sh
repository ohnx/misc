#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 [chroot name]"
    exit
fi

set -e

chroot_name=$1

mkdir $chroot_name

cp /etc/fstab fstab_backup
grep -F -v "$PWD/$chroot_name" fstab_backup > fstab_new
mv fstab_new /etc/fstab
mount -a

rm -rf $PWD/$chroot_name

echo "done! if issues with fstab arise, the old version is stored in fstab_backup"
