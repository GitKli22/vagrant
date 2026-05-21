#!/usr/bin/env bash

# =============================================================================
#  Script pour lancer le serveur VPS local (Vagrant) et s'y connecter
# =============================================================================

echo "🚀 Lancement du serveur VPS (Vagrant)..."
vagrant up

echo "🔌 Connexion à la console en cours..."
vagrant ssh
