#!/bin/bash

if [ ! -f "random.txt" ]; then
    echo "Erreur : random.txt introuvable."
    exit 1
fi

# Lire et incrémenter le nombre aléatoire
NOMBRE=$(cat random.txt)
NOUVEAU_NOMBRE=$((NOMBRE + 1))

# Ajouter votre nom
IDENTITE="Brandon"  # Remplacez par votre nom

# Sauvegarde du message
echo "$NOUVEAU_NOMBRE - $IDENTITE" > reponse.txt

# Chiffrement du message pour l'envoyer
gpg --output reponse.txt.gpg --encrypt --recipient "editeur@example.com" reponse.txt

echo "[+] Réponse prête dans reponse.txt.gpg"

cat random.txt
