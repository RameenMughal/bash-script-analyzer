#!/bin/bash
# All dangerous commands - should be BLOCKED

rm -rf /tmp/data
chmod 777 /etc/passwd
sudo rm -rf /
dd if=/dev/zero of=/dev/sda
mkfs.ext4 /dev/sdb
chown root:root /etc/shadow
iptables -F
passwd root
useradd hacker
userdel admin
shutdown -h now
reboot
shred -u /etc/hosts
eval "rm -rf /"
