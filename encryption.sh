#!/bin/bash
# cyber.sh - simple encryption, hashing and signing with OpenSSL

while true; do
    echo
    echo "===== PICK ONE ====="
    echo "1) Generate keys"
    echo "2) Symmetric encrypt"
    echo "3) Symmetric decrypt"
    echo "4) Asymmetric encrypt"
    echo "5) Asymmetric decrypt"
    echo "6) Hash a file"
    echo "7) Sign a file"
    echo "8) Verify a signed file"
    echo "0) Exit"
    read -p "Choose: " c

    case $c in
        1)  # make a private key, then a public key from it
            openssl genrsa -out private.pem 2048
            openssl rsa -in private.pem -pubout -out public.pem
            echo "Keys created: private.pem and public.pem" ;;
        2)  read -p "File: " f
            read -sp "Password: " p; echo
            openssl enc -aes-256-cbc -pbkdf2 -in "$f" -out "$f.enc" -pass pass:"$p"
            echo "Saved as $f.enc" ;;
        3)  read -p "Encrypted file: " f
            read -sp "Password: " p; echo
            openssl enc -d -aes-256-cbc -pbkdf2 -in "$f" -out "$f.dec" -pass pass:"$p"
            echo "Saved as $f.dec" ;;
        4)  read -p "File (small): " f
            openssl pkeyutl -encrypt -pubin -inkey public.pem -in "$f" -out "$f.rsa"
            echo "Saved as $f.rsa" ;;
        5)  read -p "Encrypted file: " f
            openssl pkeyutl -decrypt -inkey private.pem -in "$f" -out "$f.dec"
            echo "Saved as $f.dec" ;;
        6)  read -p "File: " f
            sha256sum "$f" ;;
        7)  read -p "File: " f
            openssl dgst -sha256 -sign private.pem -out "$f.sig" "$f"
            echo "Signature saved as $f.sig" ;;
        8)  read -p "File: " f
            read -p "Signature file: " s
            openssl dgst -sha256 -verify public.pem -signature "$s" "$f" ;;
        0)  exit ;;
        *)  echo "Invalid choice" ;;
    esac
done
