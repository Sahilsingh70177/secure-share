#!/bin/bash

# receive.sh
# Bob uses this to decrypt and verify a received file

echo "=== Secure File Receive ==="

# Check if user gave a filename
if [ -z "$1" ]; then
    echo "ERROR: No file specified!"
    echo "Usage: ./receive.sh <filename>"
    exit 1
fi

ENCRYPTED="bob/$1.age"
DECRYPTED="bob/$1"
PRIVATE_KEY="bob/bob-key.txt"
LOG="transfer.log"

# Step 1 - Check if encrypted file exists
echo "[1/3] Checking encrypted file..."
if [ ! -f "$ENCRYPTED" ]; then
    echo "ERROR: Encrypted file '$ENCRYPTED' not found!"
    exit 1
fi
echo "Encrypted file found: $ENCRYPTED"

# Step 2 - Decrypt the file
echo "[2/3] Decrypting file..."
age -d -i "$PRIVATE_KEY" -o "$DECRYPTED" "$ENCRYPTED"
if [ $? -ne 0 ]; then
    echo "ERROR: Decryption failed! Wrong key or corrupted file."
    exit 1
fi
echo "File decrypted: $DECRYPTED"

# Step 3 - Verify checksum
echo "[3/3] Verifying checksum..."
RECEIVED_CHECKSUM=$(sha256sum "$DECRYPTED" | awk '{print $1}')
echo "Received file checksum: $RECEIVED_CHECKSUM"

# Get original checksum from log
ORIGINAL_CHECKSUM=$(grep "$1" "$LOG" | tail -1 | awk -F'sha256:' '{print $2}' | awk '{print $1}')
echo "Original checksum:      $ORIGINAL_CHECKSUM"

if [ "$RECEIVED_CHECKSUM" = "$ORIGINAL_CHECKSUM" ]; then
    echo ""
    echo "✅ SUCCESS: File is verified! Checksums match."
else
    echo ""
    echo "❌ ERROR: Checksums do not match! File may be corrupted or tampered."
    exit 1
fi

echo ""
echo "=== Receive Complete ==="
