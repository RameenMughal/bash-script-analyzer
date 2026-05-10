#!/bin/bash
# Mix of valid code and dangerous commands

owner="root"
count=3

if [ $count -gt 0 ]
then
    echo "Count is positive"
fi

for file in a b c
do
    echo $file
done

rm -rf /important/data
chmod 777 /etc/shadow
sudo reboot

result=$(( count * 10 ))
echo $result
