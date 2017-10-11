#!/bin/bash

# number of characters in password
PASSWDCHARS=8

# shell to use (rssh is set up to block ssh but allow sFTP)
USERSHELL="/usr/bin/rssh"

# CSV format
echo "\"user\",\"password\""

# generate a password for each user
while read user
do
    # skip empty lines
    [ -z "$user" ] && continue

    # generate random password
    password=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $PASSWDCHARS | head -n 1)

    # output user and password
    echo "\"$user\",\"$password\""

    # create new user using shell
    useradd -m -d /home/$user -s $USERSHELL $user

    # create public_html folder
    su -l $user -s /bin/bash -c "mkdir ~/public_html"

    # put a nice little intial page
    su -l $user -s /bin/bash -c "echo \"<h1>Welcome to $user's website!</h1>More things coming soon!\" > ~/public_html/index.html"

    # set user password
    echo "$user:$password" | chpasswd
done < users.txt
