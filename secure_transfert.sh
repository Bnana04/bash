#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <fichier_a_envoyer> <utilisateur@ip_192.168.239.144> <chemin_dest>"
    exit 1
fi

FICHIER=$1
DESTINATION=$2
CHEMIN_DEST=$3

if [ ! -f "$FICHIER" ]; then
    echo "Erreur : Le fichier $FICHIER n'existe pas."
    exit 1
fi

echo "[+] Hachage du fichier avec SHA-256..."
sha256sum "$FICHIER" > "$FICHIER.sha256"

echo "[+] Chiffrement du fichier avec AES-256..."
gpg --symmetric --cipher-algo AES256 --output "$FICHIER.gpg" "$FICHIER"

echo "[+] Signature GPG du fichier..."
gpg --armor --detach-sign "$FICHIER.gpg"

echo "[+] Génération d'un nombre aléatoire..."
head -c 16 /dev/urandom | base64 > random.txt

echo "[+] Transfert des fichiers vers $DESTINATION..."
scp "$FICHIER.gpg" "$FICHIER.sha256" "$FICHIER.asc" "random.txt" "$DESTINATION:$CHEMIN_DEST"


if [ $? -eq 0 ]; then
    echo "[+] Transfert terminé avec succès."
else
    echo "[!] Erreur lors du transfert."
    exit 1
fi
