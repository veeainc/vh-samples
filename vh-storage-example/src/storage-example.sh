#!/bin/bash

echo "vh storage example"
echo "Running on $HOSTNAME"
echo

ROOT="/var/lib/veea/external_storage"
# ROOT="/tmp"
STORAGE=($ROOT/mmcblk* $ROOT/sd??)

# Test if the folders exists
echo "Checking devices: ${STORAGE[@]}"
i=0
for DIR in ${STORAGE[@]}; do
    if [ ! -d $DIR ]; then
        echo "${STORAGE[$i]} not found!"
        unset STORAGE[$i]
    fi
    ((i += 1))
done
echo
echo "Found Storage: ${STORAGE[@]}"
echo

# Create Directory
echo "Checking Directories..."
for DIR in ${STORAGE[@]}; do
    TARGET=$DIR/$HOSTNAME
    if [ ! -d $TARGET ]; then
        echo "making $TARGET"
        mkdir $TARGET
    fi
done
echo

# Test File Creation
echo "Testing file creation..."
for DIR in ${STORAGE[@]}; do
    TARGET=$DIR/$HOSTNAME
    FILE=$TARGET/helloworld.txt
    [ ! -f $FILE ] && touch $FILE

    echo "Writing to $FILE"
    echo "Hello, World!" >$FILE

    echo "Result:"
    cat $FILE
    echo "EOF"
    echo

done
echo

# Test File Copy
echo "Testing file copy..."

for DIR in ${STORAGE[*]}; do
    TARGET=$DIR/$HOSTNAME
    TARGETFILE=$TARGET/$LOCALFILE

    [ -f $TARGETFILE ] && rm $TARGETFILE

    echo "Copying $LOCALFILE -> $TARGETFILE"
    cp /app/$LOCALFILE $TARGETFILE

    echo "Contents of  $TARGET:"
    ls $TARGET

    echo
done
echo

while true; do
    sleep 60
done
