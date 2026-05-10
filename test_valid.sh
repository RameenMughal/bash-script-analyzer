#!/bin/bash
# All valid constructs - should PASS with 0 errors

name="Alice"
age=25
result=$age

total=$(( age + 5 ))
half=$(( total / 2 ))

echo $name
echo "Hello World"

if [ $age -gt 18 ]
then
    echo "Adult"
fi

if [ $name == "Alice" ]
then
    echo "Name matched"
else
    echo "Name not matched"
fi

if [ $age -eq 25 ]
then
    echo "Twenty five"
elif [ $age -ne 25 ]
then
    echo "Not twenty five"
fi

for item in one two three
do
    echo $item
done

while [ $age -gt 0 ]
do
    age=$(( age - 1 ))
done
