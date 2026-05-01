#!/bin/bash

# send.sh
# Alice uses this to encrypt and send a file to Bob

echo "=== Secure File Send ==="

# Check if user gave a filename
if [ -z "$1" ]; then
    echo "ERROR: No file specified!"
    echo "Usage: ./send.sh <filename>"
    exit 1
fi

FILE="alice/$1"
RECIPIENT="bob"
PUBLIC_KEY="alice/bob-public.txt"
ENCRYPTED="alice/$1.age"
LOG="transfer.log"
TIMESTAMP=$(date +"%Y-%m-%dT%H:%M:%S")

# Step 1 - Check if file exists
echo "[1/4] Checking file..."
if [ ! -f "$FILE" ]; then
    echo "ERROR: File '$FILE' not found!"
    exit 1
fi
echo "File found: $FILE"

# Step 2 - Generate checksum
echo "[2/4] Generating checksum..."
CHECKSUM=$(sha256sum "$FILE" | awk '{print $1}')
echo "Checksum: $CHECKSUM"

# Step 3 - Encrypt the file
echo "[3/4] Encrypting file..."
age -r "$(cat $PUBLIC_KEY)" -o "$ENCRYPTED" "$FILE"
if [ $? -ne 0 ]; then
    echo "ERROR: Encryption failed!"
    echo "$TIMESTAMP | alice | ssuk04@localhost | $1 | sha256:$CHECKSUM | FAILED (encryption)" >> "$LOG"
    exit 1
fi
echo "Encrypted file created: $ENCRYPTED"

# Step 4 - Send to Bob's folder
echo "[4/4] Sending to Bob..."
scp -i alice/alice-ssh-key -o StrictHostKeyChecking=no "$ENCRYPTED" ssuk04@localhost:/home/ssuk04/secure-share/bob/
if [ $? -ne 0 ]; then
    echo "ERROR: Transfer failed!"
    echo "$TIMESTAMP | alice | ssuk04@localhost | $1 | sha256:$CHECKSUM | FAILED (transfer)" >> "$LOG"
    exit 1
fi
echo "File sent to Bob successfully!"

# Log the success
echo "$TIMESTAMP | alice | ssuk04@localhost | $1 | sha256:$CHECKSUM | SUCCESS" >> "$LOG"

echo ""
echo "=== Transfer Complete ==="
echo "Log updated: $LOG"
