#!/bin/ash

# generate host keys if not present
ssh-keygen -A
sed -ie 's/#Port 22/Port 22/g' /etc/ssh/sshd_config

# do not detach (-D), log to stderr (-e), passthrough other arguments
exec /usr/sbin/sshd -D -e "$@"

