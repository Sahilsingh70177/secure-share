-Secure File Sharing Tool

This tool was built for a small non-profit organisation where field researchers
need to share sensitive documents ,witness statements, photos, location notes ,
without risking interception or tampering.

It runs entirely on the command line using tools that are already available on
any Linux system: age, ssh, and bash.



- The Problem it Solves

Sending files over email or USB is risky. Files can be:
- Read by the wrong person (confidentiality risk)
- Secretly changed in transit (integrity risk)
- Lost without any record (accountability risk)

This tool fixes all three.



-How it Works

1. Alice has a file she needs to send to Bob
2. She encrypts it using Bob's public key — only Bob can open it
3. She generates a checksum — a fingerprint of the file
4. She sends the encrypted file to Bob
5. Bob decrypts it using his private key
6. Bob verifies the checksum — confirms nothing was changed
7. Everything gets logged automatically



-What You Need

- Linux or WSL (Ubuntu)
- age installed (age --version to check)
- ssh and scp available
- bash (already there on any Linux system)

- Folder Structure

secure-share/
├── setup_keys.sh     - run this first
├── send.sh           -Alice runs this to send
├── receive.sh        -Bob runs this to receive
├── transfer.log      - auto-generated log
├── README.md         - this file
├── alice/            -Alice's workspace
│   ├── notes.txt
│   └── bob-public.txt
└── bob/              - Bob's workspace
└── bob-key.txt



-Setting Up

First time only — run the setup script:

bash
chmod +x setup_keys.sh
./setup_keys.sh


This will:
- Create alice and bob folders
- Generate Bob's age key pair
- Copy Bob's public key to Alice's folder



-Sending a File

Put your file inside the alice/ folder, then run:

bash
./send.sh filename.txt


What happens behind the scenes:
- Checksum is generated
- File is encrypted using Bob's public key
- Encrypted file is copied to Bob's folder
- Transfer is logged in transfer.log



-Receiving a File

Bob runs this to decrypt and verify:

bash
./receive.sh filename.txt


What happens behind the scenes:
- Encrypted file is decrypted using Bob's private key
- Checksum is verified against the original
- Success or failure is clearly shown



-The Log File

Every transfer is recorded in transfer.log like this:

2026-04-26T10:22:57 | alice | bob | notes.txt | sha256:52280... | SUCCESS


This gives you a clear record of who sent what, when, and whether it succeeded.



-Important Security Rules

- Never share your private key with anyone
- Never transfer unencrypted files
- Always check the checksum after receiving
- If decryption fails — do not trust the file



- Testing

To test the full flow:

bash
./setup_keys.sh
./send.sh notes.txt
./receive.sh notes.txt


To simulate a tampered file:

bash
echo "tampered" >> bob/notes.txt.age
./receive.sh notes.txt
-You will see: ERROR: Decryption failed!



