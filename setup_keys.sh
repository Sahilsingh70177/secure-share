#!/bin/bash

# setup_keys.sh
# This script sets up age keys for Bob (recipient)

echo "Secure Share Setup "

# Step 1 - Create folders if they don't exist
echo "[1/3] Creating folders..."
mkdir -p alice bob

# Step 2 - Generate Bob's age key pair
echo "[2/3] Generating Bob's age key pair..."
if [ -f bob/bob-key.txt ]; then
    echo "Keys already exist, skipping..."
else
    age-keygen -o bob/bob-key.txt
fi

# Step 3 - Extract Bob's public key into Alice's folder
echo "[3/3] Copying Bob's public key to Alice..."
grep "public key" bob/bob-key.txt | awk '{print $4}' > alice/bob-public.txt

echo ""
echo "Setup Complete "
echo "Bob's public key:"
cat alice/bob-public.txt
