#!/bin/sh
echo "Changing uid/gui to ${LUID}, ${LGID}"
cat /etc/passwd | sed "s@dluser:x:1000:1000::/home/dluser:/bin/bash@dluser:x:${LUID}:${LGID}::/home/dluser:/bin/bash@" > passwd.tmp

cp passwd.tmp /etc/passwd && rm passwd.tmp

echo "Changing home folder ownership"
sudo chown -R dluser /home/dluser
export USER=dluser
chroot --userspec ${LUID} / "$@"

